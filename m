Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1413149E0E;
	Fri,  6 Dec 2024 14:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496181; cv=none; b=nXizKdZNeJYmLZrhjGO6Cccfw3DKJMbYUbPG+Iq4Clr8MJ0OLlRulquGBJIGHBY2TkEsMi6YvOPhL1nFIFb/fzCROyAy22O5Zt3k5GsbN+dG9qSS9BHLd094Tpl6oTsOTL3FL1zTOxERylyOhARIlWaUmY8cYQyVX7Mey3WRpQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496181; c=relaxed/simple;
	bh=5L5cC3BTW+MZVYhzjiSd6N/VCSgEgjMb7RKwiHwKWDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtBmMWDjatu4MK6e7U6FYKI4EawbKgxKsSmwV/XPJw/KInLdI3q7IqZS/NjjGzy52WWKp/xhVq8JHmY/Ohgv58RwPTJrSSWjAD7E41M3x9WHoOJXTGHQ/i6pUN2IZyvg0bmAz9Zejrg4t+3+W845IJ1Odf4iznYumAmlI3gJcu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kpq1xboi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kpq1xboi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D993C4CED1;
	Fri,  6 Dec 2024 14:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496180;
	bh=5L5cC3BTW+MZVYhzjiSd6N/VCSgEgjMb7RKwiHwKWDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kpq1xboiRKiZLXhMnb4zswd36IzILec0sqRLdwib37EjlzwZJPoqYZD7l6/Q6zeP3
	 YUts+mdIau6T4EKJwwFMZ3RfcbfNWTYDaaac3C+adTG+wUIeN9iIpLADQHCMdUNsHg
	 0bdVmIs3IjSTRmwMgsFugo7bBYkvN+Ux3S2/WVHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 048/146] iommu/io-pgtable-arm: Fix stage-2 map/unmap for concatenated tables
Date: Fri,  6 Dec 2024 15:36:19 +0100
Message-ID: <20241206143529.514473676@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mostafa Saleh <smostafa@google.com>

commit d71fa842d33c48ac2809ae11d2379b5a788792cb upstream.

ARM_LPAE_LVL_IDX() takes into account concatenated PGDs and can return
an index spanning multiple page-table pages given a sufficiently large
input address. However, when the resulting index is used to calculate
the number of remaining entries in the page, the possibility of
concatenation is ignored and we end up computing a negative upper bound:

	max_entries = ARM_LPAE_PTES_PER_TABLE(data) - map_idx_start;

On the map path, this results in a negative 'mapped' value being
returned but on the unmap path we can leak child tables if they are
skipped in __arm_lpae_free_pgtable().

Introduce an arm_lpae_max_entries() helper to convert a table index into
the remaining number of entries within a single page-table page.

Cc: <stable@vger.kernel.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
Link: https://lore.kernel.org/r/20241024162516.2005652-2-smostafa@google.com
[will: Tweaked comment and commit message]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/io-pgtable-arm.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -199,6 +199,18 @@ static phys_addr_t iopte_to_paddr(arm_lp
 	return (paddr | (paddr << (48 - 12))) & (ARM_LPAE_PTE_ADDR_MASK << 4);
 }
 
+/*
+ * Convert an index returned by ARM_LPAE_PGD_IDX(), which can point into
+ * a concatenated PGD, into the maximum number of entries that can be
+ * mapped in the same table page.
+ */
+static inline int arm_lpae_max_entries(int i, struct arm_lpae_io_pgtable *data)
+{
+	int ptes_per_table = ARM_LPAE_PTES_PER_TABLE(data);
+
+	return ptes_per_table - (i & (ptes_per_table - 1));
+}
+
 static bool selftest_running = false;
 
 static dma_addr_t __arm_lpae_dma_addr(void *pages)
@@ -390,7 +402,7 @@ static int __arm_lpae_map(struct arm_lpa
 
 	/* If we can install a leaf entry at this level, then do so */
 	if (size == block_size) {
-		max_entries = ARM_LPAE_PTES_PER_TABLE(data) - map_idx_start;
+		max_entries = arm_lpae_max_entries(map_idx_start, data);
 		num_entries = min_t(int, pgcount, max_entries);
 		ret = arm_lpae_init_pte(data, iova, paddr, prot, lvl, num_entries, ptep);
 		if (!ret)
@@ -592,7 +604,7 @@ static size_t arm_lpae_split_blk_unmap(s
 
 	if (size == split_sz) {
 		unmap_idx_start = ARM_LPAE_LVL_IDX(iova, lvl, data);
-		max_entries = ptes_per_table - unmap_idx_start;
+		max_entries = arm_lpae_max_entries(unmap_idx_start, data);
 		num_entries = min_t(int, pgcount, max_entries);
 	}
 
@@ -650,7 +662,7 @@ static size_t __arm_lpae_unmap(struct ar
 
 	/* If the size matches this level, we're in the right place */
 	if (size == ARM_LPAE_BLOCK_SIZE(lvl, data)) {
-		max_entries = ARM_LPAE_PTES_PER_TABLE(data) - unmap_idx_start;
+		max_entries = arm_lpae_max_entries(unmap_idx_start, data);
 		num_entries = min_t(int, pgcount, max_entries);
 
 		/* Find and handle non-leaf entries */


