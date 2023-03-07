Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D02ABA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:37:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6867C4339C;
	Tue,  7 Mar 2023 18:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214239;
	bh=rTIlHYI/iI+v0xj3VbTomCIKGeCu1HbSUkr20T77iLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1VDpE7D2zqJBLwgKQKjTBmNLPU5497nZ0UIpx+263SjwfZlS7gLIGMGr8t5j5flJI
	 aOTuaWaIJTKwnAS4b1IXoNJWPJiOBRUV+zF4Ebt09ogFKUzS2zLOMXDwNMT5eF1ikk
	 Mnv7NCLmKVtVxi3WwEomIyfIozqcZtux/BBp4ruA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 737/885] x86/microcode/AMD: Add a @cpu parameter to the reloading functions
Date: Tue,  7 Mar 2023 18:01:11 +0100
Message-Id: <20230307170033.976441247@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Borislav Petkov (AMD) <bp@alien8.de>

commit a5ad92134bd153a9ccdcddf09a95b088f36c3cce upstream.

Will be used in a subsequent change.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230130161709.11615-3-bp@alien8.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/microcode.h     |    4 ++--
 arch/x86/include/asm/microcode_amd.h |    4 ++--
 arch/x86/kernel/cpu/microcode/amd.c  |    2 +-
 arch/x86/kernel/cpu/microcode/core.c |    6 +++---
 4 files changed, 8 insertions(+), 8 deletions(-)

--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -127,13 +127,13 @@ static inline unsigned int x86_cpuid_fam
 #ifdef CONFIG_MICROCODE
 extern void __init load_ucode_bsp(void);
 extern void load_ucode_ap(void);
-void reload_early_microcode(void);
+void reload_early_microcode(unsigned int cpu);
 extern bool initrd_gone;
 void microcode_bsp_resume(void);
 #else
 static inline void __init load_ucode_bsp(void)			{ }
 static inline void load_ucode_ap(void)				{ }
-static inline void reload_early_microcode(void)			{ }
+static inline void reload_early_microcode(unsigned int cpu)	{ }
 static inline void microcode_bsp_resume(void)			{ }
 #endif
 
--- a/arch/x86/include/asm/microcode_amd.h
+++ b/arch/x86/include/asm/microcode_amd.h
@@ -47,12 +47,12 @@ struct microcode_amd {
 extern void __init load_ucode_amd_bsp(unsigned int family);
 extern void load_ucode_amd_ap(unsigned int family);
 extern int __init save_microcode_in_initrd_amd(unsigned int family);
-void reload_ucode_amd(void);
+void reload_ucode_amd(unsigned int cpu);
 #else
 static inline void __init load_ucode_amd_bsp(unsigned int family) {}
 static inline void load_ucode_amd_ap(unsigned int family) {}
 static inline int __init
 save_microcode_in_initrd_amd(unsigned int family) { return -EINVAL; }
-static inline void reload_ucode_amd(void) {}
+static inline void reload_ucode_amd(unsigned int cpu) {}
 #endif
 #endif /* _ASM_X86_MICROCODE_AMD_H */
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -578,7 +578,7 @@ int __init save_microcode_in_initrd_amd(
 	return 0;
 }
 
-void reload_ucode_amd(void)
+void reload_ucode_amd(unsigned int cpu)
 {
 	struct microcode_amd *mc;
 	u32 rev, dummy __always_unused;
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -298,7 +298,7 @@ struct cpio_data find_microcode_in_initr
 #endif
 }
 
-void reload_early_microcode(void)
+void reload_early_microcode(unsigned int cpu)
 {
 	int vendor, family;
 
@@ -312,7 +312,7 @@ void reload_early_microcode(void)
 		break;
 	case X86_VENDOR_AMD:
 		if (family >= 0x10)
-			reload_ucode_amd();
+			reload_ucode_amd(cpu);
 		break;
 	default:
 		break;
@@ -695,7 +695,7 @@ void microcode_bsp_resume(void)
 	if (uci->valid && uci->mc)
 		microcode_ops->apply_microcode(cpu);
 	else if (!uci->mc)
-		reload_early_microcode();
+		reload_early_microcode(cpu);
 }
 
 static struct syscore_ops mc_syscore_ops = {


