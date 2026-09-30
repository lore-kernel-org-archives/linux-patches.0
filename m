Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5ADF3D3CE5;
	Wed, 30 Sep 2026 19:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795501; cv=none; b=sv+AhWYa/TlzS98CwvIo9PHsGVn8ETDpuXA7n1mbfFpDVB8AmJ0f+dlsASK8tAHuNDlHu4C5afBYpBjS1H5pLR62fXziWijsvNIoSE3Er8uBQRXbZ37/FFGeDK6DLfUJpdNNVJD59gBzwA60L1+Ke4l0YatGy9Y0BK57U86ZReQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795501; c=relaxed/simple;
	bh=e0hnew/78KyALapKW80W7JOnC2iWoorrZkOeIB6CyWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+jQPNcyZjRP5LgtQ6Yf+GNXcgY2lrzTUx+bQeaKnXfWU4oq4/OhD7PHotri3PTyCAzyzY4CtSrYXV0rUd44Qapq9R7ilaDNimGMLZXKVn47ynwvBa14HQiBfHqSpnkLZYxcawZAEtNeUtmc797sT89uqtJUnKMSdMTqv7Q1T+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q3sAlLdR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q3sAlLdR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A50E1F000FF;
	Wed, 30 Sep 2026 19:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795499;
	bh=+4cO/wWrIyVOPaGx2yoX5MzdTqaYI6cyJw1JJ9kI004=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q3sAlLdR1vL41SGqjJweXfKh+KofbXdNrxHDA7WMVuvjFrFscDh7hd+ZWv5TkWboY
	 xT2BNv9i8kXpD6I1/lbrE1azHBMgDPlFpRh7Pw3wjfxU5xkS5Ez28OQ9laZ6UR29lL
	 SZrE8o95x7EiQDkFOFiHokyaFgRryTVZLe56/kqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0583/1193] net/sched: cls_route: free emptied bucket on filter move
Date: Wed, 30 Sep 2026 17:21:07 +0200
Message-ID: <20260930152447.196668513@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit 1853f30cf5c84971f99788a76207c6f745380896 ]

route4_change can move an existing filter to a different top-level
bucket: route4_set_parms recomputes the handle from TCA_ROUTE4_TO/
FROM/IIF, and the handle-mismatch check is gated on the 'new' flag, so
for an existing filter the new handle may differ from the old one and
land in a different bucket. When this happens, the filter is unlinked
from the old bucket, but the bucket itself is never freed once it goes
empty. The stale empty bucket remains in head->table[], causing
route4_delete to report *last=false even after the last live filter is
gone. That pins the empty tcf_proto and causes a leak.

Fix this by refcounting the filters linked to a bucket and freeing the
bucket when the count drops to zero. The existing scan in route4_delete
goes away with it.

The count is updated at all sites that link or unlink a filter during add,
change and delete, and the bucket is dropped from head->table[] as soon as
it reaches zero.

Conditions to recreate the bug:
  CONFIG_NET_CLS_ROUTE4=y, CONFIG_NET_SCH_INGRESS=y, CONFIG_NET_CLS_ACT=y.

  tc qdisc replace dev lo clsact
  tc filter add dev lo ingress protocol ip pref 100 route from 1 to 1
  tc filter change dev lo ingress protocol ip pref 100 handle 0x10001 \
    route from 1 to 2
  tc filter del dev lo ingress protocol ip pref 100 handle 0x10002 \
    route from 1 to 2
  tc filter show dev lo ingress | grep -c 'pref 100 route chain 0 '

Fixes: 1e052be69d04 ("net_sched: destroy proto tp when all filters are gone")
Reported-by: Vega <vega@nebusec.ai>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Link: https://patch.msgid.link/20260907192133.2639067-2-victor@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_route.c | 45 +++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
index fd72ab9d19eac..e725d293f0779 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/errno.h>
+#include <linux/refcount.h>
 #include <linux/skbuff.h>
 #include <net/dst.h>
 #include <net/route.h>
