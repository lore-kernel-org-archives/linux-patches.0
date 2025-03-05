Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9E21C860D;
	Wed,  5 Mar 2025 18:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197824; cv=none; b=PWA3pLteN5VMO2c8iP6Xmg13tg6ygdtiip6Cpy60jMy2ZuRhxFv34qvgU5a9h4QD2d/gN4AN18u8rxDYe6ZdqxnNHWpnju+Pt+xPo9IxemSNtnJeuu+zv0WSaHO3Bsl1zvrWa0DXU8K/mVTNiEPVTKTcSt1LRhhQ1LGL5n2QeY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197824; c=relaxed/simple;
	bh=Yzozj5lnCJmHNM5jU06kOdQ9hhqZvdi3PAhzGIuvZ5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uO35eRBRc0mGKQOPmmDbMFgmWN1cZqTcBQjab6BnYrVeQ8oQsupePiaKkDYB20R3BOkDw4CMTb40peEZZG7aE8SBf//2BZ1LeupDNDTHAvxUNxifWhhaYmaDAwH9KD9SfM9FK3mAiaMzZhquikmmullgv1Wl+9Ts+cXcoNQR0ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LenJHAiL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LenJHAiL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1895EC4CEE0;
	Wed,  5 Mar 2025 18:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197823;
	bh=Yzozj5lnCJmHNM5jU06kOdQ9hhqZvdi3PAhzGIuvZ5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LenJHAiLd6H2kgfAM5h5/ULWMCD4hT1GOUk4eWE+ZMUKMT0ks1Rf9oFCRSynDfvOC
	 8JiGTAM35aKtWZzS/Cr9c9i5gRRpwCHbgPO99IB2nQQdLVqqej82EOWsvSD8vuTpHl
	 T28zd53e2ah33yizaHd2uIvj1n7FlInnJwZtyoWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 113/142] x86/microcode/amd: Use cached microcode for AP load
Date: Wed,  5 Mar 2025 18:48:52 +0100
Message-ID: <20250305174504.868058881@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 5af05b8d51a8e3ff5905663655c0f46d1aaae44a upstream

Now that the microcode cache is initialized before the APs are brought
up, there is no point in scanning builtin/initrd microcode during AP
loading.

Convert the AP loader to utilize the cache, which in turn makes the CPU
hotplug callback which applies the microcode after initrd/builtin is
gone, obsolete as the early loading during late hotplug operations
including the resume path depends now only on the cache.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20231017211723.243426023@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c      |   20 +++++++++++---------
 arch/x86/kernel/cpu/microcode/core.c     |   15 ++-------------
 arch/x86/kernel/cpu/microcode/internal.h |    2 --
 3 files changed, 13 insertions(+), 24 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -496,7 +496,7 @@ static bool get_builtin_microcode(struct
 	return false;
 }
 
