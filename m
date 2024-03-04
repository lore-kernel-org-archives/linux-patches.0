Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121A97BAF0;
	Mon,  4 Mar 2024 21:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589060; cv=none; b=n+SwVmNPuByWCebl9G85NCNHORqAVIPRDbYCtXnmBuEAdtBnIbyyUTEq5uhjTkbtaCvrOjkMhpeSnmRpyMJH6NTr4ISpll0Z6M/wbmLgZwTxoIgBL8Fm7I/OK3C0Gt1R6B0pfnVSyeOyQWeuQXppPVN0OGYITdxky1Y4BUGCkxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589060; c=relaxed/simple;
	bh=LsfiHcxjl+fbSFy3u7kChCLaUS9TGNQIpmYlkA/ys2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5Fc4macNRxnb7C+1FCtzOAWWRbEwA02uI717s25CQNyV8eSQJ/W2Au1Uu0pO1mgqelCeOe8ms55AAzdttVHbyDYi+8VNc5UryXv2/wrXQdUpnjZYw04ktydgl6YCq4Wb25mXL1L7NgZiH7lsQT/h+OZZwpt8nWv5ZxMgbUr71s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qsl1XBbA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qsl1XBbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2BBC433C7;
	Mon,  4 Mar 2024 21:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589060;
	bh=LsfiHcxjl+fbSFy3u7kChCLaUS9TGNQIpmYlkA/ys2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qsl1XBbAA2CTqbEb9Vxin4hgpeM5lO1A0QT5dtobSkgWzKaEsWwacbmbM4k+yrjDh
	 Eae+Vtcz+k7f2j1vFvSUeTsxqpea12gf5Skds7VGWJLxuDHvpL/cAF4TxIFDG3JAUP
	 O48I7+P/8NEogulQqK20a06V7kC01WLVbJWKenN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 186/215] efi/libstub: Add limit argument to efi_random_alloc()
Date: Mon,  4 Mar 2024 21:24:09 +0000
Message-ID: <20240304211602.860080424@linuxfoundation.org>
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

[ Commit bc5ddceff4c14494d83449ad45c985e6cd353fce upstream ]

x86 will need to limit the kernel memory allocation to the lowest 512
MiB of memory, to match the behavior of the existing bare metal KASLR
physical randomization logic. So in preparation for that, add a limit
parameter to efi_random_alloc() and wire it up.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230807162720.545787-22-ardb@kernel.org
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/arm64-stub.c  |    2 +-
 drivers/firmware/efi/libstub/efistub.h     |    2 +-
 drivers/firmware/efi/libstub/randomalloc.c |   10 ++++++----
 3 files changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -181,7 +181,7 @@ efi_status_t handle_kernel_image(unsigne
 		 */
 		status = efi_random_alloc(*reserve_size, min_kimg_align,
 					  reserve_addr, phys_seed,
-					  EFI_LOADER_CODE);
+					  EFI_LOADER_CODE, EFI_ALLOC_LIMIT);
 		if (status != EFI_SUCCESS)
 			efi_warn("efi_random_alloc() failed: 0x%lx\n", status);
 	} else {
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -905,7 +905,7 @@ efi_status_t efi_get_random_bytes(unsign
 
 efi_status_t efi_random_alloc(unsigned long size, unsigned long align,
 			      unsigned long *addr, unsigned long random_seed,
-			      int memory_type);
+			      int memory_type, unsigned long alloc_limit);
 
 efi_status_t efi_random_get_seed(void);
 
--- a/drivers/firmware/efi/libstub/randomalloc.c
+++ b/drivers/firmware/efi/libstub/randomalloc.c
@@ -16,7 +16,8 @@
  */
 static unsigned long get_entry_num_slots(efi_memory_desc_t *md,
 					 unsigned long size,
-					 unsigned long align_shift)
+					 unsigned long align_shift,
+					 u64 alloc_limit)
 {
 	unsigned long align = 1UL << align_shift;
 	u64 first_slot, last_slot, region_end;
@@ -29,7 +30,7 @@ static unsigned long get_entry_num_slots
 		return 0;
 
 	region_end = min(md->phys_addr + md->num_pages * EFI_PAGE_SIZE - 1,
-			 (u64)EFI_ALLOC_LIMIT);
+			 alloc_limit);
 	if (region_end < size)
 		return 0;
 
@@ -54,7 +55,8 @@ efi_status_t efi_random_alloc(unsigned l
 			      unsigned long align,
 			      unsigned long *addr,
 			      unsigned long random_seed,
-			      int memory_type)
+			      int memory_type,
+			      unsigned long alloc_limit)
 {
 	unsigned long total_slots = 0, target_slot;
 	unsigned long total_mirrored_slots = 0;
@@ -76,7 +78,7 @@ efi_status_t efi_random_alloc(unsigned l
 		efi_memory_desc_t *md = (void *)map->map + map_offset;
 		unsigned long slots;
 
-		slots = get_entry_num_slots(md, size, ilog2(align));
+		slots = get_entry_num_slots(md, size, ilog2(align), alloc_limit);
 		MD_NUM_SLOTS(md) = slots;
 		total_slots += slots;
 		if (md->attribute & EFI_MEMORY_MORE_RELIABLE)


