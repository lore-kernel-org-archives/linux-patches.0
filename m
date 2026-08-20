Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5156381AEC;
	Thu, 20 Aug 2026 17:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247738; cv=none; b=u2wiXM48K6SXvQoB5VzZBHEEdbqRkFrBo6a1P7fRkZtS9M7QcvIv2OSYGd5bVNI5J/vFav8x2n7JkIgaYjuKw0LLACKShTL/X8JFhCV/ACPyxu2BqyqBg/a+pX9zQjrskMtV0ELoNUxaND7/nloxHtiZ0cnAWfpqxvKJbEwfxgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247738; c=relaxed/simple;
	bh=gK9gSOuRDdOp3bfJ28u72Trc2R98miDRJlsMCdaWZMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W29PPZy0rY2UBUlpF9yEqaggy2ieOU3Jmne2QOPh8mw6nZdcT+BUKCGxYLW+nUmbW7+PAWZcfyDk8CDBPKikw7QV7IKU4wx+qXa4+51dlnLaMEolCT0/eoq803wz9ojKy3PlTe0xGL4qLkgWvJENHzIEH8ztZulArIestNncpPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TuyspsZx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TuyspsZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB5E1F000E9;
	Thu, 20 Aug 2026 17:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247736;
	bh=segLPv161AiRT7QiKLvQHvmxsMh8R6brpSK3ImNY2ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TuyspsZxsjQnUDnwh0fUtqJaKqtK9lIhunb4VwOJ1J1Gh32/uDs0oNi/eZcQ2CmYC
	 AZVqF/lktBQn73nGBsT7lVu6U/5CmIq5Q/pmxgvG6vfY4X4rU1OMGQbpoPiqoQMF9n
	 wgQhnSDDRoaZJ7RVD/StFaXerDYj0EBQmGRVlO5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 150/166] net, sched: Make tc-related drop reason more flexible
Date: Thu, 20 Aug 2026 16:56:49 +0200
Message-ID: <20260820145215.682600065@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 54a59aed395ce0f4177b5212e5746a6462de3ad9 ]

Currently, the kfree_skb_reason() in sch_handle_{ingress,egress}() can only
express a basic SKB_DROP_REASON_TC_INGRESS or SKB_DROP_REASON_TC_EGRESS reason.

Victor kicked-off an initial proposal to make this more flexible by disambiguating
verdict from return code by moving the verdict into struct tcf_result and
letting tcf_classify() return a negative error. If hit, then two new drop
reasons were added in the proposal, that is SKB_DROP_REASON_TC_INGRESS_ERROR
as well as SKB_DROP_REASON_TC_EGRESS_ERROR. Further analysis of the actual
error codes would have required to attach to tcf_classify via kprobe/kretprobe
to more deeply debug skb and the returned error.

In order to make the kfree_skb_reason() in sch_handle_{ingress,egress}() more
extensible, it can be addressed in a more straight forward way, that is: Instead
of placing the verdict into struct tcf_result, we can just put the drop reason
in there, which does not require changes throughout various classful schedulers
given the existing verdict logic can stay as is.

Then, SKB_DROP_REASON_TC_ERROR{,_*} can be added to the enum skb_drop_reason
to disambiguate between an error or an intentional drop. New drop reason error
codes can be added successively to the tc code base.

For internal error locations which have not yet been annotated with a
SKB_DROP_REASON_TC_ERROR{,_*}, the fallback is SKB_DROP_REASON_TC_INGRESS and
SKB_DROP_REASON_TC_EGRESS, respectively. Generic errors could be marked with a
SKB_DROP_REASON_TC_ERROR code until they are converted to more specific ones
if it is found that they would be useful for troubleshooting.

While drop reasons have infrastructure for subsystem specific error codes which
are currently used by mac80211 and ovs, Jakub mentioned that it is preferred
for tc to use the enum skb_drop_reason core codes given it is a better fit and
currently the tooling support is better, too.

With regards to the latter:

  [...] I think Alastair (bpftrace) is working on auto-prettifying enums when
  bpftrace outputs maps. So we can do something like:

  $ bpftrace -e 'tracepoint:skb:kfree_skb { @[args->reason] = count(); }'
  Attaching 1 probe...
  ^C

  @[SKB_DROP_REASON_TC_INGRESS]: 2
  @[SKB_CONSUMED]: 34

  ^^^^^^^^^^^^ names!!

  Auto-magically. [...]

Add a small helper tcf_set_drop_reason() which can be used to set the drop reason
into the tcf_result.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Victor Nogueira <victor@mojatatu.com>
Link: https://lore.kernel.org/netdev/20231006063233.74345d36@kernel.org
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/20231009092655.22025-1-daniel@iogearbox.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f60b396ee174 ("net/sched: act_api: fix TOCTOU NULL deref on a->goto_chain")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/pkt_cls.h     |  6 ++++++
 include/net/sch_generic.h |  3 +--
 net/core/dev.c            | 15 ++++++++++-----
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 307478c233223..253bd199d8648 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -163,6 +163,12 @@ __cls_set_class(unsigned long *clp, unsigned long cl)
 	return xchg(clp, cl);
 }
 
