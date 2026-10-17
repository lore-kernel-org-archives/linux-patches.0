Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A19832FA18;
	Sat, 17 Oct 2026 17:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259240; cv=none; b=sO7UPVk0b3suapqImsJpNBYV4EBtKPPU8S0AuAfQBLWyEdyu418lvZ+6PCVUHAVqz5BcDPoVmW/CNFVpAnMfWrgQqmqc2ZCOnfl7mzetEk6er6n91N8zUQCGRztrvetKOmJsLP0e3yGWgsW2XxyXMO/ae4kpTaBkBiVJ1Xln/n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259240; c=relaxed/simple;
	bh=xhdF6Q1UZRNMBxH0loeDZQ5Nd+zEx2DAgsPMZ8JgLbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MH/J1wFHMyW0kQTkae8r7am46MuQZaLEqyx/LtIT6Xd0VhlPeLPmQI0semJr+ZpkOMTkSFYgcUibk8ZjOsuiA36WjhdZlop+lZnUFUCKwcwZiEup0lHLrGh2RSayTuGFYTXSS0iwRcpGXeWt9zufptqJqfFXLJunaB6bUxgshEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kB0YekAw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kB0YekAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A698D1F000C4;
	Sat, 17 Oct 2026 17:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259239;
	bh=BvJa4Esad9Dpd1r5fFMOgEHx8jh82IroWwzFuaZlq44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kB0YekAwKOFPH0oWEtTgCL+ZUB+DyYqgQMhQoIrhCUf7p4JXD0ieqFWasSYHnrAdi
	 lVE8urHLxYPSlWEzeDR08DYS+Gq2dHDFiuYylxQAVSCiv1QoGRKvZhtER3yy/x+BTl
	 XHZ5hMcuJxvOyqph5Tm8r21zg9mLSgxqAAPvDxSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1109/1674] net/sched: Handle TC_ACT_REDIRECT from qdisc filter chains
Date: Sat, 17 Oct 2026 17:56:21 +0200
Message-ID: <20261017160459.592338435@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit ec48b3be2c8595dd290be883dbd4fb8b2f9f5d5e ]

When a TC filter attached to a qdisc filter chain returns
TC_ACT_REDIRECT (ex: via an eBPF program calling bpf_redirect() or an
act_bpf action), the redirect was silently lost i.e no qdisc classify
function handled TC_ACT_REDIRECT, so the packet fell through the
switch and was enqueued normally instead of being redirected.

This has been broken since bpf_redirect() was introduced for TC in
commit 27b29f63058d ("bpf: add bpf_redirect() helper"). We got lucky
for a long time because bpf_net_context was a per-CPU variable that
was always available.

