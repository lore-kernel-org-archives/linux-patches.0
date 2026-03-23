Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAAF3B52EF;
	Mon, 23 Mar 2026 15:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279269; cv=none; b=aTBfKf4GtYBnKpaHZ+Q4JrXKygIMS47dlL3mB5bZBB5PsNZd6rnzK+xBKzzz9ab6ySKQLkjBN+ehcIcUcNGobb3kIG9vRQT0Q5ygCOaFw4J3oq1QmAZcaRbQiHRGyOUdyql7mvSYRtss12GQkpjTZGlC241lEm8qZKSo+j77j/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279269; c=relaxed/simple;
	bh=WAPF7g9VPXu926rOo9BsBptIkDiVfoXkpZz0qTdHGOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbVwEEF6tiz/pN3jJ1A+4gBvPQ8sBO4L765rvJjdxN51U9Yw8OJyp8RmZ2d0a+SEmBMCZmB6yjg3Rmcw+P+rX0m/Y1+kqp8RIdAKuU7poNGi9eEDzLcLJLTo1H0lWiV1IZTG/Gxz3chIr7gu2H3d1kj4c6npwqTCF2Kp/L985hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwccNDBU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwccNDBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88E9C2BC9E;
	Mon, 23 Mar 2026 15:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279269;
	bh=WAPF7g9VPXu926rOo9BsBptIkDiVfoXkpZz0qTdHGOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwccNDBURt++OPAzNKFjX5oMbS/4gMLcuetncNyVXieXl2pZm0R+9rDYWPeQiJWBQ
	 eI/0ht6hL5VAX5JUoEgfp2BRA6vfRV0Rz7wPZGv4Ne5BjBRedXspeh0GQV0KYE3Kfv
	 GGwvMB+fudV5RUDXcEeeS02m7R7ptwRTGKv/H2q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keenan Dong <keenanat2000@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 530/567] clsact: Fix use-after-free in init/destroy rollback asymmetry
Date: Mon, 23 Mar 2026 14:47:30 +0100
Message-ID: <20260323134547.106953728@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

[ Upstream commit a0671125d4f55e1e98d9bde8a0b671941987e208 ]

Fix a use-after-free in the clsact qdisc upon init/destroy rollback asymmetry.
The latter is achieved by first fully initializing a clsact instance, and
then in a second step having a replacement failure for the new clsact qdisc
instance. clsact_init() initializes ingress first and then takes care of the
egress part. This can fail midway, for example, via tcf_block_get_ext(). Upon
failure, the kernel will trigger the clsact_destroy() callback.

Commit 1cb6f0bae504 ("bpf: Fix too early release of tcx_entry") details the
way how the transition is happening. If tcf_block_get_ext on the q->ingress_block
ends up failing, we took the tcx_miniq_inc reference count on the ingress
side, but not yet on the egress side. clsact_destroy() tests whether the
{ingress,egress}_entry was non-NULL. However, even in midway failure on the
replacement, both are in fact non-NULL with a valid egress_entry from the
previous clsact instance.

What we really need to test for is whether the qdisc instance-specific ingress
or egress side previously got initialized. This adds a small helper for checking
the miniq initialization called mini_qdisc_pair_inited, and utilizes that upon
clsact_destroy() in order to fix the use-after-free scenario. Convert the
ingress_destroy() side as well so both are consistent to each other.

Fixes: 1cb6f0bae504 ("bpf: Fix too early release of tcx_entry")
Reported-by: Keenan Dong <keenanat2000@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Martin KaFai Lau <martin.lau@kernel.org>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/20260313065531.98639-1-daniel@iogearbox.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sch_generic.h |  5 +++++
 net/sched/sch_ingress.c   | 14 ++++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 15f4a0548d824..385af747b0b4e 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1365,6 +1365,11 @@ void mini_qdisc_pair_init(struct mini_Qdisc_pair *miniqp, struct Qdisc *qdisc,
 void mini_qdisc_pair_block_init(struct mini_Qdisc_pair *miniqp,
 				struct tcf_block *block);
 
+static inline bool mini_qdisc_pair_inited(struct mini_Qdisc_pair *miniqp)
+{
+	return !!miniqp->p_miniq;
+}
+
 void mq_change_real_num_tx(struct Qdisc *sch, unsigned int new_real_tx);
 
 int sch_frag_xmit_hook(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb));
diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
index 8dde3548dc11c..70d668cb0db81 100644
--- a/net/sched/sch_ingress.c
+++ b/net/sched/sch_ingress.c
@@ -113,14 +113,15 @@ static void ingress_destroy(struct Qdisc *sch)
 {
 	struct ingress_sched_data *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
-	struct bpf_mprog_entry *entry = rtnl_dereference(dev->tcx_ingress);
+	struct bpf_mprog_entry *entry;
 
 	if (sch->parent != TC_H_INGRESS)
 		return;
 
 	tcf_block_put_ext(q->block, sch, &q->block_info);
 
-	if (entry) {
+	if (mini_qdisc_pair_inited(&q->miniqp)) {
+		entry = rtnl_dereference(dev->tcx_ingress);
 		tcx_miniq_dec(entry);
 		if (!tcx_entry_is_active(entry)) {
 			tcx_entry_update(dev, NULL, true);
@@ -289,10 +290,9 @@ static int clsact_init(struct Qdisc *sch, struct nlattr *opt,
 
 static void clsact_destroy(struct Qdisc *sch)
 {
+	struct bpf_mprog_entry *ingress_entry, *egress_entry;
 	struct clsact_sched_data *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
-	struct bpf_mprog_entry *ingress_entry = rtnl_dereference(dev->tcx_ingress);
-	struct bpf_mprog_entry *egress_entry = rtnl_dereference(dev->tcx_egress);
 
 	if (sch->parent != TC_H_CLSACT)
 		return;
@@ -300,7 +300,8 @@ static void clsact_destroy(struct Qdisc *sch)
 	tcf_block_put_ext(q->ingress_block, sch, &q->ingress_block_info);
 	tcf_block_put_ext(q->egress_block, sch, &q->egress_block_info);
 
-	if (ingress_entry) {
+	if (mini_qdisc_pair_inited(&q->miniqp_ingress)) {
+		ingress_entry = rtnl_dereference(dev->tcx_ingress);
 		tcx_miniq_dec(ingress_entry);
 		if (!tcx_entry_is_active(ingress_entry)) {
 			tcx_entry_update(dev, NULL, true);
@@ -308,7 +309,8 @@ static void clsact_destroy(struct Qdisc *sch)
 		}
 	}
 
-	if (egress_entry) {
+	if (mini_qdisc_pair_inited(&q->miniqp_egress)) {
+		egress_entry = rtnl_dereference(dev->tcx_egress);
 		tcx_miniq_dec(egress_entry);
 		if (!tcx_entry_is_active(egress_entry)) {
 			tcx_entry_update(dev, NULL, false);
-- 
2.51.0



