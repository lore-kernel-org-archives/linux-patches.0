Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48CB3FBEA5;
	Tue, 21 Jul 2026 17:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654178; cv=none; b=j3ToswF/UY43TuBoXvhaSkJYjk7JKsvQZIO4PHLF3aYTAQhmcSKPtY+wIkyJp+AC9O5CGKuZhfzsfkgUYC8wI3NUdWbobvWhbxgSBCDuTRc33uUgyAzldXLpJJd3zDFrRLKVmVxR+gHvHDcqzUtEb9RQswvDRhBvKVw3x8Q8MLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654178; c=relaxed/simple;
	bh=QAxPbLOxeygH5XdtrRwEx69wcv3kfrqK1suc5RY1leQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HEjXeLyyOmHcb+3ALuyOddS8RRxV0sbMCX+h5yg1Vlzsle6nXZ+L+SW2lj/ZTrVovdClirXQ2eH7s0mq8xLyMZ9cYuArNtQcWdHWfSXyXZgHBYu9uxCZS2jzDpAuPI+cLzNpnSKnCgeFRHrJuV7mVGzvtZsd+NGbpkiZbm/iSlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ThOlnkdo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ThOlnkdo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564361F000E9;
	Tue, 21 Jul 2026 17:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654176;
	bh=KOF7ay98nOxcDFFBNniz9oIfCiMzS+cxN3eVEM6fX2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ThOlnkdocIm5/zw4eq/5ODvVNbwtXC8YTF9TAUWTDcj1jUPmVB0pyNcegb/GxEIEp
	 HRyre8wYYDLsQUBAo07AE3339+X/a4nsV1SEme+aiOQU1JO/xL6vKWnBZqmgDK8zTF
	 OICY/IdgBN3Ym+dMUgHtjxGGPS1zB4/D0EV+VImE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theodor Arsenij Larionov-Trichkine <theodorlarionov@gmail.com>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 7.1 1605/2077] netfilter: nft_fib: reject fib expression on the netdev egress hook
Date: Tue, 21 Jul 2026 17:21:18 +0200
Message-ID: <20260721152630.626128970@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodor Arsenij Larionov-Trichkine <theodorlarionov@gmail.com>

commit d07955dd34ecae17d35d8c7d0a273a3fba653a8c upstream.

A fib expression in a netdev egress base chain dereferences nft_in(pkt),
NULL on the transmit path, causing a NULL pointer dereference at eval.
nft_fib_validate() masks the hook with NF_INET_* values, but netdev hook
numbers are a separate enum that aliases them (NF_NETDEV_EGRESS ==
NF_INET_LOCAL_IN), so an egress chain passes validation and then faults.

Add nft_fib_netdev_validate() that limits each result/flag to the netdev
hook where the device it reads exists: the input-device cases (OIF,
OIFNAME, ADDRTYPE with F_IIF) to ingress, the output-device case (ADDRTYPE
with F_OIF) to egress, ADDRTYPE with no device flag to both. Also restrict
nft_fib_validate() to NFPROTO_IPV4/IPV6/INET so its NF_INET_* masks are
not applied to another family's hooks.

Fixes: 42df6e1d221d ("netfilter: Introduce egress hook")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/netfilter-devel/ajxsjcDOnwllMfoR@strlen.de/
Signed-off-by: Theodor Arsenij Larionov-Trichkine <theodorlarionov@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_fib.c        |    9 +++++++++
 net/netfilter/nft_fib_netdev.c |   29 ++++++++++++++++++++++++++++-
 2 files changed, 37 insertions(+), 1 deletion(-)

--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -31,6 +31,15 @@ int nft_fib_validate(const struct nft_ct
 	const struct nft_fib *priv = nft_expr_priv(expr);
 	unsigned int hooks;
 
+	switch (ctx->family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+	case NFPROTO_INET:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
 	switch (priv->result) {
 	case NFT_FIB_RESULT_OIF:
 	case NFT_FIB_RESULT_OIFNAME:
--- a/net/netfilter/nft_fib_netdev.c
+++ b/net/netfilter/nft_fib_netdev.c
@@ -50,6 +50,33 @@ static void nft_fib_netdev_eval(const st
 	regs->verdict.code = NFT_BREAK;
 }
 
+static int nft_fib_netdev_validate(const struct nft_ctx *ctx,
+				   const struct nft_expr *expr)
+{
+	const struct nft_fib *priv = nft_expr_priv(expr);
+	unsigned int hooks;
+
+	switch (priv->result) {
+	case NFT_FIB_RESULT_OIF:
+	case NFT_FIB_RESULT_OIFNAME:
+		hooks = (1 << NF_NETDEV_INGRESS);
+		break;
+	case NFT_FIB_RESULT_ADDRTYPE:
+		if (priv->flags & NFTA_FIB_F_IIF)
+			hooks = (1 << NF_NETDEV_INGRESS);
+		else if (priv->flags & NFTA_FIB_F_OIF)
+			hooks = (1 << NF_NETDEV_EGRESS);
+		else
+			hooks = (1 << NF_NETDEV_INGRESS) |
+				(1 << NF_NETDEV_EGRESS);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return nft_chain_validate_hooks(ctx->chain, hooks);
+}
+
 static struct nft_expr_type nft_fib_netdev_type;
 static const struct nft_expr_ops nft_fib_netdev_ops = {
 	.type		= &nft_fib_netdev_type,
@@ -57,7 +84,7 @@ static const struct nft_expr_ops nft_fib
 	.eval		= nft_fib_netdev_eval,
 	.init		= nft_fib_init,
 	.dump		= nft_fib_dump,
-	.validate	= nft_fib_validate,
+	.validate	= nft_fib_netdev_validate,
 };
 
 static struct nft_expr_type nft_fib_netdev_type __read_mostly = {


