Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216319;
	b=ErO7sVaDx3AAL6okNszZAIMIAeKqU4Ar74qVrmtPidQkBJljjdE5FtjmaWMszQ+oVeFE
	 74jmeih4TUoRa9+o+L8xaA0iiExqIXsFBAJjV/BY20hkWXwGbCcZ0UQJ1567yqcHM04TB
	 MdCJgpuipNQwWjm3jWdTHkppSpSVsTvQFvAK1FEXdGNTINLXPlfuz304pnqtKNhVD6J8h
	 63hAQ7t86ird63MCtm52FfehVLtsDQzm4tw1r3mQ2dcYM3W06Z2K+6OnWohTbCBg1V5hL
	 5IV3EVfSwT0Y/cIN+z01SHFxUmc6mV2EfDwxofckpSMoWKy/17UdbjErDh0DVorIzxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dHFBTH6MR5H6DCbyLwzm3i3Cqh0ecx/rK8Gf8dmndYc=;
	b=W9yxuh3MBFpm1FxD4KV2g3xkzawNALxA1lJHuhxNouwO1Hi4mnlIr9SyZOcFCxPpT49o
	 6fDRgQebvqZpHSPkZStzpPFPVZe2qsvqeiqiyCV0vZGe0JkwT0ERsHMoh+r4/VeIqq1JV
	 NfG12G57q3xsBfMpN2/c6OBZhYsHgKQlcgCGatQSwJC1enb9YB1enasJ60w2AkQXt68bu
	 7PyftZLbDakZm5QTR7yAMU2dBMXCEStGEhQqKufQRkAvTZJ7UdFzeXUa9aXSlrj9dlh/v
	 nSV2jqslWNrJ8aA6mSlCA8fCoxBZ0EqzLgsTbrWKqQkbVvJNSbrfwKFNj7XnFoziXxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=llMWFL1L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89403606A31C;
	Wed, 28 Oct 2026 19:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=llMWFL1L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7731F01825;
	Wed, 28 Oct 2026 19:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216319;
	bh=dHFBTH6MR5H6DCbyLwzm3i3Cqh0ecx/rK8Gf8dmndYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=llMWFL1LXlRkaVuEyMBkxhgW5yVNDC34WXQoFuFrCHWlgoE+qVJ4ulaDtrkQ3wfEv
	 cpPkAPvLkFmQWM0htyKFNxtzVE6UEYnngthpicf/sb/IsS5xV1eM8Rhp6G0W4iWvXO
	 Jng8vOZDCoBKpUeaY54GyCZtMgtIlGP0dJqSSex4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	vega@nebusec.ai,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1518/1887] net/sched: account classifier filter allocations to memcg
Date: Wed, 28 Oct 2026 18:00:14 +0100
Message-ID: <20261028170534.006549416@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 1beb81947eb486716af80db7a584f9e9fef7e003 ]

Allocations in the tc classifier *_change() paths (filter objects,
per-CPU counters, and per-filter aux data) use plain GFP_KERNEL without
__GFP_ACCOUNT, allowing unprivileged users to pin kernel memory outside
memcg charging. The shared tcf_exts_init_ex() action array allocation in
cls_api.c was also uncharged; this patch closes it along with the
per-classifier filter-object/percpu/aux allocations that remain
unaccounted.

Add GFP_KERNEL_ACCOUNT to:
- the shared tcf_exts_init_ex() action array (cls_api.c), common to every
  filter of every classifier (32 pointers, 256 bytes);
- the filter-object, per-CPU-counter, and per-filter aux allocations in
  cls_basic, cls_bpf, cls_cgroup, cls_flow, cls_flower, cls_fw,
  cls_matchall, cls_route and cls_u32;
- the u32_init_knode() replace-path knode allocation (cls_u32.c), which
  allocates the same struct tc_u_knode + sel.keys on every replace of an
  existing knode and was missed by the create-path-only conversion.

