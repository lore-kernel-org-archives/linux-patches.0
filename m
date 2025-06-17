Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8924018E025;
	Tue, 17 Jun 2025 15:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175559; cv=none; b=Nt8gghJ/WIysWP6ieQd/WY+GJyLy8MDzwdXL3W5lZO53C0MYnt+nfu5ijLcxmGD7ot0HUzLS3H3JvVTdpuzZUtgkQe1zfm+my6P7C0MHvsuaqKk6aNeqL2aAHqtj/ngD+wxKPsqLWysVxekUykm8UM3xK1XR5j/xLpPCyBfs5RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175559; c=relaxed/simple;
	bh=rF6s4wzTZncY5X7BrsQQ0JNVzDnYvGUZxJuAyN4EqKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJbqKozt157GkPbRZU/53IoCehMa8KAhtvCHA2+lCxpNM5+h+8vO2qa+baVTbCcqc08wpjIoFINgXfScdWjszjqhBJNCVg1JmhhG7M1/ZM+UgkjNTpcua/V6RL53cs4stWmYINdiJxmWiKK5pFP2EBB+trMPDMmOFjjTT31lNY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tx1QV1y2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tx1QV1y2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932AFC4CEE3;
	Tue, 17 Jun 2025 15:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175559;
	bh=rF6s4wzTZncY5X7BrsQQ0JNVzDnYvGUZxJuAyN4EqKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tx1QV1y2Mhjsm0Urgf/eCc1cXWb7euDktCAULcwOIXJXF4m7eOj6oXE5NyS8Kv20o
	 b10xOkVBSo1EymSn/pqWBiowk9Uw+axXNhUxgzD98lKZrxeK/Jxbp2qAiB2/KxvG64
	 XO1RpPILVwPp8ciMBgZgWkj7QenBvGfWaKlTPMZs=
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
Subject: [PATCH 6.15 101/780] arm64/fpsimd: Discard stale CPU state when handling SME traps
Date: Tue, 17 Jun 2025 17:16:49 +0200
Message-ID: <20250617152455.623422112@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1ee5f330b8ed3..c92c0a08370b2 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1460,6 +1460,8 @@ void do_sme_acc(unsigned long esr, struct pt_regs *regs)
 		sme_set_vq(vq_minus_one);
 
 		fpsimd_bind_task_to_cpu();
+	} else {
+		fpsimd_flush_task_state(current);
 	}
 
 	put_cpu_fpsimd_context();
-- 
2.39.5