commit 401cb7dae813 ("net: Reference bpf_redirect_info via task_struct
on PREEMPT_RT.") turned bpf_net_context into a task_struct member that
is only set up by explicit callers. Without a caller setting it up,
bpf_redirect() itself crashes with a NULL pointer dereference in
bpf_net_ctx_get_ri(). However, even with bpf_net_context available,
TC_ACT_REDIRECT from qdisc filter chains cannot be honored without
adding skb_do_redirect() calls to every qdisc classify function, which
would require changes across net/sched/. Isolate it to ebpf core where
it belongs.

Instead, add a tcf_classify_qdisc() inline helper in pkt_cls.h, as a
wrapper around tcf_classify() for use by qdisc classify functions and
tcf_qevent_handle(). When the classify verdict is TC_ACT_REDIRECT,
the wrapper converts it to TC_ACT_SHOT, dropping the packet rather
than letting it continue silently. Dropping is preferred over
letting the packet through because the user immediately sees packet
loss. Silently passing the packet through would hide the problem and
leave the user wondering why their redirect is not working.

The clsact fast path, tc_run() continues to call tcf_classify() directly
and is unaffected: TC_ACT_REDIRECT is returned as-is and handled by
sch_handle_egress/ingress() calling skb_do_redirect() as before.

Fixes: 27b29f63058d ("bpf: add bpf_redirect() helper")
Fixes: 401cb7dae813 ("net: Reference bpf_redirect_info via task_struct on PREEMPT_RT.")
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://patch.msgid.link/20260706185609.330006-3-daniel@iogearbox.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/pkt_cls.h    | 14 +++++++++++++-
 net/sched/sch_cake.c     |  2 +-
 net/sched/sch_drr.c      |  2 +-
 net/sched/sch_ets.c      |  2 +-
 net/sched/sch_fq_codel.c |  2 +-
 net/sched/sch_fq_pie.c   |  2 +-
 net/sched/sch_hfsc.c     |  2 +-
 net/sched/sch_htb.c      |  2 +-
 net/sched/sch_multiq.c   |  2 +-
 net/sched/sch_prio.c     |  2 +-
 net/sched/sch_qfq.c      |  2 +-
 net/sched/sch_sfb.c      |  2 +-
 net/sched/sch_sfq.c      |  2 +-
 13 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 325a8553853df..05890fc84abe0 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -154,8 +154,20 @@ static inline int tcf_classify(struct sk_buff *skb,
 {
 	return TC_ACT_UNSPEC;
 }
-
 #endif
+static inline int tcf_classify_qdisc(struct sk_buff *skb,
+				     const struct tcf_proto *tp,
+				     struct tcf_result *res, bool compat_mode)
+{
+	int ret = tcf_classify(skb, NULL, tp, res, compat_mode);
+
+	/* TC_ACT_REDIRECT from qdisc filter chains is not supported.
+	 * Use BPF via tcx or mirred redirect instead.
+	 */
+	if (unlikely(ret == TC_ACT_REDIRECT))
+		ret = TC_ACT_SHOT;
+	return ret;
+}
 
 static inline unsigned long
 __cls_set_class(unsigned long *clp, unsigned long cl)
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 4331097f813ec..a25b45ab6fb0e 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1721,7 +1721,7 @@ static u32 cake_classify(struct Qdisc *sch, struct cake_tin_data **t,
 		goto hash;
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
-	result = tcf_classify(skb, NULL, filter, &res, false);
+	result = tcf_classify_qdisc(skb, filter, &res, false);
 
 	if (result >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
diff --git a/net/sched/sch_drr.c b/net/sched/sch_drr.c
index 6469b39c91611..843dbe3469043 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -313,7 +313,7 @@ static struct drr_class *drr_classify(struct sk_buff *skb, struct Qdisc *sch,
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
 	fl = rcu_dereference_bh(q->filter_list);
-	result = tcf_classify(skb, NULL, fl, &res, false);
+	result = tcf_classify_qdisc(skb, fl, &res, false);
 	if (result >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
index 2f1e8a5d5b37b..f65dae86c6186 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -389,7 +389,7 @@ static struct ets_class *ets_classify(struct sk_buff *skb, struct Qdisc *sch,
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
 	if (TC_H_MAJ(skb->priority) != sch->handle) {
 		fl = rcu_dereference_bh(q->filter_list);
-		err = tcf_classify(skb, NULL, fl, &res, false);
+		err = tcf_classify_qdisc(skb, fl, &res, false);
 #ifdef CONFIG_NET_CLS_ACT
 		switch (err) {
 		case TC_ACT_STOLEN:
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index f618ec382081b..8a4f4c4963708 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -91,7 +91,7 @@ static unsigned int fq_codel_classify(struct sk_buff *skb, struct Qdisc *sch,
 		return fq_codel_hash(q, skb) + 1;
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
-	result = tcf_classify(skb, NULL, filter, &res, false);
+	result = tcf_classify_qdisc(skb, filter, &res, false);
 	if (result >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
index d7c144af98916..1bf86b65dacfd 100644
--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -95,7 +95,7 @@ static unsigned int fq_pie_classify(struct sk_buff *skb, struct Qdisc *sch,
 		return fq_pie_hash(q, skb) + 1;
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
-	result = tcf_classify(skb, NULL, filter, &res, false);
+	result = tcf_classify_qdisc(skb, filter, &res, false);
 	if (result >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index 51dd4243db46d..d0249c45394d2 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1154,7 +1154,7 @@ hfsc_classify(struct sk_buff *skb, struct Qdisc *sch, int *qerr)
 	head = &q->root;
 	drift = HFSC_CLASSIFY_MAX_DRIFT;
 	tcf = rcu_dereference_bh(q->root.filter_list);
-	while (tcf && (result = tcf_classify(skb, NULL, tcf, &res, false)) >= 0) {
+	while (tcf && (result = tcf_classify_qdisc(skb, tcf, &res, false)) >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
 		case TC_ACT_QUEUED:
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index ed1bf8406ae6b..6edd9a82aaeb1 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -243,7 +243,7 @@ static struct htb_class *htb_classify(struct sk_buff *skb, struct Qdisc *sch,
 	}
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
-	while (tcf && (result = tcf_classify(skb, NULL, tcf, &res, false)) >= 0) {
+	while (tcf && (result = tcf_classify_qdisc(skb, tcf, &res, false)) >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
 		case TC_ACT_QUEUED:
diff --git a/net/sched/sch_multiq.c b/net/sched/sch_multiq.c
index 62cc1a21a603f..3dff4b1d4aa97 100644
--- a/net/sched/sch_multiq.c
+++ b/net/sched/sch_multiq.c
@@ -36,7 +36,7 @@ multiq_classify(struct sk_buff *skb, struct Qdisc *sch, int *qerr)
 	int err;
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
-	err = tcf_classify(skb, NULL, fl, &res, false);
+	err = tcf_classify_qdisc(skb, fl, &res, false);
 #ifdef CONFIG_NET_CLS_ACT
 	switch (err) {
 	case TC_ACT_STOLEN:
diff --git a/net/sched/sch_prio.c b/net/sched/sch_prio.c
index fdd9caa41e80f..7ef77ead388e6 100644
--- a/net/sched/sch_prio.c
+++ b/net/sched/sch_prio.c
@@ -39,7 +39,7 @@ prio_classify(struct sk_buff *skb, struct Qdisc *sch, int *qerr)
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
 	if (TC_H_MAJ(skb->priority) != sch->handle) {
 		fl = rcu_dereference_bh(q->filter_list);
-		err = tcf_classify(skb, NULL, fl, &res, false);
+		err = tcf_classify_qdisc(skb, fl, &res, false);
 #ifdef CONFIG_NET_CLS_ACT
 		switch (err) {
 		case TC_ACT_STOLEN:
diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index a17f7c31378e6..e3b1921aa7dd3 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -712,7 +712,7 @@ static struct qfq_class *qfq_classify(struct sk_buff *skb, struct Qdisc *sch,
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
 	fl = rcu_dereference_bh(q->filter_list);
-	result = tcf_classify(skb, NULL, fl, &res, false);
+	result = tcf_classify_qdisc(skb, fl, &res, false);
 	if (result >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 58bf4c803f7fe..693f562bd8648 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -260,7 +260,7 @@ static bool sfb_classify(struct sk_buff *skb, struct tcf_proto *fl,
 	struct tcf_result res;
 	int result;
 
-	result = tcf_classify(skb, NULL, fl, &res, false);
+	result = tcf_classify_qdisc(skb, fl, &res, false);
 	if (result >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index 779e632ede19c..31b5aeb416cea 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -171,7 +171,7 @@ static unsigned int sfq_classify(struct sk_buff *skb, struct Qdisc *sch,
 		return sfq_hash(q, skb) + 1;
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
-	result = tcf_classify(skb, NULL, fl, &res, false);
+	result = tcf_classify_qdisc(skb, fl, &res, false);
 	if (result >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
-- 
2.53.0



