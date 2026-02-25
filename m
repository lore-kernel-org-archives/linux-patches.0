Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDF7265CBE;
	Wed, 25 Feb 2026 01:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771984007; cv=none; b=W7T1asi2L7iUFPM6Koi91YzsTJzfgaFfSHZDTrp5YVMOun0g/4aaxn+f7GBsWxRGyDRE+5abrz8g/SzHAMQ8Co3tqqqh2mm/PSfdM6Hi4gzeQYDhFrGsnFJHA+1U9FeCnlMOBb+LIyljXHdYlst3eMiIvx48Qg8QxMC1Q8+Ea0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771984007; c=relaxed/simple;
	bh=ZhhpiGFh7er93iK67ms0fqWmSqierUy+QHZtBCmj+B0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sM3xg7SZwvf2ry991+MAkc4ubm+TsSfSJv4NBnh1D7sNnd5RX8P9IlFZNWuRSxMiY79Haux5KxCant8aBhptjKAHFp3K17n5Va4Jf4EMmp3/qXsKFXY8Z5M1gYGKs1HhqCgeLm9iga9AgCZuV+My/x/MZyzcecxJ4+b125EfBas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zp/BJ7ld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zp/BJ7ld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0384AC116D0;
	Wed, 25 Feb 2026 01:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771984007;
	bh=ZhhpiGFh7er93iK67ms0fqWmSqierUy+QHZtBCmj+B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zp/BJ7ld78BthmVazQirU62O0R9fkIM0k2a45MtuqcM/9peHdxy7raNVUlbYlwPR4
	 +RPrtwGpwH5qitFqizmh91xRGxxViSq+E+0hot4LINVUIwZf7oRnwLUoHA5w89ocuH
	 b+kYhWIFILfr7aQGQ5KA5Pki0SmaVi8OdwpNr3lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandra Rukomoinikova <ARukomoinikova@k2.cloud>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 258/641] netfilter: nf_conncount: increase the connection clean up limit to 64
Date: Tue, 24 Feb 2026 17:19:44 -0800
Message-ID: <20260225012355.083123436@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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



