Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBD83EDAB8;
	Mon, 17 Aug 2026 13:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974001; cv=none; b=frrXeiyXbvWTeJ/JmjyClOWBf/FqoRam2eNcFyZ3G3/riqGc0YJs4ls2MZfG8c/ls7aIhJRN007+BnZ+nmR+HXbrMgkeRKcaUWZhxqNAQiMCNwPIyd+Q364/F9NZN84HN3BKbBP6iCsma64IqHti82gGo08u3Y99/a0bOI5WjLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974001; c=relaxed/simple;
	bh=LSrVfRnG17gsUgl32GbwGUUgdAA5MnQiTW4mPy7T6BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJJsw6hkpijy2EDZ1QT/hb/OhsKkVn5hxVZcYpxHqyQSoa1PrgRzqxs6K0vsug2MhXB2Qpcuz8C1ILsLsdhFTvUFci2nraeZm6rN/c1pKbBtaGBiDrb24P1hYUpknSz3TzjLEFEZaZUh/sprYP7S+TvXoDC/qllyd2U3h4WpM8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xMpkd1xS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xMpkd1xS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C8C1F000E9;
	Mon, 17 Aug 2026 13:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973999;
	bh=BrXSrNnSP+NzRWyo8xr/4JksKhkNTdsEBBU12VpZf+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xMpkd1xSMu2hWQWytER2ZM9p55dyz4d2EI5mwhMWbz5TAwvvoj+O6yhknoWIvRBx7
	 XUpKaxNUTM1t3yoyYss7jU+05NNRB+PUxo+5UjgE+QMbq8nsBQsgA+5CymhRyyfYKo
	 iyUYq28XiX242GM+vk5J/5P+QHVvOMl1p3ClhCEQ=
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
Subject: [PATCH 7.1 055/271] net/sched: cls_route: fix fastmap use-after-free on filter
Date: Mon, 17 Aug 2026 15:29:40 +0200
Message-ID: <20260817132539.007220466@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index bd6f945bd3883..eded7aacd3f70 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -52,6 +52,7 @@ struct route4_filter {
 	struct tcf_result	res;
 	struct tcf_exts		exts;
 	u32			handle;
+	bool			dying;
 	struct route4_bucket	*bkt;
 	struct tcf_proto	*tp;
 	struct rcu_work		rwork;
@@ -66,9 +67,11 @@ static inline int route4_fastmap_hash(u32 id, int iif)
 
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
@@ -81,9 +84,11 @@ route4_set_fastmap(struct route4_head *head, u32 id, int iif,
 
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
 
@@ -297,6 +302,13 @@ static void route4_destroy(struct tcf_proto *tp, bool rtnl_held,
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
@@ -307,6 +319,11 @@ static void route4_destroy(struct tcf_proto *tp, bool rtnl_held,
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
 
@@ -334,11 +351,11 @@ static int route4_delete(struct tcf_proto *tp, void *arg, bool *last,
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
@@ -558,7 +575,7 @@ static int route4_change(struct net *net, struct sk_buff *in_skb,
 		}
 	}
 
-	route4_reset_fastmap(head);
+	route4_reset_fastmap(head, fold);
 	*arg = f;
 	if (fold) {
 		tcf_unbind_filter(tp, &fold->res);
-- 
2.53.0



