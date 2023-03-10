Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40858820
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305B8C433EF;
	Fri, 10 Mar 2023 14:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459738;
	bh=3axzQABghvmE2Q0uMqGPD8yZEbETNwKXLkjkyXorML4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P8aBzv+NfWQAOcoho0fzwVt8OC7e1JL6JNy2xoC0HqTkV1MEArhHRMEwLhlA7Ut5q
	 xU4ohKngDT0vyUDZsyrWW6pA9swvBWmZi8DdrCaV6j0wRlG6CmLZcdvCDBetKhQ1Vp
	 Tq2F3OntA5rCJB7JwetYztldUqZjs5QcPZH3skio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Borislav Petkov <bp@suse.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/529] x86/microcode: Default-disable late loading
Date: Fri, 10 Mar 2023 14:34:06 +0100
Message-Id: <20230310133809.747158423@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Borislav Petkov <bp@suse.de>

[ Upstream commit a77a94f86273ce42a39cb479217dd8d68acfe0ff ]

It is dangerous and it should not be used anyway - there's a nice early
loading already.

Requested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20220525161232.14924-3-bp@alien8.de
Stable-dep-of: c0dd9245aa9e ("x86/microcode: Check CPU capabilities after late microcode update correctly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Kconfig                     | 11 +++++++++++
 arch/x86/kernel/cpu/common.c         |  2 ++
 arch/x86/kernel/cpu/microcode/core.c |  7 ++++++-
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1f55fc6470371..2284666e8c90c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1329,6 +1329,17 @@ config MICROCODE_AMD
 	  If you select this option, microcode patch loading support for AMD
 	  processors will be enabled.
 
+config MICROCODE_LATE_LOADING
+	bool "Late microcode loading (DANGEROUS)"
+	default n
+	depends on MICROCODE
+	help
+	  Loading microcode late, when the system is up and executing instructions
+	  is a tricky business and should be avoided if possible. Just the sequence
+	  of synchronizing all cores and SMT threads is one fragile dance which does
+	  not guarantee that cores might not softlock after the loading. Therefore,
+	  use this at your own risk. Late loading taints the kernel too.
+
 config X86_MSR
 	tristate "/dev/cpu/*/msr - Model-specific register support"
 	help
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4402589a1ee19..95f52540db378 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2129,6 +2129,7 @@ void cpu_init_secondary(void)
 }
 #endif
 
+#ifdef CONFIG_MICROCODE_LATE_LOADING
 /*
  * The microcode loader calls this upon late microcode load to recheck features,
  * only when microcode has been updated. Caller holds microcode_mutex and CPU
@@ -2158,6 +2159,7 @@ void microcode_check(void)
 	pr_warn("x86/CPU: CPU features have changed after loading microcode, but might not take effect.\n");
 	pr_warn("x86/CPU: Please consider either early loading through initrd/built-in or a potential BIOS update.\n");
 }
+#endif
 
 /*
  * Invoked from core CPU hotplug code after hotplug operations
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 8d8d7ee47e1ce..5b27030714e43 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -393,6 +393,7 @@ static int apply_microcode_on_target(int cpu)
 /* fake device for request_firmware */
 static struct platform_device	*microcode_pdev;
 
+#ifdef CONFIG_MICROCODE_LATE_LOADING
 /*
  * Late loading dance. Why the heavy-handed stomp_machine effort?
  *
@@ -560,6 +561,9 @@ static ssize_t reload_store(struct device *dev,
 	return ret;
 }
 
+static DEVICE_ATTR_WO(reload);
+#endif
+
 static ssize_t version_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
@@ -576,7 +580,6 @@ static ssize_t pf_show(struct device *dev,
 	return sprintf(buf, "0x%x\n", uci->cpu_sig.pf);
 }
 
-static DEVICE_ATTR_WO(reload);
 static DEVICE_ATTR(version, 0444, version_show, NULL);
 static DEVICE_ATTR(processor_flags, 0444, pf_show, NULL);
 
@@ -729,7 +732,9 @@ static int mc_cpu_down_prep(unsigned int cpu)
 }
 
 static struct attribute *cpu_root_microcode_attrs[] = {
+#ifdef CONFIG_MICROCODE_LATE_LOADING
 	&dev_attr_reload.attr,
+#endif
 	NULL
 };
 
-- 
2.39.2



