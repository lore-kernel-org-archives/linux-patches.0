Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D6D38E5C5;
	Thu, 17 Sep 2026 18:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668611; cv=none; b=W67j8qx+re0yfEd/KDMDKj4+EDWq+v7EiG+wzZSGhKdagiqcvtqSaZzSSDMBH18vn/QE4FrEPdZ7KH1W+Q75AaPROKi7KDqQPgX7n0kV/XszxbalmYTpweVqPQyWnOtWleBuJyMp6EBkvSZfAAL0LQJfhqjm724bGGHi9FNkY+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668611; c=relaxed/simple;
	bh=y0nfQOlXGFJjojmusS7G8y4dmJPIis+JO5BnjXCeNYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swvLrX2RD6X7HYKMXvvSPclgHDNxLJSRQcFyqitmnAt9RvRtrKjlfdLZvYcY/RScNnheT6sOJP8ZHX2CP/3v0YyWB2IuujmoN1hj4e9qlZ4AI3w6jr06rI6ThK3Xjd1HpJ6OK5VhKz/+Su16wra9hYPr2bPd1EQwsd4V7NjJEQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nVSevxUG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nVSevxUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF2A1F000FF;
	Thu, 17 Sep 2026 18:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668609;
	bh=UnNe0Vgw6m/YcHUNLiVT9cjxs5vy7F0GzR619Z6AMNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nVSevxUGvqWmJ2UDHagM7pQlDZ4AvBQkDvS+0oLJVji5rH0krT253RHrPs9ALIeTR
	 SJxn7mkbkQnkr4tHc9vRI0cIqQY4a+VoOHpY9R9MCkNj2PPNH34kxCXNAofoEOSfv2
	 nLwNkWJIuGdu8m4jh3o3gi7PGEpaOUtCi4YZdlPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0482/1102] bpf: Reject redirect helpers without a bpf_net_context
Date: Thu, 17 Sep 2026 16:07:05 +0100
Message-ID: <20260917151551.798896866@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 3f4920d165b29052255527d8ae7619e7ec132ece ]

The bpf_redirect*() helpers and skb_do_redirect() obtain the per-task
bpf_redirect_info via bpf_net_ctx_get_ri(), which dereferences the
current->bpf_net_context unconditionally. That context is established
on the paths that run tc BPF such as sch_handle_{ingress,egress}(),
*except* for the case where {cls,act}_bpf was attached to a proper
qdisc. A program running from there reaches the NULL deref in two ways:

* It calls bpf_redirect() directly, which dereferences the context at
  the top of the helper:

     tc qdisc add dev eth0 root handle 1: red limit 1MB min 10KB max 20KB \
        avpkt 1000 burst 100 qevent early_drop block 10
     tc filter add block 10 pref 1 bpf obj redirect.o

* It simply returns TC_ACT_REDIRECT without helper call: tcf_qevent_handle()
  then dispatches to skb_do_redirect(), which dereferences the context

Rather than extending bpf_net_context management into the qdisc path,
make the redirect helpers refuse to operate when no context exists, and
have tcf_qevent_handle() drop a TC_ACT_REDIRECT verdict instead of
calling skb_do_redirect(). Previous behaviour was a crash, so nothing
regresses by not supporting it.

Fixes: 401cb7dae813 ("net: Reference bpf_redirect_info via task_struct on PREEMPT_RT.")
Fixes: 3625750f05ec ("net: sched: Introduce helpers for qevent blocks")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://patch.msgid.link/20260706185609.330006-2-daniel@iogearbox.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c   | 17 +++++++++++------
 net/sched/cls_api.c |  6 ++----
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index bf7c57b06ed91..e0f757ffcfc5b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2559,11 +2559,13 @@ int skb_do_redirect(struct sk_buff *skb)
 
 BPF_CALL_2(bpf_redirect, u32, ifindex, u64, flags)
 {
-	struct bpf_redirect_info *ri = bpf_net_ctx_get_ri();
+	struct bpf_redirect_info *ri;
 
-	if (unlikely(flags & (~(BPF_F_INGRESS) | BPF_F_REDIRECT_INTERNAL)))
+	if (unlikely(!bpf_net_ctx_get() ||
+		     (flags & (~(BPF_F_INGRESS) | BPF_F_REDIRECT_INTERNAL))))
 		return TC_ACT_SHOT;
 
+	ri = bpf_net_ctx_get_ri();
 	ri->flags = flags;
 	ri->tgt_index = ifindex;
 
@@ -2580,11 +2582,12 @@ static const struct bpf_func_proto bpf_redirect_proto = {
 
 BPF_CALL_2(bpf_redirect_peer, u32, ifindex, u64, flags)
 {
-	struct bpf_redirect_info *ri = bpf_net_ctx_get_ri();
+	struct bpf_redirect_info *ri;
 
-	if (unlikely(flags))
+	if (unlikely(!bpf_net_ctx_get() || flags))
 		return TC_ACT_SHOT;
 
+	ri = bpf_net_ctx_get_ri();
 	ri->flags = BPF_F_PEER;
 	ri->tgt_index = ifindex;
 
@@ -2602,11 +2605,13 @@ static const struct bpf_func_proto bpf_redirect_peer_proto = {
 BPF_CALL_4(bpf_redirect_neigh, u32, ifindex, struct bpf_redir_neigh *, params,
 	   int, plen, u64, flags)
 {
-	struct bpf_redirect_info *ri = bpf_net_ctx_get_ri();
+	struct bpf_redirect_info *ri;
 
-	if (unlikely((plen && plen < sizeof(*params)) || flags))
+	if (unlikely((plen && plen < sizeof(*params)) ||
+		     !bpf_net_ctx_get() || flags))
 		return TC_ACT_SHOT;
 
+	ri = bpf_net_ctx_get_ri();
 	ri->flags = BPF_F_NEIGH | (plen ? BPF_F_NEXTHOP : 0);
 	ri->tgt_index = ifindex;
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 53f5cab47e01e..f8c89e30fc04a 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -4059,6 +4059,8 @@ struct sk_buff *tcf_qevent_handle(struct tcf_qevent *qe, struct Qdisc *sch, stru
 	fl = rcu_dereference_bh(qe->filter_chain);
 
 	switch (tcf_classify(skb, NULL, fl, &cl_res, false)) {
+	case TC_ACT_REDIRECT:
+		fallthrough;
 	case TC_ACT_SHOT:
 		qdisc_qstats_drop(sch);
 		__qdisc_drop(skb, to_free);
@@ -4070,10 +4072,6 @@ struct sk_buff *tcf_qevent_handle(struct tcf_qevent *qe, struct Qdisc *sch, stru
 		__qdisc_drop(skb, to_free);
 		*ret = __NET_XMIT_STOLEN;
 		return NULL;
-	case TC_ACT_REDIRECT:
-		skb_do_redirect(skb);
-		*ret = __NET_XMIT_STOLEN;
-		return NULL;
 	case TC_ACT_CONSUMED:
 		*ret = __NET_XMIT_STOLEN;
 		return NULL;
-- 
2.53.0



