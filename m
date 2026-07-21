Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411953FFF82;
	Tue, 21 Jul 2026 17:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654338; cv=none; b=rqUgElfDmqGEONfxe0WEfe9D1WBolR8eZmYM/mETwlK3EDqUw7w5z80y1OxW4xY67hoyLBdC4Q4rOwKUVr5KjPH1qHPB4wrPXc+WB3LFL1AQ+RlFn54meB4Dm0lgwVcrGavzRD3Fl9tigZaZd7ZHqAtEYwoR8lgpLZ+j1mxBcJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654338; c=relaxed/simple;
	bh=IPnUnHIADntxH2BYTK0Ya38Ji0+uXwBROZZPhT1guTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JECIB9qTJifDiGYM42/ZpraxrT60ggpo/VKpTaHvCYyZ10xI0nq6O4CUocUY9aDO5qAQK1SQ2L8IN/FW9k/B+NjBTupRQaNyh9WEXGpuBiBu02blvgjx/4nRxWxSIcMOVzP09nAti1kEz+blEN7McY6qGuZzFUoBrRk2ubCtqiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vAPUXU73; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vAPUXU73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FAB51F00A3A;
	Tue, 21 Jul 2026 17:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654330;
	bh=oQ8tT4oM0xXelwI+t5R+u7mIrbcymzkF+b/FbG7/bo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vAPUXU73MnY4HoLi/tL2YP4ZA9lG+AxDeWEwwzzewdYsfC1w4Ns9Hsw8f2FDp09bN
	 B0KR7Jviprk7CkhPKAeqa2xm8wG53oAMEKzISk7+Q82+3DSnYvLGuhEqE9evAUn8/3
	 7b/h3HUxf1bLi8rYPtLPOOHZLUrpYSqaSHcWD51Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	John Olender <john.olender@gmail.com>,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Subject: [PATCH 7.1 1620/2077] gpu/buddy: bail out of try_harder when alignment cannot be honoured
Date: Tue, 21 Jul 2026 17:21:33 +0200
Message-ID: <20260721152630.970744525@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>

commit 56bc6384314fb9ae98975fb2af8b143097ede3dc upstream.

The try_harder contiguous fallback could return a range whose start
offset did not match the caller's min_block_size. When a candidate's
start is misaligned, realign it: free the misaligned run and reallocate
exactly @size at the next lower min_block_size boundary. This keeps the
returned size unchanged with no surplus to trim, and rejects the request
only when no aligned candidate fits.

v2: align misaligned candidates down to min_block_size instead of
    bailing out, for both the RHS and LHS paths (Matthew).

Fixes: 0a1844bf0b53 ("drm/buddy: Improve contiguous memory allocation")
Suggested-by: Christian König <christian.koenig@amd.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Timur Kristóf <timur.kristof@gmail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Tested-by: John Olender <john.olender@gmail.com>
Signed-off-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Link: https://patch.msgid.link/20260709131050.1022759-1-Arunpravin.PaneerSelvam@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/buddy.c |   65 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 45 insertions(+), 20 deletions(-)

--- a/drivers/gpu/buddy.c
+++ b/drivers/gpu/buddy.c
@@ -1078,22 +1078,30 @@ static int __gpu_buddy_alloc_range(struc
 			     blocks, total_allocated_on_err);
 }
 
+static int __alloc_contig_aligned_retry(struct gpu_buddy *mm,
+					u64 unaligned_offset,
+					u64 size,
+					u64 min_block_size,
+					struct list_head *blocks)
+{
+	u64 aligned_offset = round_down(unaligned_offset, min_block_size);
+
+	return __gpu_buddy_alloc_range(mm, aligned_offset, size, NULL, blocks);
+}
+
 static int __alloc_contig_try_harder(struct gpu_buddy *mm,
 				     u64 size,
 				     u64 min_block_size,
 				     struct list_head *blocks)
 {
-	u64 rhs_offset, lhs_offset, lhs_size, filled;
+	u64 rhs_offset, lhs_offset, filled;
 	struct gpu_buddy_block *block;
 	unsigned int tree, order;
-	LIST_HEAD(blocks_lhs);
-	unsigned long pages;
 	u64 modify_size;
 	int err;
 
 	modify_size = rounddown_pow_of_two(size);
-	pages = modify_size >> ilog2(mm->chunk_size);
-	order = fls(pages) - 1;
+	order = ilog2(modify_size) - ilog2(mm->chunk_size);
 	if (order == 0)
 		return -ENOSPC;
 
@@ -1109,31 +1117,48 @@ static int __alloc_contig_try_harder(str
 		while (iter) {
 			block = rbtree_get_free_block(iter);
 
-			/* Allocate blocks traversing RHS */
 			rhs_offset = gpu_buddy_block_offset(block);
+
+			/* Allocate blocks traversing RHS */
 			err =  __gpu_buddy_alloc_range(mm, rhs_offset, size,
 						       &filled, blocks);
-			if (!err || err != -ENOSPC)
+			if (err && err != -ENOSPC)
 				return err;
-
-			lhs_size = max((size - filled), min_block_size);
-			if (!IS_ALIGNED(lhs_size, min_block_size))
-				lhs_size = round_up(lhs_size, min_block_size);
-
-			/* Allocate blocks traversing LHS */
-			lhs_offset = gpu_buddy_block_offset(block) - lhs_size;
-			err =  __gpu_buddy_alloc_range(mm, lhs_offset, lhs_size,
-						       NULL, &blocks_lhs);
+			if (!err && IS_ALIGNED(rhs_offset, min_block_size))
+				return 0;
 			if (!err) {
-				list_splice(&blocks_lhs, blocks);
+				/* Allocate the unaligned RHS offset using round_down */
+				gpu_buddy_free_list_internal(mm, blocks);
+				err = __alloc_contig_aligned_retry(mm, rhs_offset,
+								   size,
+								   min_block_size,
+								   blocks);
+				if (!err)
+					return 0;
+				if (err != -ENOSPC) {
+					gpu_buddy_free_list_internal(mm, blocks);
+					return err;
+				}
+				goto next;
+			}
+
+			if (size - filled > rhs_offset)
+				goto next;
+
+			lhs_offset = rhs_offset - (size - filled);
+
+			/* Allocate the unaligned LHS offset using round_down */
+			gpu_buddy_free_list_internal(mm, blocks);
+			err = __alloc_contig_aligned_retry(mm, lhs_offset, size,
+							   min_block_size, blocks);
+			if (!err)
 				return 0;
-			} else if (err != -ENOSPC) {
+			if (err != -ENOSPC) {
 				gpu_buddy_free_list_internal(mm, blocks);
 				return err;
 			}
-			/* Free blocks for the next iteration */
+next:
 			gpu_buddy_free_list_internal(mm, blocks);
-
 			iter = rb_prev(iter);
 		}
 	}