+static inline void tcf_set_drop_reason(struct tcf_result *res,
+				       enum skb_drop_reason reason)
+{
+	res->drop_reason = reason;
+}
+
 static inline void
 __tcf_bind_filter(struct Qdisc *q, struct tcf_result *r, unsigned long base)
 {
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 8ad29d2c210ab..ac09063bcd92a 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -326,7 +326,6 @@ struct Qdisc_ops {
 	struct module		*owner;
 };
 
-
 struct tcf_result {
 	union {
 		struct {
@@ -334,8 +333,8 @@ struct tcf_result {
 			u32		classid;
 		};
 		const struct tcf_proto *goto_tp;
-
 	};
+	enum skb_drop_reason		drop_reason;
 };
 
 struct tcf_chain;
diff --git a/net/core/dev.c b/net/core/dev.c
index 0fa5431de2cc0..3fe9e6b60d4f5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4025,7 +4025,8 @@ EXPORT_SYMBOL_GPL(netdev_xmit_skip_txqueue);
 #endif /* CONFIG_NET_EGRESS */
 
 #ifdef CONFIG_NET_XGRESS
-static int tc_run(struct tcx_entry *entry, struct sk_buff *skb)
+static int tc_run(struct tcx_entry *entry, struct sk_buff *skb,
+		  enum skb_drop_reason *drop_reason)
 {
 	int ret = TC_ACT_UNSPEC;
 #ifdef CONFIG_NET_CLS_ACT
@@ -4045,12 +4046,14 @@ static int tc_run(struct tcx_entry *entry, struct sk_buff *skb)
 
 	tc_skb_cb(skb)->mru = 0;
 	tc_skb_cb(skb)->post_ct = false;
+	res.drop_reason = *drop_reason;
 
 	mini_qdisc_bstats_cpu_update(miniq, skb);
 	ret = tcf_classify(skb, miniq->block, miniq->filter_list, &res, false);
 	/* Only tcf related quirks below. */
 	switch (ret) {
 	case TC_ACT_SHOT:
+		*drop_reason = res.drop_reason;
 		mini_qdisc_qstats_cpu_drop(miniq);
 		break;
 	case TC_ACT_OK:
@@ -4100,6 +4103,7 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 		   struct net_device *orig_dev, bool *another)
 {
 	struct bpf_mprog_entry *entry = rcu_dereference_bh(skb->dev->tcx_ingress);
+	enum skb_drop_reason drop_reason = SKB_DROP_REASON_TC_INGRESS;
 	int sch_ret;
 
 	if (!entry)
@@ -4117,7 +4121,7 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 		if (sch_ret != TC_ACT_UNSPEC)
 			goto ingress_verdict;
 	}
-	sch_ret = tc_run(tcx_entry(entry), skb);
+	sch_ret = tc_run(tcx_entry(entry), skb, &drop_reason);
 ingress_verdict:
 	switch (sch_ret) {
 	case TC_ACT_REDIRECT:
@@ -4134,7 +4138,7 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 		*ret = NET_RX_SUCCESS;
 		return NULL;
 	case TC_ACT_SHOT:
-		kfree_skb_reason(skb, SKB_DROP_REASON_TC_INGRESS);
+		kfree_skb_reason(skb, drop_reason);
 		*ret = NET_RX_DROP;
 		return NULL;
 	/* used by tc_run */
@@ -4155,6 +4159,7 @@ static __always_inline struct sk_buff *
 sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 {
 	struct bpf_mprog_entry *entry = rcu_dereference_bh(dev->tcx_egress);
+	enum skb_drop_reason drop_reason = SKB_DROP_REASON_TC_EGRESS;
 	int sch_ret;
 
 	if (!entry)
@@ -4168,7 +4173,7 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 		if (sch_ret != TC_ACT_UNSPEC)
 			goto egress_verdict;
 	}
-	sch_ret = tc_run(tcx_entry(entry), skb);
+	sch_ret = tc_run(tcx_entry(entry), skb, &drop_reason);
 egress_verdict:
 	switch (sch_ret) {
 	case TC_ACT_REDIRECT:
@@ -4177,7 +4182,7 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 		*ret = NET_XMIT_SUCCESS;
 		return NULL;
 	case TC_ACT_SHOT:
-		kfree_skb_reason(skb, SKB_DROP_REASON_TC_EGRESS);
+		kfree_skb_reason(skb, drop_reason);
 		*ret = NET_XMIT_DROP;
 		return NULL;
 	/* used by tc_run */
-- 
2.53.0



