Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585F634252B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301781; cv=none; b=LIjvs/9DWFsUkXPl+4LdY83yfHWunjjVq6BhtkBsoLtTJ9fnkP4chak6l4kLPYMTZqQQ2AHoF+SpdapvvkrMNkULwJypiHMY/OWWfnSnMFIMXUIj1SD/Gq/qdnw4j8IOkWJhCrY6arkk8p8dtGqCz4Xr3f/DgKO0rZ2pLn68zkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301781; c=relaxed/simple;
	bh=vuqZpVS4Lc0Q4MGAH1gDK6ObCGPK+/djvaV/Ymj7+7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uA+00TM7jz1eGl6Ws2DNho8rxOf60gh21rEWyPEW6LFWPEMIaMkY0sM0F0yVh1Rai8ig1w/7jaD92Yeh2y5Hgg8BonGR+AO9YTMXXVdb07/WiW8eN8Odul4RGeKYDX8XJx4sIKONFkBy4DtxDyUVYWCUU9kevmI1jsaDWTk33eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ly4k6h82; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ly4k6h82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C54C19423;
	Sat, 28 Feb 2026 18:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301781;
	bh=vuqZpVS4Lc0Q4MGAH1gDK6ObCGPK+/djvaV/Ymj7+7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ly4k6h82aepS0z8gR+jzpNI18NQtJ/7ur4y7+nbkXEkDfTbwZT0OnS8VK6ZJK6QfR
	 XCaQ59N467C/6t2283SJtqOYQlw00xsdq5rfEnZJf9ipIKwsgvKZtVtazgasAfDjBz
	 xDcWBC0A1+2Hw/NbdJLaZgexv+cjHd/QsPMbTCM1eYwr0J9QZBnekg1zvt8Q+LcR+b
	 8HQi7rOnnaoCwC9wTDKQAHQDGPCSCAPXouqvCY+bS5FWMyQStFatpCojympYyeaRGR
	 4QQmXdJEd4V6N+NmGEYQHf05sSxl7qlhHiRoK8kHzuxET99boingnyD+H0zKCw9nO9
	 jMKltoeP/vVxw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	Aleksandra Rukomoinikova <ARukomoinikova@k2.cloud>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 191/385] netfilter: nf_conncount: increase the connection clean up limit to 64
Date: Sat, 28 Feb 2026 12:56:53 -0500
Message-ID: <20260228180011.1568201-191-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 52a06de41aa0f..cf0166520cf33 100644
--- a/include/net/netfilter/nf_conntrack_count.h
+++ b/include/net/netfilter/nf_conntrack_count.h
@@ -13,6 +13,7 @@ struct nf_conncount_list {
 	u32 last_gc;		/* jiffies at most recent gc */
 	struct list_head head;	/* connections with the same filtering key */
 	unsigned int count;	/* length of list */
+	unsigned int last_gc_count; /* length of list at most recent gc */
 };
 
 struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int keylen);
diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 8487808c87614..288936f5c1bf9 100644
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

