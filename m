Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089A536C9ED
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302369; cv=none; b=K2YjO72huzEvPR5SNBpWxJU9D/jRedCtsjrL9wQziB31Gk4fR/A3ZdEGKtchC68LCkBikaoRD1B3qWECmOqMxOwT5sgsFZgNDrse2GnJrUjz2TLPmD0zpZUbeItI2TOMJpEK4e5zBYmw4kYt3P5uBPpLva7F7R4CeXxtCP6t4PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302369; c=relaxed/simple;
	bh=beAwWYjS10sqCTS9sRSfi8dxm4SWn9+OFzfmcu5GoZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sleeRSpwIAXEpEyved90gqz3joKgn0wGwtV53l4lf4UwJBfzMdULXEb1QK6eab27I/vn3XWKE1HxWZp7pY1t5olIphylGJ4PVnwAFXASsoL+RzCeKFnePFcM1Vms2kWbBxQ94KsNXgxokMokKuZLc9icgZ956gL6U27ysTTRBfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D+GdF0Pe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D+GdF0Pe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF76C4AF13;
	Sat, 28 Feb 2026 18:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302368;
	bh=beAwWYjS10sqCTS9sRSfi8dxm4SWn9+OFzfmcu5GoZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D+GdF0Pewk4Av5zRxnaPXu++yCK/0Lugr+ubdXBCdPEbKLTNsS3zBHKujnl1PIIgp
	 m7puP9iJJHk4Fj1y3us4WnUEH0RGfgjT5zaNg3gZnl9cfjbOd2skaIOCjyK7pNKMtR
	 jZr1nXVI61U6BwipBm3bIcesJb3UzD39AUOnnDojJSEm7Wthhy5oJei52pzu+g/ChO
	 /7X0htqaNK8jsiDj4q/Xkck/nhD8RS5iZJNbD+Q9LnZSANzG2z7hggt1nJXAHnD+U7
	 ulIJXNHZl9Ud3eZmLs7CqAWf7AUQ6LvnHcxJH3A0oy7y7MaP13vzH5h6ezbm6JQ0LG
	 HEVwLstqyRO5w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	Aleksandra Rukomoinikova <ARukomoinikova@k2.cloud>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/232] netfilter: nf_conncount: increase the connection clean up limit to 64
Date: Sat, 28 Feb 2026 13:09:10 -0500
Message-ID: <20260228181127.1592657-97-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 21d033e472735ecec677f1ae46d6740b5e47a4f3 ]

After the optimization to only perform one GC per jiffy, a new problem
was introduced. If more than 8 new connections are tracked per jiffy the
list won't be cleaned up fast enough possibly reaching the limit
wrongly.

In order to prevent this issue, only skip the GC if it was already
triggered during the same jiffy and the increment is lower than the
clean up limit. In addition, increase the clean up limit to 64
connections to avoid triggering GC too often and do more effective GCs.

This has been tested using a HTTP server and several
performance tools while having nft_connlimit/xt_connlimit or OVS limit
configured.

Output of slowhttptest + OVS limit at 52000 connections:

 slow HTTP test status on 340th second:
 initializing:        0
 pending:             432
 connected:           51998
 error:               0
 closed:              0
 service available:   YES

Fixes: d265929930e2 ("netfilter: nf_conncount: reduce unnecessary GC")
Reported-by: Aleksandra Rukomoinikova <ARukomoinikova@k2.cloud>
Closes: https://lore.kernel.org/netfilter/b2064e7b-0776-4e14-adb6-c68080987471@k2.cloud/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_conntrack_count.h |  1 +
 net/netfilter/nf_conncount.c               | 15 ++++++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_count.h b/include/net/netfilter/nf_conntrack_count.h
index 115bb7e572f7d..bf22661925b81 100644
--- a/include/net/netfilter/nf_conntrack_count.h
+++ b/include/net/netfilter/nf_conntrack_count.h
@@ -13,6 +13,7 @@ struct nf_conncount_list {
 	u32 last_gc;		/* jiffies at most recent gc */
 	struct list_head head;	/* connections with the same filtering key */
 	unsigned int count;	/* length of list */
+	unsigned int last_gc_count; /* length of list at most recent gc */
 };
 
 struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int family,
diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 70e9662fe1777..47bdd8d121bb5 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -34,8 +34,9 @@
 
 #define CONNCOUNT_SLOTS		256U
 
-#define CONNCOUNT_GC_MAX_NODES	8
-#define MAX_KEYLEN		5
+#define CONNCOUNT_GC_MAX_NODES		8
+#define CONNCOUNT_GC_MAX_COLLECT	64
+#define MAX_KEYLEN			5
 
 /* we will save the tuples of all connections we care about */
 struct nf_conncount_tuple {
@@ -182,12 +183,13 @@ static int __nf_conncount_add(struct net *net,
 		goto out_put;
 	}
 
-	if ((u32)jiffies == list->last_gc)
+	if ((u32)jiffies == list->last_gc &&
+	    (list->count - list->last_gc_count) < CONNCOUNT_GC_MAX_COLLECT)
 		goto add_new_node;
 
 	/* check the saved connections */
 	list_for_each_entry_safe(conn, conn_n, &list->head, node) {
-		if (collect > CONNCOUNT_GC_MAX_NODES)
+		if (collect > CONNCOUNT_GC_MAX_COLLECT)
 			break;
 
 		found = find_or_evict(net, list, conn);
@@ -230,6 +232,7 @@ static int __nf_conncount_add(struct net *net,
 		nf_ct_put(found_ct);
 	}
 	list->last_gc = (u32)jiffies;
+	list->last_gc_count = list->count;
 
 add_new_node:
 	if (WARN_ON_ONCE(list->count > INT_MAX)) {
@@ -277,6 +280,7 @@ void nf_conncount_list_init(struct nf_conncount_list *list)
 	spin_lock_init(&list->list_lock);
 	INIT_LIST_HEAD(&list->head);
 	list->count = 0;
+	list->last_gc_count = 0;
 	list->last_gc = (u32)jiffies;
 }
 EXPORT_SYMBOL_GPL(nf_conncount_list_init);
@@ -316,13 +320,14 @@ static bool __nf_conncount_gc_list(struct net *net,
 		}
 
 		nf_ct_put(found_ct);
-		if (collected > CONNCOUNT_GC_MAX_NODES)
+		if (collected > CONNCOUNT_GC_MAX_COLLECT)
 			break;
 	}
 
 	if (!list->count)
 		ret = true;
 	list->last_gc = (u32)jiffies;
+	list->last_gc_count = list->count;
 
 	return ret;
 }
-- 
2.51.0

