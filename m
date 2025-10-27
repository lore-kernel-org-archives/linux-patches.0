Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDAC1BC4E;
	Mon, 27 Oct 2025 19:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593246; cv=none; b=NtzA0uz8l6Ngibx1xnBqSiUx3epWu4q8fRhwc1UIWNKYusuGzXnz8Vyu9GYWOxsQ87R00ZVqgHQIqVlX8kdjsIaB1MT/y5UFF8gff3PGO4oEOV+VNRO7K+FhPEgQRRhdd0cgiUk0pPFClCIt9xu3zIhWxSGlbw5h04isn9HNsDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593246; c=relaxed/simple;
	bh=XPcAxNMJ6NsmtceC3Oj5tQzI34eN7HkTYoxVtb8MJI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DqZsiQeA3C/w9hoSxZvAX6U7prlMfrYpJ7lAfwmanrCVxTA4O+c2UZHn72WvXcFFesC+Fy0Y3vDZ1BBs27JtDHu5LhFPpz/1PeVcCpAYYrPqWieolANUWvjA9K7/xlSKJs1dMwS50CWx8C/C+iDs50aB0aoCYnc50R3cq05eMOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yh6LGTry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yh6LGTry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62BB3C4CEF1;
	Mon, 27 Oct 2025 19:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593246;
	bh=XPcAxNMJ6NsmtceC3Oj5tQzI34eN7HkTYoxVtb8MJI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yh6LGTry+ksHal2+tml4QHkysreGP/huefQezDepnGCbKUzpMqF7M+VUi48n+v5hs
	 bLLKopZXXSvgDGSNThbFJ4pwczTJ+58dOtiaoBRHW9NBi/kGqsuE9zI17nLZQzVr8I
	 MaYwYKXFwln5Ezd2J1dk8rdLuTBLQMvf4AoqJCI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tsukasa OI <research_trasio@irq.a4lg.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Olof Johansson <olof@lixom.net>,
	Jingwei Wang <wangjingwei@iscas.ac.cn>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.17 068/184] riscv: hwprobe: Fix stale vDSO data for late-initialized keys at boot
Date: Mon, 27 Oct 2025 19:35:50 +0100
Message-ID: <20251027183516.720763341@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

From: Jingwei Wang <wangjingwei@iscas.ac.cn>

commit 5d15d2ad36b0f7afab83ca9fc8a2a6e60cbe54c4 upstream.

The hwprobe vDSO data for some keys, like MISALIGNED_VECTOR_PERF,
is determined by an asynchronous kthread. This can create a race
condition where the kthread finishes after the vDSO data has
already been populated, causing userspace to read stale values.

To fix this race, a new 'ready' flag is added to the vDSO data,
initialized to 'false' during arch_initcall_sync. This flag is
checked by both the vDSO's user-space code and the riscv_hwprobe
syscall. The syscall serves as a one-time gate, using a completion
to wait for any pending probes before populating the data and
setting the flag to 'true', thus ensuring userspace reads fresh
values on its first request.

Reported-by: Tsukasa OI <research_trasio@irq.a4lg.com>
Closes: https://lore.kernel.org/linux-riscv/760d637b-b13b-4518-b6bf-883d55d44e7f@irq.a4lg.com/
Fixes: e7c9d66e313b ("RISC-V: Report vector unaligned access speed hwprobe")
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: stable@vger.kernel.org
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Co-developed-by: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Jingwei Wang <wangjingwei@iscas.ac.cn>
Link: https://lore.kernel.org/r/20250811142035.105820-1-wangjingwei@iscas.ac.cn
[pjw@kernel.org: fix checkpatch issues]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/hwprobe.h           |    7 ++
 arch/riscv/include/asm/vdso/arch_data.h    |    6 ++
 arch/riscv/kernel/sys_hwprobe.c            |   70 ++++++++++++++++++++++++-----
 arch/riscv/kernel/unaligned_access_speed.c |    9 ++-
 arch/riscv/kernel/vdso/hwprobe.c           |    2 
 5 files changed, 79 insertions(+), 15 deletions(-)

--- a/arch/riscv/include/asm/hwprobe.h
+++ b/arch/riscv/include/asm/hwprobe.h
@@ -41,4 +41,11 @@ static inline bool riscv_hwprobe_pair_cm
 	return pair->value == other_pair->value;
 }
 
+#ifdef CONFIG_MMU
+void riscv_hwprobe_register_async_probe(void);
+void riscv_hwprobe_complete_async_probe(void);
+#else
+static inline void riscv_hwprobe_register_async_probe(void) {}
+static inline void riscv_hwprobe_complete_async_probe(void) {}
+#endif
 #endif
--- a/arch/riscv/include/asm/vdso/arch_data.h
+++ b/arch/riscv/include/asm/vdso/arch_data.h
@@ -12,6 +12,12 @@ struct vdso_arch_data {
 
 	/* Boolean indicating all CPUs have the same static hwprobe values. */
 	__u8 homogeneous_cpus;
+
+	/*
+	 * A gate to check and see if the hwprobe data is actually ready, as
+	 * probing is deferred to avoid boot slowdowns.
+	 */
+	__u8 ready;
 };
 
 #endif /* __RISCV_ASM_VDSO_ARCH_DATA_H */
--- a/arch/riscv/kernel/sys_hwprobe.c
+++ b/arch/riscv/kernel/sys_hwprobe.c
@@ -5,6 +5,9 @@
  * more details.
  */
 #include <linux/syscalls.h>
+#include <linux/completion.h>
+#include <linux/atomic.h>
+#include <linux/once.h>
 #include <asm/cacheflush.h>
 #include <asm/cpufeature.h>
 #include <asm/hwprobe.h>
