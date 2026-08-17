Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEE443CEC1;
	Mon, 17 Aug 2026 15:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980221; cv=none; b=kl3jJ3/Kd5tO3cY10oDxMBSO7YADryIdK7E1hGotRLiCuF4vIHPGXS2S/V++96BxY9THlOYA6buMgL31WlYecM16uKeGb3JHZQeUMUWo/RJ9Nd8fKfBiFIP0x9jYnq5KC53Clo4A6lR3px4ASbBKT0f8n55HpoaExD2yvvnet48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980221; c=relaxed/simple;
	bh=hMfc12L0qtyrFfAIvrIRX1kmf3tmGQaXxA3hMqG6MJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKmxBASGjSuS19/dyF+RFfuV5BZDG51pMlUcLXXn3Q7eHipyjSSpOdBta1plktzCXK5c1EigNROGykyBhqxrk6DH2UwqX+NEYmhk17ILA08LNFiGZkVi4XRMJXyY8Hn9dCGSNvgQOgWCumZAxyU7fx5ewjqGQNcEjxPVvkSh4nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjr6CkC6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjr6CkC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5722F1F000E9;
	Mon, 17 Aug 2026 15:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980219;
	bh=8UfEkH6pdXLyJyXW+ZSJ3S8jk/7WBK5iPZviKolDtes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kjr6CkC6hikMgS3C6bGGjCj+hyaJONh1S4/+xH0/4RVkE64DqDNQPN1wT/fr/Gpre
	 ICEWXDREJDwpqJcJi64p9DaVHOd36AGk4HlUtgr+QMsLGsjmNip3m1rUQP/oJwOoca
	 LX91QtivZlknRJrPmgcCmnNpt0+nN5UU+QutT12M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zdi-disclosures@trendmicro.com,
	Santosh Kalluri <santosh.kalluri129@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 498/609] net/sched: cls_route: fix fastmap use-after-free on filter
Date: Mon, 17 Aug 2026 15:33:14 +0200
Message-ID: <20260817132600.555394627@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 47d7f7051253bdc02b1d245d87e38f16d31a74df ]

The route4 classifier maintains a 16-slot fastmap cache that stores raw
struct route4_filter pointers indexed by (id, iif). The reader
(route4_classify) populates this cache via route4_set_fastmap() for every
classified packet that hits a filter. The writer (route4_delete,
route4_change) clears the cache via route4_reset_fastmap() before
RCU-deferred kfree of the filter.

This creates a UAF race:
 1. Reader walks the RCU-protected bucket chain, finds filter f
 2. Writer unlinks f, calls route4_reset_fastmap(), then tcf_queue_work()
 3. Reader calls route4_set_fastmap() and writes f into the cache
    *after* the writer's reset, caching a pointer about to be freed
 4. After the RCU grace period, kfree(f) executes
 5. Next classified packet on the same (id, iif) tuple hits the stale
    fastmap entry and reads f->res from freed memory

Reproduced with an mdelay(100) accelerator in route4_set_fastmap() and a
concurrent add/delete stress test (provided by both zdi and Santosh).
Both triggered KASAN slab-use-after-free reports in the route4 fastmap
paths.

Fix:
Introduce a per-filter boolean dying flag to suppress stale fastmap
republishing by in-flight readers.

Fixes: 1109c00547fc ("net: sched: RCU cls_route")
Reported-by: zdi-disclosures@trendmicro.com
Reported-by: Santosh Kalluri <santosh.kalluri129@gmail.com>
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Tested-by: Victor Nogueira <victor@mojatatu.com>
Tested-by: Santosh Kalluri <santosh.kalluri129@gmail.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260729094411.46257-1-jhs@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_route.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
index 306188bf2d1ff..6c205fcb65475 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -51,6 +51,7 @@ struct route4_filter {
 	struct tcf_result	res;
 	struct tcf_exts		exts;
 	u32			handle;
+	bool			dying;
 	struct route4_bucket	*bkt;
 	struct tcf_proto	*tp;
 	struct rcu_work		rwork;
@@ -65,9 +66,11 @@ static inline int route4_fastmap_hash(u32 id, int iif)
 
 static DEFINE_SPINLOCK(fastmap_lock);
 static void
-route4_reset_fastmap(struct route4_head *head)
+route4_reset_fastmap(struct route4_head *head, struct route4_filter *f)
 {
 	spin_lock_bh(&fastmap_lock);
+	if (f)
+		f->dying = true;
 	memset(head->fastmap, 0, sizeof(head->fastmap));
 	spin_unlock_bh(&fastmap_lock);
 }
@@ -80,9 +83,11 @@ route4_set_fastmap(struct route4_head *head, u32 id, int iif,
 
 	/* fastmap updates must look atomic to aling id, iff, filter */
 	spin_lock_bh(&fastmap_lock);
-	head->fastmap[h].id = id;
-	head->fastmap[h].iif = iif;
-	head->fastmap[h].filter = f;
+	if (f == ROUTE4_FAILURE || !f->dying) {
+		head->fastmap[h].id = id;
+		head->fastmap[h].iif = iif;
+		head->fastmap[h].filter = f;
+	}
 	spin_unlock_bh(&fastmap_lock);
 }
 
@@ -295,6 +300,13 @@ static void route4_destroy(struct tcf_proto *tp, bool rtnl_held,
 					next = rtnl_dereference(f->next);
 					RCU_INIT_POINTER(b->ht[h2], next);
 					tcf_unbind_filter(tp, &f->res);
+					/* Mark the filter dying under fastmap_lock so
+					 * any in-flight reader that still holds it
+					 * will skip the republish in route4_set_fastmap().
+					 */
+					spin_lock_bh(&fastmap_lock);
+					f->dying = true;
+					spin_unlock_bh(&fastmap_lock);
 					if (tcf_exts_get_net(&f->exts))
 						route4_queue_work(f);
 					else
@@ -305,6 +317,11 @@ static void route4_destroy(struct tcf_proto *tp, bool rtnl_held,
 			kfree_rcu(b, rcu);
 		}
 	}
+
+	/* All filters are unlinked and marked dying, so no in-flight
+	 * reader can republish a stale entry after this reset.
+	 */
+	route4_reset_fastmap(head, NULL);
 	kfree_rcu(head, rcu);
 }
 
@@ -332,11 +349,11 @@ static int route4_delete(struct tcf_proto *tp, void *arg, bool *last,
 			/* unlink it */
 			RCU_INIT_POINTER(*fp, rtnl_dereference(f->next));
 
-			/* Remove any fastmap lookups that might ref filter
-			 * notice we unlink'd the filter so we can't get it
-			 * back in the fastmap.
+			/* Clear any fastmap entries that may ref this filter and
+			 * mark it dying so in-flight readers can't republish it
+			 * after the reset.
 			 */
-			route4_reset_fastmap(head);
+			route4_reset_fastmap(head, f);
 
 			/* Delete it */
 			tcf_unbind_filter(tp, &f->res);
@@ -551,7 +568,7 @@ static int route4_change(struct net *net, struct sk_buff *in_skb,
 		}
 	}
 
-	route4_reset_fastmap(head);
+	route4_reset_fastmap(head, fold);
 	*arg = f;
 	if (fold) {
 		tcf_unbind_filter(tp, &fold->res);
-- 
2.53.0



