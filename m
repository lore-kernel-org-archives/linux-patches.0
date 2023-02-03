Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B721FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B81C433D2;
	Fri,  3 Feb 2023 10:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419716;
	bh=WhbR4MKUsgKinL0jOlu+gZ1A1HqWpjQDjDpuRn+pUAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YbA2hlhQRhGwRPPWqgPOwldPDb23LwnFNQGdF4Fzqxj/pHyTgRPoAuLmTaGxNqFM2
	 Gh9ufitpF2tP/4xyZt/DxDMtNQf8Q9g+NNBTlMi3mFFFFZbEnlVDe7rHdQblRi6ojO
	 coceQ2aN8vQqQoYItOZgr67plzXkR9Ya+dvTTASk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinyang He <hejinyang@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 14/28] LoongArch: Get frame info in unwind_start() when regs is not available
Date: Fri,  3 Feb 2023 11:13:02 +0100
Message-Id: <20230203101010.573082813@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
References: <20230203101009.946745030@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jinyang He <hejinyang@loongson.cn>

[ Upstream commit 429a9671f235c94fc4b5d6687308714b74adc820 ]

At unwind_start(), it is better to get its frame info here rather than
get them outside, even we don't have 'regs'. In this way we can simply
use unwind_{start, next_frame, done} outside.

Signed-off-by: Jinyang He <hejinyang@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/process.c         | 12 +++---------
 arch/loongarch/kernel/unwind_guess.c    |  6 ++++++
 arch/loongarch/kernel/unwind_prologue.c | 16 +++++++++++++---
 3 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/arch/loongarch/kernel/process.c b/arch/loongarch/kernel/process.c
index ddb8ba4eb399..90a5de746332 100644
--- a/arch/loongarch/kernel/process.c
+++ b/arch/loongarch/kernel/process.c
@@ -185,20 +185,14 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 
 unsigned long __get_wchan(struct task_struct *task)
 {
-	unsigned long pc;
+	unsigned long pc = 0;
 	struct unwind_state state;
 
 	if (!try_get_task_stack(task))
 		return 0;
 
-	unwind_start(&state, task, NULL);
-	state.sp = thread_saved_fp(task);
-	get_stack_info(state.sp, state.task, &state.stack_info);
-	state.pc = thread_saved_ra(task);
-#ifdef CONFIG_UNWINDER_PROLOGUE
-	state.type = UNWINDER_PROLOGUE;
-#endif
-	for (; !unwind_done(&state); unwind_next_frame(&state)) {
+	for (unwind_start(&state, task, NULL);
+	     !unwind_done(&state); unwind_next_frame(&state)) {
 		pc = unwind_get_return_address(&state);
 		if (!pc)
 			break;
diff --git a/arch/loongarch/kernel/unwind_guess.c b/arch/loongarch/kernel/unwind_guess.c
index 5afa6064d73e..0c20e5184de6 100644
--- a/arch/loongarch/kernel/unwind_guess.c
+++ b/arch/loongarch/kernel/unwind_guess.c
@@ -25,6 +25,12 @@ void unwind_start(struct unwind_state *state, struct task_struct *task,
 	if (regs) {
 		state->sp = regs->regs[3];
 		state->pc = regs->csr_era;
+	} else if (task && task != current) {
+		state->sp = thread_saved_fp(task);
+		state->pc = thread_saved_ra(task);
+	} else {
+		state->sp = (unsigned long)__builtin_frame_address(0);
+		state->pc = (unsigned long)__builtin_return_address(0);
 	}
 
 	state->task = task;
diff --git a/arch/loongarch/kernel/unwind_prologue.c b/arch/loongarch/kernel/unwind_prologue.c
index 4571c3c87cd4..1c5b65756144 100644
--- a/arch/loongarch/kernel/unwind_prologue.c
+++ b/arch/loongarch/kernel/unwind_prologue.c
@@ -111,12 +111,22 @@ void unwind_start(struct unwind_state *state, struct task_struct *task,
 		    struct pt_regs *regs)
 {
 	memset(state, 0, sizeof(*state));
+	state->type = UNWINDER_PROLOGUE;
 
-	if (regs &&  __kernel_text_address(regs->csr_era)) {
-		state->pc = regs->csr_era;
+	if (regs) {
 		state->sp = regs->regs[3];
+		state->pc = regs->csr_era;
 		state->ra = regs->regs[1];
-		state->type = UNWINDER_PROLOGUE;
+		if (!__kernel_text_address(state->pc))
+			state->type = UNWINDER_GUESS;
+	} else if (task && task != current) {
+		state->sp = thread_saved_fp(task);
+		state->pc = thread_saved_ra(task);
+		state->ra = 0;
+	} else {
+		state->sp = (unsigned long)__builtin_frame_address(0);
+		state->pc = (unsigned long)__builtin_return_address(0);
+		state->ra = 0;
 	}
 
 	state->task = task;
-- 
2.39.0



