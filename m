Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4511A5BB7;
	Wed,  5 Mar 2025 18:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198288; cv=none; b=SHC8TF3mxEjLhgQnoUIOZVUcQMRHYdKtnertTte6ah3lj6Ansmht1Wx0UFCCzv9fUQ3T8FfjwHsLhkIrNcx82Pb6A+BpRa0iQzmgUvJbf/SoFjmxQJVuyfE47TeLudIRS3fSCvTRK5Y5+bqWX3v+dClIuoZFp6zDjXnVtDQNjUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198288; c=relaxed/simple;
	bh=HWCkRrlYs4P6g7+J9vSTS4WHTW6S3pbbV/TSQNrJieQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+hJtRkIRaiDGUT2pzxyAA6U0WvVhXdI1hEq+y+iZvr8CMsg7eoxxhFkVSa7Rgw0ryVPeCUOLLMhq758Sa6zMERSCfLdnKUEop8gtThS2OfUBTI4WiXqDW2xhNz6++F+LVPzGyCn1eTICQDHqJTanIDZZepTc9r9kNKxKBlD6/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KjF+JEKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KjF+JEKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338B2C4CED1;
	Wed,  5 Mar 2025 18:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198288;
	bh=HWCkRrlYs4P6g7+J9vSTS4WHTW6S3pbbV/TSQNrJieQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KjF+JEKirve+BuCfDQU3RW+PEeMvToxh7o62PvV5oN2+fKix82LjIlKR6slJ7+dVU
	 u2T6PIssBoXekqf2bvcTf6uhRko8K4w22rp5JVlJZ86vVmILrhAEgD1w680suQIDiB
	 SfZ0KWI8To16nsFnKx5VJNO68LgZ0D8V4aQ6Es10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.12 128/150] sched/core: Prevent rescheduling when interrupts are disabled
Date: Wed,  5 Mar 2025 18:49:17 +0100
Message-ID: <20250305174508.956984427@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Thomas Gleixner <tglx@linutronix.de>

commit 82c387ef7568c0d96a918a5a78d9cad6256cfa15 upstream.

David reported a warning observed while loop testing kexec jump:

  Interrupts enabled after irqrouter_resume+0x0/0x50
  WARNING: CPU: 0 PID: 560 at drivers/base/syscore.c:103 syscore_resume+0x18a/0x220
   kernel_kexec+0xf6/0x180
   __do_sys_reboot+0x206/0x250
   do_syscall_64+0x95/0x180

The corresponding interrupt flag trace:

  hardirqs last  enabled at (15573): [<ffffffffa8281b8e>] __up_console_sem+0x7e/0x90
  hardirqs last disabled at (15580): [<ffffffffa8281b73>] __up_console_sem+0x63/0x90

That means __up_console_sem() was invoked with interrupts enabled. Further
instrumentation revealed that in the interrupt disabled section of kexec
jump one of the syscore_suspend() callbacks woke up a task, which set the
NEED_RESCHED flag. A later callback in the resume path invoked
cond_resched() which in turn led to the invocation of the scheduler:

  __cond_resched+0x21/0x60
  down_timeout+0x18/0x60
  acpi_os_wait_semaphore+0x4c/0x80
  acpi_ut_acquire_mutex+0x3d/0x100
  acpi_ns_get_node+0x27/0x60
  acpi_ns_evaluate+0x1cb/0x2d0
  acpi_rs_set_srs_method_data+0x156/0x190
  acpi_pci_link_set+0x11c/0x290
  irqrouter_resume+0x54/0x60
  syscore_resume+0x6a/0x200
  kernel_kexec+0x145/0x1c0
  __do_sys_reboot+0xeb/0x240
  do_syscall_64+0x95/0x180

This is a long standing problem, which probably got more visible with
the recent printk changes. Something does a task wakeup and the
scheduler sets the NEED_RESCHED flag. cond_resched() sees it set and
invokes schedule() from a completely bogus context. The scheduler
enables interrupts after context switching, which causes the above
warning at the end.

Quite some of the code paths in syscore_suspend()/resume() can result in
triggering a wakeup with the exactly same consequences. They might not
have done so yet, but as they share a lot of code with normal operations
it's just a question of time.

The problem only affects the PREEMPT_NONE and PREEMPT_VOLUNTARY scheduling
models. Full preemption is not affected as cond_resched() is disabled and
the preemption check preemptible() takes the interrupt disabled flag into
account.

Cure the problem by adding a corresponding check into cond_resched().

Reported-by: David Woodhouse <dwmw@amazon.co.uk>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: David Woodhouse <dwmw@amazon.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@vger.kernel.org
Closes: https://lore.kernel.org/all/7717fe2ac0ce5f0a2c43fdab8b11f4483d54a2a4.camel@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7229,7 +7229,7 @@ out_unlock:
 #if !defined(CONFIG_PREEMPTION) || defined(CONFIG_PREEMPT_DYNAMIC)
 int __sched __cond_resched(void)
 {
-	if (should_resched(0)) {
+	if (should_resched(0) && !irqs_disabled()) {
 		preempt_schedule_common();
 		return 1;
 	}


