Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FCDBA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE6EC433EF;
	Tue,  7 Mar 2023 17:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210815;
	bh=W0X+bglo/2EJq1DlaNXfa7q21jxRw4oo7JaOBAQ6veU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rp+0lpJDyN8EtLoj11MKeJCh7y5FbfmW0q8KheBHkYiQc0sAObhBD7DCuSkNUI+er
	 x6ABSb3KXSlbmgG4auNEnkAPuC7mlaGvoo2fR8cPlZCQQLWRNik1kCuwETt0d/t9rF
	 S/E5ZqjbveKwrIEbiQlbbXgZxUg2Ufa+e3pp300A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0622/1001] exit: Detect and fix irq disabled state in oops
Date: Tue,  7 Mar 2023 17:56:34 +0100
Message-Id: <20230307170048.557339503@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 001c28e57187570e4b5aa4492c7a957fb6d65d7b ]

If a task oopses with irqs disabled, this can cause various cascading
problems in the oops path such as sleep-from-invalid warnings, and
potentially worse.

Since commit 0258b5fd7c712 ("coredump: Limit coredumps to a single
thread group"), the unconditional irq enable in coredump_task_exit()
will "fix" the irq state to be enabled early in do_exit(), so currently
this may not be triggerable, but that is coincidental and fragile.

Detect and fix the irqs_disabled() condition in the oops path before
calling do_exit(), similarly to the way in_atomic() is handled.

Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Link: https://lore.kernel.org/lkml/20221004094401.708299-1-npiggin@gmail.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/exit.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/exit.c b/kernel/exit.c
index 15dc2ec80c467..bccfa4218356e 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -807,6 +807,8 @@ void __noreturn do_exit(long code)
 	struct task_struct *tsk = current;
 	int group_dead;
 
+	WARN_ON(irqs_disabled());
+
 	synchronize_group_exit(tsk, code);
 
 	WARN_ON(tsk->plug);
@@ -938,6 +940,11 @@ void __noreturn make_task_dead(int signr)
 	if (unlikely(!tsk->pid))
 		panic("Attempted to kill the idle task!");
 
+	if (unlikely(irqs_disabled())) {
+		pr_info("note: %s[%d] exited with irqs disabled\n",
+			current->comm, task_pid_nr(current));
+		local_irq_enable();
+	}
 	if (unlikely(in_atomic())) {
 		pr_info("note: %s[%d] exited with preempt_count %d\n",
 			current->comm, task_pid_nr(current),
-- 
2.39.2



