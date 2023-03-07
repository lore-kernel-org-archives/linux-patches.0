Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C92BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6A7C433D2;
	Tue,  7 Mar 2023 18:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214999;
	bh=0gTlL293W3X5WsPp8H8A+jodvvwPCdfxz5yJJN363DM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tsG1M6ap+Jfm9cwN8yOaFm+pxy/TcScYHnDoKXlMc9zqM1GzAXVFkfu5q5dYww9mF
	 ekmUNRXGv7pHOVS7p/BOwLdzKx4FVUJ5kr1Mw+nEW+ORpEyY/fAKmuf7FN2VbTJP8v
	 BX95S7yO4egxaHJW7pY7+Jj5LcrYoWshEWg2X+J8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashok Raj <ashok.raj@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/567] x86/microcode: Add a parameter to microcode_check() to store CPU capabilities
Date: Tue,  7 Mar 2023 17:57:33 +0100
Message-Id: <20230307165910.972103740@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ashok Raj <ashok.raj@intel.com>

[ Upstream commit ab31c74455c64e69342ddab21fd9426fcbfefde7 ]

Add a parameter to store CPU capabilities before performing a microcode
update so that CPU capabilities can be compared before and after update.

  [ bp: Massage. ]

Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230109153555.4986-2-ashok.raj@intel.com
Stable-dep-of: c0dd9245aa9e ("x86/microcode: Check CPU capabilities after late microcode update correctly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/processor.h     |  2 +-
 arch/x86/kernel/cpu/common.c         | 21 +++++++++++++--------
 arch/x86/kernel/cpu/microcode/core.c |  3 ++-
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 5c7904c97a1a7..eb6d6d1057929 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -835,7 +835,7 @@ bool xen_set_default_idle(void);
 #endif
 
 void __noreturn stop_this_cpu(void *dummy);
-void microcode_check(void);
+void microcode_check(struct cpuinfo_x86 *prev_info);
 
 enum l1tf_mitigations {
 	L1TF_MITIGATION_OFF,
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 6b71f40cd52d6..f2cd244d31311 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2150,30 +2150,35 @@ void cpu_init_secondary(void)
 #endif
 
 #ifdef CONFIG_MICROCODE_LATE_LOADING
-/*
+/**
+ * microcode_check() - Check if any CPU capabilities changed after an update.
+ * @prev_info:	CPU capabilities stored before an update.
+ *
  * The microcode loader calls this upon late microcode load to recheck features,
  * only when microcode has been updated. Caller holds microcode_mutex and CPU
  * hotplug lock.
+ *
+ * Return: None
  */
-void microcode_check(void)
+void microcode_check(struct cpuinfo_x86 *prev_info)
 {
-	struct cpuinfo_x86 info;
-
 	perf_check_microcode();
 
 	/* Reload CPUID max function as it might've changed. */
-	info.cpuid_level = cpuid_eax(0);
+	prev_info->cpuid_level = cpuid_eax(0);
 
 	/*
 	 * Copy all capability leafs to pick up the synthetic ones so that
 	 * memcmp() below doesn't fail on that. The ones coming from CPUID will
 	 * get overwritten in get_cpu_cap().
 	 */
-	memcpy(&info.x86_capability, &boot_cpu_data.x86_capability, sizeof(info.x86_capability));
+	memcpy(&prev_info->x86_capability, &boot_cpu_data.x86_capability,
+	       sizeof(prev_info->x86_capability));
 
-	get_cpu_cap(&info);
+	get_cpu_cap(prev_info);
 
-	if (!memcmp(&info.x86_capability, &boot_cpu_data.x86_capability, sizeof(info.x86_capability)))
+	if (!memcmp(&prev_info->x86_capability, &boot_cpu_data.x86_capability,
+		    sizeof(prev_info->x86_capability)))
 		return;
 
 	pr_warn("x86/CPU: CPU features have changed after loading microcode, but might not take effect.\n");
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index a7fc2d47a4ace..9592dbf628b43 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -509,13 +509,14 @@ static int __reload_late(void *info)
 static int microcode_reload_late(void)
 {
 	int old = boot_cpu_data.microcode, ret;
+	struct cpuinfo_x86 prev_info;
 
 	atomic_set(&late_cpus_in,  0);
 	atomic_set(&late_cpus_out, 0);
 
 	ret = stop_machine_cpuslocked(__reload_late, NULL, cpu_online_mask);
 	if (ret == 0)
-		microcode_check();
+		microcode_check(&prev_info);
 
 	pr_info("Reload completed, microcode revision: 0x%x -> 0x%x\n",
 		old, boot_cpu_data.microcode);
-- 
2.39.2



