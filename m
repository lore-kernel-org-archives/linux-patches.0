Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9259347FE1;
	Tue, 16 Dec 2025 11:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885374; cv=none; b=S6sOKjTmGaAFTACPXzbBMMyqlO8m4SSHg00H+/weQuqxMSua2XEM23ZzzP+iKqDsiupE9o88q0xmOzb9kUAES1w0W4/5IJBJkkQ1VO493EHpTjoN7WQEJWPPEPVkV6ampSlx9nEWxDXnj4dMTxu9j9POIiNPp4tR5SOkoeuorkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885374; c=relaxed/simple;
	bh=ojd4RUv+K9/BGUHoBIOvl4nFbQNVyn8wiJmC9DNfyx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHsHv8zf1SQIerUTI8Fa5a7dGw9VQjwPSM9zRT3iJuYdwhtQHQS2J+qSt3PXavfSORcgkNqH5/cwiGNqEuKjTgRegpkZQJdOYp+NIcGx3XWjw6id6ffqFzDkSTWCBTsvDZfHQarhZxFaWHNkrcw9NDWocySeazC7i9IuWn2/AFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CY9j+vEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CY9j+vEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8289AC4CEF5;
	Tue, 16 Dec 2025 11:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885374;
	bh=ojd4RUv+K9/BGUHoBIOvl4nFbQNVyn8wiJmC9DNfyx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CY9j+vEjsfS0hC4t8/OrV0sIrWqlfMCrZoprR9iz903jJ2kbNMeh3DueYSY3h/7jA
	 RhuwDo5aOqEIQPWWtPNR+2TrY4wEjtUPJtCwkpz3MUm5Kb/ySK9/tjt74/x4xY8gX9
	 2BYHX0AwhaCoeHgXnM2VZIONy2qg0MaBWkG+PDzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 120/507] task_work: Fix NMI race condition
Date: Tue, 16 Dec 2025 12:09:21 +0100
Message-ID: <20251216111349.880530040@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit ef1ea98c8fffe227e5319215d84a53fa2a4bcebc ]

  __schedule()
  // disable irqs
      <NMI>
	  task_work_add(current, work, TWA_NMI_CURRENT);
      </NMI>
  // current = next;
  // enable irqs
      <IRQ>
	  task_work_set_notify_irq()
	  test_and_set_tsk_thread_flag(current,
                                       TIF_NOTIFY_RESUME); // wrong task!
      </IRQ>
  // original task skips task work on its next return to user (or exit!)

Fixes: 466e4d801cd4 ("task_work: Add TWA_NMI_CURRENT as an additional notify mode.")
Reported-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Link: https://patch.msgid.link/20250924080118.425949403@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/task_work.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/task_work.c b/kernel/task_work.c
index d1efec571a4a4..0f7519f8e7c93 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -9,7 +9,12 @@ static struct callback_head work_exited; /* all we need is ->next == NULL */
 #ifdef CONFIG_IRQ_WORK
 static void task_work_set_notify_irq(struct irq_work *entry)
 {
-	test_and_set_tsk_thread_flag(current, TIF_NOTIFY_RESUME);
+	/*
+	 * no-op IPI
+	 *
+	 * TWA_NMI_CURRENT will already have set the TIF flag, all
+	 * this interrupt does it tickle the return-to-user path.
+	 */
 }
 static DEFINE_PER_CPU(struct irq_work, irq_work_NMI_resume) =
 	IRQ_WORK_INIT_HARD(task_work_set_notify_irq);
@@ -86,6 +91,7 @@ int task_work_add(struct task_struct *task, struct callback_head *work,
 		break;
 #ifdef CONFIG_IRQ_WORK
 	case TWA_NMI_CURRENT:
+		set_tsk_thread_flag(current, TIF_NOTIFY_RESUME);
 		irq_work_queue(this_cpu_ptr(&irq_work_NMI_resume));
 		break;
 #endif
-- 
2.51.0



