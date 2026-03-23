Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918163B9D9F;
	Mon, 23 Mar 2026 16:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283012; cv=none; b=gkHyYl12QEbVTY4oFuIrsw02DHiMuUG044saz8Z6k+re/XG8K8awPcc7OVYRAIgUXCioQJGjdqUVsgCCoqyJ3PX/KTXjKRRuxVS+Ul2lhEBCoAm7C6SnKf+z2kITmjRN/FQBpayvsAtkstJkH3nVzrYIOGBdrH2i4IwIwJ8+wS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283012; c=relaxed/simple;
	bh=dj1nqE7VtOQRN6Y36qNz//lOSqaSBO+gDjtf4Q/8kvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXTUZFJdOvLHZXc+q+ILKLrDgzO+BA0YaF98LEwcXsafYNQiYoQhZq3oZjyjwUO1jvofetIRcRh5KsQm+d/rpZrZGc410ypU/CDl8htQSJTbOpPfBwybs7VXe5Ti/YdYNQh9DTpf8Oym4hGLhyqXg//QxKYf+Q0wPIcCX76oqig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2ptk7rk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2ptk7rk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC79C2BC9E;
	Mon, 23 Mar 2026 16:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283012;
	bh=dj1nqE7VtOQRN6Y36qNz//lOSqaSBO+gDjtf4Q/8kvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H2ptk7rkBqCyC6bEqFq3ICBI8fWEGMmy9q06LWUCdnJOP8ez99D8dASZ6nrXIzInJ
	 F7iJ6YOSsrBq3e1dLM7/wUe5jLdvA7PDsT7z3JcGLxIgRkuSd1qKxFPUcyTD/S/WOS
	 SWl1Y68LiGf/ZXJLzrIoH0WLARP2Xxgce3zopthk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Jakub Staniszewski <jakub.staniszewski@linux.intel.com>,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.1 367/481] ice: reintroduce retry mechanism for indirect AQ
Date: Mon, 23 Mar 2026 14:45:49 +0100
Message-ID: <20260323134534.063224661@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Staniszewski <jakub.staniszewski@linux.intel.com>

[ Upstream commit 326256c0a72d4877cec1d4df85357da106233128 ]

Add retry mechanism for indirect Admin Queue (AQ) commands. To do so we
need to keep the command buffer.

This technically reverts commit 43a630e37e25
("ice: remove unused buffer copy code in ice_sq_send_cmd_retry()"),
but combines it with a fix in the logic by using a kmemdup() call,
making it more robust and less likely to break in the future due to
programmer error.

Cc: Michal Schmidt <mschmidt@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 3056df93f7a8 ("ice: Re-send some AQ commands, as result of EBUSY AQ error")
Signed-off-by: Jakub Staniszewski <jakub.staniszewski@linux.intel.com>
Co-developed-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
Signed-off-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_common.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1596,6 +1596,7 @@ ice_sq_send_cmd_retry(struct ice_hw *hw,
 {
 	struct ice_aq_desc desc_cpy;
 	bool is_cmd_for_retry;
+	u8 *buf_cpy = NULL;
 	u8 idx = 0;
 	u16 opcode;
 	int status;
@@ -1605,8 +1606,11 @@ ice_sq_send_cmd_retry(struct ice_hw *hw,
 	memset(&desc_cpy, 0, sizeof(desc_cpy));
 
 	if (is_cmd_for_retry) {
-		/* All retryable cmds are direct, without buf. */
-		WARN_ON(buf);
+		if (buf) {
+			buf_cpy = kmemdup(buf, buf_size, GFP_KERNEL);
+			if (!buf_cpy)
+				return -ENOMEM;
+		}
 
 		memcpy(&desc_cpy, desc, sizeof(desc_cpy));
 	}
@@ -1618,12 +1622,14 @@ ice_sq_send_cmd_retry(struct ice_hw *hw,
 		    hw->adminq.sq_last_status != ICE_AQ_RC_EBUSY)
 			break;
 
+		if (buf_cpy)
+			memcpy(buf, buf_cpy, buf_size);
 		memcpy(desc, &desc_cpy, sizeof(desc_cpy));
-
 		msleep(ICE_SQ_SEND_DELAY_TIME_MS);
 
 	} while (++idx < ICE_SQ_SEND_MAX_EXECUTE);
 
+	kfree(buf_cpy);
 	return status;
 }
 


