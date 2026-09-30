Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F07C3515DC;
	Wed, 30 Sep 2026 18:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793385; cv=none; b=NVpV2uYMUr4kIiPLj0PKm3/ZPv5XNFqZpuiZ9OG+aKScC1tociz6mMO3k7eCLV3ltEihk3U6pkSamrngXsoTwcM1q3nLkZzO8LFA0+1i5u5XvAZosNRU80L1HcjNuHSbWG+21+wkv7sVl5w36FnygpR7LTQCVHQTABEcWApculI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793385; c=relaxed/simple;
	bh=dr4ciy3dcXsBGJ1GxQOSnq24bd8UaznqosfgYHYBykU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=esWp3NhihNtkc2EOrNWQ5L8Y1SMApzrrm89z4Xi3k+r2pQNeUh/fmEITp653XhqNg+e7xRUWnVpDC3OyM7+EPNBS8n4K5gqPbOVVIlFedYYqewVOlyVAUUX1S/ERhqF6Al3SpG9tUAfnYCFDvpQ9x5Q6ltsZRZb1b2tOE9Zs9aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XaJMyomx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XaJMyomx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839A01F00899;
	Wed, 30 Sep 2026 18:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793384;
	bh=FKqB8H+CefqadP7+wdaux4aZRyJaLY0Bz9UPjvZma8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XaJMyomxZkm5NCqnV7ziVJhDWqtJiF4ryMQ44oMH2PkyFiLI6iKy4OUFeGGItZ/tj
	 Hp7jdrEOFu0SzdSBH2eP4zwtNWdTHI7nBiB0YKn5aM776B85qVGk6KVgPRM47wDmsP
	 L73NK/OsivzogV1OcPfaYBnyqVTmK9KHs+nee6rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandru Dadu <alexandru.dadu@imgtec.com>,
	Alessio Belle <alessio.belle@imgtec.com>,
	Brajesh Gupta <brajesh.gupta@imgtec.com>
Subject: [PATCH 6.18 237/395] drm/imagination: Fix page count for page table for map() interface
Date: Wed, 30 Sep 2026 17:28:19 +0200
Message-ID: <20260930152345.801870778@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brajesh Gupta <brajesh.gupta@imgtec.com>

commit 0a8224058a5835297dcf4a46bbcd16f77a9fe424 upstream.

The GPU virtual start address wasn't included in the calculation for the
amount of page tables required for mapping a BO object in map() interface.
It resulted in map failure later due to not enough pages at L0/L1 level.
Update pvr_mmu_op_context_create() interface to pass device address as well
to allow correct calculation for page table memory.

If L0 tables cover 2MB (0x200000), the range defined by device address
0x80001ff000 (general heap at 2MB - 4KB) and size 0x2000 (two 4KB pages)
requires two L0 pages to be mapped, but without the base
address a range of 0x2000 computes to a single L0 page which is not enough.

Fixes: ff5f643de0bf ("drm/imagination: Add GEM and VM related code")
Reviewed-by: Alexandru Dadu <alexandru.dadu@imgtec.com>
Reviewed-by: Alessio Belle <alessio.belle@imgtec.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260922-mmu_fix-v4-2-12f1a871456a@imgtec.com
Signed-off-by: Brajesh Gupta <brajesh.gupta@imgtec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/imagination/pvr_mmu.c |   14 ++++++++------
 drivers/gpu/drm/imagination/pvr_mmu.h |    2 +-
 drivers/gpu/drm/imagination/pvr_vm.c  |    4 ++--
 3 files changed, 11 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/imagination/pvr_mmu.c
