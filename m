Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124761CA8F;
	Mon,  1 Apr 2024 16:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987442; cv=none; b=ZpEeaQj8zNvX94W0Zj5piEB7W6FKJnLERiY3tZklpzZ6m0sp6Lp+ZZwos4AOLDBJJKLF5ks7y9RVqhY6MHjCAQPC2Lz2V7Tkr0FHrPrWTs+sQjE0jzylMkJM9OWX+0MeHFcss2f+87MrIeSamUSyIWuR61qWnt9VgQJUA+gQQ+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987442; c=relaxed/simple;
	bh=rx2CsUR5tWug6cH+ijS6szM9rsB3VldqajqRWqRy0zI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfQwGkwIneZ01trz8/Oqu3Z841d7itjkk2hyhbZwf0zxfLZbAkSlBOePk1SkQGTV+FYGVasjVUJSzXLGta6t2EhhC9ZILWFYJ1O5MAyi75R8xgWQ0sGeFZqOdjXlEuSOYioC7F5ysTsbfXh5aIT45Mb7vbUuiGIh+IO/WxUrBD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hRbN665q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hRbN665q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D009C433F1;
	Mon,  1 Apr 2024 16:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987442;
	bh=rx2CsUR5tWug6cH+ijS6szM9rsB3VldqajqRWqRy0zI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hRbN665qeMm8TVDPL15iL1R6jSm+Mj55ywRmbzBh4c5hnmFjuUCnagR+1qtkCW0sN
	 6mZAn0+l9W3Eu8p2XUxB8PEOqrOViC54qll4K3xEDl+P/SAszg+uxQSzFMQLZtryI4
	 TkNmhWFKKHNMRVBBgESj6FAoCxhI4dbytT8y5UsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clayton Craft <clayton@craftyguy.net>,
	Hans de Goede <hdegoede@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.8 288/399] x86/efistub: Add missing boot_params for mixed mode compat entry
Date: Mon,  1 Apr 2024 17:44:14 +0200
Message-ID: <20240401152557.781967117@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit d21f5a59ea773826cc489acb287811d690b703cc upstream.

The pure EFI stub entry point does not take a struct boot_params from
the boot loader, but creates it from scratch, and populates only the
fields that still have meaning in this context (command line, initrd
base and size, etc)

The original mixed mode implementation used the EFI handover protocol
instead, where the boot loader (i.e., GRUB) populates a boot_params
struct and passes it to a special Linux specific EFI entry point that
takes the boot_params pointer as its third argument.

When the new mixed mode implementation was introduced, using a special
32-bit PE entrypoint in the 64-bit kernel, it adopted the pure approach,
and relied on the EFI stub to create the struct boot_params.  This is
preferred because it makes the bootloader side much easier to implement,
as it does not need any x86-specific knowledge on how struct boot_params
and struct setup_header are put together. This mixed mode implementation
was adopted by systemd-boot version 252 and later.

When commit

  e2ab9eab324c ("x86/boot/compressed: Move 32-bit entrypoint code into .text section")

refactored this code and moved it out of head_64.S, the fact that ESI
was populated with the address of the base of the image was overlooked,
and to simplify the code flow, ESI is now zeroed and stored to memory
unconditionally in shared code, so that the NULL-ness of that variable
can still be used later to determine which mixed mode boot protocol is
in use.

With ESI pointing to the base of the image, it can serve as a struct
boot_params pointer for startup_32(), which only accesses the init_data
and kernel_alignment fields (and the scratch field as a temporary
stack). Zeroing ESI means that those accesses produce garbage now, even
though things appear to work if the first page of memory happens to be
zeroed, and the region right before LOAD_PHYSICAL_ADDR (== 16 MiB)
happens to be free.

The solution is to pass a special, temporary struct boot_params to
startup_32() via ESI, one that is sufficient for getting it to create
the page tables correctly and is discarded right after. This involves
setting a minimal alignment of 4k, only to get the statically allocated
page tables line up correctly, and setting init_size to the executable
image size (_end - startup_32). This ensures that the page tables are
covered by the static footprint of the PE image.

Given that EFI boot no longer calls the decompressor and no longer pads
the image to permit the decompressor to execute in place, the same
temporary struct boot_params should be used in the EFI handover protocol
based mixed mode implementation as well, to prevent the page tables from
being placed outside of allocated memory.

Fixes: e2ab9eab324c ("x86/boot/compressed: Move 32-bit entrypoint code into .text section")
Cc: <stable@kernel.org> # v6.1+
Closes: https://lore.kernel.org/all/20240321150510.GI8211@craftyguy.net/
Reported-by: Clayton Craft <clayton@craftyguy.net>
Tested-by: Clayton Craft <clayton@craftyguy.net>
Tested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/efi_mixed.S |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/arch/x86/boot/compressed/efi_mixed.S
+++ b/arch/x86/boot/compressed/efi_mixed.S
@@ -15,10 +15,12 @@
  */
 
 #include <linux/linkage.h>
+#include <asm/asm-offsets.h>
 #include <asm/msr.h>
 #include <asm/page_types.h>
 #include <asm/processor-flags.h>
 #include <asm/segment.h>
+#include <asm/setup.h>
 
 	.code64
 	.text
@@ -149,6 +151,7 @@ SYM_FUNC_END(__efi64_thunk)
 SYM_FUNC_START(efi32_stub_entry)
 	call	1f
 1:	popl	%ecx
+	leal	(efi32_boot_args - 1b)(%ecx), %ebx
 
 	/* Clear BSS */
 	xorl	%eax, %eax
@@ -163,6 +166,7 @@ SYM_FUNC_START(efi32_stub_entry)
 	popl	%ecx
 	popl	%edx
 	popl	%esi
+	movl	%esi, 8(%ebx)
 	jmp	efi32_entry
 SYM_FUNC_END(efi32_stub_entry)
 #endif
@@ -239,8 +243,6 @@ SYM_FUNC_END(efi_enter32)
  *
  * Arguments:	%ecx	image handle
  * 		%edx	EFI system table pointer
- *		%esi	struct bootparams pointer (or NULL when not using
- *			the EFI handover protocol)
  *
  * Since this is the point of no return for ordinary execution, no registers
  * are considered live except for the function parameters. [Note that the EFI
@@ -266,9 +268,18 @@ SYM_FUNC_START_LOCAL(efi32_entry)
 	leal	(efi32_boot_args - 1b)(%ebx), %ebx
 	movl	%ecx, 0(%ebx)
 	movl	%edx, 4(%ebx)
-	movl	%esi, 8(%ebx)
 	movb	$0x0, 12(%ebx)          // efi_is64
 
+	/*
+	 * Allocate some memory for a temporary struct boot_params, which only
+	 * needs the minimal pieces that startup_32() relies on.
+	 */
+	subl	$PARAM_SIZE, %esp
+	movl	%esp, %esi
+	movl	$PAGE_SIZE, BP_kernel_alignment(%esi)
+	movl	$_end - 1b, BP_init_size(%esi)
+	subl	$startup_32 - 1b, BP_init_size(%esi)
+
 	/* Disable paging */
 	movl	%cr0, %eax
 	btrl	$X86_CR0_PG_BIT, %eax
@@ -294,8 +305,7 @@ SYM_FUNC_START(efi32_pe_entry)
 
 	movl	8(%ebp), %ecx			// image_handle
 	movl	12(%ebp), %edx			// sys_table
-	xorl	%esi, %esi
-	jmp	efi32_entry			// pass %ecx, %edx, %esi
+	jmp	efi32_entry			// pass %ecx, %edx
 						// no other registers remain live
 
 2:	popl	%edi				// restore callee-save registers


