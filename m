Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8653A2332C8;
	Tue, 12 Nov 2024 10:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407880; cv=none; b=Br223A9g/NwhKwVg+JKKhv+05itNepO6Mt4YUrmL2OVBjSsMrF/waK0r7T93bFQgS+6R6otcG7Qyf3bhSqMtRXwzeo9jmz1vx+/F/xyW1mC0a7HKnW022xOohCCaT6cGBqQm7wKekbdXU55szisyscMheRRkazu9eyL4yeFMxGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407880; c=relaxed/simple;
	bh=y+kW2kzhSQjQSG2AeEcrjJKJ0Zp5Ys1QwKTIyyZ2jgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avLfTGPBEa/4hKwAh5xBs2AgFEoY9Jbc/qOWR7P2+rsotdBs+gSuF24EmFNp5OYfVbh8/Slk8O5MHiuhsM52Fm3yqVu0Qd2jHJPDr0bGXMwEXnNl0rqj6JAmz4JPGz2I/3xO3nRWXbFKKDfOgdqGRGTRyJF2heAbufzhmDkmge8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ngmqiEUc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ngmqiEUc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5F1C4CED8;
	Tue, 12 Nov 2024 10:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407880;
	bh=y+kW2kzhSQjQSG2AeEcrjJKJ0Zp5Ys1QwKTIyyZ2jgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ngmqiEUckJtZPjLymEBr/AcGIYK2u9Hm4ZHVADBy9RPUxL0Fx7q3hsvNQvkByyl7k
	 AQJJeD0TNie01UwdFdos3+lDSu5dt/fyX05DOIiiG5u7v33IEwmXh40XfpXULiVZuX
	 fEizZbLEJWj70r7u8srdvVcCpI9JglNL5wdzV1EI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.6 094/119] arm64/sve: Discard stale CPU state when handling SVE traps
Date: Tue, 12 Nov 2024 11:21:42 +0100
Message-ID: <20241112101852.312087736@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

commit 751ecf6afd6568adc98f2a6052315552c0483d18 upstream.

The logic for handling SVE traps manipulates saved FPSIMD/SVE state
incorrectly, and a race with preemption can result in a task having
TIF_SVE set and TIF_FOREIGN_FPSTATE clear even though the live CPU state
is stale (e.g. with SVE traps enabled). This has been observed to result
in warnings from do_sve_acc() where SVE traps are not expected while
TIF_SVE is set:

|         if (test_and_set_thread_flag(TIF_SVE))
|                 WARN_ON(1); /* SVE access shouldn't have trapped */

Warnings of this form have been reported intermittently, e.g.

  https://lore.kernel.org/linux-arm-kernel/CA+G9fYtEGe_DhY2Ms7+L7NKsLYUomGsgqpdBj+QwDLeSg=JhGg@mail.gmail.com/
  https://lore.kernel.org/linux-arm-kernel/000000000000511e9a060ce5a45c@google.com/

The race can occur when the SVE trap handler is preempted before and
after manipulating the saved FPSIMD/SVE state, starting and ending on
the same CPU, e.g.

| void do_sve_acc(unsigned long esr, struct pt_regs *regs)
| {
|         // Trap on CPU 0 with TIF_SVE clear, SVE traps enabled
|         // task->fpsimd_cpu is 0.
|         // per_cpu_ptr(&fpsimd_last_state, 0) is task.
|
|         ...
|
|         // Preempted; migrated from CPU 0 to CPU 1.
|         // TIF_FOREIGN_FPSTATE is set.
|
|         get_cpu_fpsimd_context();
|
|         if (test_and_set_thread_flag(TIF_SVE))
|                 WARN_ON(1); /* SVE access shouldn't have trapped */
|
|         sve_init_regs() {
|                 if (!test_thread_flag(TIF_FOREIGN_FPSTATE)) {
|                         ...
|                 } else {
|                         fpsimd_to_sve(current);
|                         current->thread.fp_type = FP_STATE_SVE;
|                 }
|         }
|
|         put_cpu_fpsimd_context();
|
|         // Preempted; migrated from CPU 1 to CPU 0.
|         // task->fpsimd_cpu is still 0
|         // If per_cpu_ptr(&fpsimd_last_state, 0) is still task then:
|         // - Stale HW state is reused (with SVE traps enabled)
|         // - TIF_FOREIGN_FPSTATE is cleared
|         // - A return to userspace skips HW state restore
| }

Fix the case where the state is not live and TIF_FOREIGN_FPSTATE is set
by calling fpsimd_flush_task_state() to detach from the saved CPU
state. This ensures that a subsequent context switch will not reuse the
stale CPU state, and will instead set TIF_FOREIGN_FPSTATE, forcing the
new state to be reloaded from memory prior to a return to userspace.

Fixes: cccb78ce89c4 ("arm64/sve: Rework SVE access trap to convert state in registers")
Reported-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20241030-arm64-fpsimd-foreign-flush-v1-1-bd7bd66905a2@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/fpsimd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1445,6 +1445,7 @@ static void sve_init_regs(void)
 	} else {
 		fpsimd_to_sve(current);
 		current->thread.fp_type = FP_STATE_SVE;
+		fpsimd_flush_task_state(current);
 	}
 }
 


