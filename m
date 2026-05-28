Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A6B32ABC0;
	Thu, 28 May 2026 20:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999153; cv=none; b=T9/ssu5wuos4gaLhZtZp9+ZNS0sfi4q5ZtqZSdZb5/X1jx7sXOJ/KlkEkPUGCrukJSDxdvoJ/nMT0r8AtiGE/YIpOvVolntn+PDDN8T93CcUMlBEJCPxogmtXgVFS7QrfaWfwMm3X6+xE4+0y5cCwYSr7VtKgc4oColCCkZwO3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999153; c=relaxed/simple;
	bh=+Q3zBdC8lrOXsyo4Bom+QHVSmoEo6CngYO3HPJjNJWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzZ+pZzQKZMU2oW4noTEOwuJ9A/sEbByBJXLNl3To87nYKxF2Jt8DMEfJ1Orm9R5Iwns5074tAeiOO6UglerhMwGGLpKb++5CTd3IXAKSDD1M1t/4+wjDYvGn09I9MNyrFOrIkHeiBTYe79L2FnBfn/kGM1jy+hqhypODvdKiqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YsS/53hF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YsS/53hF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10BF1F000E9;
	Thu, 28 May 2026 20:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999152;
	bh=wwg5Cjga/IPbBpVz/JZqaQV6rSBpvigdKhfziTDpueU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YsS/53hFI1gVIuQZrn2jJm9X7+vxqCeXsziXpUrsvPkkM11pEda8RfVa1NX1HP20e
	 a5pYr0yV1bGZtVVOyg95+RYWi3K/MWTNW5JKNB6dtA83DfAWwDtUsO057YbXCvi9U6
	 dHqAE1QYbXdQ1BwvmNcVaVnMD2GtDLuhUz6OCiFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 426/461] net: shaper: rework the VALID marking (again)
Date: Thu, 28 May 2026 21:49:15 +0200
Message-ID: <20260528194659.841569051@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit b8d7519352ba8c6df83259295d4a3bad093cae90 ]

Recent commit changed the semantics from NOT_VALID to VALID.
I didn't realize that the flags are not stored atomically
with the entry in XArray. There's still a race of reader
observing a VALID mark for a slot, getting interrupted,
writer replacing the entry with a different one, reader
continuing, fetching the entry which is now a different
pointer than the pointer for which VALID was meant.

The biggest consequence of this is that we may see a UAF
since net_shaper_rollback() assumed that entries without
VALID can be freed without observing RCU.

Looks like the XArray marks are buying us nothing at this
point. Let's convert the code to an explicit valid field.
The smp_load_acquire() / smp_store_release() barriers are
marginally cleaner.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 93954b40f6a4 ("net-shapers: implement NL set and delete operations")
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260515221325.1685455-3-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/net_shaper.h |  1 +
 net/shaper/shaper.c      | 45 ++++++++++++++++------------------------
 2 files changed, 19 insertions(+), 27 deletions(-)

diff --git a/include/net/net_shaper.h b/include/net/net_shaper.h
index 5c3f49b52fe96..3939b816b0011 100644
--- a/include/net/net_shaper.h
+++ b/include/net/net_shaper.h
@@ -53,6 +53,7 @@ struct net_shaper {
 
 	/* private: */
 	u32 leaves; /* accounted only for NODE scope */
+	bool valid;
 	struct rcu_head rcu;
 };
 
diff --git a/net/shaper/shaper.c b/net/shaper/shaper.c
index 520cefdc3d908..dea9270f3e57d 100644
--- a/net/shaper/shaper.c
+++ b/net/shaper/shaper.c
@@ -306,31 +306,24 @@ static void net_shaper_default_parent(const struct net_shaper_handle *handle,
 	parent->id = 0;
 }
 
-/* MARK_0 is already in use due to XA_FLAGS_ALLOC. The VALID mark is set on
- * an entry only after the device-side configuration has completed
- * successfully (see net_shaper_commit()). Lookups and dumps must filter on
- * this mark to avoid exposing tentative entries inserted by
- * net_shaper_pre_insert() while the driver call is still in flight.
- */
-#define NET_SHAPER_VALID	XA_MARK_1
-
 static struct net_shaper *
 net_shaper_lookup(struct net_shaper_binding *binding,
 		  const struct net_shaper_handle *handle)
 {
 	u32 index = net_shaper_handle_to_index(handle);
 	struct net_shaper_hierarchy *hierarchy;
+	struct net_shaper *cur;
 
 	hierarchy = net_shaper_hierarchy_rcu(binding);
-	if (!hierarchy || !xa_get_mark(&hierarchy->shapers, index,
-				       NET_SHAPER_VALID))
+	if (!hierarchy)
 		return NULL;
 
-	/* Pairs with smp_wmb() in net_shaper_commit(): if the entry is
-	 * valid, its contents must be visible too.
-	 */
-	smp_rmb();
-	return xa_load(&hierarchy->shapers, index);
+	cur = xa_load(&hierarchy->shapers, index);
+	/* Check valid before reading fields */
+	if (!cur || !smp_load_acquire(&cur->valid))
+		return NULL;
+
+	return cur;
 }
 
 /* Allocate on demand the per device shaper's hierarchy container.
@@ -444,12 +437,10 @@ static void net_shaper_commit(struct net_shaper_binding *binding,
 		if (WARN_ON_ONCE(!cur))
 			continue;
 
-		/* Successful update: drop the tentative mark
-		 * and update the hierarchy container.
-		 */
+		/* Successful update: update the hierarchy container... */
 		net_shaper_copy(cur, &shapers[i]);
-		smp_wmb();
-		__xa_set_mark(&hierarchy->shapers, index, NET_SHAPER_VALID);
+		/* ... publish to lockless readers. */
+		smp_store_release(&cur->valid, true);
 	}
 	xa_unlock(&hierarchy->shapers);
 }
@@ -466,10 +457,10 @@ static void net_shaper_rollback(struct net_shaper_binding *binding)
 
 	xa_lock(&hierarchy->shapers);
 	xa_for_each(&hierarchy->shapers, index, cur) {
-		if (xa_get_mark(&hierarchy->shapers, index, NET_SHAPER_VALID))
+		if (cur->valid)
 			continue;
 		__xa_erase(&hierarchy->shapers, index);
-		kfree(cur);
+		kfree_rcu(cur, rcu);
 	}
 	xa_unlock(&hierarchy->shapers);
 }
@@ -882,12 +873,12 @@ int net_shaper_nl_get_dumpit(struct sk_buff *skb,
 		goto out_unlock;
 
 	for (; (shaper = xa_find(&hierarchy->shapers, &ctx->start_index,
-				 U32_MAX, NET_SHAPER_VALID));
+				 U32_MAX, XA_PRESENT));
 	     ctx->start_index++) {
-		/* Pairs with smp_wmb() in net_shaper_commit(): the entry
-		 * is marked VALID, so its contents must be visible too.
-		 */
-		smp_rmb();
+		/* Check valid before reading fields */
+		if (!smp_load_acquire(&shaper->valid))
+			continue;
+
 		ret = net_shaper_fill_one(skb, binding, shaper, info);
 		if (ret)
 			break;
-- 
2.53.0



