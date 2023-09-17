Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E786FCC
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:52:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A900C433C9;
	Sun, 17 Sep 2023 19:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980323;
	bh=59OISQo5yJm9nwZ+bUhiSNP5EokUGs98oC78DXua8lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FipLwws+gCT8JLqBFked0Z0xCdt5giztplJSFS4ff+nAI/99Mp1huE7wJTFz2q87I
	 /AyEAr08m/BrrFCUpngbhSEwfcUWGluA/6uKG1Lvv5eyktCvhCxkhSK+urJbBNYlp8
	 rQP7cJ5UB++NVgDzDs7A86WsC0DTUvvbO/kN8aQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 158/285] bpf: Assign bpf_tramp_run_ctx::saved_run_ctx before recursion check.
Date: Sun, 17 Sep 2023 21:12:38 +0200
Message-ID: <20230917191057.146769732@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 6764e767f4af1e35f87f3497e1182d945de37f93 ]

__bpf_prog_enter_recur() assigns bpf_tramp_run_ctx::saved_run_ctx before
performing the recursion check which means in case of a recursion
__bpf_prog_exit_recur() uses the previously set bpf_tramp_run_ctx::saved_run_ctx
value.

__bpf_prog_enter_sleepable_recur() assigns bpf_tramp_run_ctx::saved_run_ctx
after the recursion check which means in case of a recursion
__bpf_prog_exit_sleepable_recur() uses an uninitialized value. This does not
look right. If I read the entry trampoline code right, then bpf_tramp_run_ctx
isn't initialized upfront.

Align __bpf_prog_enter_sleepable_recur() with __bpf_prog_enter_recur() and
set bpf_tramp_run_ctx::saved_run_ctx before the recursion check is made.
Remove the assignment of saved_run_ctx in kern_sys_bpf() since it happens
a few cycles later.

Fixes: e384c7b7b46d0 ("bpf, x86: Create bpf_tramp_run_ctx on the caller thread's stack")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/bpf/20230830080405.251926-3-bigeasy@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c    | 1 -
 kernel/bpf/trampoline.c | 5 ++---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index c925c270ed8b4..1480b6cf12f06 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -5304,7 +5304,6 @@ int kern_sys_bpf(int cmd, union bpf_attr *attr, unsigned int size)
 		}
 
 		run_ctx.bpf_cookie = 0;
-		run_ctx.saved_run_ctx = NULL;
 		if (!__bpf_prog_enter_sleepable_recur(prog, &run_ctx)) {
 			/* recursion detected */
 			__bpf_prog_exit_sleepable_recur(prog, 0, &run_ctx);
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 78acf28d48732..53ff50cac61ea 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -926,13 +926,12 @@ u64 notrace __bpf_prog_enter_sleepable_recur(struct bpf_prog *prog,
 	migrate_disable();
 	might_fault();
 
+	run_ctx->saved_run_ctx = bpf_set_run_ctx(&run_ctx->run_ctx);
+
 	if (unlikely(this_cpu_inc_return(*(prog->active)) != 1)) {
 		bpf_prog_inc_misses_counter(prog);
 		return 0;
 	}
-
-	run_ctx->saved_run_ctx = bpf_set_run_ctx(&run_ctx->run_ctx);
-
 	return bpf_prog_start_time();
 }
 
-- 
2.40.1



