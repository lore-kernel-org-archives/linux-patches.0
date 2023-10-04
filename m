Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179BD1CF94
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jp+YzUl4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F575C433C7;
	Wed,  4 Oct 2023 18:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443788;
	bh=zBy5N0u2Z8uki96m7jNymF83WXmfoXm+dPtk7hKVadI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jp+YzUl4aTTd9+jL3/VGudRsnbQelkeuMPNz8RKWa7YIhUmV2FZBxI590eXnWi2uN
	 0u8b3dGfj4+ci7EJTwUP22KvGG4PI8Y/IQomuuvsvqqxhQH4HwiPWi5Ow8B+gZr4OD
	 jJs0Wm4mbRDC1CELlii2KYfVA8voBPrMbJgrMGNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 020/321] netfilter: nft_set_pipapo: call nft_trans_gc_queue_sync() in catchall GC
Date: Wed,  4 Oct 2023 19:52:45 +0200
Message-ID: <20231004175230.128831570@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 4a9e12ea7e70223555ec010bec9f711089ce96f6 upstream.

pipapo needs to enqueue GC transactions for catchall elements through
nft_trans_gc_queue_sync(). Add nft_trans_gc_catchall_sync() and
nft_trans_gc_catchall_async() to handle GC transaction queueing
accordingly.

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Fixes: f6c383b8c31a ("netfilter: nf_tables: adapt set backend to use GC transaction API")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  5 +++--
 net/netfilter/nf_tables_api.c     | 22 +++++++++++++++++++---
 net/netfilter/nft_set_hash.c      |  2 +-
 net/netfilter/nft_set_pipapo.c    |  2 +-
 net/netfilter/nft_set_rbtree.c    |  2 +-
 5 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index dd40c75011d25..a4455f4995abf 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1700,8 +1700,9 @@ void nft_trans_gc_queue_sync_done(struct nft_trans_gc *trans);
 
 void nft_trans_gc_elem_add(struct nft_trans_gc *gc, void *priv);
 
-struct nft_trans_gc *nft_trans_gc_catchall(struct nft_trans_gc *gc,
-					   unsigned int gc_seq);
+struct nft_trans_gc *nft_trans_gc_catchall_async(struct nft_trans_gc *gc,
+						 unsigned int gc_seq);
+struct nft_trans_gc *nft_trans_gc_catchall_sync(struct nft_trans_gc *gc);
 
 void nft_setelem_data_deactivate(const struct net *net,
 				 const struct nft_set *set,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a72934f00804e..bba8042f721a5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9602,8 +9602,9 @@ void nft_trans_gc_queue_sync_done(struct nft_trans_gc *trans)
 	call_rcu(&trans->rcu, nft_trans_gc_trans_free);
 }
 
-struct nft_trans_gc *nft_trans_gc_catchall(struct nft_trans_gc *gc,
-					   unsigned int gc_seq)
+static struct nft_trans_gc *nft_trans_gc_catchall(struct nft_trans_gc *gc,
+						  unsigned int gc_seq,
+						  bool sync)
 {
 	struct nft_set_elem_catchall *catchall;
 	const struct nft_set *set = gc->set;
@@ -9619,7 +9620,11 @@ struct nft_trans_gc *nft_trans_gc_catchall(struct nft_trans_gc *gc,
 
 		nft_set_elem_dead(ext);
 dead_elem:
-		gc = nft_trans_gc_queue_async(gc, gc_seq, GFP_ATOMIC);
+		if (sync)
+			gc = nft_trans_gc_queue_sync(gc, GFP_ATOMIC);
+		else
+			gc = nft_trans_gc_queue_async(gc, gc_seq, GFP_ATOMIC);
+
 		if (!gc)
 			return NULL;
 
@@ -9629,6 +9634,17 @@ struct nft_trans_gc *nft_trans_gc_catchall(struct nft_trans_gc *gc,
 	return gc;
 }
 
+struct nft_trans_gc *nft_trans_gc_catchall_async(struct nft_trans_gc *gc,
+						 unsigned int gc_seq)
+{
+	return nft_trans_gc_catchall(gc, gc_seq, false);
+}
+
+struct nft_trans_gc *nft_trans_gc_catchall_sync(struct nft_trans_gc *gc)
+{
+	return nft_trans_gc_catchall(gc, 0, true);
+}
+
 static void nf_tables_module_autoload_cleanup(struct net *net)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 524763659f251..eca20dc601384 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -372,7 +372,7 @@ static void nft_rhash_gc(struct work_struct *work)
 		nft_trans_gc_elem_add(gc, he);
 	}
 
-	gc = nft_trans_gc_catchall(gc, gc_seq);
+	gc = nft_trans_gc_catchall_async(gc, gc_seq);
 
 try_later:
 	/* catchall list iteration requires rcu read side lock. */
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 6af9c9ed4b5c3..10b89ac74476b 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1610,7 +1610,7 @@ static void pipapo_gc(const struct nft_set *_set, struct nft_pipapo_match *m)
 		}
 	}
 
-	gc = nft_trans_gc_catchall(gc, 0);
+	gc = nft_trans_gc_catchall_sync(gc);
 	if (gc) {
 		nft_trans_gc_queue_sync_done(gc);
 		priv->last_gc = jiffies;
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 70491ba98decb..487572dcd6144 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -669,7 +669,7 @@ static void nft_rbtree_gc(struct work_struct *work)
 		nft_trans_gc_elem_add(gc, rbe);
 	}
 
-	gc = nft_trans_gc_catchall(gc, gc_seq);
+	gc = nft_trans_gc_catchall_async(gc, gc_seq);
 
 try_later:
 	read_unlock_bh(&priv->lock);
-- 
2.40.1



