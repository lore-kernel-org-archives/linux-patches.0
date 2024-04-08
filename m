Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A6679F0;
	Mon,  8 Apr 2024 13:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584145; cv=none; b=PPP4G3DtvvnulAsZgHWdm0/HuFOqzT/9/eMmkplp50n7z2t7ql6exSC/HmI4C/RXpOkm9cTf8ieUAKFAfv+aE30/bS7f4gMFKyVvAzxLzuWok2iZq86LTrDN697raNuaoZnYV6TsEsS6Fw24GQ5erfqBUbQEtVS61lV/v5tUkQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584145; c=relaxed/simple;
	bh=WwyFZO5TQyer23VKESiXblpmHu3cL7P8Xv0vf+VjcZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndyUBqBc1JAtFEvoe5dAQM7nmbONE4wXG7TXXfJvSMYEpiJ9VRuJzzlsebEqS+tAR+11LDJ1dRb/2TCzdK33m1s+Fvcksii4RKJezWRb0R9Zl0eZZOMxYypq8VNY+3UUSovqKlLXOQ96RzuMXSryMHZVP4FqtbcWwY8yetWaLtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w6lDqtw8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w6lDqtw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46777C433C7;
	Mon,  8 Apr 2024 13:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584144;
	bh=WwyFZO5TQyer23VKESiXblpmHu3cL7P8Xv0vf+VjcZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w6lDqtw8owG6eM8MEuT3mfDbcYlFt6qafjq53YMseiItP/b563XS9sfEnnNcttIh0
	 HTE3oMbeXB6TDPzeRQljzexPESZlCQkB5J+pjcFFAVe/tjxQaGNWTvVNxKFHqu4juO
	 sLh3uPcsa/fwVvB/iWyaSQH44U7NubTEDWfuAv8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+981935d9485a560bfbcb@syzkaller.appspotmail.com,
	syzbot+2cb5a6c573e98db598cc@syzkaller.appspotmail.com,
	syzbot+62d8b26793e8a2bd0516@syzkaller.appspotmail.com,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.8 268/273] bpf: support deferring bpf_link dealloc to after RCU grace period
Date: Mon,  8 Apr 2024 14:59:03 +0200
Message-ID: <20240408125317.817336581@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

commit 1a80dbcb2dbaf6e4c216e62e30fa7d3daa8001ce upstream.

BPF link for some program types is passed as a "context" which can be
used by those BPF programs to look up additional information. E.g., for
multi-kprobes and multi-uprobes, link is used to fetch BPF cookie values.

Because of this runtime dependency, when bpf_link refcnt drops to zero
there could still be active BPF programs running accessing link data.

This patch adds generic support to defer bpf_link dealloc callback to
after RCU GP, if requested. This is done by exposing two different
deallocation callbacks, one synchronous and one deferred. If deferred
one is provided, bpf_link_free() will schedule dealloc_deferred()
callback to happen after RCU GP.

BPF is using two flavors of RCU: "classic" non-sleepable one and RCU
tasks trace one. The latter is used when sleepable BPF programs are
used. bpf_link_free() accommodates that by checking underlying BPF
program's sleepable flag, and goes either through normal RCU GP only for
non-sleepable, or through RCU tasks trace GP *and* then normal RCU GP
(taking into account rcu_trace_implies_rcu_gp() optimization), if BPF
program is sleepable.

We use this for multi-kprobe and multi-uprobe links, which dereference
link during program run. We also preventively switch raw_tp link to use
deferred dealloc callback, as upcoming changes in bpf-next tree expose
raw_tp link data (specifically, cookie value) to BPF program at runtime
as well.

