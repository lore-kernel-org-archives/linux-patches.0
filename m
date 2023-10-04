Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8E41C29E
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iXBRkVW8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42C8C433C8;
	Wed,  4 Oct 2023 18:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444605;
	bh=d+StRMS/Tmk5T1nErvV7YSt8I02GsIStE1mROjHxqvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXBRkVW8+SYfI2PKFOCHohZ1+2uxqw3FxGFCDAWLK1e5+q+ptWhZ8/N3LwoKYnvzh
	 LzV85IeU5qzT9s0FRjF/4KzWqB8ezybAHJp7pvaG9eF8rbI+aCwz5JSedqyXMmQHWL
	 04Pz1b9xWISX/AveUPoe4kUndpu7acjnegFAY38g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.5 271/321] kernel/sched: Modify initial boot task idle setup
Date: Wed,  4 Oct 2023 19:56:56 +0200
Message-ID: <20231004175241.842063337@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

From: Liam R. Howlett <Liam.Howlett@oracle.com>

commit cff9b2332ab762b7e0586c793c431a8f2ea4db04 upstream.

Initial booting is setting the task flag to idle (PF_IDLE) by the call
path sched_init() -> init_idle().  Having the task idle and calling
call_rcu() in kernel/rcu/tiny.c means that TIF_NEED_RESCHED will be
set.  Subsequent calls to any cond_resched() will enable IRQs,
potentially earlier than the IRQ setup has completed.  Recent changes
have caused just this scenario and IRQs have been enabled early.

This causes a warning later in start_kernel() as interrupts are enabled
before they are fully set up.

Fix this issue by setting the PF_IDLE flag later in the boot sequence.

Although the boot task was marked as idle since (at least) d80e4fda576d,
I am not sure that it is wrong to do so.  The forced context-switch on
idle task was introduced in the tiny_rcu update, so I'm going to claim
this fixes 5f6130fa52ee.

Fixes: 5f6130fa52ee ("tiny_rcu: Directly force QS when call_rcu_[bh|sched]() on idle_task")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mm/CAMuHMdWpvpWoDa=Ox-do92czYRvkok6_x6pYUH+ZouMcJbXy+Q@mail.gmail.com/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c |    2 +-
 kernel/sched/idle.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -9271,7 +9271,7 @@ void __init init_idle(struct task_struct
 	 * PF_KTHREAD should already be set at this point; regardless, make it
 	 * look like a proper per-CPU kthread.
 	 */
-	idle->flags |= PF_IDLE | PF_KTHREAD | PF_NO_SETAFFINITY;
+	idle->flags |= PF_KTHREAD | PF_NO_SETAFFINITY;
 	kthread_set_per_cpu(idle, cpu);
 
 #ifdef CONFIG_SMP
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -373,6 +373,7 @@ EXPORT_SYMBOL_GPL(play_idle_precise);
 
 void cpu_startup_entry(enum cpuhp_state state)
 {
+	current->flags |= PF_IDLE;
 	arch_cpu_idle_prepare();
 	cpuhp_online_idle(state);
 	while (1)


