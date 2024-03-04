Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36799200D4;
	Mon,  4 Mar 2024 21:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589081; cv=none; b=bYWEbopUfSppy1MSBrWGzgVygyULuqI5+YS0xbMQOra5c2R4XlYCMVgOdnaWzEvNxTgrglm7J6Bzqz7547zPK4xwDtnu0P2xGnI5mYED6LWrEIKZANZ/gvD9SQ24+Fa8KnEC5riBT94ni1G+0fNH0pwHXcKIkjxYaR7J7IJV0n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589081; c=relaxed/simple;
	bh=SyV5hay3FoOl6ok0FYKxifmJOjYXvO79CpOinw2JsUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxOlPPosEI8GUpAplOB+IeKL6b61Hsacyrt2EKwfetOnE/QhzEclP1UgPp2trE97TE7y33h+FWyO/QYkpiL3ZcGGLYJy8zONRKq3JzpJklmjNERfMoB3nGgL+mlRJ9hiHrr1eWHwcu+sF4zlVfWqT+N9u0GMbVt4Af0HkKLM7j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQwHQhTE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQwHQhTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDD3C433F1;
	Mon,  4 Mar 2024 21:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589081;
	bh=SyV5hay3FoOl6ok0FYKxifmJOjYXvO79CpOinw2JsUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQwHQhTEeT1xtJsWdSv4UNszYotfEmG+uWA6ZckC9O2g4wvuR6kQJ9KPt8GAOZVDc
	 mf5BnlQHtgkzTjNZt+QF4v4TE5//VO3ZBxG4Rb7sgpiyzb6ITKwT5OvX0HzrKl49ag
	 JJYw9w6lbAGXXiMtf3zM9nzRjS60kShK5rES3z6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Englund <tomenglund26@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 193/215] x86/efistub: Avoid placing the kernel below LOAD_PHYSICAL_ADDR
Date: Mon,  4 Mar 2024 21:24:16 +0000
Message-ID: <20240304211603.096620975@linuxfoundation.org>
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

[ Commit 2f77465b05b1270c832b5e2ee27037672ad2a10a upstream ]

The EFI stub's kernel placement logic randomizes the physical placement
of the kernel by taking all available memory into account, and picking a
region at random, based on a random seed.

When KASLR is disabled, this seed is set to 0x0, and this results in the
lowest available region of memory to be selected for loading the kernel,
even if this is below LOAD_PHYSICAL_ADDR. Some of this memory is
typically reserved for the GFP_DMA region, to accommodate masters that
can only access the first 16 MiB of system memory.

Even if such devices are rare these days, we may still end up with a
warning in the kernel log, as reported by Tom:

 swapper/0: page allocation failure: order:10, mode:0xcc1(GFP_KERNEL|GFP_DMA), nodemask=(null),cpuset=/,mems_allowed=0

Fix this by tweaking the random allocation logic to accept a low bound
on the placement, and set it to LOAD_PHYSICAL_ADDR.

Fixes: a1b87d54f4e4 ("x86/efistub: Avoid legacy decompressor when doing EFI boot")
Reported-by: Tom Englund <tomenglund26@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218404
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/arm64-stub.c  |    2 +-
 drivers/firmware/efi/libstub/efistub.h     |    3 ++-
 drivers/firmware/efi/libstub/randomalloc.c |   12 +++++++-----
 drivers/firmware/efi/libstub/x86-stub.c    |    1 +
 4 files changed, 11 insertions(+), 7 deletions(-)

--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -181,7 +181,7 @@ efi_status_t handle_kernel_image(unsigne
 		 */
 		status = efi_random_alloc(*reserve_size, min_kimg_align,
 					  reserve_addr, phys_seed,
-					  EFI_LOADER_CODE, EFI_ALLOC_LIMIT);
+					  EFI_LOADER_CODE, 0, EFI_ALLOC_LIMIT);
 		if (status != EFI_SUCCESS)
 			efi_warn("efi_random_alloc() failed: 0x%lx\n", status);
 	} else {
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -906,7 +906,8 @@ efi_status_t efi_get_random_bytes(unsign
 
 efi_status_t efi_random_alloc(unsigned long size, unsigned long align,
 			      unsigned long *addr, unsigned long random_seed,
-			      int memory_type, unsigned long alloc_limit);
+			      int memory_type, unsigned long alloc_min,
+			      unsigned long alloc_max);
 
 efi_status_t efi_random_get_seed(void);
 
--- a/drivers/firmware/efi/libstub/randomalloc.c
+++ b/drivers/firmware/efi/libstub/randomalloc.c
@@ -17,7 +17,7 @@
 static unsigned long get_entry_num_slots(efi_memory_desc_t *md,
 					 unsigned long size,
 					 unsigned long align_shift,
-					 u64 alloc_limit)
+					 u64 alloc_min, u64 alloc_max)
 {
 	unsigned long align = 1UL << align_shift;
 	u64 first_slot, last_slot, region_end;
@@ -30,11 +30,11 @@ static unsigned long get_entry_num_slots
 		return 0;
 
 	region_end = min(md->phys_addr + md->num_pages * EFI_PAGE_SIZE - 1,
-			 alloc_limit);
+			 alloc_max);
 	if (region_end < size)
 		return 0;
 
-	first_slot = round_up(md->phys_addr, align);
+	first_slot = round_up(max(md->phys_addr, alloc_min), align);
 	last_slot = round_down(region_end - size + 1, align);
 
 	if (first_slot > last_slot)
@@ -56,7 +56,8 @@ efi_status_t efi_random_alloc(unsigned l
 			      unsigned long *addr,
 			      unsigned long random_seed,
 			      int memory_type,
-			      unsigned long alloc_limit)
+			      unsigned long alloc_min,
+			      unsigned long alloc_max)
 {
 	unsigned long total_slots = 0, target_slot;
 	unsigned long total_mirrored_slots = 0;
@@ -78,7 +79,8 @@ efi_status_t efi_random_alloc(unsigned l
 		efi_memory_desc_t *md = (void *)map->map + map_offset;
 		unsigned long slots;
 
-		slots = get_entry_num_slots(md, size, ilog2(align), alloc_limit);
+		slots = get_entry_num_slots(md, size, ilog2(align), alloc_min,
+					    alloc_max);
 		MD_NUM_SLOTS(md) = slots;
 		total_slots += slots;
 		if (md->attribute & EFI_MEMORY_MORE_RELIABLE)
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -785,6 +785,7 @@ static efi_status_t efi_decompress_kerne
 
 	status = efi_random_alloc(alloc_size, CONFIG_PHYSICAL_ALIGN, &addr,
 				  seed[0], EFI_LOADER_CODE,
+				  LOAD_PHYSICAL_ADDR,
 				  EFI_X86_KERNEL_ALLOC_LIMIT);
 	if (status != EFI_SUCCESS)
 		return status;


