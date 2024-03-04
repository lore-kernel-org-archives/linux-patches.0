Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5057A1EB5A;
	Mon,  4 Mar 2024 21:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589118; cv=none; b=V7a1cL7qDjq5BA5GxzFM70z1k5DODVLT+lFVzGQcpXqXNe+9jtbKQha8bscWzxC6P5BUTcEnCnAXbeBaa6xgqdeFBWD6k8Ys3fzWOLQwkdcLtUk0CZe5/oTY3QhI0LadvUOGJixeRfZxOps0kISjzyBsZ0MXzFd/PKzkuExMzoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589118; c=relaxed/simple;
	bh=Y92VHxA5XzcMJTs3mQQddxw0lkuUlKL1/7C/kBb0Odk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IWfG0nUmmvzuqDdKDOQdV49mlwt1TjlIWB2vgK3/qKL0ao5dajENJJiXC3SO1Uz94/m5srZMccsQO8EgSy7lKropVYtq1+lliCYhIIfzqoGlNJhR3rDSrEQS6X6xM83CnyxYwNBj6hH5eJILHeay8nUgp79/nWXytgEcIp8ZTYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UFbw50Cw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFbw50Cw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D1DC433F1;
	Mon,  4 Mar 2024 21:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589118;
	bh=Y92VHxA5XzcMJTs3mQQddxw0lkuUlKL1/7C/kBb0Odk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UFbw50CwxM9bBDsD/Ob5gbmDbQ7jKdvHvSM2dd6azVQNBdQnCmJrSaCUDMNwPKGRK
	 mqiBq7iduWxoen/GKUPJFIiJn37ZGzpkk9ZYKVeIHz8sUuUPKv3ghF5As+0kLPEOuN
	 JvdusrEKwjwVJb3qT46r3RXbZ5960GzoX5KQ7BfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"linux-efi@vger.kernel.org, Ard Biesheuvel" <ardb@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 180/215] arm64: efi: Limit allocations to 48-bit addressable physical region
Date: Mon,  4 Mar 2024 21:24:03 +0000
Message-ID: <20240304211602.653003128@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb+git@google.com>

From: Ard Biesheuvel <ardb@kernel.org>

[ Commit a37dac5c5dcfe0f1fd58513c16cdbc280a47f628 upstream ]

The UEFI spec does not mention or reason about the configured size of
the virtual address space at all, but it does mention that all memory
should be identity mapped using a page size of 4 KiB.

This means that a LPA2 capable system that has any system memory outside
of the 48-bit addressable physical range and follows the spec to the
letter may serve page allocation requests from regions of memory that
the kernel cannot access unless it was built with LPA2 support and
enables it at runtime.

So let's ensure that all page allocations are limited to the 48-bit
range.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/efi.h               |    1 +
 drivers/firmware/efi/libstub/alignedmem.c  |    2 ++
 drivers/firmware/efi/libstub/arm64-stub.c  |    5 +++--
 drivers/firmware/efi/libstub/efistub.h     |    4 ++++
 drivers/firmware/efi/libstub/mem.c         |    2 ++
 drivers/firmware/efi/libstub/randomalloc.c |    2 +-
 6 files changed, 13 insertions(+), 3 deletions(-)

--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -103,6 +103,7 @@ static inline void free_screen_info(stru
 }
 
 #define EFI_ALLOC_ALIGN		SZ_64K
+#define EFI_ALLOC_LIMIT		((1UL << 48) - 1)
 
 /*
  * On ARM systems, virtually remapped UEFI runtime services are set up in two
--- a/drivers/firmware/efi/libstub/alignedmem.c
+++ b/drivers/firmware/efi/libstub/alignedmem.c
@@ -29,6 +29,8 @@ efi_status_t efi_allocate_pages_aligned(
 	efi_status_t status;
 	int slack;
 
+	max = min(max, EFI_ALLOC_LIMIT);
+
 	if (align < EFI_ALLOC_ALIGN)
 		align = EFI_ALLOC_ALIGN;
 
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -191,10 +191,11 @@ efi_status_t handle_kernel_image(unsigne
 	if (status != EFI_SUCCESS) {
 		if (!check_image_region((u64)_text, kernel_memsize)) {
 			efi_err("FIRMWARE BUG: Image BSS overlaps adjacent EFI memory region\n");
-		} else if (IS_ALIGNED((u64)_text, min_kimg_align)) {
+		} else if (IS_ALIGNED((u64)_text, min_kimg_align) &&
+			   (u64)_end < EFI_ALLOC_LIMIT) {
 			/*
 			 * Just execute from wherever we were loaded by the
-			 * UEFI PE/COFF loader if the alignment is suitable.
+			 * UEFI PE/COFF loader if the placement is suitable.
 			 */
 			*image_addr = (u64)_text;
 			*reserve_size = 0;
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -29,6 +29,10 @@
 #define EFI_ALLOC_ALIGN		EFI_PAGE_SIZE
 #endif
 
+#ifndef EFI_ALLOC_LIMIT
+#define EFI_ALLOC_LIMIT		ULONG_MAX
+#endif
+
 extern bool efi_nochunk;
 extern bool efi_nokaslr;
 extern int efi_loglevel;
--- a/drivers/firmware/efi/libstub/mem.c
+++ b/drivers/firmware/efi/libstub/mem.c
@@ -89,6 +89,8 @@ efi_status_t efi_allocate_pages(unsigned
 	efi_physical_addr_t alloc_addr;
 	efi_status_t status;
 
+	max = min(max, EFI_ALLOC_LIMIT);
+
 	if (EFI_ALLOC_ALIGN > EFI_PAGE_SIZE)
 		return efi_allocate_pages_aligned(size, addr, max,
 						  EFI_ALLOC_ALIGN,
--- a/drivers/firmware/efi/libstub/randomalloc.c
+++ b/drivers/firmware/efi/libstub/randomalloc.c
@@ -29,7 +29,7 @@ static unsigned long get_entry_num_slots
 		return 0;
 
 	region_end = min(md->phys_addr + md->num_pages * EFI_PAGE_SIZE - 1,
-			 (u64)ULONG_MAX);
+			 (u64)EFI_ALLOC_LIMIT);
 	if (region_end < size)
 		return 0;
 


