Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622639;
	b=W2mOjGATYcgpNO32g7LxFTa9Wo2ag/jfAnSGODoehwGGVTX/aKRTehy/o5vDSn9g9NTZ
	 J9gybtrEyknKiD3w6Ewywzeib9BflT5qa5dSXsgfIPOsEC/C3nMEqZg06I8nkMdpMEsg5
	 bN2tP24LAzb6ob6aOuXIrK/1GK0p5SG0PYzMk6xiqc8FrrLhCSvGYUTSmUUeJLWXkzMlk
	 DRS6mdNcA3Thjfy9NChDB0wtE+cIQyy/YqInVLNnImO25jLlTklsE5yIlCAOJz5bw+8Sk
	 1m2sxxbAcKl/rKP7W2E4ZXUnv5v6FaEV/BbdX/yZgOjpSMp3mxGn1zmPK81IsuLqDaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622639;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9WgDKi/vVhmV7rWiCAjfCWx/Bx0zZr0My7k6bFZLLw4=;
	b=UdoB2YCrEj8mjjt16s4RvoEZUjmN07nMb9rxjq5qi0fwcxnVftygRPFr1H42HMMmoOiv
	 nkzbE6RQMwIoSLe4FpuZSydsA15i8NNFpfP62F1cTjHC+3/yyTBsMa+cPriPJr4vHHTnn
	 /84Opz7yCiyXGWsu5znf1oa6pEqE/LneDmE6e4wG5bV8lVspDwnGkQmKhxUFhCV74pDKJ
	 fBGs5RRJ9vCYglbk2Nz984Fn0y7JSfNxf7vsnNGzbZL4KuPHjFbSc/IMQ+tpRE7YTd6bY
	 2iDoC5Khu6QAsy8Qxo+crBK66HJ4Z5odCB8GoTijfLecUFW5i/RAd1HFksBlyNJq3jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="a+wm4//c";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED11606A31E;
	Wed, 25 Nov 2026 16:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a+wm4//c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6194F1F000C4;
	Wed, 25 Nov 2026 16:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622638;
	bh=9WgDKi/vVhmV7rWiCAjfCWx/Bx0zZr0My7k6bFZLLw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a+wm4//cnotA0PcYlDZJ/dyx/ld4a4yt/RYzBcv6RK/qzE0LvH3hr4Gp1OvIbYvtD
	 PyTmhc86XqcN6J4xOvgJyjDe2EaIItD8yTRaWYIxldDU0jFAHWlLvV/jjB8f1FoLJU
	 h/maOwgWTHtR70EkRSjlt7ZvaO3etVEDIvo/5vKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 602/990] bpf: Keep a program until its bpf_wq callback has ended
Date: Wed, 25 Nov 2026 15:32:49 +0100
Message-ID: <20261125143836.194369272@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 1e28a5e52d32b7d3f4c9fb24898774f941166d2b ]

bpf_wq_work() runs the callback under rcu_read_lock_trace() only, since
the callback may sleep.  The program it belongs to need not be sleepable,
and such a program is freed behind a plain RCU grace period.  The
reference that the bpf_wq holds is dropped when the map element goes, or
when another callback is set, no matter whether the work is running.

If that was the last reference the program is freed under the running
callback, and the worker goes on in the freed JIT image:

  Oops: int3: 0000 [#1] SMP NOPTI
  RIP: 0010:0xffffffffc0600947

All it takes is to close the map and the program while the callback runs.

Note in the program that it has a callback that runs sleepable, and wait
for an RCU Tasks Trace grace period, which implies a plain one, before
such a program is freed.  Let bpf_wq_work() enter its read side critical
section before it reads callback_fn.

bpf_task_work holds a reference to the program until the callback is done.

Fixes: 8e83da9732d9 ("bpf: add bpf_wq_start")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-23-alexei.starovoitov@gmail.com
[ sashal: Dropped the nonexistent tramp_linked context line and the __bpf_prog_put_rcu_tasks() hunk, and used bpf_prog_runs_sleepable() in the simpler if/else of __bpf_prog_put_noref(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h   | 10 ++++++++++
 kernel/bpf/helpers.c  |  9 ++++++---
 kernel/bpf/syscall.c  |  2 +-
 kernel/bpf/verifier.c |  2 ++
 4 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f165743cd71f3..2d8cb15fb9ba7 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1619,6 +1619,7 @@ struct bpf_prog_aux {
 	bool offload_requested; /* Program is bound and offloaded to the netdev. */
 	bool attach_btf_trace; /* true if attaching to BTF-enabled raw tp */
 	bool attach_tracing_prog; /* true if tracing another tracing program */
+	bool sleepable_async_cb; /* has a bpf_wq or bpf_task_work callback */
 	bool func_proto_unreliable;
 	bool tail_call_reachable;
 	bool xdp_has_frags;
@@ -1741,6 +1742,15 @@ struct bpf_prog {
 	};
 };
 
+/*
+ * Does the program, or a callback of it, run under RCU Tasks Trace protection
+ * only, outside of any RCU read side critical section?
+ */
+static inline bool bpf_prog_runs_sleepable(const struct bpf_prog *prog)
+{
+	return prog->sleepable || prog->aux->sleepable_async_cb;
+}
+
 struct bpf_array_aux {
 	/* Programs with direct jumps into programs part of this array. */
 	struct list_head poke_progs;
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 89cb7e38be764..5271bc5178ea3 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1214,18 +1214,21 @@ static void bpf_wq_work(struct work_struct *work)
 
 	BTF_TYPE_EMIT(struct bpf_wq);
 
+	/* keeps the program that callback_fn belongs to */
+	rcu_read_lock_trace();
+
 	callback_fn = READ_ONCE(cb->callback_fn);
 	if (!callback_fn)
-		return;
+		goto out;
 
 	key = map_key_from_value(map, value, &idx);
 
-        rcu_read_lock_trace();
-        migrate_disable();
+	migrate_disable();
 
 	callback_fn((u64)(long)map, (u64)(long)key, (u64)(long)value, 0, 0);
 
 	migrate_enable();
+out:
 	rcu_read_unlock_trace();
 }
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 79668e8441419..865107eb49467 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2403,7 +2403,7 @@ static void __bpf_prog_put_noref(struct bpf_prog *prog, bool deferred)
 		btf_put(prog->aux->attach_btf);
 
 	if (deferred) {
-		if (prog->sleepable)
+		if (bpf_prog_runs_sleepable(prog))
 			call_rcu_tasks_trace(&prog->aux->rcu, __bpf_prog_put_rcu);
 		else
 			call_rcu(&prog->aux->rcu, __bpf_prog_put_rcu);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b664c160b9277..55d6cf2653755 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10891,6 +10891,8 @@ static int push_callback_call(struct bpf_verifier_env *env, struct bpf_insn *ins
 					 is_async_cb_sleepable(env, insn));
 		if (IS_ERR(async_cb))
 			return PTR_ERR(async_cb);
+		if (is_async_cb_sleepable(env, insn))
+			env->prog->aux->sleepable_async_cb = true;
 		callee = async_cb->frame[0];
 		callee->async_entry_cnt = state->frame[0]->async_entry_cnt + 1;
 
-- 
2.53.0