+++ b/drivers/gpu/drm/imagination/pvr_mmu.c
@@ -2338,6 +2338,7 @@ void pvr_mmu_op_context_destroy(struct p
  * pvr_mmu_op_context_create() - Create an MMU op context.
  * @ctx: MMU context associated with owning VM context.
  * @sgt: Scatter gather table containing pages pinned for use by this context.
+ * @device_addr: Virtual device address at the start of the requested mapping.
  * @sgt_offset: Start offset of the requested device-virtual memory mapping.
  * @size: Size in bytes of the requested device-virtual memory mapping. For an
  * unmapping, this should be zero so that no page tables are allocated.
@@ -2349,8 +2350,9 @@ void pvr_mmu_op_context_destroy(struct p
  */
 struct pvr_mmu_op_context *
 pvr_mmu_op_context_create(struct pvr_mmu_context *ctx, struct sg_table *sgt,
-			  u64 sgt_offset, u64 size)
+			  u64 device_addr, u64 sgt_offset, u64 size)
 {
+	u64 start_addr = device_addr + sgt_offset;
 	int err;
 
 	struct pvr_mmu_op_context *op_ctx =
@@ -2367,16 +2369,16 @@ pvr_mmu_op_context_create(struct pvr_mmu
 	if (size) {
 		/*
 		 * The number of page table objects we need to prealloc is
-		 * indicated by the mapping size, start offset and the sizes
+		 * indicated by the mapping size, start address and the sizes
 		 * of the areas mapped per PT or PD. The range calculation is
 		 * identical to that for the index into a table for a device
 		 * address, so we reuse those functions here.
 		 */
-		const u32 l1_start_idx = pvr_page_table_l2_idx(sgt_offset);
-		const u32 l1_end_idx = pvr_page_table_l2_idx(sgt_offset + size);
+		const u32 l1_start_idx = pvr_page_table_l2_idx(start_addr);
+		const u32 l1_end_idx = pvr_page_table_l2_idx(start_addr + size);
 		const u32 l1_count = l1_end_idx - l1_start_idx + 1;
-		const u32 l0_start_idx = pvr_page_table_l1_idx(sgt_offset);
-		const u32 l0_end_idx = pvr_page_table_l1_idx(sgt_offset + size);
+		const u32 l0_start_idx = pvr_page_table_l1_idx(start_addr);
+		const u32 l0_end_idx = pvr_page_table_l1_idx(start_addr + size);
 		const u32 l0_count = l0_end_idx - l0_start_idx + 1;
 
 		/*
--- a/drivers/gpu/drm/imagination/pvr_mmu.h
+++ b/drivers/gpu/drm/imagination/pvr_mmu.h
@@ -99,7 +99,7 @@ dma_addr_t pvr_mmu_get_root_table_dma_ad
 void pvr_mmu_op_context_destroy(struct pvr_mmu_op_context *op_ctx);
 struct pvr_mmu_op_context *
 pvr_mmu_op_context_create(struct pvr_mmu_context *ctx,
-			  struct sg_table *sgt, u64 sgt_offset, u64 size);
+			  struct sg_table *sgt, u64 device_addr, u64 sgt_offset, u64 size);
 
 int pvr_mmu_map(struct pvr_mmu_op_context *op_ctx, u64 size, u64 flags,
 		u64 device_addr);
--- a/drivers/gpu/drm/imagination/pvr_vm.c
+++ b/drivers/gpu/drm/imagination/pvr_vm.c
@@ -275,7 +275,7 @@ pvr_vm_bind_op_map_init(struct pvr_vm_bi
 		goto err_bind_op_fini;
 
 	bind_op->mmu_op_ctx =
-		pvr_mmu_op_context_create(vm_ctx->mmu_ctx, sgt, offset, size);
+		pvr_mmu_op_context_create(vm_ctx->mmu_ctx, sgt, device_addr, offset, size);
 	err = PTR_ERR_OR_ZERO(bind_op->mmu_op_ctx);
 	if (err) {
 		bind_op->mmu_op_ctx = NULL;
@@ -317,7 +317,7 @@ pvr_vm_bind_op_unmap_init(struct pvr_vm_
 	}
 
 	bind_op->mmu_op_ctx =
-		pvr_mmu_op_context_create(vm_ctx->mmu_ctx, NULL, 0, 0);
+		pvr_mmu_op_context_create(vm_ctx->mmu_ctx, NULL, device_addr, 0, 0);
 	err = PTR_ERR_OR_ZERO(bind_op->mmu_op_ctx);
 	if (err) {
 		bind_op->mmu_op_ctx = NULL;