@@ -41,6 +42,7 @@ struct route4_head {
 struct route4_bucket {
 	/* 16 FROM buckets + 16 IIF buckets + 1 wildcard bucket */
 	struct route4_filter __rcu	*ht[16 + 16 + 1];
+	refcount_t			filters_ref;
 	struct rcu_head			rcu;
 };
 
@@ -336,7 +338,7 @@ static int route4_delete(struct tcf_proto *tp, void *arg, bool *last,
 	struct route4_filter *nf;
 	struct route4_bucket *b;
 	unsigned int h = 0;
-	int i, h1;
+	int h1;
 
 	if (!head || !f)
 		return -EINVAL;
@@ -362,23 +364,14 @@ static int route4_delete(struct tcf_proto *tp, void *arg, bool *last,
 			tcf_exts_get_net(&f->exts);
 			tcf_queue_work(&f->rwork, route4_delete_filter_work);
 
-			/* Strip RTNL protected tree */
-			for (i = 0; i <= 32; i++) {
-				struct route4_filter *rt;
-
-				rt = rtnl_dereference(b->ht[i]);
-				if (rt)
-					goto out;
+			if (refcount_dec_and_test(&b->filters_ref)) {
+				RCU_INIT_POINTER(head->table[to_hash(h)], NULL);
+				kfree_rcu(b, rcu);
 			}
-
-			/* OK, session has no flows */
-			RCU_INIT_POINTER(head->table[to_hash(h)], NULL);
-			kfree_rcu(b, rcu);
 			break;
 		}
 	}
 
-out:
 	*last = true;
 	for (h1 = 0; h1 <= 256; h1++) {
 		if (rcu_access_pointer(head->table[h1])) {
@@ -455,6 +448,7 @@ static int route4_set_parms(struct net *net, struct tcf_proto *tp,
 		if (b == NULL)
 			return -ENOBUFS;
 
+		refcount_set(&b->filters_ref, 1);
 		rcu_assign_pointer(head->table[h1], b);
 	} else {
 		unsigned int h2 = from_hash(nhandle >> 16);
@@ -464,6 +458,8 @@ static int route4_set_parms(struct net *net, struct tcf_proto *tp,
 		     fp = rtnl_dereference(fp->next))
 			if (fp->handle == f->handle)
 				return -EEXIST;
+
+		refcount_inc(&b->filters_ref);
 	}
 
 	if (tb[TCA_ROUTE4_TO])
@@ -497,7 +493,7 @@ static int route4_change(struct net *net, struct sk_buff *in_skb,
 	struct route4_bucket *b;
 	struct nlattr *opt = tca[TCA_OPTIONS];
 	struct nlattr *tb[TCA_ROUTE4_MAX + 1];
-	unsigned int h, th;
+	unsigned int h;
 	int err;
 	bool new = true;
 
@@ -555,17 +551,20 @@ static int route4_change(struct net *net, struct sk_buff *in_skb,
 	rcu_assign_pointer(*fp, f);
 
 	if (fold) {
-		th = to_hash(fold->handle);
+		b = fold->bkt;
 		h = from_hash(fold->handle >> 16);
-		b = rtnl_dereference(head->table[th]);
-		if (b) {
-			fp = &b->ht[h];
-			for (pfp = rtnl_dereference(*fp); pfp;
-			     fp = &pfp->next, pfp = rtnl_dereference(*fp)) {
-				if (pfp == fold) {
-					rcu_assign_pointer(*fp, fold->next);
-					break;
+		fp = &b->ht[h];
+		for (pfp = rtnl_dereference(*fp); pfp;
+		     fp = &pfp->next, pfp = rtnl_dereference(*fp)) {
+			if (pfp == fold) {
+				rcu_assign_pointer(*fp, fold->next);
+				if (refcount_dec_and_test(&b->filters_ref)) {
+					unsigned int th = to_hash(fold->handle);
+
+					RCU_INIT_POINTER(head->table[th], NULL);
+					kfree_rcu(b, rcu);
 				}
+				break;
 			}
 		}
 	}
-- 
2.53.0



