Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C801095F
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704CBC433C0;
	Mon, 19 Jun 2023 10:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170627;
	bh=0fLyNTZ4hhugsgYS/zeY7m0ISDGhU0boRxpRpOmeDBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3ybYvYeVhe8hNGalKoF2T/VP/Go56i+N/+ILuaePo6W6K0+mZ9UF1hqFjon2Ymhn
	 dFySHtZQnaOTj/DIRfPmStwstkFb9Ehtbt44uDWRYKrEyEfBMObmROzTLK9ug9C/vx
	 VJWIhbheLyqHL7qxf6mYiTVRDtXuZKxWTPfhM+3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 30/32] neighbour: delete neigh_lookup_nodev as not used
Date: Mon, 19 Jun 2023 12:29:18 +0200
Message-ID: <20230619102129.130942122@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102127.461443957@linuxfoundation.org>
References: <20230619102127.461443957@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

commit 76b9bf965c98c9b53ef7420b3b11438dbd764f92 upstream.

neigh_lookup_nodev isn't used in the kernel after removal
of DECnet. So let's remove it.

Fixes: 1202cdd66531 ("Remove DECnet support from kernel")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/eb5656200d7964b2d177a36b77efa3c597d6d72d.1678267343.git.leonro@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/neighbour.h |    2 --
 net/core/neighbour.c    |   31 -------------------------------
 2 files changed, 33 deletions(-)

--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -299,8 +299,6 @@ void neigh_table_init(int index, struct
 int neigh_table_clear(int index, struct neigh_table *tbl);
 struct neighbour *neigh_lookup(struct neigh_table *tbl, const void *pkey,
 			       struct net_device *dev);
-struct neighbour *neigh_lookup_nodev(struct neigh_table *tbl, struct net *net,
-				     const void *pkey);
 struct neighbour *__neigh_create(struct neigh_table *tbl, const void *pkey,
 				 struct net_device *dev, bool want_ref);
 static inline struct neighbour *neigh_create(struct neigh_table *tbl,
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -474,37 +474,6 @@ struct neighbour *neigh_lookup(struct ne
 }
 EXPORT_SYMBOL(neigh_lookup);
 
-struct neighbour *neigh_lookup_nodev(struct neigh_table *tbl, struct net *net,
-				     const void *pkey)
-{
-	struct neighbour *n;
-	int key_len = tbl->key_len;
-	u32 hash_val;
-	struct neigh_hash_table *nht;
-
-	NEIGH_CACHE_STAT_INC(tbl, lookups);
-
-	rcu_read_lock_bh();
-	nht = rcu_dereference_bh(tbl->nht);
-	hash_val = tbl->hash(pkey, NULL, nht->hash_rnd) >> (32 - nht->hash_shift);
-
-	for (n = rcu_dereference_bh(nht->hash_buckets[hash_val]);
-	     n != NULL;
-	     n = rcu_dereference_bh(n->next)) {
-		if (!memcmp(n->primary_key, pkey, key_len) &&
-		    net_eq(dev_net(n->dev), net)) {
-			if (!refcount_inc_not_zero(&n->refcnt))
-				n = NULL;
-			NEIGH_CACHE_STAT_INC(tbl, hits);
-			break;
-		}
-	}
-
-	rcu_read_unlock_bh();
-	return n;
-}
-EXPORT_SYMBOL(neigh_lookup_nodev);
-
 struct neighbour *__neigh_create(struct neigh_table *tbl, const void *pkey,
 				 struct net_device *dev, bool want_ref)
 {


