Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209560;
	b=vULzmfTW5+ZaZw281w9fcgu4MOKWtHPZhpGg2VSd4uzPi8d5HiSXxvt7C96/r879i266
	 HaFXOobTpBon9r2CmqGxJj+lALGbfcXdrcxTfwtp7Xqo5U0Yj6SLmXwnxkqm4j72YdB32
	 3HDcZgUbRKRbZFBdS8+N/mD6GwS7dSYhRw2xF+MRxlEbjFI6wnIvYD6porqIDuhjuerD2
	 ycMdYjX2QKnF3XpPx2mFCdX9M/aH+6BKLwp34W1BWadnRe+WuzC39rLQcPMkEhTHWzWd7
	 oJ0kHSJjME9fuqOptlX30TrREJAoflTRyrfJll43ySS4gFGUtB51Zpdf4fR41AAA8xQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209560;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vtt69r2od9Gu0CcXenq4/oMZgkz2IjeUKZF5xNsJXyA=;
	b=s5ndpDbcLPLlHj2WXyjsq/OllOjhnDl1XOcXeruJBOD76TnPU6K5UU0z3mAxFm67qsuE
	 xaLxscDovSMzIlPrPelWTrLipaKNcs4rh1JWwmzAugXEVjRN6FE3ljwifz2+dSlSKeJAG
	 CD+n28QBm8GzMJIj0UZKHY8yUPMflPInJmvN9xS0DZelFknIlmua7+vY4gISZPKUxRI4B
	 lXlFCsTNRLd3P+AeJ8ATxYZ3WeSrk+nI3ddHNjrczgOW9jY28VaoVwQ1PyUCaZ683LyZ5
	 5MEF26VhOllCfZdwuWcHwWaZyd0R96oT0FEC8HGm+2KaDnzkrO/nUhGESBOCZrT7p1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FZgNRBGs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F202606A31C;
	Wed, 28 Oct 2026 17:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FZgNRBGs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6352D1F01825;
	Wed, 28 Oct 2026 17:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209559;
	bh=Vtt69r2od9Gu0CcXenq4/oMZgkz2IjeUKZF5xNsJXyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FZgNRBGsO6QmfiJnDNWnubMQubtMjzdfo+DkJrEUJakxGPxENBtQvDYytl4pYRc0U
	 ZCEXIbyJBOKOUpxgM9TiAkhjtTSij6Gz/tm+1Af9aCPgmVh2x5N5fRjvN4lOyxlfQK
	 tFEr7SpX3BtHsQOKaAlNhLDCAIC1dNnVOtq69bls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aswin Karuvally <aswin@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 471/516] s390/ctcm: Prevent XID null dereference
Date: Wed, 28 Oct 2026 18:00:23 +0100
Message-ID: <20261028170014.638951323@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aswin Karuvally <aswin@linux.ibm.com>

commit b264d8422779d69febce914efc47a92a85cc382c upstream.

The mpc_validate_xid() function sets grp->saved_xid2->xid2_flag2 to 0x40
to signal XID validation error. If peer XID is NULL or r/w channel
pairing mismatch happens, grp->saved_xid2 is never initialized. An
attempt to set the flag in such case leads to NULL dereference.

Fix this by using the always available priv->xid->xid2_flag2 instead of
grp->saved_xid2->xid2_flag2 for validation errors.

Fixes: 293d984f0e36 ("ctcm: infrastructure for replaced ctc driver")
Cc: stable@vger.kernel.org
Signed-off-by: Aswin Karuvally <aswin@linux.ibm.com>
Link: https://patch.msgid.link/20260827063408.2168914-1-aswin@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/net/ctcm_mpc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/s390/net/ctcm_mpc.c
+++ b/drivers/s390/net/ctcm_mpc.c
@@ -838,7 +838,7 @@ static void mpc_action_go_ready(fsm_inst
 
 	fsm_deltimer(&grp->timer);
 
-	if (grp->saved_xid2->xid2_flag2 == 0x40) {
+	if (priv->xid->xid2_flag2 == 0x40) {
 		priv->xid->xid2_flag2 = 0x00;
 		if (grp->estconnfunc) {
 			grp->estconnfunc(grp->port_num, 1,
@@ -1647,7 +1647,6 @@ done:
 			"The XID used in the MPC protocol is not valid, "
 			"rc = %d\n", rc);
 		priv->xid->xid2_flag2 = 0x40;
-		grp->saved_xid2->xid2_flag2 = 0x40;
 	}
 
 	return rc;


