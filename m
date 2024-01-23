Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B63165BB4;
	Tue, 23 Jan 2024 01:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975112; cv=none; b=nNJTj47uoXzueQzVZMcNXxfrkxeMhmqxoxhTw9LKc076fiKiKXt3QK/vJr7u5XObkJ6746Fg2Q/uiJoY8RImyaTJvYiFtELXDgMNnxLXNuXK818p4BgjA80z0CmI0Tn8i5g91AClcswHjeg+oyU3Y559I2Pt0A4cgLCESuJaki4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975112; c=relaxed/simple;
	bh=Q7I1+5o5+P6MHg7RQV3SG2QQv2+aLldC4Isjk4Q7ZIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DqO66VbU289wubwbLW1QOjOHVmZ/Q1o1WlOoTw7d97HImWFfptc6ayJbrV5KNrelDZqhL4GoukXKv9vC6W7JNjD/deawxKJM8yhPo4nQntk10IUTrkOuzdUwr4ioGK7a5C69BDcD95qWqx2UgHLwpTrBsv3CnWkFiNujS6OZfZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pM+8k3Il; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pM+8k3Il"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F09C433F1;
	Tue, 23 Jan 2024 01:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975112;
	bh=Q7I1+5o5+P6MHg7RQV3SG2QQv2+aLldC4Isjk4Q7ZIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pM+8k3IlpQnpBhRoYVW9tU2u64FQW7/C73LzfP98d+22/s1Wg2jMC7wtKAe5i1wyO
	 e4Gq8dRfrvWJP35/ndXiUhECJwp46TTtC1z2+9SbdBAtHtzMKzrrLVBEYCfEW9+2tP
	 Q5SCyX3latGqT7vc1/FLS2HY5WtmZR9vUMzVGK54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 370/374] netfilter: nft_connlimit: memleak if nf_ct_netns_get() fails
Date: Mon, 22 Jan 2024 16:00:26 -0800
Message-ID: <20240122235757.849876804@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 7d70984a1ad4c445dff08edb9aacce8906b6a222 upstream.

Check if nf_ct_netns_get() fails then release the limit object
previously allocated via kmalloc().

Fixes: 37f319f37d90 ("netfilter: nft_connlimit: move stateful fields out of expression data")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_connlimit.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -62,6 +62,7 @@ static int nft_connlimit_do_init(const s
 {
 	bool invert = false;
 	u32 flags, limit;
+	int err;
 
 	if (!tb[NFTA_CONNLIMIT_COUNT])
 		return -EINVAL;
@@ -84,7 +85,15 @@ static int nft_connlimit_do_init(const s
 	priv->limit	= limit;
 	priv->invert	= invert;
 
-	return nf_ct_netns_get(ctx->net, ctx->family);
+	err = nf_ct_netns_get(ctx->net, ctx->family);
+	if (err < 0)
+		goto err_netns;
+
+	return 0;
+err_netns:
+	kfree(priv->list);
+
+	return err;
 }
 
 static void nft_connlimit_do_destroy(const struct nft_ctx *ctx,