-static void find_blobs_in_containers(unsigned int cpuid_1_eax, struct cpio_data *ret)
+static void __init find_blobs_in_containers(unsigned int cpuid_1_eax, struct cpio_data *ret)
 {
 	struct cpio_data cp;
 
@@ -506,12 +506,12 @@ static void find_blobs_in_containers(uns
 	*ret = cp;
 }
 
-static void apply_ucode_from_containers(unsigned int cpuid_1_eax)
+void __init load_ucode_amd_bsp(unsigned int cpuid_1_eax)
 {
 	struct cpio_data cp = { };
 
 	/* Needed in load_microcode_amd() */
-	ucode_cpu_info[smp_processor_id()].cpu_sig.sig = cpuid_1_eax;
+	ucode_cpu_info[0].cpu_sig.sig = cpuid_1_eax;
 
 	find_blobs_in_containers(cpuid_1_eax, &cp);
 	if (!(cp.data && cp.size))
@@ -520,11 +520,6 @@ static void apply_ucode_from_containers(
 	early_apply_microcode(cpuid_1_eax, cp.data, cp.size);
 }
 
-void load_ucode_amd_early(unsigned int cpuid_1_eax)
-{
-	return apply_ucode_from_containers(cpuid_1_eax);
-}
-
 static enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size);
 
 static int __init save_microcode_in_initrd(void)
@@ -608,7 +603,6 @@ static struct ucode_patch *find_patch(un
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	u16 equiv_id;
 
-
 	equiv_id = find_equiv_id(&equiv_table, uci->cpu_sig.sig);
 	if (!equiv_id)
 		return NULL;
@@ -710,6 +704,14 @@ out:
 	return ret;
 }
 
+void load_ucode_amd_ap(unsigned int cpuid_1_eax)
+{
+	unsigned int cpu = smp_processor_id();
+
+	ucode_cpu_info[cpu].cpu_sig.sig = cpuid_1_eax;
+	apply_microcode_amd(cpu);
+}
+
 static size_t install_equiv_cpu_table(const u8 *buf, size_t buf_size)
 {
 	u32 equiv_tbl_len;
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -154,7 +154,7 @@ void __init load_ucode_bsp(void)
 	if (intel)
 		load_ucode_intel_bsp();
 	else
-		load_ucode_amd_early(cpuid_1_eax);
+		load_ucode_amd_bsp(cpuid_1_eax);
 }
 
 void load_ucode_ap(void)
@@ -173,7 +173,7 @@ void load_ucode_ap(void)
 		break;
 	case X86_VENDOR_AMD:
 		if (x86_family(cpuid_1_eax) >= 0x10)
-			load_ucode_amd_early(cpuid_1_eax);
+			load_ucode_amd_ap(cpuid_1_eax);
 		break;
 	default:
 		break;
@@ -494,15 +494,6 @@ static struct syscore_ops mc_syscore_ops
 	.resume	= microcode_bsp_resume,
 };
 
-static int mc_cpu_starting(unsigned int cpu)
-{
-	enum ucode_state err = microcode_ops->apply_microcode(cpu);
-
-	pr_debug("%s: CPU%d, err: %d\n", __func__, cpu, err);
-
-	return err == UCODE_ERROR;
-}
-
 static int mc_cpu_online(unsigned int cpu)
 {
 	struct device *dev = get_cpu_device(cpu);
@@ -590,8 +581,6 @@ static int __init microcode_init(void)
 	schedule_on_each_cpu(setup_online_cpu);
 
 	register_syscore_ops(&mc_syscore_ops);
-	cpuhp_setup_state_nocalls(CPUHP_AP_MICROCODE_LOADER, "x86/microcode:starting",
-				  mc_cpu_starting, NULL);
 	cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN, "x86/microcode:online",
 				  mc_cpu_online, mc_cpu_down_prep);
 
--- a/arch/x86/kernel/cpu/microcode/internal.h
+++ b/arch/x86/kernel/cpu/microcode/internal.h
@@ -91,7 +91,6 @@ extern bool initrd_gone;
 #ifdef CONFIG_CPU_SUP_AMD
 void load_ucode_amd_bsp(unsigned int family);
 void load_ucode_amd_ap(unsigned int family);
-void load_ucode_amd_early(unsigned int cpuid_1_eax);
 int save_microcode_in_initrd_amd(unsigned int family);
 void reload_ucode_amd(unsigned int cpu);
 struct microcode_ops *init_amd_microcode(void);
@@ -99,7 +98,6 @@ void exit_amd_microcode(void);
 #else /* CONFIG_CPU_SUP_AMD */
 static inline void load_ucode_amd_bsp(unsigned int family) { }
 static inline void load_ucode_amd_ap(unsigned int family) { }
-static inline void load_ucode_amd_early(unsigned int family) { }
 static inline int save_microcode_in_initrd_amd(unsigned int family) { return -EINVAL; }
 static inline void reload_ucode_amd(unsigned int cpu) { }
 static inline struct microcode_ops *init_amd_microcode(void) { return NULL; }


