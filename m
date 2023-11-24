Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244EA35F1A;
	Fri, 24 Nov 2023 19:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qLWxw38k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD46C433CB;
	Fri, 24 Nov 2023 19:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853488;
	bh=9NGid/NsgUBHbWJWMUt+Fmj9uMY/IhzpIOaKYuHGlXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qLWxw38kqHXO5Z0gFF87a/Aog3981FPLtGE62uNxOQrbFAKVnrtP/FViDZNa8U9+s
	 ES0glTJS6uXUnqmHu85Erfx+CldjyIz40bR6k1XJefKavD/73ZHeGgR3/sQ3c/dJYC
	 W4cYnd58075tDhH0ADjWzbBRzu5bzCgjxMMF7QS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 208/297] netfilter: nf_tables: split async and sync catchall in two functions
Date: Fri, 24 Nov 2023 17:54:10 +0000
Message-ID: <20231124172007.491599848@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

[ Upstream commit 8837ba3e58ea1e3d09ae36db80b1e80853aada95 ]

list_for_each_entry_safe() does not work for the async case which runs
under RCU, therefore, split GC logic for catchall in two functions
instead, one for each of the sync and async GC variants.

The catchall sync GC variant never sees a _DEAD bit set on ever, thus,
this handling is removed in such case, moreover, allocate GC sync batch
via GFP_KERNEL.

Fixes: 93995bf4af2c ("netfilter: nf_tables: remove catchall element in GC sync path")
Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 61 ++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 29 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e9d0c6c8e0b12..bf0bd44f2fb3a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9047,16 +9047,14 @@ void nft_trans_gc_queue_sync_done(struct nft_trans_gc *trans)
 	call_rcu(&trans->rcu, nft_trans_gc_trans_free);
 }
 
-static struct nft_trans_gc *nft_trans_gc_catchall(struct nft_trans_gc *gc,
-						  unsigned int gc_seq,
-						  bool sync)
+struct nft_trans_gc *nft_trans_gc_catchall_async(struct nft_trans_gc *gc,
+						 unsigned int gc_seq)
 {
-	struct nft_set_elem_catchall *catchall, *next;
+	struct nft_set_elem_catchall *catchall;
 	const struct nft_set *set = gc->set;
-	struct nft_elem_priv *elem_priv;
 	struct nft_set_ext *ext;
 
-	list_for_each_entry_safe(catchall, next, &set->catchall_list, list) {
+	list_for_each_entry_rcu(catchall, &set->catchall_list, list) {
 		ext = nft_set_elem_ext(set, catchall->elem);
 
 		if (!nft_set_elem_expired(ext))
@@ -9066,39 +9064,44 @@ static struct nft_trans_gc *nft_trans_gc_catchall(struct nft_trans_gc *gc,
 
 		nft_set_elem_dead(ext);
 dead_elem:
-		if (sync)
-			gc = nft_trans_gc_queue_sync(gc, GFP_ATOMIC);
-		else
-			gc = nft_trans_gc_queue_async(gc, gc_seq, GFP_ATOMIC);
-
+		gc = nft_trans_gc_queue_async(gc, gc_seq, GFP_ATOMIC);
 		if (!gc)
 			return NULL;
 
-		elem_priv = catchall->elem;
-		if (sync) {
-			struct nft_set_elem elem = {
-				.priv = elem_priv,
-			};
-
-			nft_setelem_data_deactivate(gc->net, gc->set, &elem);
-			nft_setelem_catchall_destroy(catchall);
-		}
-
-		nft_trans_gc_elem_add(gc, elem_priv);
+		nft_trans_gc_elem_add(gc, catchall->elem);
 	}
 
 	return gc;
 }
 
-struct nft_trans_gc *nft_trans_gc_catchall_async(struct nft_trans_gc *gc,
-						 unsigned int gc_seq)
-{
-	return nft_trans_gc_catchall(gc, gc_seq, false);
-}
-
 struct nft_trans_gc *nft_trans_gc_catchall_sync(struct nft_trans_gc *gc)
 {
-	return nft_trans_gc_catchall(gc, 0, true);
+	struct nft_set_elem_catchall *catchall, *next;
+	const struct nft_set *set = gc->set;
+	struct nft_set_elem elem;
+	struct nft_set_ext *ext;
+
+	WARN_ON_ONCE(!lockdep_commit_lock_is_held(gc->net));
+
+	list_for_each_entry_safe(catchall, next, &set->catchall_list, list) {
+		ext = nft_set_elem_ext(set, catchall->elem);
+
+		if (!nft_set_elem_expired(ext))
+			continue;
+
+		gc = nft_trans_gc_queue_sync(gc, GFP_KERNEL);
+		if (!gc)
+			return NULL;
+
+		memset(&elem, 0, sizeof(elem));
+		elem.priv = catchall->elem;
+
+		nft_setelem_data_deactivate(gc->net, gc->set, &elem);
+		nft_setelem_catchall_destroy(catchall);
+		nft_trans_gc_elem_add(gc, elem.priv);
+	}
+
+	return gc;
 }
 
 static void nf_tables_module_autoload_cleanup(struct net *net)
-- 
2.42.0



