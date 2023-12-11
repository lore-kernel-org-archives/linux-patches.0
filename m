Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FE24437B;
	Mon, 11 Dec 2023 18:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="upVp+RyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6A1C433C7;
	Mon, 11 Dec 2023 18:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320307;
	bh=DxCGKioTLS7FUpWAkyhYNKt0XUo26bi2Do2/cJPTFxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=upVp+RyJHuvvTQrCtA+wNVbyKyDp1gASg+T49RDXXBE6dS308CMSX2grZr8EFEpz5
	 HDM20Y5CuvS+cCy4GOscJZ5MPj3oQMha9dJXew7zTSG8K/YFq2xXmjFS1qJvYA0rU4
	 gFzgLHl0ZIZ5/1Ko6hNXrGGu4aNatkBFHJ6jGg/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 013/194] x86/entry: Do not allow external 0x80 interrupts
Date: Mon, 11 Dec 2023 19:20:03 +0100
Message-ID: <20231211182037.197124870@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ upstream commit 55617fb991df535f953589586468612351575704 ]

The INT 0x80 instruction is used for 32-bit x86 Linux syscalls. The
kernel expects to receive a software interrupt as a result of the INT
0x80 instruction. However, an external interrupt on the same vector
also triggers the same codepath.

An external interrupt on vector 0x80 will currently be interpreted as a
32-bit system call, and assuming that it was a user context.

Panic on external interrupts on the vector.

To distinguish software interrupts from external ones, the kernel checks
the APIC ISR bit relevant to the 0x80 vector. For software interrupts,
this bit will be 0.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@vger.kernel.org> # v6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/common.c |   37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -25,6 +25,7 @@
 #include <xen/events.h>
 #endif
 
+#include <asm/apic.h>
 #include <asm/desc.h>
 #include <asm/traps.h>
 #include <asm/vdso.h>
@@ -120,6 +121,25 @@ static __always_inline void do_syscall_3
 }
 
 #ifdef CONFIG_IA32_EMULATION
+static __always_inline bool int80_is_external(void)
+{
+	const unsigned int offs = (0x80 / 32) * 0x10;
+	const u32 bit = BIT(0x80 % 32);
+
+	/* The local APIC on XENPV guests is fake */
+	if (cpu_feature_enabled(X86_FEATURE_XENPV))
+		return false;
+
+	/*
+	 * If vector 0x80 is set in the APIC ISR then this is an external
+	 * interrupt. Either from broken hardware or injected by a VMM.
+	 *
+	 * Note: In guest mode this is only valid for secure guests where
+	 * the secure module fully controls the vAPIC exposed to the guest.
+	 */
+	return apic_read(APIC_ISR + offs) & bit;
+}
+
 /**
  * int80_emulation - 32-bit legacy syscall entry
  *
@@ -143,12 +163,27 @@ DEFINE_IDTENTRY_RAW(int80_emulation)
 {
 	int nr;
 
-	/* Establish kernel context. */
+	/* Kernel does not use INT $0x80! */
+	if (unlikely(!user_mode(regs))) {
+		irqentry_enter(regs);
+		instrumentation_begin();
+		panic("Unexpected external interrupt 0x80\n");
+	}
+
+	/*
+	 * Establish kernel context for instrumentation, including for
+	 * int80_is_external() below which calls into the APIC driver.
+	 * Identical for soft and external interrupts.
+	 */
 	enter_from_user_mode(regs);
 
 	instrumentation_begin();
 	add_random_kstack_offset();
 
+	/* Validate that this is a soft interrupt to the extent possible */
+	if (unlikely(int80_is_external()))
+		panic("Unexpected external interrupt 0x80\n");
+
 	/*
 	 * The low level idtentry code pushed -1 into regs::orig_ax
 	 * and regs::ax contains the syscall number.