Also fix the cls_basic error path: basic_change() inserts fnew into the
IDR before allocating the per-CPU counter. If alloc_percpu() fails the
errout path kfree'd fnew without idr_remove, leaving a dangling pointer
in the IDR. With GFP_KERNEL_ACCOUNT the percpu alloc becomes failable
on demand (memcg at memory.max), making the dead path attacker-reachable
and burning the handle permanently. Add the idr_remove on the percpu
failure path, matching the basic_set_parms failure-path pattern.

Note: vega@nebusec.ai provided a poc for basic_cls, but it was easy to
extend to the other classifiers.

Conditions to recreate the bug:
- CONFIG_NET_SCHED, CONFIG_NET_CLS_* (the classifier being used),
  CONFIG_NET_CLS_ACT, CONFIG_MEMCG, CONFIG_USER_NS, CONFIG_NET_NS.
- Unprivileged user in a fresh user+network namespace (unshare -Urn),
  or root with CAP_NET_ADMIN.
- Create a large number of tc filters (e.g. tc filter add dev lo
  ingress ... <classifier> ...) while watching a memcg-limited cgroup:
  system slab grows far faster than memory.current, pinning kernel
  memory outside memcg charging.

Fixes: 0da974f4f303 ("[NET]: Conversions from kmalloc+memset to k(z|c)alloc.")
Reported-by: vega@nebusec.ai
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260819143733.57538-1-jhs@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/pkt_cls.h    |  2 +-
 net/sched/cls_basic.c    |  6 ++++--
 net/sched/cls_bpf.c      |  6 +++---
 net/sched/cls_cgroup.c   |  2 +-
 net/sched/cls_flow.c     |  2 +-
 net/sched/cls_flower.c   |  4 ++--
 net/sched/cls_fw.c       |  4 ++--
 net/sched/cls_matchall.c |  4 ++--
 net/sched/cls_route.c    |  4 ++--
 net/sched/cls_u32.c      | 12 +++++++-----
 10 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 7ee8c92c41fa7..7ab833b41d05f 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -280,7 +280,7 @@ static inline int tcf_exts_init(struct tcf_exts *exts, struct net *net,
 	 */
 	exts->net = net;
 	exts->actions = kcalloc(TCA_ACT_MAX_PRIO, sizeof(struct tc_action *),
-				GFP_KERNEL);
+				GFP_KERNEL_ACCOUNT);
 	if (!exts->actions)
 		return -ENOMEM;
 #endif
diff --git a/net/sched/cls_basic.c b/net/sched/cls_basic.c
index d229ce99e5548..bf500510f60ff 100644
--- a/net/sched/cls_basic.c
+++ b/net/sched/cls_basic.c
@@ -191,7 +191,7 @@ static int basic_change(struct net *net, struct sk_buff *in_skb,
 			return -EINVAL;
 	}
 
-	fnew = kzalloc(sizeof(*fnew), GFP_KERNEL);
+	fnew = kzalloc(sizeof(*fnew), GFP_KERNEL_ACCOUNT);
 	if (!fnew)
 		return -ENOBUFS;
 
