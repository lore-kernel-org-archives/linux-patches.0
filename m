Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5AF39A055;
	Mon, 23 Mar 2026 14:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275713; cv=none; b=U/VViOssx0/LVWMm2+BnW0ajjrth3V0m/EtvOfuiYs1o15EfBebMdMSuaqjOXqzK3DGeV1EIjxpL5Gf1+YTmq9/l3KPN9zweeVq+hrQY86suyrhJrvmPrmmUGw6YDzUPpphrKld3gu8D8WeimG7MOlsguE7go/hpSmMzha6qUVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275713; c=relaxed/simple;
	bh=nhqbnu3Tu4+VVirKM33P1zrlKposTo0360b1GJdLkpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdMH+NHvE0+vjBnibQiFzJH/gyn5y04/cJElH2hTmPJtWn4NyaXrDYE88sFbMnzHooL/OErIssjQf3tTBuZjGr+kroJju0LX/0smGOrrk0geAekrc1/kMldeo3RM5MFlnUaib2pbiCQdj2uIbnAdjRf5sLBBNiilpHKV6Zddmzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wdko7SCU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wdko7SCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53544C2BCB3;
	Mon, 23 Mar 2026 14:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275713;
	bh=nhqbnu3Tu4+VVirKM33P1zrlKposTo0360b1GJdLkpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wdko7SCUKUalOVwW4BIwQ7d9TgMWH77Cgr/ot0zUHi29AFDD6t+FFV152Ee3gkpYL
	 C1TaQD6IfkHyljrbikmL7AX0H10V4zrctT+1J8GeNhbUXPp0KYT37TNaNiTim01HLP
	 1kjyctCTm6xHQplmUEqviom7rXlcNJpxzUbvcNWs=
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
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.12 150/460] ice: reintroduce retry mechanism for indirect AQ
Date: Mon, 23 Mar 2026 14:42:26 +0100
Message-ID: <20260323134530.261249030@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Staniszewski <jakub.staniszewski@linux.intel.com>

commit 326256c0a72d4877cec1d4df85357da106233128 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_common.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1579,6 +1579,7 @@ ice_sq_send_cmd_retry(struct ice_hw *hw,
 {
 	struct ice_aq_desc desc_cpy;
 	bool is_cmd_for_retry;
+	u8 *buf_cpy = NULL;
 	u8 idx = 0;
 	u16 opcode;
 	int status;
@@ -1588,8 +1589,11 @@ ice_sq_send_cmd_retry(struct ice_hw *hw,
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
@@ -1601,12 +1605,14 @@ ice_sq_send_cmd_retry(struct ice_hw *hw,
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
 


