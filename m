Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDC03BFE35;
	Thu, 15 Jan 2026 17:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499235; cv=none; b=Ddz30DAgC6SVdkuj1W86Uo8afxURNrSlqSenkhZal+IkGJcAsortxWo+uMBK1Ig2u1aOEb0p+caahl8+NtQHfQBgDpqU4yvfWAC/UVlYIso0nabb47X7LiR+qOMDb+cA+MtYNKGc5oPA/vgfmGT0lixcawaZtQTWKLr9P+dorhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499235; c=relaxed/simple;
	bh=6NBm1MSlpUqM8Fx7O9ME3oeUoGFEMk/Gtf7ZaM9+iZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxkG5H2+gjj+I5k6K5/XZKQ1b3OJTR44jUc8OMv/CCZTVUISk73nCquJVzw2ShJImGvKsIsgZrRfrv0oQeNlyLVWaBTxCqb3u7DARNy3UzbpW/j4UtET9i6yRGKNLD8sSpxNa0QcvZp/AIrCF60JntZGKGASxLze7BBW9/a5jIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uELs84S1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uELs84S1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34BB7C116D0;
	Thu, 15 Jan 2026 17:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499234;
	bh=6NBm1MSlpUqM8Fx7O9ME3oeUoGFEMk/Gtf7ZaM9+iZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uELs84S1VzR1xujJcmh+mvX31uZjsFK05BW+YUogSsCgrbWAb4kcjyCGwHs0aDL1t
	 87XkPS/Xjp3qdH6s0VaPHqYDETuQskwzw0Bkn9pw/PvfmKYFaDaQ9OQBlSZUko1dfP
	 z1VIfMd4YfPqFKOXctojS8elMv1WqIdKfhwVwpzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 154/451] netfilter: nft_connlimit: memleak if nf_ct_netns_get() fails
Date: Thu, 15 Jan 2026 17:45:55 +0100
Message-ID: <20260115164236.484563355@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -56,6 +56,7 @@ static int nft_connlimit_do_init(const s
 {
 	bool invert = false;
 	u32 flags, limit;
+	int err;
 
 	if (!tb[NFTA_CONNLIMIT_COUNT])
 		return -EINVAL;
@@ -78,7 +79,15 @@ static int nft_connlimit_do_init(const s
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


