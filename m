Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220237CF29;
	Wed, 21 Feb 2024 14:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525594; cv=none; b=LLjKwQ7O3VecclqvALNnRkRLHA3vQjAbQmpyJAPiLQsQYZHwwEa0AOl1gOvHwbpn90UDvnpsv2r+Ay0vJF3XA8x7Z3yjaspAoAMUQ6ZRROliyXWlD5A5YnN8i/YvbC6QmY4ParLoJYyBF5Vi6hhVejtVMuGK948aIp77sOCh6yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525594; c=relaxed/simple;
	bh=ZCw6iP9BqPRwv4lVOv9Yy74fN6R9n7jV4pNV4cT0VkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZnlNFGvgK+R1F40H8nu4RDm9xTHFaTOApXZCsGw8KwUXUFNvcMdWtezz0YNADGVfTkRgBm8EsOfoLPx7PGobSN1NCdSttYnAOPI4ovLAcuyVj4a4jBeWot8JBMgsEye4wUZsNLWAQytl8Wp6oW7OamRpZcg6XyZ6dfOTNdgnsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eNla3Iq5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eNla3Iq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BADC43394;
	Wed, 21 Feb 2024 14:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525594;
	bh=ZCw6iP9BqPRwv4lVOv9Yy74fN6R9n7jV4pNV4cT0VkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eNla3Iq5bQ7xvd5b6lpySuNvT9Lwqlj+esKzvl8n2HJo0mxof/yeX4e15fSnUjC3+
	 Qf1UYTp1Vwe0M+82Mq0eE9iPGIbEzjTylZzzLuPkyVnxH8u2fKndTDjfFOX6pmA/e/
	 zV1m+bEuSQDB3RFZlxzT9HUyQ9b58KrL81cz7MQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lonial con <kongln9170@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 203/267] netfilter: nft_set_rbtree: skip end interval element from gc
Date: Wed, 21 Feb 2024 14:09:04 +0100
Message-ID: <20240221125946.544872153@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 60c0c230c6f046da536d3df8b39a20b9a9fd6af0 upstream.

rbtree lazy gc on insert might collect an end interval element that has
been just added in this transactions, skip end interval elements that
are not yet active.

Fixes: f718863aca46 ("netfilter: nft_set_rbtree: fix overlap expiration walk")
Cc: stable@vger.kernel.org
Reported-by: lonial con <kongln9170@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_rbtree.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -237,8 +237,7 @@ static void nft_rbtree_gc_remove(struct
 
 static int nft_rbtree_gc_elem(const struct nft_set *__set,
 			      struct nft_rbtree *priv,
-			      struct nft_rbtree_elem *rbe,
-			      u8 genmask)
+			      struct nft_rbtree_elem *rbe)
 {
 	struct nft_set *set = (struct nft_set *)__set;
 	struct rb_node *prev = rb_prev(&rbe->node);
@@ -257,7 +256,7 @@ static int nft_rbtree_gc_elem(const stru
 	while (prev) {
 		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
 		if (nft_rbtree_interval_end(rbe_prev) &&
-		    nft_set_elem_active(&rbe_prev->ext, genmask))
+		    nft_set_elem_active(&rbe_prev->ext, NFT_GENMASK_ANY))
 			break;
 
 		prev = rb_prev(prev);
@@ -365,7 +364,7 @@ static int __nft_rbtree_insert(const str
 		 */
 		if (nft_set_elem_expired(&rbe->ext) &&
 		    nft_set_elem_active(&rbe->ext, cur_genmask)) {
-			err = nft_rbtree_gc_elem(set, priv, rbe, genmask);
+			err = nft_rbtree_gc_elem(set, priv, rbe);
 			if (err < 0)
 				return err;
 


