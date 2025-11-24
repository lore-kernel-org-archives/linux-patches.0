Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E5C2F0681;
	Mon, 24 Nov 2025 08:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763971640; cv=none; b=ZkchMTc3kbG0ucgsONWTo0RH8jZP5fosloTpanxJ5WrowFFBL1gKwgj0WzReVfvfaFVnZdk32bwQu4n74gprDy8+qmfps639fXghn9GfCmEjYhsLUuVGDn4fDDXEciPGlynKN0QAwa05j2SC52AYNb/taQnHryF4k9hSPPNed1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763971640; c=relaxed/simple;
	bh=yW2KYTsA6eTWk08ID+yei6Fu893QyI7zhdL5JaWXyYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZk5ovTX5k1hxlTJzJkPnW7j7Y9efEJ8vIOIGfOPmRx9jOiNHVwjEfZfmPb2KzJinDw+tcFV2OnLe+9s1xK4ezZD1dEkDzQ5jO3n4YAZnKaz2kY6kd1ZvzveLbQY3FMPAj3LKeYDd/OVviYCK4QDWEqdHKXxET4IDtYgNjfeuBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FY+91fKy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FY+91fKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28818C4CEF1;
	Mon, 24 Nov 2025 08:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763971640;
	bh=yW2KYTsA6eTWk08ID+yei6Fu893QyI7zhdL5JaWXyYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FY+91fKyMtU7mdjLa4njIj720ef63oAHRbDxDuF+F6iQLv68UwLfTifqJ/CuSkm8N
	 f9jRKZiXwFLVkzMrUydKsW4CJ/+tfBV+0+ZnkCTLM5keqiKbgwoBW9IWkkEL2S5HLp
	 Oe2gnmEyPkCfohUvjjel1riqaOMtExjELdP9Qv1eFMQS8u/ahNB0Nw9hpRzVqnTQvL
	 XmwoiEOAOSzhfVk/ITaUd2w9Y6ZyIxXf0xeREvOGX3IyQl7nIWu9xJI+SGM8Toow7/
	 Dar0WF1K/gkZlGE4zkkqfEvLFslmP3ElQKVQkBSwPYAY6rgPRpdPZSyyvUImaY4e8q
	 xMfwOACdVyNLw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Huacai Chen <chenhuacai@loongson.cn>,
	Tianyang Zhang <zhangtianyang@loongson.cn>,
	Sasha Levin <sashal@kernel.org>,
	chenhuacai@kernel.org,
	maqianga@uniontech.com,
	alexander.deucher@amd.com,
	tangyouling@kylinos.cn,
	alexandre.f.demers@gmail.com,
	yangtiezhu@loongson.cn
Subject: [PATCH AUTOSEL 6.17-6.1] LoongArch: Mask all interrupts during kexec/kdump
Date: Mon, 24 Nov 2025 03:06:33 -0500
Message-ID: <20251124080644.3871678-19-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251124080644.3871678-1-sashal@kernel.org>
References: <20251124080644.3871678-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.8
Content-Transfer-Encoding: 8bit

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 863a320dc6fd7c855f47da4bb82a8de2d9102ea2 ]

If the default state of the interrupt controllers in the first kernel
don't mask any interrupts, it may cause the second kernel to potentially
receive interrupts (which were previously allocated by the first kernel)
immediately after a CPU becomes online during its boot process. These
interrupts cannot be properly routed, leading to bad IRQ issues.

This patch calls machine_kexec_mask_interrupts() to mask all interrupts
during the kexec/kdump process.

Signed-off-by: Tianyang Zhang <zhangtianyang@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Comprehensive Analysis

### 1. Commit Message and Problem Analysis
The commit addresses a significant reliability issue in the LoongArch
architecture's kexec (soft reboot) and kdump (crash dump) mechanisms.
- **Problem:** When transitioning from the current kernel to a new one
  (either via kexec or panic-induced kdump), the interrupt controllers
  are not being properly masked. This allows interrupts from the old
  kernel to fire immediately as the new kernel boots, before it is ready
  to handle them. This results in "bad IRQ" errors, spurious interrupts,
  and potentially failed crash dumps.
- **Solution:** The patch introduces calls to
  `machine_kexec_mask_interrupts()` in the shutdown paths. This function
  iterates through active interrupts and masks them at the controller
  level, ensuring a clean, quiescent state for the incoming kernel.
- **Context:** This aligns LoongArch with other architectures (ARM64,
  RISC-V, PowerPC) where this masking is already standard practice.

### 2. Code Research and Validation
- **Mechanism:** The fix adds two function calls: one in
  `machine_kexec()` (standard path) and one in
  `machine_crash_shutdown()` (crash path).
- **Dependencies & Backporting Complexity:**
    - The function `machine_kexec_mask_interrupts()` is a standard
      helper. However, it was consolidated into the generic
      `kernel/irq/kexec.c` in kernel versions around v6.14 (approx. Dec
      2024).
    - **For recent stable kernels (e.g., 6.14+):** The patch should
      apply cleanly as the generic symbol is available.
    - **For older LTS kernels (e.g., 6.1.y, 6.6.y, 6.12.y):** The
      generic helper likely does not exist. Backporting to these trees
      will require a slight modification to include a local
      implementation of `machine_kexec_mask_interrupts()` within
      `arch/loongarch/kernel/machine_kexec.c`, similar to how ARM64 and
      RISC-V handled it prior to the consolidation. This is a standard
      procedure for architecture-specific fixes in stable.

### 3. Stable Kernel Rules Assessment
- **Fixes a Real Bug:** Yes. The lack of interrupt masking causes race
  conditions and potential boot failures in the second kernel.
- **Important Severity:** High. Kdump is a critical feature for
  enterprise debugging. If kdump fails due to spurious IRQs, diagnosing
  the original system crash becomes impossible.
- **Small and Contained:** The logic change is minimal (masking
  interrupts).
- **No New Features:** This is a fix for existing, broken functionality.
- **Regression Risk:** Low. The system is shutting down; masking
  interrupts is the correct defensive posture.

### 4. Conclusion
This commit is an essential fix for LoongArch system reliability. It
corrects a deviation from standard kernel behavior that jeopardizes
crash recovery. While backporting to older long-term stable trees will
require handling the missing generic helper function (by adding a local
version), the fix itself is obviously correct and required.

**YES**

 arch/loongarch/kernel/machine_kexec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/loongarch/kernel/machine_kexec.c b/arch/loongarch/kernel/machine_kexec.c
index f9381800e291c..8ef4e4595d61a 100644
--- a/arch/loongarch/kernel/machine_kexec.c
+++ b/arch/loongarch/kernel/machine_kexec.c
@@ -249,6 +249,7 @@ void machine_crash_shutdown(struct pt_regs *regs)
 #ifdef CONFIG_SMP
 	crash_smp_send_stop();
 #endif
+	machine_kexec_mask_interrupts();
 	cpumask_set_cpu(crashing_cpu, &cpus_in_crash);
 
 	pr_info("Starting crashdump kernel...\n");
@@ -286,6 +287,7 @@ void machine_kexec(struct kimage *image)
 
 	/* We do not want to be bothered. */
 	local_irq_disable();
+	machine_kexec_mask_interrupts();
 
 	pr_notice("EFI boot flag 0x%lx\n", efi_boot);
 	pr_notice("Command line at 0x%lx\n", cmdline_ptr);
-- 
2.51.0

