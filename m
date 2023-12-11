Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F76251C2A;
	Mon, 11 Dec 2023 18:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IPd+kIvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930FAC433C7;
	Mon, 11 Dec 2023 18:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320301;
	bh=P9sM0a1GTFX4rtVk7neS1rLxId6+mIxcyPggYYmppr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IPd+kIvESql2e6Ocp9znivzUZo6xQIT8nLH373ewcZkRgQns9Dny73uZXfe+DG3r9
	 hTlWvaPDwYv2T8TkJH+dILtRiZ4D/6TwTSZ6cLttDTEEorOOGthCAKodVFISSiI9yg
	 F4fYl4+zyLFvWSM9MNEgRMxwXyVBgQmiFoueI/lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Supraja Sridhara <supraja.sridhara@inf.ethz.ch>,
	=?UTF-8?q?Benedict=20Schl=C3=BCter?= <benedict.schlueter@inf.ethz.ch>,
	Mark Kuhne <mark.kuhne@inf.ethz.ch>,
	Andrin Bertschi <andrin.bertschi@inf.ethz.ch>,
	Shweta Shinde <shweta.shinde@inf.ethz.ch>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 011/194] x86/coco: Disable 32-bit emulation by default on TDX and SEV
Date: Mon, 11 Dec 2023 19:20:01 +0100
Message-ID: <20231211182037.105233085@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

[ upstream commit b82a8dbd3d2f4563156f7150c6f2ecab6e960b30 ]

The INT 0x80 instruction is used for 32-bit x86 Linux syscalls. The
kernel expects to receive a software interrupt as a result of the INT
0x80 instruction. However, an external interrupt on the same vector
triggers the same handler.

The kernel interprets an external interrupt on vector 0x80 as a 32-bit
system call that came from userspace.

A VMM can inject external interrupts on any arbitrary vector at any
time.  This remains true even for TDX and SEV guests where the VMM is
untrusted.

Put together, this allows an untrusted VMM to trigger int80 syscall
handling at any given point. The content of the guest register file at
that moment defines what syscall is triggered and its arguments. It
opens the guest OS to manipulation from the VMM side.

Disable 32-bit emulation by default for TDX and SEV. User can override
it with the ia32_emulation=y command line option.

[ dhansen: reword the changelog ]

Reported-by: Supraja Sridhara <supraja.sridhara@inf.ethz.ch>
Reported-by: Benedict Schlüter <benedict.schlueter@inf.ethz.ch>
Reported-by: Mark Kuhne <mark.kuhne@inf.ethz.ch>
Reported-by: Andrin Bertschi <andrin.bertschi@inf.ethz.ch>
Reported-by: Shweta Shinde <shweta.shinde@inf.ethz.ch>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@vger.kernel.org> # 6.0+: 1da5c9b x86: Introduce ia32_enabled()
Cc: <stable@vger.kernel.org> # 6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/coco/tdx/tdx.c       |   10 ++++++++++
 arch/x86/include/asm/ia32.h   |    7 +++++++
 arch/x86/mm/mem_encrypt_amd.c |   11 +++++++++++
 3 files changed, 28 insertions(+)

--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -8,6 +8,7 @@
 #include <asm/coco.h>
 #include <asm/tdx.h>
 #include <asm/vmx.h>
+#include <asm/ia32.h>
 #include <asm/insn.h>
 #include <asm/insn-eval.h>
 #include <asm/pgtable.h>
@@ -829,5 +830,14 @@ void __init tdx_early_init(void)
 	x86_platform.guest.enc_cache_flush_required  = tdx_cache_flush_required;
 	x86_platform.guest.enc_tlb_flush_required    = tdx_tlb_flush_required;
 
+	/*
+	 * The VMM is capable of injecting interrupt 0x80 and triggering the
+	 * compatibility syscall path.
+	 *
+	 * By default, the 32-bit emulation is disabled in order to ensure
+	 * the safety of the VM.
+	 */
+	ia32_disable();
+
 	pr_info("Guest detected\n");
 }
--- a/arch/x86/include/asm/ia32.h
+++ b/arch/x86/include/asm/ia32.h
@@ -75,6 +75,11 @@ static inline bool ia32_enabled(void)
 	return __ia32_enabled;
 }
 
+static inline void ia32_disable(void)
+{
+	__ia32_enabled = false;
+}
+
 #else /* !CONFIG_IA32_EMULATION */
 
 static inline bool ia32_enabled(void)
@@ -82,6 +87,8 @@ static inline bool ia32_enabled(void)
 	return IS_ENABLED(CONFIG_X86_32);
 }
 
+static inline void ia32_disable(void) {}
+
 #endif
 
 #endif /* _ASM_X86_IA32_H */
--- a/arch/x86/mm/mem_encrypt_amd.c
+++ b/arch/x86/mm/mem_encrypt_amd.c
@@ -34,6 +34,7 @@
 #include <asm/msr.h>
 #include <asm/cmdline.h>
 #include <asm/sev.h>
+#include <asm/ia32.h>
 
 #include "mm_internal.h"
 
@@ -502,6 +503,16 @@ void __init sme_early_init(void)
 	x86_platform.guest.enc_status_change_finish  = amd_enc_status_change_finish;
 	x86_platform.guest.enc_tlb_flush_required    = amd_enc_tlb_flush_required;
 	x86_platform.guest.enc_cache_flush_required  = amd_enc_cache_flush_required;
+
+	/*
+	 * The VMM is capable of injecting interrupt 0x80 and triggering the
+	 * compatibility syscall path.
+	 *
+	 * By default, the 32-bit emulation is disabled in order to ensure
+	 * the safety of the VM.
+	 */
+	if (sev_status & MSR_AMD64_SEV_ENABLED)
+		ia32_disable();
 }
 
 void __init mem_encrypt_free_decrypted_mem(void)


