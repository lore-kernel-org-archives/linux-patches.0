Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C9C7868F;
	Mon,  4 Mar 2024 21:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588819; cv=none; b=lM/fXu4ERBa4r0I7xeC/mHhHxjaB7HhpSWfEJM26tZN3ATUQ6Q64/OalPJfmEvq0Zy15rHa/h0B4JUyWTeMdrL33m0Fu3HBi7bbKYkRxk/EHlmjpHJmoDBzJIDLAc49BlITi66nDmbMU8vZzOjxciyv1xWATCPWkuIFnE8wyHog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588819; c=relaxed/simple;
	bh=uM4+O1OacFrAJFSB/x+yKPX9u/h+2k4/dRKw5fawdNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MeP1nJL+NPhrnUFfFt6iQMDbNSDDEQmETB732ZlXkWDX6rzD74OVn9Yn0W9XeYclGYkekqg5Aoj7ka3CW4R4ZMc39X0+KiksN9qs43QleRFGAGYz13RSJiHV5kwBaD7ty1OiZQO/2WwVGNEAg18MIeexqmZBvlVPNrk+TEZ/7aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rf+TrxXG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rf+TrxXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA21C433F1;
	Mon,  4 Mar 2024 21:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588818;
	bh=uM4+O1OacFrAJFSB/x+yKPX9u/h+2k4/dRKw5fawdNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rf+TrxXG3ez+/2XftypNlC5dehoQicLNVqs0ZXUShPBQffO/zQCe5cgOYvtLmOFnr
	 lJCFNMy5UQkPoEgRTjWvPZ0pDNUZx5LoMrPVUVUr8IFzWuBFdlRsbj7r7wuEqBZ4YP
	 QPFy/O1BJnJNwSPgHLInGbELo9PKnrGc1gUDkWXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 109/215] efi: libstub: use EFI_LOADER_CODE region when moving the kernel in memory
Date: Mon,  4 Mar 2024 21:22:52 +0000
Message-ID: <20240304211600.493214147@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb@kernel.org>

commit 9cf42bca30e98a1c6c9e8abf876940a551eaa3d1 upstream.

The EFI spec is not very clear about which permissions are being given
when allocating pages of a certain type. However, it is quite obvious
that EFI_LOADER_CODE is more likely to permit execution than
EFI_LOADER_DATA, which becomes relevant once we permit booting the
kernel proper with the firmware's 1:1 mapping still active.

Ostensibly, recent systems such as the Surface Pro X grant executable
permissions to EFI_LOADER_CODE regions but not EFI_LOADER_DATA regions.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/alignedmem.c  |    5 +++--
 drivers/firmware/efi/libstub/arm64-stub.c  |    6 ++++--
 drivers/firmware/efi/libstub/efistub.h     |    6 ++++--
 drivers/firmware/efi/libstub/mem.c         |    3 ++-
 drivers/firmware/efi/libstub/randomalloc.c |    5 +++--
 5 files changed, 16 insertions(+), 9 deletions(-)

--- a/drivers/firmware/efi/libstub/alignedmem.c
+++ b/drivers/firmware/efi/libstub/alignedmem.c
@@ -22,7 +22,8 @@
  * Return:	status code
  */
 efi_status_t efi_allocate_pages_aligned(unsigned long size, unsigned long *addr,
-					unsigned long max, unsigned long align)
+					unsigned long max, unsigned long align,
+					int memory_type)
 {
 	efi_physical_addr_t alloc_addr;
 	efi_status_t status;
@@ -36,7 +37,7 @@ efi_status_t efi_allocate_pages_aligned(
 	slack = align / EFI_PAGE_SIZE - 1;
 
 	status = efi_bs_call(allocate_pages, EFI_ALLOCATE_MAX_ADDRESS,
-			     EFI_LOADER_DATA, size / EFI_PAGE_SIZE + slack,
+			     memory_type, size / EFI_PAGE_SIZE + slack,
 			     &alloc_addr);
 	if (status != EFI_SUCCESS)
 		return status;
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -180,7 +180,8 @@ efi_status_t handle_kernel_image(unsigne
 		 * locate the kernel at a randomized offset in physical memory.
 		 */
 		status = efi_random_alloc(*reserve_size, min_kimg_align,
-					  reserve_addr, phys_seed);
+					  reserve_addr, phys_seed,
+					  EFI_LOADER_CODE);
 		if (status != EFI_SUCCESS)
 			efi_warn("efi_random_alloc() failed: 0x%lx\n", status);
 	} else {
@@ -201,7 +202,8 @@ efi_status_t handle_kernel_image(unsigne
 		}
 
 		status = efi_allocate_pages_aligned(*reserve_size, reserve_addr,
-						    ULONG_MAX, min_kimg_align);
+						    ULONG_MAX, min_kimg_align,
+						    EFI_LOADER_CODE);
 
 		if (status != EFI_SUCCESS) {
 			efi_err("Failed to relocate kernel\n");
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -880,7 +880,8 @@ void efi_get_virtmap(efi_memory_desc_t *
 efi_status_t efi_get_random_bytes(unsigned long size, u8 *out);
 
 efi_status_t efi_random_alloc(unsigned long size, unsigned long align,
-			      unsigned long *addr, unsigned long random_seed);
+			      unsigned long *addr, unsigned long random_seed,
+			      int memory_type);
 
 efi_status_t efi_random_get_seed(void);
 
@@ -907,7 +908,8 @@ efi_status_t efi_allocate_pages(unsigned
 				unsigned long max);
 
 efi_status_t efi_allocate_pages_aligned(unsigned long size, unsigned long *addr,
-					unsigned long max, unsigned long align);
+					unsigned long max, unsigned long align,
+					int memory_type);
 
 efi_status_t efi_low_alloc_above(unsigned long size, unsigned long align,
 				 unsigned long *addr, unsigned long min);
--- a/drivers/firmware/efi/libstub/mem.c
+++ b/drivers/firmware/efi/libstub/mem.c
@@ -91,7 +91,8 @@ efi_status_t efi_allocate_pages(unsigned
 
 	if (EFI_ALLOC_ALIGN > EFI_PAGE_SIZE)
 		return efi_allocate_pages_aligned(size, addr, max,
-						  EFI_ALLOC_ALIGN);
+						  EFI_ALLOC_ALIGN,
+						  EFI_LOADER_DATA);
 
 	alloc_addr = ALIGN_DOWN(max + 1, EFI_ALLOC_ALIGN) - 1;
 	status = efi_bs_call(allocate_pages, EFI_ALLOCATE_MAX_ADDRESS,
--- a/drivers/firmware/efi/libstub/randomalloc.c
+++ b/drivers/firmware/efi/libstub/randomalloc.c
@@ -53,7 +53,8 @@ static unsigned long get_entry_num_slots
 efi_status_t efi_random_alloc(unsigned long size,
 			      unsigned long align,
 			      unsigned long *addr,
-			      unsigned long random_seed)
+			      unsigned long random_seed,
+			      int memory_type)
 {
 	unsigned long total_slots = 0, target_slot;
 	unsigned long total_mirrored_slots = 0;
@@ -118,7 +119,7 @@ efi_status_t efi_random_alloc(unsigned l
 		pages = size / EFI_PAGE_SIZE;
 
 		status = efi_bs_call(allocate_pages, EFI_ALLOCATE_ADDRESS,
-				     EFI_LOADER_DATA, pages, &target);
+				     memory_type, pages, &target);
 		if (status == EFI_SUCCESS)
 			*addr = target;
 		break;


