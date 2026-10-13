Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8C64F390D;
	Tue, 13 Oct 2026 11:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892436; cv=none; b=V1Mq1WdZODSQTtLQHH5cJlF7Wvi5UbeKGQkMkjTk1cpCUcjVQFjdcC6tmuqqpZLX59IiE9xwgNhZmlbZUCwvHBqLcr5BxpyricvM4hnS6UIY2PWfvo3Eew1G8WxtsPWpsWv/EEuyysJc6DUK3Jduj7bK/xFUEUCFoCmBk8Ax3js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892436; c=relaxed/simple;
	bh=0NgRH43h6LlcA1uECk0dC2VSWbC8xqWy7iOzhhoqNhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uh6JBFwED42VnnOK8B4+//aaQwXVFuMwfkY2cTXq2KyRSCYHq8YBpyO7gOJO9HncWfQ3HgyhwBwbeQFdQWMvlyWPEt1xhaBXjMoXDOTEMy5VI8oGaWS7WsZg5ct2S3WgPeDgvXRGOYIM3efzq6RcqE70otCkl99gq7JET7cSPbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=diNWZUo0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="diNWZUo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E211F000FF;
	Tue, 13 Oct 2026 11:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892434;
	bh=uJ4hbwS0OdFmCDJ1AnQm2aYO7ApA4mUyRXdNpyKKaHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=diNWZUo0o/v67YikqrT587+L26zTTsvvroxDBY9MxHMkTn+caHL7jaGKdW7pYFcy8
	 sFUXXW3M4adl7dAs9rkdvWLCoXCTSKP/LzgKwo8aZpdBx2mmBDZGK8DsT+ehvY10R+
	 yD16+ctUr++vnav+lCu7FqrNjClD70a16hQMld1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gyeyoung Baek <gye976@gmail.com>,
	Brajesh Gupta <brajesh.gupta@imgtec.com>,
	Alessio Belle <alessio.belle@imgtec.com>
Subject: [PATCH 7.2 128/281] drm/imagination: Size page table preallocation by device address
Date: Tue, 13 Oct 2026 13:37:24 +0200
Message-ID: <20261013112858.257421048@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gyeyoung Baek <gye976@gmail.com>

commit 789f290b2e81d42820bddcb4010ffbc2ae2ded54 upstream.

Commit 0a8224058a58 ("drm/imagination: Fix page count for page table for
map() interface") passed the device address to
pvr_mmu_op_context_create(), but the preallocation is still sized from
device_addr + sgt_offset with an exclusive end. The offset into the
object's pages has no place in a device-virtual range, and the exclusive
end allocates one table too many when the range ends on a table
boundary.

Count the tables from device_addr and the inclusive end of the range.

The new calculation does not take page table indices into account. This
fixes another issue with the previous implementation, where the
difference between start and end indices could underflow when a mapping
crossed a page table boundary. This would lead to the driver
preallocating a huge number of MMU pages, exhausting system memory and
triggering an out of memory panic.

Fixes: 0a8224058a58 ("drm/imagination: Fix page count for page table for map() interface")
Fixes: ff5f643de0bf ("drm/imagination: Add GEM and VM related code")
Signed-off-by: Gyeyoung Baek <gye976@gmail.com>
Reviewed-by: Brajesh Gupta <brajesh.gupta@imgtec.com>
Reviewed-by: Alessio Belle <alessio.belle@imgtec.com>
Cc: stable@vger.kernel.org
[Alessio: add paragraph to point out OOM bug being fixed, cc stable]
Link: https://patch.msgid.link/20261001-pvr-fixes-a-v2-2-f58254e5dfb8@gmail.com
Signed-off-by: Alessio Belle <alessio.belle@imgtec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/imagination/pvr_mmu.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

--- a/drivers/gpu/drm/imagination/pvr_mmu.c
+++ b/drivers/gpu/drm/imagination/pvr_mmu.c
@@ -2337,7 +2337,7 @@ void pvr_mmu_op_context_destroy(struct p
  * @ctx: MMU context associated with owning VM context.
  * @sgt: Scatter gather table containing pages pinned for use by this context.
  * @device_addr: Virtual device address at the start of the requested mapping.
- * @sgt_offset: Start offset of the requested device-virtual memory mapping.
+ * @sgt_offset: Offset into @sgt of the start of the requested mapping.
  * @size: Size in bytes of the requested device-virtual memory mapping. For an
  * unmapping, this should be zero so that no page tables are allocated.
  *
@@ -2350,7 +2350,6 @@ struct pvr_mmu_op_context *
 pvr_mmu_op_context_create(struct pvr_mmu_context *ctx, struct sg_table *sgt,
 			  u64 device_addr, u64 sgt_offset, u64 size)
 {
-	u64 start_addr = device_addr + sgt_offset;
 	int err;
 
 	struct pvr_mmu_op_context *op_ctx = kzalloc_obj(*op_ctx);
@@ -2365,18 +2364,18 @@ pvr_mmu_op_context_create(struct pvr_mmu
 
 	if (size) {
 		/*
-		 * The number of page table objects we need to prealloc is
-		 * indicated by the mapping size, start address and the sizes
-		 * of the areas mapped per PT or PD. The range calculation is
-		 * identical to that for the index into a table for a device
-		 * address, so we reuse those functions here.
+		 * The page tables needed are set by the device-virtual range
+		 * being mapped: one level 1 table per 1GiB region and one
+		 * level 0 table per 2MiB region the range touches. Tables that
+		 * already exist are not consumed, so this is an upper bound.
 		 */
-		const u32 l1_start_idx = pvr_page_table_l2_idx(start_addr);
-		const u32 l1_end_idx = pvr_page_table_l2_idx(start_addr + size);
-		const u32 l1_count = l1_end_idx - l1_start_idx + 1;
-		const u32 l0_start_idx = pvr_page_table_l1_idx(start_addr);
-		const u32 l0_end_idx = pvr_page_table_l1_idx(start_addr + size);
-		const u32 l0_count = l0_end_idx - l0_start_idx + 1;
+		const u64 last_addr = device_addr + size - 1;
+		const u64 l1_count =
+			(last_addr >> ROGUE_MMUCTRL_VADDR_PC_INDEX_SHIFT) -
+			(device_addr >> ROGUE_MMUCTRL_VADDR_PC_INDEX_SHIFT) + 1;
+		const u64 l0_count =
+			(last_addr >> ROGUE_MMUCTRL_VADDR_PD_INDEX_SHIFT) -
+			(device_addr >> ROGUE_MMUCTRL_VADDR_PD_INDEX_SHIFT) + 1;
 
 		/*
 		 * Alloc and push page table entries until we have enough of


