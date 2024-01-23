Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF13967739;
	Tue, 23 Jan 2024 02:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975280; cv=none; b=sdwprcSOPCe3dg4KH3HG6hYHwfo0jBZ+64GZJXrCC8Hle3v7ZmJ4oIw3dV8P5GuTzXkN9UGFS4iPqOjFzrmB3nxX5Hp3e9FH8vLZU8dXjpJI0ltR0cYhylKd+XNgKW7yRbJXHUpLkSiLeOmikeveyRlVBEpqOX8oXEQT5tQi+2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975280; c=relaxed/simple;
	bh=L+s/c/AraNHzwiuyG8TDCB5KLK5NDn5BaR7r8B8ANJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7zyhrU30+RxVtoZeXXbNrRYN1Ac/HABwd8y+nwmTz3cTE/i7ytz3ZPI215dNQql3XQiQLqOggR5/VUerT+O4nyvli2xg61GObNc+zVq4WCLpiGpjLwV4SxLt0f4i05mcUP3oMZNbOTLbcLc468d5DSThVhjk+SkBMlmsMoZf9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wkG53B9K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wkG53B9K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFA9C433C7;
	Tue, 23 Jan 2024 02:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975279;
	bh=L+s/c/AraNHzwiuyG8TDCB5KLK5NDn5BaR7r8B8ANJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wkG53B9K/O0NCvu7y3lOSUZqRGjLtHoOl777LL/F0+Mgw3BtMpRkHlkpzsZFrlGUk
	 Q8O+QHNZhbACNQ6clcU1woIcbNFjR0lG17sx9EiggXcftmJbkTg2Ub9ofD/mXgQxJD
	 blRlOb7m7Nc4pugbdm6ulydXa9lJyW+YKbLcjuVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 371/374] netfilter: nft_limit: fix stateful object memory leak
Date: Mon, 22 Jan 2024 16:00:27 -0800
Message-ID: <20240122235757.884327046@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

commit 1a58f84ea5df7f026bf92a0009f931bf547fe965 upstream.

We need to provide a destroy callback to release the extra fields.

Fixes: 3b9e2ea6c11b ("netfilter: nft_limit: move stateful fields out of expression data")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_limit.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -345,11 +345,20 @@ static int nft_limit_obj_pkts_dump(struc
 	return nft_limit_dump(skb, &priv->limit, NFT_LIMIT_PKTS);
 }
 
+static void nft_limit_obj_pkts_destroy(const struct nft_ctx *ctx,
+				       struct nft_object *obj)
+{
+	struct nft_limit_priv_pkts *priv = nft_obj_data(obj);
+
+	nft_limit_destroy(ctx, &priv->limit);
+}
+
 static struct nft_object_type nft_limit_obj_type;
 static const struct nft_object_ops nft_limit_obj_pkts_ops = {
 	.type		= &nft_limit_obj_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_limit_priv_pkts)),
 	.init		= nft_limit_obj_pkts_init,
+	.destroy	= nft_limit_obj_pkts_destroy,
 	.eval		= nft_limit_obj_pkts_eval,
 	.dump		= nft_limit_obj_pkts_dump,
 };
@@ -383,11 +392,20 @@ static int nft_limit_obj_bytes_dump(stru
 	return nft_limit_dump(skb, priv, NFT_LIMIT_PKT_BYTES);
 }
 
+static void nft_limit_obj_bytes_destroy(const struct nft_ctx *ctx,
+					struct nft_object *obj)
+{
+	struct nft_limit_priv *priv = nft_obj_data(obj);
+
+	nft_limit_destroy(ctx, priv);
+}
+
 static struct nft_object_type nft_limit_obj_type;
 static const struct nft_object_ops nft_limit_obj_bytes_ops = {
 	.type		= &nft_limit_obj_type,
 	.size		= sizeof(struct nft_limit_priv),
 	.init		= nft_limit_obj_bytes_init,
+	.destroy	= nft_limit_obj_bytes_destroy,
 	.eval		= nft_limit_obj_bytes_eval,
 	.dump		= nft_limit_obj_bytes_dump,
 };


