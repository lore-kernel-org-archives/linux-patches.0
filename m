Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F9B81ADA;
	Tue,  3 Dec 2024 16:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242434; cv=none; b=ThQIOeooCU2opYw7UYaHrJ0pc4e6UjT3ncmF8VwgrE/L25+b6i4RLVdaXSEv0O0fo22yYykwvaJZuF8dMSW3V+DOyo3GqbauSBBVCb6jlgvBKfGYVpG4rBDlJXYP6GflpqiRYMsstOISK7K0Z5ozOaTKeBdvbhLoWfmaHMHOSUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242434; c=relaxed/simple;
	bh=ShaJTsgH2DFQ8MpWgHuuMfjoi1N4rdnWl+6Wb1LQpKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5yk4UvWRMoCqFaMy65sSax5uVCrbWVKJk0p7G1Icnff+WgFNVQi6a7xbrpu5xgPaMxrpnWDo+4qCf3MAD56DnSU0D6SI5h+3WYrODkk+h1UEwxARJZnEpPvlO8Fgu1aMl7eLM7g4pqsoaLUi23prXov4pad2ESiPGoT8zWzRas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DEUqFLi8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DEUqFLi8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BA0C4CECF;
	Tue,  3 Dec 2024 16:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242434;
	bh=ShaJTsgH2DFQ8MpWgHuuMfjoi1N4rdnWl+6Wb1LQpKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DEUqFLi8of0LJC/6QShUG69w4b3wbAc8rTVfOIfLWQpl+9+w4MqC7wf1sh3pxI5UG
	 /5m69G2cYQ6sp7xaZeyQZXP4fVEA0nZdwineMPStFsxmJefGi9i3C9C4oRVyqWzYb/
	 23AaPpbQ7h1c+A0Bm6m0JHjk/dJkbLi3LKfpAFkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Taube <jesse@rivosinc.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Evan Green <evan@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.12 702/826] RISC-V: Check scalar unaligned access on all CPUs
Date: Tue,  3 Dec 2024 15:47:09 +0100
Message-ID: <20241203144811.142026418@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Taube <jesse@rivosinc.com>

commit 8d20a739f17a2de9e269db72330f5655d6545dd4 upstream.

Originally, the check_unaligned_access_emulated_all_cpus function
only checked the boot hart. This fixes the function to check all
harts.

Fixes: 71c54b3d169d ("riscv: report misaligned accesses emulation to hwprobe")
Signed-off-by: Jesse Taube <jesse@rivosinc.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Reviewed-by: Evan Green <evan@rivosinc.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20241017-jesse_unaligned_vector-v10-1-5b33500160f8@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/cpufeature.h  |    2 ++
 arch/riscv/kernel/traps_misaligned.c |   14 +++++++-------
 2 files changed, 9 insertions(+), 7 deletions(-)

--- a/arch/riscv/include/asm/cpufeature.h
+++ b/arch/riscv/include/asm/cpufeature.h
@@ -8,6 +8,7 @@
 
 #include <linux/bitmap.h>
 #include <linux/jump_label.h>
+#include <linux/workqueue.h>
 #include <asm/hwcap.h>
 #include <asm/alternative-macros.h>
 #include <asm/errno.h>
@@ -60,6 +61,7 @@ void riscv_user_isa_enable(void);
 
 #if defined(CONFIG_RISCV_MISALIGNED)
 bool check_unaligned_access_emulated_all_cpus(void);
+void check_unaligned_access_emulated(struct work_struct *work __always_unused);
 void unaligned_emulation_finish(void);
 bool unaligned_ctl_available(void);
 DECLARE_PER_CPU(long, misaligned_access_speed);
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -524,11 +524,11 @@ int handle_misaligned_store(struct pt_re
 	return 0;
 }
 
-static bool check_unaligned_access_emulated(int cpu)
+void check_unaligned_access_emulated(struct work_struct *work __always_unused)
 {
+	int cpu = smp_processor_id();
 	long *mas_ptr = per_cpu_ptr(&misaligned_access_speed, cpu);
 	unsigned long tmp_var, tmp_val;
-	bool misaligned_emu_detected;
 
 	*mas_ptr = RISCV_HWPROBE_MISALIGNED_SCALAR_UNKNOWN;
 
@@ -536,19 +536,16 @@ static bool check_unaligned_access_emula
 		"       "REG_L" %[tmp], 1(%[ptr])\n"
 		: [tmp] "=r" (tmp_val) : [ptr] "r" (&tmp_var) : "memory");
 
-	misaligned_emu_detected = (*mas_ptr == RISCV_HWPROBE_MISALIGNED_SCALAR_EMULATED);
 	/*
 	 * If unaligned_ctl is already set, this means that we detected that all
 	 * CPUS uses emulated misaligned access at boot time. If that changed
 	 * when hotplugging the new cpu, this is something we don't handle.
 	 */
-	if (unlikely(unaligned_ctl && !misaligned_emu_detected)) {
+	if (unlikely(unaligned_ctl && (*mas_ptr != RISCV_HWPROBE_MISALIGNED_SCALAR_EMULATED))) {
 		pr_crit("CPU misaligned accesses non homogeneous (expected all emulated)\n");
 		while (true)
 			cpu_relax();
 	}
-
-	return misaligned_emu_detected;
 }
 
 bool check_unaligned_access_emulated_all_cpus(void)
@@ -560,8 +557,11 @@ bool check_unaligned_access_emulated_all
 	 * accesses emulated since tasks requesting such control can run on any
 	 * CPU.
 	 */
+	schedule_on_each_cpu(check_unaligned_access_emulated);
+
 	for_each_online_cpu(cpu)
-		if (!check_unaligned_access_emulated(cpu))
+		if (per_cpu(misaligned_access_speed, cpu)
+		    != RISCV_HWPROBE_MISALIGNED_SCALAR_EMULATED)
 			return false;
 
 	unaligned_ctl = true;


