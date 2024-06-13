Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0E4399;
	Thu, 13 Jun 2024 12:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282085; cv=none; b=EonIIV65Fem+RFYC1OGi2DfEwnh6ny0yihPeE9iR5CPE0W5ddB0J1mP73Ubk7S+SDacK2LxfIWqx5rOVrgX+jKo4MUAzYqwLj9FyhKxtX7enctiP0xcYbDDdHiTRAWBdopnDNu+DwYnqk6ymMCLSelksnyzgwLSsmluOWc8rwco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282085; c=relaxed/simple;
	bh=Otlwzx0mBVpB5tmwPufJ+v8K/EFbmnLtQrw+DWybmok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVaTnkED0FTeSaOKMS8mEUOHyBYrjV1cX7qOZ/05qx2CmWanc7I6N1aTgc4qB4FqkIY4dCF9U0kBv9kY41Pu4qxg4qnczRjqCB2NqsOvV4A/u25QQakwOaKiDMGTUjKfunDoIvfzoITi0aaXfcSBJUfgyJEvTkfBfV13rrQFlkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cFkqzc09; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFkqzc09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44121C2BBFC;
	Thu, 13 Jun 2024 12:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282085;
	bh=Otlwzx0mBVpB5tmwPufJ+v8K/EFbmnLtQrw+DWybmok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cFkqzc09X6eqgVpP6ddKlK4Gg+GZ/3GwukvjAb1vJziYla18adJg//eJLbIZirbvq
	 m8IlfeOkDhkp0/wA57NX6a07r+9EKCisMginswc0xK++7pqhogaVuCyztQzzbHOEsi
	 m4ye5D6SEpf6+piW2EXVqf+ezaD3XebbuEzjxO8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fei Li <fei1.li@intel.com>,
	Len Baker <len.baker@gmx.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 158/402] virt: acrn: Prefer array_size and struct_size over open coded arithmetic
Date: Thu, 13 Jun 2024 13:31:55 +0200
Message-ID: <20240613113308.299429561@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Baker <len.baker@gmx.com>

[ Upstream commit 746f1b0ac5bf6ecfb71674af210ae476aa714f46 ]

As noted in the "Deprecated Interfaces, Language Features, Attributes,
and Conventions" documentation [1], size calculations (especially
multiplication) should not be performed in memory allocator (or similar)
function arguments due to the risk of them overflowing. This could lead
to values wrapping around and a smaller allocation being made than the
caller was expecting. Using those allocations could lead to linear
overflows of heap memory and other misbehaviors.

So, use the array_size() helper to do the arithmetic instead of the
argument "count * size" in the vzalloc() function.

Also, take the opportunity to add a flexible array member of struct
vm_memory_region_op to the vm_memory_region_batch structure. And then,
change the code accordingly and use the struct_size() helper to do the
arithmetic instead of the argument "size + size * count" in the kzalloc
function.

This code was detected with the help of Coccinelle and audited and fixed
manually.

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments

Acked-by: Fei Li <fei1.li@intel.com>
Signed-off-by: Len Baker <len.baker@gmx.com>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Stable-dep-of: 3d6586008f7b ("drivers/virt/acrn: fix PFNMAP PTE checks in acrn_vm_ram_map()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virt/acrn/acrn_drv.h | 10 ++++++----
 drivers/virt/acrn/mm.c       |  9 ++++-----
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/virt/acrn/acrn_drv.h b/drivers/virt/acrn/acrn_drv.h
index 1be54efa666cb..5663c17ad37c7 100644
--- a/drivers/virt/acrn/acrn_drv.h
+++ b/drivers/virt/acrn/acrn_drv.h
@@ -48,6 +48,7 @@ struct vm_memory_region_op {
  * @reserved:		Reserved.
  * @regions_num:	The number of vm_memory_region_op.
  * @regions_gpa:	Physical address of a vm_memory_region_op array.
+ * @regions_op:		Flexible array of vm_memory_region_op.
  *
  * HC_VM_SET_MEMORY_REGIONS uses this structure to manage EPT mappings of
  * multiple memory regions of a User VM. A &struct vm_memory_region_batch
@@ -55,10 +56,11 @@ struct vm_memory_region_op {
  * ACRN Hypervisor.
  */
 struct vm_memory_region_batch {
-	u16	vmid;
-	u16	reserved[3];
-	u32	regions_num;
-	u64	regions_gpa;
+	u16			   vmid;
+	u16			   reserved[3];
+	u32			   regions_num;
+	u64			   regions_gpa;
+	struct vm_memory_region_op regions_op[];
 };
 
 /**
diff --git a/drivers/virt/acrn/mm.c b/drivers/virt/acrn/mm.c
index 3b1b1e7a844b4..b4ad8d452e9a1 100644
--- a/drivers/virt/acrn/mm.c
+++ b/drivers/virt/acrn/mm.c
@@ -192,7 +192,7 @@ int acrn_vm_ram_map(struct acrn_vm *vm, struct acrn_vm_memmap *memmap)
 
 	/* Get the page number of the map region */
 	nr_pages = memmap->len >> PAGE_SHIFT;
-	pages = vzalloc(nr_pages * sizeof(struct page *));
+	pages = vzalloc(array_size(nr_pages, sizeof(*pages)));
 	if (!pages)
 		return -ENOMEM;
 
@@ -244,16 +244,15 @@ int acrn_vm_ram_map(struct acrn_vm *vm, struct acrn_vm_memmap *memmap)
 	}
 
 	/* Prepare the vm_memory_region_batch */
-	regions_info = kzalloc(sizeof(*regions_info) +
-			       sizeof(*vm_region) * nr_regions,
-			       GFP_KERNEL);
+	regions_info = kzalloc(struct_size(regions_info, regions_op,
+					   nr_regions), GFP_KERNEL);
 	if (!regions_info) {
 		ret = -ENOMEM;
 		goto unmap_kernel_map;
 	}
 
 	/* Fill each vm_memory_region_op */
-	vm_region = (struct vm_memory_region_op *)(regions_info + 1);
+	vm_region = regions_info->regions_op;
 	regions_info->vmid = vm->vmid;
 	regions_info->regions_num = nr_regions;
 	regions_info->regions_gpa = virt_to_phys(vm_region);
-- 
2.43.0