Fixes: 0dcac2725406 ("bpf: Add multi kprobe link")
Fixes: 89ae89f53d20 ("bpf: Add multi uprobe link")
Reported-by: syzbot+981935d9485a560bfbcb@syzkaller.appspotmail.com
Reported-by: syzbot+2cb5a6c573e98db598cc@syzkaller.appspotmail.com
Reported-by: syzbot+62d8b26793e8a2bd0516@syzkaller.appspotmail.com
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20240328052426.3042617-2-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf.h      |   16 +++++++++++++++-
 kernel/bpf/syscall.c     |   35 ++++++++++++++++++++++++++++++++---
 kernel/trace/bpf_trace.c |    4 ++--
 3 files changed, 49 insertions(+), 6 deletions(-)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1568,12 +1568,26 @@ struct bpf_link {
 	enum bpf_link_type type;
 	const struct bpf_link_ops *ops;
 	struct bpf_prog *prog;
-	struct work_struct work;
+	/* rcu is used before freeing, work can be used to schedule that
+	 * RCU-based freeing before that, so they never overlap
+	 */
+	union {
+		struct rcu_head rcu;
+		struct work_struct work;
+	};
 };
 
 struct bpf_link_ops {
 	void (*release)(struct bpf_link *link);
+	/* deallocate link resources callback, called without RCU grace period
+	 * waiting
+	 */
 	void (*dealloc)(struct bpf_link *link);
+	/* deallocate link resources callback, called after RCU grace period;
+	 * if underlying BPF program is sleepable we go through tasks trace
+	 * RCU GP and then "classic" RCU GP
+	 */
+	void (*dealloc_deferred)(struct bpf_link *link);
 	int (*detach)(struct bpf_link *link);
 	int (*update_prog)(struct bpf_link *link, struct bpf_prog *new_prog,
 			   struct bpf_prog *old_prog);
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2895,17 +2895,46 @@ void bpf_link_inc(struct bpf_link *link)
 	atomic64_inc(&link->refcnt);
 }
 
+static void bpf_link_defer_dealloc_rcu_gp(struct rcu_head *rcu)
+{
+	struct bpf_link *link = container_of(rcu, struct bpf_link, rcu);
+
+	/* free bpf_link and its containing memory */
+	link->ops->dealloc_deferred(link);
+}
+
+static void bpf_link_defer_dealloc_mult_rcu_gp(struct rcu_head *rcu)
+{
+	if (rcu_trace_implies_rcu_gp())
+		bpf_link_defer_dealloc_rcu_gp(rcu);
+	else
+		call_rcu(rcu, bpf_link_defer_dealloc_rcu_gp);
+}
+
 /* bpf_link_free is guaranteed to be called from process context */
 static void bpf_link_free(struct bpf_link *link)
 {
+	bool sleepable = false;
+
 	bpf_link_free_id(link->id);
 	if (link->prog) {
+		sleepable = link->prog->aux->sleepable;
 		/* detach BPF program, clean up used resources */
 		link->ops->release(link);
 		bpf_prog_put(link->prog);
 	}
-	/* free bpf_link and its containing memory */
-	link->ops->dealloc(link);
+	if (link->ops->dealloc_deferred) {
+		/* schedule BPF link deallocation; if underlying BPF program
+		 * is sleepable, we need to first wait for RCU tasks trace
+		 * sync, then go through "classic" RCU grace period
+		 */
+		if (sleepable)
+			call_rcu_tasks_trace(&link->rcu, bpf_link_defer_dealloc_mult_rcu_gp);
+		else
+			call_rcu(&link->rcu, bpf_link_defer_dealloc_rcu_gp);
+	}
+	if (link->ops->dealloc)
+		link->ops->dealloc(link);
 }
 
 static void bpf_link_put_deferred(struct work_struct *work)
@@ -3415,7 +3444,7 @@ static int bpf_raw_tp_link_fill_link_inf
 
 static const struct bpf_link_ops bpf_raw_tp_link_lops = {
 	.release = bpf_raw_tp_link_release,
-	.dealloc = bpf_raw_tp_link_dealloc,
+	.dealloc_deferred = bpf_raw_tp_link_dealloc,
 	.show_fdinfo = bpf_raw_tp_link_show_fdinfo,
 	.fill_link_info = bpf_raw_tp_link_fill_link_info,
 };
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2713,7 +2713,7 @@ static int bpf_kprobe_multi_link_fill_li
 
 static const struct bpf_link_ops bpf_kprobe_multi_link_lops = {
 	.release = bpf_kprobe_multi_link_release,
-	.dealloc = bpf_kprobe_multi_link_dealloc,
+	.dealloc_deferred = bpf_kprobe_multi_link_dealloc,
 	.fill_link_info = bpf_kprobe_multi_link_fill_link_info,
 };
 
@@ -3227,7 +3227,7 @@ static int bpf_uprobe_multi_link_fill_li
 
 static const struct bpf_link_ops bpf_uprobe_multi_link_lops = {
 	.release = bpf_uprobe_multi_link_release,
-	.dealloc = bpf_uprobe_multi_link_dealloc,
+	.dealloc_deferred = bpf_uprobe_multi_link_dealloc,
 	.fill_link_info = bpf_uprobe_multi_link_fill_link_info,
 };
 