@@ -450,28 +453,32 @@ static int hwprobe_get_cpus(struct riscv
 	return 0;
 }
 
-static int do_riscv_hwprobe(struct riscv_hwprobe __user *pairs,
-			    size_t pair_count, size_t cpusetsize,
-			    unsigned long __user *cpus_user,
-			    unsigned int flags)
-{
-	if (flags & RISCV_HWPROBE_WHICH_CPUS)
-		return hwprobe_get_cpus(pairs, pair_count, cpusetsize,
-					cpus_user, flags);
+#ifdef CONFIG_MMU
 
-	return hwprobe_get_values(pairs, pair_count, cpusetsize,
-				  cpus_user, flags);
+static DECLARE_COMPLETION(boot_probes_done);
+static atomic_t pending_boot_probes = ATOMIC_INIT(1);
+
+void riscv_hwprobe_register_async_probe(void)
+{
+	atomic_inc(&pending_boot_probes);
 }
 
-#ifdef CONFIG_MMU
+void riscv_hwprobe_complete_async_probe(void)
+{
+	if (atomic_dec_and_test(&pending_boot_probes))
+		complete(&boot_probes_done);
+}
 
-static int __init init_hwprobe_vdso_data(void)
+static int complete_hwprobe_vdso_data(void)
 {
 	struct vdso_arch_data *avd = vdso_k_arch_data;
 	u64 id_bitsmash = 0;
 	struct riscv_hwprobe pair;
 	int key;
 
+	if (unlikely(!atomic_dec_and_test(&pending_boot_probes)))
+		wait_for_completion(&boot_probes_done);
+
 	/*
 	 * Initialize vDSO data with the answers for the "all CPUs" case, to
 	 * save a syscall in the common case.
@@ -499,13 +506,52 @@ static int __init init_hwprobe_vdso_data
 	 * vDSO should defer to the kernel for exotic cpu masks.
 	 */
 	avd->homogeneous_cpus = id_bitsmash != 0 && id_bitsmash != -1;
+
+	/*
+	 * Make sure all the VDSO values are visible before we look at them.
+	 * This pairs with the implicit "no speculativly visible accesses"
+	 * barrier in the VDSO hwprobe code.
+	 */
+	smp_wmb();
+	avd->ready = true;
+	return 0;
+}
+
+static int __init init_hwprobe_vdso_data(void)
+{
+	struct vdso_arch_data *avd = vdso_k_arch_data;
+
+	/*
+	 * Prevent the vDSO cached values from being used, as they're not ready
+	 * yet.
+	 */
+	avd->ready = false;
 	return 0;
 }
 
 arch_initcall_sync(init_hwprobe_vdso_data);
 
+#else
+
+static int complete_hwprobe_vdso_data(void) { return 0; }
+
 #endif /* CONFIG_MMU */
 
+static int do_riscv_hwprobe(struct riscv_hwprobe __user *pairs,
+			    size_t pair_count, size_t cpusetsize,
+			    unsigned long __user *cpus_user,
+			    unsigned int flags)
+{
+	DO_ONCE_SLEEPABLE(complete_hwprobe_vdso_data);
+
+	if (flags & RISCV_HWPROBE_WHICH_CPUS)
+		return hwprobe_get_cpus(pairs, pair_count, cpusetsize,
+					cpus_user, flags);
+
+	return hwprobe_get_values(pairs, pair_count, cpusetsize,
+				cpus_user, flags);
+}
+
 SYSCALL_DEFINE5(riscv_hwprobe, struct riscv_hwprobe __user *, pairs,
 		size_t, pair_count, size_t, cpusetsize, unsigned long __user *,
 		cpus, unsigned int, flags)
--- a/arch/riscv/kernel/unaligned_access_speed.c
+++ b/arch/riscv/kernel/unaligned_access_speed.c
@@ -379,6 +379,7 @@ free:
 static int __init vec_check_unaligned_access_speed_all_cpus(void *unused __always_unused)
 {
 	schedule_on_each_cpu(check_vector_unaligned_access);
+	riscv_hwprobe_complete_async_probe();
 
 	return 0;
 }
@@ -473,8 +474,12 @@ static int __init check_unaligned_access
 			per_cpu(vector_misaligned_access, cpu) = unaligned_vector_speed_param;
 	} else if (!check_vector_unaligned_access_emulated_all_cpus() &&
 		   IS_ENABLED(CONFIG_RISCV_PROBE_VECTOR_UNALIGNED_ACCESS)) {
-		kthread_run(vec_check_unaligned_access_speed_all_cpus,
-			    NULL, "vec_check_unaligned_access_speed_all_cpus");
+		riscv_hwprobe_register_async_probe();
+		if (IS_ERR(kthread_run(vec_check_unaligned_access_speed_all_cpus,
+				       NULL, "vec_check_unaligned_access_speed_all_cpus"))) {
+			pr_warn("Failed to create vec_unalign_check kthread\n");
+			riscv_hwprobe_complete_async_probe();
+		}
 	}
 
 	/*
--- a/arch/riscv/kernel/vdso/hwprobe.c
+++ b/arch/riscv/kernel/vdso/hwprobe.c
@@ -27,7 +27,7 @@ static int riscv_vdso_get_values(struct
 	 * homogeneous, then this function can handle requests for arbitrary
 	 * masks.
 	 */
-	if ((flags != 0) || (!all_cpus && !avd->homogeneous_cpus))
+	if (flags != 0 || (!all_cpus && !avd->homogeneous_cpus) || unlikely(!avd->ready))
 		return riscv_hwprobe(pairs, pair_count, cpusetsize, cpus, flags);
 
 	/* This is something we can handle, fill out the pairs. */


