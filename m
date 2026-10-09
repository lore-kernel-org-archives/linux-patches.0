Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D5D31E85E;
	Fri,  9 Oct 2026 14:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556666; cv=none; b=Dl+leFY6IkF8Pi4iwY/ej/sX1oF2Hy3w2ObjTsgE29Kshux6cFA/UCfmamBnbIoj6u7wTd+wof5E2heO1B7pnnnc+S3FSCPC3m8IrrZ8qfFS3r4K5nMdIchictkmE6wlMeOlkeulL4namNrFcbsDHaefeqIRSSeXXLGjuAY0p28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556666; c=relaxed/simple;
	bh=BwGm/9Dz0aSgEQZjmpT+seQbWuhDOy2J9JkvNqAlOj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qsd8nYEc8A/tpiGHWKSub1Wjqay2tRV7ouCZAM1WHWM2RYvDeoTBl6sXe29/Lr7jwur4qasyovlhTPenNxbTdeQJNrKG2T8nVs7glxuNkfY3qlCtEYStwyET8n1Ge5pHt/PeKeeBTiOJLURekjAgHS9Z8USZq5KBiPgZluXjkD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XDND/S6a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDND/S6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551331F00893;
	Fri,  9 Oct 2026 14:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556664;
	bh=sLvpDid0UNnZp/tQyFO0PLzHBfS9WHm6hdWozvX8D4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XDND/S6aSXGyHyCDz33hIiF4/DFk7v43MYL3qxfh/kXJ8dW/vBONfobvdTVUJ8sev
	 ZquWg0b3aeGjakVoTtFax0F1KLi3lE1ylrSL2E9jRIYwmH5c4R2ZCTkATFC2BCu+US
	 s7W1I0Zf2XPOQG4pzQZLfYaAgFpvGDnTacgmdnxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 240/403] fprobe: Use guard(rcu_sched_notrace) and check rcu_is_watching()
Date: Fri,  9 Oct 2026 16:10:01 +0200
Message-ID: <20261009140957.782743608@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit e0a6249190402a28f1e2925a81acf573157d55ef ]

unregister_fprobe() and unregister_fprobe_async() (used by BPF
kprobe-multi) rely on standard RCU grace periods (synchronize_rcu()
and call_rcu()) to wait until in-flight fprobe handlers complete before
freeing the fprobe.

However, if an fprobe handler executes while RCU is not watching (such
as in the idle loop or nohz_full extended quiescent states), standard
RCU does not track preemption-disabled sections. Consequently,
synchronize_rcu() does not wait for those executions, which can lead
to a use-after-free if the fprobe is freed immediately after
unregistration. Ensure handlers exit early when !rcu_is_watching().

Furthermore, fprobe_fgraph_entry() and fprobe_ftrace_entry() previously
used guard(rcu)() and rcu_read_lock(), which invoke lockdep on every
hit under CONFIG_PROVE_LOCKING. This adds overhead and can cause lockdep
recursion if probed functions interact with lockdep.

Since rhltable_lookup() and rhl_for_each_entry_rcu() use
rcu_dereference_all_check() (which checks rcu_read_lock_any_held()),
holding preemption disabled via rcu_read_lock_sched_notrace() is fully
valid and sufficient so long as rcu_is_watching() is true.

Define and use guard(rcu_sched_notrace)() across fprobe_ftrace_entry(),
fprobe_fgraph_entry(), and fprobe_return(). This eliminates fast-path
rcu_read_lock() and lockdep overhead while guaranteeing safe grace
period synchronization.

Link: https://lore.kernel.org/all/179064115227.394389.16910234241400391996.stgit@devnote2/

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-e46bcd68-4a56-4f19-a255-e3772980e5e3
Fixes: 657b594b2084 ("fprobe: Fix unregister_fprobe() to wait for RCU grace period")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/fprobe.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
index 2ba7470443551..a236baed157a4 100644
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -47,6 +47,10 @@ static struct rhltable fprobe_ip_table;
 static DEFINE_MUTEX(fprobe_mutex);
 static struct fgraph_ops fprobe_graph_ops;
 
+DEFINE_LOCK_GUARD_0(rcu_sched_notrace,
+		    rcu_read_lock_sched_notrace(),
+		    rcu_read_unlock_sched_notrace())
+
 static u32 fprobe_node_hashfn(const void *data, u32 len, u32 seed)
 {
 	return hash_ptr(*(unsigned long **)data, 32);
@@ -260,16 +264,14 @@ static void fprobe_ftrace_entry(unsigned long ip, unsigned long parent_ip,
 	struct fprobe *fp;
 	int bit;
 
+	if (!rcu_is_watching())
+		return;
+
 	bit = ftrace_test_recursion_trylock(ip, parent_ip);
 	if (bit < 0)
 		return;
 
-	/*
-	 * ftrace_test_recursion_trylock() disables preemption, but
-	 * rhltable_lookup() checks whether rcu_read_lcok is held.
-	 * So we take rcu_read_lock() here.
-	 */
-	rcu_read_lock();
+	guard(rcu_sched_notrace)();
 	head = rhltable_lookup(&fprobe_ip_table, &ip, fprobe_rht_params);
 
 	rhl_for_each_entry_rcu(node, pos, head, hlist) {
@@ -284,7 +286,6 @@ static void fprobe_ftrace_entry(unsigned long ip, unsigned long parent_ip,
 		else
 			__fprobe_handler(ip, parent_ip, fp, fregs, NULL);
 	}
-	rcu_read_unlock();
 	ftrace_test_recursion_unlock(bit);
 }
 NOKPROBE_SYMBOL(fprobe_ftrace_entry);
@@ -425,10 +426,13 @@ static int fprobe_fgraph_entry(struct ftrace_graph_ent *trace, struct fgraph_ops
 	struct fprobe *fp;
 	int used, ret;
 
+	if (!rcu_is_watching())
+		return 0;
+
 	if (WARN_ON_ONCE(!fregs))
 		return 0;
 
-	guard(rcu)();
+	guard(rcu_sched_notrace)();
 	head = rhltable_lookup(&fprobe_ip_table, &func, fprobe_rht_params);
 	reserved_words = 0;
 	rhl_for_each_entry_rcu(node, pos, head, hlist) {
@@ -521,13 +525,16 @@ static void fprobe_return(struct ftrace_graph_ret *trace,
 	int size, curr;
 	int size_words;
 
+	if (!rcu_is_watching())
+		return;
+
 	fgraph_data = (unsigned long *)fgraph_retrieve_data(gops->idx, &size);
 	if (WARN_ON_ONCE(!fgraph_data))
 		return;
 	size_words = SIZE_IN_LONG(size);
 	ret_ip = ftrace_regs_get_instruction_pointer(fregs);
 
-	preempt_disable_notrace();
+	guard(rcu_sched_notrace)();
 
 	curr = 0;
 	while (size_words > curr) {
@@ -543,7 +550,6 @@ static void fprobe_return(struct ftrace_graph_ret *trace,
 		}
 		curr += size;
 	}
-	preempt_enable_notrace();
 }
 NOKPROBE_SYMBOL(fprobe_return);
 
-- 
2.53.0



