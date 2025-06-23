Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBA1246BC9;
	Mon, 23 Jun 2025 13:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685946; cv=none; b=ZvHofkw+pwX+W6+zTI/8Wqhlnl/vBWlO6p3gLk1qKgs1N06FMS2rvSbEL1oMXru3mSgKqW7apBXUfOdo1P6R9XDfF7yM2unk7A6W7jK/y7sjDntrVjD4XHYL2fBIOKknlCtrJfQuSxAQ3F79GWbFG/plCIQLzmW8L04PWMNNHk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685946; c=relaxed/simple;
	bh=81IlkyopLFeubM1rvtIvsiitUEZMgv7se9R5iEXcz7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZ0TeNTfDPL/S8cnuC3laYAPhOwjo2EDMhRJKcLeWLqVSajMSu+FKB2nj9O7cFsEaYTr4Xj0yYynbWb28fbEsJw27vd3HheiWdmq6p+YFhO5jHOAUIFTivXUjnTsQVHG7a1GTCKeaPy0kQ693d+jOIWXoPM8Ldj9XKcKZ98e8q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pLyOM7az; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pLyOM7az"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA651C4CEEA;
	Mon, 23 Jun 2025 13:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685946;
	bh=81IlkyopLFeubM1rvtIvsiitUEZMgv7se9R5iEXcz7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLyOM7azNIqHN49yR6zrklxUhU/NTAV+GxoOGSZrRq3fY/ivyHLOrDB6iRpkjlD9r
	 yL+f1Jj5SOMIThV1qUuYFKfJZ8mPqkVcH5R/Wu/ErFUlDtCZwA2L41oJxfVTz125j9
	 aSEVTDRXZACEdnSZg1aUvMgEwJLBWysbm6SJFQac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/508] arm64/fpsimd: Discard stale CPU state when handling SME traps
Date: Mon, 23 Jun 2025 15:01:24 +0200
Message-ID: <20250623130646.207740530@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit d3eaab3c70905c5467e5c4ea403053d67505adeb ]

The logic for handling SME traps manipulates saved FPSIMD/SVE/SME state
incorrectly, and a race with preemption can result in a task having
TIF_SME set and TIF_FOREIGN_FPSTATE clear even though the live CPU state
is stale (e.g. with SME traps enabled). This can result in warnings from
do_sme_acc() where SME traps are not expected while TIF_SME is set:

|        /* With TIF_SME userspace shouldn't generate any traps */
|        if (test_and_set_thread_flag(TIF_SME))
|                WARN_ON(1);

This is very similar to the SVE issue we fixed in commit:

  751ecf6afd6568ad ("arm64/sve: Discard stale CPU state when handling SVE traps")

The race can occur when the SME trap handler is preempted before and
after manipulating the saved FPSIMD/SVE/SME state, starting and ending on
the same CPU, e.g.

| void do_sme_acc(unsigned long esr, struct pt_regs *regs)
| {
|         // Trap on CPU 0 with TIF_SME clear, SME traps enabled
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
|         /* With TIF_SME userspace shouldn't generate any traps */
|         if (test_and_set_thread_flag(TIF_SME))
|                 WARN_ON(1);
|
|         if (!test_thread_flag(TIF_FOREIGN_FPSTATE)) {
|                 unsigned long vq_minus_one =
|                         sve_vq_from_vl(task_get_sme_vl(current)) - 1;
|                 sme_set_vq(vq_minus_one);
|
|                 fpsimd_bind_task_to_cpu();
|         }
|
|         put_cpu_fpsimd_context();
|
|         // Preempted; migrated from CPU 1 to CPU 0.
|         // task->fpsimd_cpu is still 0
|         // If per_cpu_ptr(&fpsimd_last_state, 0) is still task then:
|         // - Stale HW state is reused (with SME traps enabled)
|         // - TIF_FOREIGN_FPSTATE is cleared
|         // - A return to userspace skips HW state restore
| }

Fix the case where the state is not live and TIF_FOREIGN_FPSTATE is set
by calling fpsimd_flush_task_state() to detach from the saved CPU
state. This ensures that a subsequent context switch will not reuse the
stale CPU state, and will instead set TIF_FOREIGN_FPSTATE, forcing the
new state to be reloaded from memory prior to a return to userspace.

Note: this was originallly posted as [1].

Fixes: 8bd7f91c03d8 ("arm64/sme: Implement traps and syscall handling for SME")
Reported-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/linux-arm-kernel/20241204-arm64-sme-reenable-v2-1-bae87728251d@kernel.org/
[ Rutland: rewrite commit message ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20250409164010.3480271-6-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/fpsimd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index b3e101a7d04f8..235131db8b8db 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1504,6 +1504,8 @@ void do_sme_acc(unsigned long esr, struct pt_regs *regs)
 		sme_set_vq(vq_minus_one);
 
 		fpsimd_bind_task_to_cpu();
+	} else {
+		fpsimd_flush_task_state(current);
 	}
 
 	put_cpu_fpsimd_context();
-- 
2.39.5



