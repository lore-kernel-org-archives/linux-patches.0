Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBEF26CE32;
	Mon, 13 Apr 2026 16:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096347; cv=none; b=XeqCweIaULyQxEWDjpeh8RGnSZiET9nGddq32zIS+NPIZosY7lTJ9TMylU3rm5FT2ccpTh6HgmJHIr68MyvXhm+GbbiA5O6m4sCzmZkTWfetXttC8I+pqlZAyUFuZoETMnm4H82weYGojL/LlOz+vvN59/A47HsdxbD/Lq6HL2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096347; c=relaxed/simple;
	bh=/Uc9YrMZ2iLQjG3P+or5bz38rRkC+7Fbd8ck0iadQNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1bDll3gYi79emHOw/X9fh3Ow0xO9RH4U96uwXTV2BU03qOuM6IOS6Vz1LkLCBwKDLoyEDIL8S7VIpBlfW+EpIoj/y+VPdyG8Dx0dIs+SbGC+anQuWH47W4eU5ue8vQLpWh9jTCzm2rXOpurb2UB9jIEZ/Laag/Y6i4XushiBvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mbABNgzz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mbABNgzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C10C2BCAF;
	Mon, 13 Apr 2026 16:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096346;
	bh=/Uc9YrMZ2iLQjG3P+or5bz38rRkC+7Fbd8ck0iadQNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mbABNgzz5wo9hFVfSsnUMd59sohoP6KSQPl7VmC6E+oUHhk/pK/+IaFP747dNjX2g
	 lBIKL5/QC8hVPYRxn0D3qPLNcrXWvzjNg0YljdOd6HP0TrH2SAyLbTw3LdKm4DRx8E
	 9LC0O702OY4E+3POfCbHDxOmQ++X8pMO4bcOEGlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Tantilov <emil.s.tantilov@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Li Li <boolli@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.19 61/86] idpf: set the payload size before calling the async handler
Date: Mon, 13 Apr 2026 18:00:08 +0200
Message-ID: <20260413155733.838743776@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Tantilov <emil.s.tantilov@intel.com>

commit 8e2a2420e267a515f6db56a6e9570b5cacd92919 upstream.

Set the payload size before forwarding the reply to the async handler.
Without this, xn->reply_sz will be 0 and idpf_mac_filter_async_handler()
will never get past the size check.

Fixes: 34c21fa894a1 ("idpf: implement virtchnl transaction manager")
Cc: stable@vger.kernel.org
Signed-off-by: Emil Tantilov <emil.s.tantilov@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Li Li <boolli@google.com>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
@@ -612,6 +612,10 @@ idpf_vc_xn_forward_reply(struct idpf_ada
 		err = -ENXIO;
 		goto out_unlock;
 	case IDPF_VC_XN_ASYNC:
+		/* Set reply_sz from the actual payload so that async_handler
+		 * can evaluate the response.
+		 */
+		xn->reply_sz = ctlq_msg->data_len;
 		err = idpf_vc_xn_forward_async(adapter, xn, ctlq_msg);
 		idpf_vc_xn_unlock(xn);
 		return err;


