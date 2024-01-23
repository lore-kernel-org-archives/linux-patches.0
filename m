Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990B867741;
	Tue, 23 Jan 2024 02:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975285; cv=none; b=Qf4x+stmbhWjJdToHj0TifseUIUnoNJt8unqtlf8KkCg0vVPX2y8C6qMIRsep30X3Z2PtNQR46zZjgiw7j6sqKNOaQWsvA8p+hkWQirO50VN83DVHOf4bgc5P+27e9EkmsEnWCSUZ8g+MgM7iKMVwonCP6BQy7Nu5ibyuaP91KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975285; c=relaxed/simple;
	bh=XmACvI3lyroW9SPfoyTgE3WyVMMZsmGwXqkryas+hTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMt01qE8IdXzDB+p0OPHuQeP1O8fOPypb5MP2X9lJg3dMMTbiG+UfBRwXNVZwjWigRW3IVvRaSpKQYbDywoZABSZOVkeLghOB+1c7GzcJpdT2RcERunvsOIKDsY+dxRHb3Wlce8HULPmGs6GgywoOqD40DC+XxHwkZP18CyZhcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EG6fW4nR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EG6fW4nR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F914C433C7;
	Tue, 23 Jan 2024 02:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975285;
	bh=XmACvI3lyroW9SPfoyTgE3WyVMMZsmGwXqkryas+hTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EG6fW4nRAe0co2+kX38bIHmNSEwxn4dgXpk1MNz2i+Db0oNX8fNJSNFiuMJt++RZc
	 /V6K3NO7FrdfErwusRlqBe2VURmYmuDXPaGlrVZlvQkw5mKgV01l1jJCuEi/gKGRxj
	 IDuAh96AKB1PUasFQ65dgCYkgiHn9uElZ/Y9G0L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 374/374] netfilter: nft_quota: copy content when cloning expression
Date: Mon, 22 Jan 2024 16:00:30 -0800
Message-ID: <20240122235758.000457628@linuxfoundation.org>
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

commit aabef97a35160461e9c576848ded737558d89055 upstream.

If the ruleset contains consumed quota, restore them accordingly.
Otherwise, listing after restoration shows never used items.

Restore the user-defined quota and flags too.

Fixes: ed0a0c60f0e5 ("netfilter: nft_quota: move stateful fields out of expression data")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_quota.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -235,12 +235,16 @@ static void nft_quota_destroy(const stru
 static int nft_quota_clone(struct nft_expr *dst, const struct nft_expr *src)
 {
 	struct nft_quota *priv_dst = nft_expr_priv(dst);
+	struct nft_quota *priv_src = nft_expr_priv(src);
+
+	priv_dst->quota = priv_src->quota;
+	priv_dst->flags = priv_src->flags;
 
 	priv_dst->consumed = kmalloc(sizeof(*priv_dst->consumed), GFP_ATOMIC);
 	if (!priv_dst->consumed)
 		return -ENOMEM;
 
-	atomic64_set(priv_dst->consumed, 0);
+	*priv_dst->consumed = *priv_src->consumed;
 
 	return 0;
 }


