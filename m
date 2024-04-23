Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B17146D5A;
	Tue, 23 Apr 2024 21:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908687; cv=none; b=rIt0NUBoXTbAPKv/lPYE9kLqhaTy6VBNsZjKjB2+HQCWC52+olQwQCuxeJR4/qVREbdxRbYPy6dUeh/nUa0l7q1urCptsLenw+Koaqm/KfHkeJVHxBakrFJxNdk7C5nXDzVTfpFBie6xnxG/zOH/zZO3fPNwuIA3pmmESweSJQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908687; c=relaxed/simple;
	bh=RyTgzor2LnU/hqVjNgP2SRUoRZZyx36V/q1B1aHZVMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8uSNwUI53NYpuq0ytpkVnIBp5HD07EXw4RQpGplqy3dreGWDJPMEj7XiOs8CMnpiDkgCUVaCgahRrn1eI5Wu68BSZ4b4aIVFvNyv8a39HxhRnmc1VKWqabFojdfklHTigpW5h22ooAoC45Dosmm7+4NV8SkHQgoTM9i0Cj8+rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IdLWMcPR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdLWMcPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46AAC32783;
	Tue, 23 Apr 2024 21:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908686;
	bh=RyTgzor2LnU/hqVjNgP2SRUoRZZyx36V/q1B1aHZVMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IdLWMcPRJXJbK28sgL2Cwih7zaU4/AUSFgsrzNxTOQRzlr7gtr7q+7t3WZaImDytF
	 v1S7mtF4yAOB4VdmCUh6KUZGrIK+q5OwD1NRAlKv0P0H5lonDYeImJPH6MQPEwlvuf
	 M6BEPQRxCdLOkzs3Ib4Th6qbwlvB8msgIcUl3KG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 033/141] x86/efistub: Remap kernel text read-only before dropping NX attribute
Date: Tue, 23 Apr 2024 14:38:21 -0700
Message-ID: <20240423213854.377796037@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb@kernel.org>

[ Commit 9c55461040a9264b7e44444c53d26480b438eda6 upstream ]

Currently, the EFI stub invokes the EFI memory attributes protocol to
strip any NX restrictions from the entire loaded kernel, resulting in
all code and data being mapped read-write-execute.

The point of the EFI memory attributes protocol is to remove the need
for all memory allocations to be mapped with both write and execute
permissions by default, and make it the OS loader's responsibility to
transition data mappings to code mappings where appropriate.

Even though the UEFI specification does not appear to leave room for
denying memory attribute changes based on security policy, let's be
cautious and avoid relying on the ability to create read-write-execute
mappings. This is trivially achievable, given that the amount of kernel
code executing via the firmware's 1:1 mapping is rather small and
limited to the .head.text region. So let's drop the NX restrictions only
on that subregion, but not before remapping it as read-only first.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/Makefile       |    2 +-
 arch/x86/boot/compressed/misc.c         |    1 +
 arch/x86/include/asm/boot.h             |    1 +
 drivers/firmware/efi/libstub/x86-stub.c |   11 ++++++++++-
 4 files changed, 13 insertions(+), 2 deletions(-)

--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -84,7 +84,7 @@ LDFLAGS_vmlinux += -T
 hostprogs	:= mkpiggy
 HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 
-sed-voffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(_text\|__bss_start\|_end\)$$/\#define VO_\2 _AC(0x\1,UL)/p'
+sed-voffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(_text\|__start_rodata\|__bss_start\|_end\)$$/\#define VO_\2 _AC(0x\1,UL)/p'
 
 quiet_cmd_voffset = VOFFSET $@
       cmd_voffset = $(NM) $< | sed -n $(sed-voffset) > $@
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -330,6 +330,7 @@ static size_t parse_elf(void *output)
 	return ehdr.e_entry - LOAD_PHYSICAL_ADDR;
 }
 
+const unsigned long kernel_text_size = VO___start_rodata - VO__text;
 const unsigned long kernel_total_size = VO__end - VO__text;
 
 static u8 boot_heap[BOOT_HEAP_SIZE] __aligned(4);
--- a/arch/x86/include/asm/boot.h
+++ b/arch/x86/include/asm/boot.h
@@ -81,6 +81,7 @@
 
 #ifndef __ASSEMBLY__
 extern unsigned int output_len;
+extern const unsigned long kernel_text_size;
 extern const unsigned long kernel_total_size;
 
 unsigned long decompress_kernel(unsigned char *outbuf, unsigned long virt_addr,
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -227,6 +227,15 @@ efi_status_t efi_adjust_memory_range_pro
 	rounded_end = roundup(start + size, EFI_PAGE_SIZE);
 
 	if (memattr != NULL) {
+		status = efi_call_proto(memattr, set_memory_attributes,
+					rounded_start,
+					rounded_end - rounded_start,
+					EFI_MEMORY_RO);
+		if (status != EFI_SUCCESS) {
+			efi_warn("Failed to set EFI_MEMORY_RO attribute\n");
+			return status;
+		}
+
 		status = efi_call_proto(memattr, clear_memory_attributes,
 					rounded_start,
 					rounded_end - rounded_start,
@@ -778,7 +787,7 @@ static efi_status_t efi_decompress_kerne
 
 	*kernel_entry = addr + entry;
 
-	return efi_adjust_memory_range_protection(addr, kernel_total_size);
+	return efi_adjust_memory_range_protection(addr, kernel_text_size);
 }
 
 static void __noreturn enter_kernel(unsigned long kernel_addr,