@@ -210,9 +210,11 @@ static int basic_change(struct net *net, struct sk_buff *in_skb,
 	if (err)
 		goto errout;
 	fnew->handle = handle;
-	fnew->pf = alloc_percpu(struct tc_basic_pcnt);
+	fnew->pf = alloc_percpu_gfp(struct tc_basic_pcnt, GFP_KERNEL_ACCOUNT);
 	if (!fnew->pf) {
 		err = -ENOMEM;
+		if (!fold)
+			idr_remove(&head->handle_idr, fnew->handle);
 		goto errout;
 	}
 
diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index ff0a8dd0b9548..3e5316c05d2c6 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -350,7 +350,7 @@ static int cls_bpf_prog_from_ops(struct nlattr **tb, struct cls_bpf_prog *prog)
 	if (bpf_size != nla_len(tb[TCA_BPF_OPS]))
 		return -EINVAL;
 
-	bpf_ops = kmemdup(nla_data(tb[TCA_BPF_OPS]), bpf_size, GFP_KERNEL);
+	bpf_ops = kmemdup(nla_data(tb[TCA_BPF_OPS]), bpf_size, GFP_KERNEL_ACCOUNT);
 	if (bpf_ops == NULL)
 		return -ENOMEM;
 
@@ -387,7 +387,7 @@ static int cls_bpf_prog_from_efd(struct nlattr **tb, struct cls_bpf_prog *prog,
 		return PTR_ERR(fp);
 
 	if (tb[TCA_BPF_NAME]) {
-		name = nla_memdup(tb[TCA_BPF_NAME], GFP_KERNEL);
+		name = nla_memdup(tb[TCA_BPF_NAME], GFP_KERNEL_ACCOUNT);
 		if (!name) {
 			bpf_prog_put(fp);
 			return -ENOMEM;
@@ -427,7 +427,7 @@ static int cls_bpf_change(struct net *net, struct sk_buff *in_skb,
 	if (ret < 0)
 		return ret;
 
-	prog = kzalloc(sizeof(*prog), GFP_KERNEL);
+	prog = kzalloc(sizeof(*prog), GFP_KERNEL_ACCOUNT);
 	if (!prog)
 		return -ENOBUFS;
 
diff --git a/net/sched/cls_cgroup.c b/net/sched/cls_cgroup.c
index ed00001b528a6..300806f80b866 100644
--- a/net/sched/cls_cgroup.c
+++ b/net/sched/cls_cgroup.c
@@ -93,7 +93,7 @@ static int cls_cgroup_change(struct net *net, struct sk_buff *in_skb,
 	if (head && handle != head->handle)
 		return -ENOENT;
 
-	new = kzalloc(sizeof(*head), GFP_KERNEL);
+	new = kzalloc(sizeof(*head), GFP_KERNEL_ACCOUNT);
 	if (!new)
 		return -ENOBUFS;
 
diff --git a/net/sched/cls_flow.c b/net/sched/cls_flow.c
index 315d689adf651..50a707f2fe8e3 100644
--- a/net/sched/cls_flow.c
+++ b/net/sched/cls_flow.c
@@ -436,7 +436,7 @@ static int flow_change(struct net *net, struct sk_buff *in_skb,
 			return -EOPNOTSUPP;
 	}
 
-	fnew = kzalloc(sizeof(*fnew), GFP_KERNEL);
+	fnew = kzalloc(sizeof(*fnew), GFP_KERNEL_ACCOUNT);
 	if (!fnew)
 		return -ENOBUFS;
 
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 67e0a9799bd0c..e2ce1d5057e2d 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2003,7 +2003,7 @@ static struct fl_flow_mask *fl_create_new_mask(struct cls_fl_head *head,
 	struct fl_flow_mask *newmask;
 	int err;
 
-	newmask = kzalloc(sizeof(*newmask), GFP_KERNEL);
+	newmask = kzalloc(sizeof(*newmask), GFP_KERNEL_ACCOUNT);
 	if (!newmask)
 		return ERR_PTR(-ENOMEM);
 
@@ -2196,7 +2196,7 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 		goto errout_tb;
 	}
 
-	fnew = kzalloc(sizeof(*fnew), GFP_KERNEL);
+	fnew = kzalloc(sizeof(*fnew), GFP_KERNEL_ACCOUNT);
 	if (!fnew) {
 		err = -ENOBUFS;
 		goto errout_tb;
diff --git a/net/sched/cls_fw.c b/net/sched/cls_fw.c
index 979662292dced..fe6097b457073 100644
--- a/net/sched/cls_fw.c
+++ b/net/sched/cls_fw.c
@@ -274,7 +274,7 @@ static int fw_change(struct net *net, struct sk_buff *in_skb,
 		if (f->id != handle && handle)
 			return -EINVAL;
 
-		fnew = kzalloc(sizeof(struct fw_filter), GFP_KERNEL);
+		fnew = kzalloc(sizeof(struct fw_filter), GFP_KERNEL_ACCOUNT);
 		if (!fnew)
 			return -ENOBUFS;
 
@@ -328,7 +328,7 @@ static int fw_change(struct net *net, struct sk_buff *in_skb,
 		rcu_assign_pointer(tp->root, head);
 	}
 
-	f = kzalloc(sizeof(struct fw_filter), GFP_KERNEL);
+	f = kzalloc(sizeof(struct fw_filter), GFP_KERNEL_ACCOUNT);
 	if (f == NULL)
 		return -ENOBUFS;
 
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index d4bb817b3658a..4e54e7babda10 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -187,7 +187,7 @@ static int mall_change(struct net *net, struct sk_buff *in_skb,
 			return -EINVAL;
 	}
 
-	new = kzalloc(sizeof(*new), GFP_KERNEL);
+	new = kzalloc(sizeof(*new), GFP_KERNEL_ACCOUNT);
 	if (!new)
 		return -ENOBUFS;
 
@@ -199,7 +199,7 @@ static int mall_change(struct net *net, struct sk_buff *in_skb,
 		handle = 1;
 	new->handle = handle;
 	new->flags = userflags;
-	new->pf = alloc_percpu(struct tc_matchall_pcnt);
+	new->pf = alloc_percpu_gfp(struct tc_matchall_pcnt, GFP_KERNEL_ACCOUNT);
 	if (!new->pf) {
 		err = -ENOMEM;
 		goto err_alloc_percpu;
diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
index c7fe52f59521c..3f63a37bc2bb7 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -442,7 +442,7 @@ static int route4_set_parms(struct net *net, struct tcf_proto *tp,
 	h1 = to_hash(nhandle);
 	b = rtnl_dereference(head->table[h1]);
 	if (!b) {
-		b = kzalloc(sizeof(struct route4_bucket), GFP_KERNEL);
+		b = kzalloc(sizeof(struct route4_bucket), GFP_KERNEL_ACCOUNT);
 		if (b == NULL)
 			return -ENOBUFS;
 
@@ -513,7 +513,7 @@ static int route4_change(struct net *net, struct sk_buff *in_skb,
 			return -EINVAL;
 
 	err = -ENOBUFS;
-	f = kzalloc(sizeof(struct route4_filter), GFP_KERNEL);
+	f = kzalloc(sizeof(struct route4_filter), GFP_KERNEL_ACCOUNT);
 	if (!f)
 		goto errout;
 
diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 599563b43def0..26874ff2db3e0 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -839,7 +839,8 @@ static struct tc_u_knode *u32_init_knode(struct net *net, struct tcf_proto *tp,
 	struct tc_u32_sel *s = &n->sel;
 	struct tc_u_knode *new;
 
-	new = kzalloc(struct_size(new, sel.keys, s->nkeys), GFP_KERNEL);
+	new = kzalloc(struct_size(new, sel.keys, s->nkeys),
+		      GFP_KERNEL_ACCOUNT);
 	if (!new)
 		return NULL;
 
@@ -1137,15 +1138,16 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 		goto erridr;
 	}
 
-	n = kzalloc(struct_size(n, sel.keys, s->nkeys), GFP_KERNEL);
+	n = kzalloc(struct_size(n, sel.keys, s->nkeys), GFP_KERNEL_ACCOUNT);
 	if (n == NULL) {
 		err = -ENOBUFS;
 		goto erridr;
 	}
 
 #ifdef CONFIG_CLS_U32_PERF
-	n->pf = __alloc_percpu(struct_size(n->pf, kcnts, s->nkeys),
-			       __alignof__(struct tc_u32_pcnt));
+	n->pf = __alloc_percpu_gfp(struct_size(n->pf, kcnts, s->nkeys),
+				   __alignof__(struct tc_u32_pcnt),
+				   GFP_KERNEL_ACCOUNT);
 	if (!n->pf) {
 		err = -ENOBUFS;
 		goto errfree;
@@ -1167,7 +1169,7 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 		goto errout;
 
 #ifdef CONFIG_CLS_U32_MARK
-	n->pcpu_success = alloc_percpu(u32);
+	n->pcpu_success = alloc_percpu_gfp(u32, GFP_KERNEL_ACCOUNT);
 	if (!n->pcpu_success) {
 		err = -ENOMEM;
 		goto errout;
-- 
2.53.0



