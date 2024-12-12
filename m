Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2C82F44;
	Thu, 12 Dec 2024 16:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020473; cv=none; b=DVYM/J718DEQn0jTg15GwkOcPkaaPjlrL/6b1o7byrLKjGvGcPVPOgfCY2YP5vQymW9P7f9oX21M7CHwsT26kOLdZCPZUNNh45KkqzhWnJYh4sqioBRxL79qbWLFt/5z92W8gHTkoq8NLlM54mBwznWHOGx00dhAXOcI3gN3GWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020473; c=relaxed/simple;
	bh=YSwQ5Fo8NvrUhyJqOnXGxxVlJH92sDib1H4iG/Ocji0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VTVwBK4x3YO6PKZLl3fI7NcVCgApuKX0pzVC+PbOq+jBBYm9XB/3mNsWryPxDUNHvX5OZ8IfqB/LuL23CJ9XYVBFak17VvhEMymU4JxtAgcjKAdzIPP2J8dmNMNBM3nCZDksmG3K08TEXnGcqLb+XdGd87ffgOp6/S5DnlRyGTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQasToGw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQasToGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53104C4CED3;
	Thu, 12 Dec 2024 16:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020472;
	bh=YSwQ5Fo8NvrUhyJqOnXGxxVlJH92sDib1H4iG/Ocji0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IQasToGwFjU9bJpEJ87kwwzkqxElK08BJuYDTmkBrn2KXvElgMNMIgEL0Aeq/d6az
	 Y+1mfUo3l5CGxrTKmksY7thwYRlkJyCpUp+7ofu3iUCmqkp2/nF1dVawb3ldfyXCX1
	 XsdlC7oRP0/6vbDDvQ2vbxY+Uj1EX4JI9WO+oye4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 475/772] iommu/io-pgtable-arm: Fix stage-2 map/unmap for concatenated tables
Date: Thu, 12 Dec 2024 15:57:00 +0100
Message-ID: <20241212144409.563173934@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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
@@ -180,6 +180,18 @@ static phys_addr_t iopte_to_paddr(arm_lp
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
@@ -357,7 +369,7 @@ static int __arm_lpae_map(struct arm_lpa
 
 	/* If we can install a leaf entry at this level, then do so */
 	if (size == block_size) {
-		max_entries = ARM_LPAE_PTES_PER_TABLE(data) - map_idx_start;
+		max_entries = arm_lpae_max_entries(map_idx_start, data);
 		num_entries = min_t(int, pgcount, max_entries);
 		ret = arm_lpae_init_pte(data, iova, paddr, prot, lvl, num_entries, ptep);
 		if (!ret && mapped)
@@ -564,7 +576,7 @@ static size_t arm_lpae_split_blk_unmap(s
 
 	if (size == split_sz) {
 		unmap_idx_start = ARM_LPAE_LVL_IDX(iova, lvl, data);
-		max_entries = ptes_per_table - unmap_idx_start;
+		max_entries = arm_lpae_max_entries(unmap_idx_start, data);
 		num_entries = min_t(int, pgcount, max_entries);
 	}
 
@@ -622,7 +634,7 @@ static size_t __arm_lpae_unmap(struct ar
 
 	/* If the size matches this level, we're in the right place */
 	if (size == ARM_LPAE_BLOCK_SIZE(lvl, data)) {
-		max_entries = ARM_LPAE_PTES_PER_TABLE(data) - unmap_idx_start;
+		max_entries = arm_lpae_max_entries(unmap_idx_start, data);
 		num_entries = min_t(int, pgcount, max_entries);
 
 		while (i < num_entries) {


