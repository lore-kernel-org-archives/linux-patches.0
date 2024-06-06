Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA4419D08D;
	Thu,  6 Jun 2024 14:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683089; cv=none; b=MSUbZgJwiqviCPMYPdX0Y79ya7DLenYCUNL2VgLbY8195kb91Tc+ACPICFIOtCzi+hXtWxMIcFa3oGIelBDZjgS8vIgGzsrhfwhEFPNtRntle4gYhgoJ3PpnUtW0AF/muHNyY7g1QVfbpswMiwSfD4eEJ5RcyJ82yja55OQQsso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683089; c=relaxed/simple;
	bh=owqWxyCZ1oeiggLyQr+OaEYTfjwCDWiS3r8/s4D59KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LHNTu9VHmgV9c37a2wtUC/3GH/EFJ8uEjL2FuBOaUKGJ6XiAYFQwf8KlxW/a+GY96BQhO+PeA4/2Pp0Qs8ACbfnEESFvhG7DBiDN6GHn4AeuU4hCEXnMF9xgKC3EEuN3MP42IMYeyHmQygRI9sqqKhj9vnu0ey1zeF2TCjjmxFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4BdcqT3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4BdcqT3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBC6C32781;
	Thu,  6 Jun 2024 14:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683089;
	bh=owqWxyCZ1oeiggLyQr+OaEYTfjwCDWiS3r8/s4D59KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y4BdcqT3+fJUmWUdH9dp9eBTSAxT5U1DVHqolm9aYo7iNBalWe+b+71wZkCzYFw0h
	 RUMsu96H6wq5TjSVQNsl7v5OZ+0Ja61CJe7bDQF3jYxmGJ1AzVi0YLKeLnT37G2HEs
	 KDzWq27F9RtaR++CWqQbLnFagbNEASpvPgI6cXKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Schneider <pschneider1968@googlemail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.9 371/374] x86/topology/intel: Unlock CPUID before evaluating anything
Date: Thu,  6 Jun 2024 16:05:50 +0200
Message-ID: <20240606131704.313429144@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 0c2f6d04619ec2b53ad4b0b591eafc9389786e86 upstream.

Intel CPUs have a MSR bit to limit CPUID enumeration to leaf two. If
this bit is set by the BIOS then CPUID evaluation including topology
enumeration does not work correctly as the evaluation code does not try
to analyze any leaf greater than two.

This went unnoticed before because the original topology code just
repeated evaluation several times and managed to overwrite the initial
limited information with the correct one later. The new evaluation code
does it once and therefore ends up with the limited and wrong
information.

Cure this by unlocking CPUID right before evaluating anything which
depends on the maximum CPUID leaf being greater than two instead of
rereading stuff after unlock.

Fixes: 22d63660c35e ("x86/cpu: Use common topology code for Intel")
Reported-by: Peter Schneider <pschneider1968@googlemail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Peter Schneider <pschneider1968@googlemail.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/fd3f73dc-a86f-4bcf-9c60-43556a21eb42@googlemail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/common.c |    3 ++-
 arch/x86/kernel/cpu/cpu.h    |    2 ++
 arch/x86/kernel/cpu/intel.c  |   25 ++++++++++++++++---------
 3 files changed, 20 insertions(+), 10 deletions(-)

--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1589,6 +1589,7 @@ static void __init early_identify_cpu(st
 	if (have_cpuid_p()) {
 		cpu_detect(c);
 		get_cpu_vendor(c);
+		intel_unlock_cpuid_leafs(c);
 		get_cpu_cap(c);
 		setup_force_cpu_cap(X86_FEATURE_CPUID);
 		get_cpu_address_sizes(c);
@@ -1748,7 +1749,7 @@ static void generic_identify(struct cpui
 	cpu_detect(c);
 
 	get_cpu_vendor(c);
-
+	intel_unlock_cpuid_leafs(c);
 	get_cpu_cap(c);
 
 	get_cpu_address_sizes(c);
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -61,9 +61,11 @@ extern __ro_after_init enum tsx_ctrl_sta
 
 extern void __init tsx_init(void);
 void tsx_ap_init(void);
+void intel_unlock_cpuid_leafs(struct cpuinfo_x86 *c);
 #else
 static inline void tsx_init(void) { }
 static inline void tsx_ap_init(void) { }
+static inline void intel_unlock_cpuid_leafs(struct cpuinfo_x86 *c) { }
 #endif /* CONFIG_CPU_SUP_INTEL */
 
 extern void init_spectral_chicken(struct cpuinfo_x86 *c);
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -268,19 +268,26 @@ detect_keyid_bits:
 	c->x86_phys_bits -= keyid_bits;
 }
 
+void intel_unlock_cpuid_leafs(struct cpuinfo_x86 *c)
+{
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
+		return;
+
+	if (c->x86 < 6 || (c->x86 == 6 && c->x86_model < 0xd))
+		return;
+
+	/*
+	 * The BIOS can have limited CPUID to leaf 2, which breaks feature
+	 * enumeration. Unlock it and update the maximum leaf info.
+	 */
+	if (msr_clear_bit(MSR_IA32_MISC_ENABLE, MSR_IA32_MISC_ENABLE_LIMIT_CPUID_BIT) > 0)
+		c->cpuid_level = cpuid_eax(0);
+}
+
 static void early_init_intel(struct cpuinfo_x86 *c)
 {
 	u64 misc_enable;
 
-	/* Unmask CPUID levels if masked: */
-	if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
-		if (msr_clear_bit(MSR_IA32_MISC_ENABLE,
-				  MSR_IA32_MISC_ENABLE_LIMIT_CPUID_BIT) > 0) {
-			c->cpuid_level = cpuid_eax(0);
-			get_cpu_cap(c);
-		}
-	}
-
 	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
 		(c->x86 == 0x6 && c->x86_model >= 0x0e))
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);


