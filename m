Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04062207DFD;
	Fri,  6 Dec 2024 15:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498592; cv=none; b=Q/rWWpRGoM85hzOTDEa1f78LQtnajwZigp5OZwYa1sEwKgr7Px9H2OQTpAk6LW9cieDBXkqfA/kcY3nfsr95lzBTh+3I/C+184EHimd8kwn0ncIKetbG7haeuU2BlHaR4nRrKW4JMJ7pmIbrDCY0MbtlQ+mxFPf8D+hXg2yFowU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498592; c=relaxed/simple;
	bh=fGkR32AMlGpeW2iv5jona6UrSRv0Kwl5jkZBadzztKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBpAlGV1fb510uJRs7cqrFZ/zsNkqKjxCJJ8RxN04kAsibvH8JSkz3NhBtCUt6wd/7ibnShVXQyiCXab9jAa0N9RcWhyVtpYG0g6iWD9nH72ieeB2GRE+dY6Cbu9MNYfQWdramQBVUCaGQB7XhKsxQK7mmgx/aRmxmqsgmfVLTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k3KZS6g9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k3KZS6g9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BF2C4CED1;
	Fri,  6 Dec 2024 15:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498591;
	bh=fGkR32AMlGpeW2iv5jona6UrSRv0Kwl5jkZBadzztKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k3KZS6g97Y1Dk2JyG9iOxDg1roFA5KawuNunTfUstqZEkZYk+cZx2/jEtBfFr3c7/
	 kLx/TR21aGhpeDwRD08zqFeVgDE5/LqodFnWqbnXuCoylO/pqDyz5c0PreSaV65ep4
	 N6KeNGfZc6plZQiXhRalLRxOQGfTAWPjx2hx59z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.6 631/676] iommu/io-pgtable-arm: Fix stage-2 map/unmap for concatenated tables
Date: Fri,  6 Dec 2024 15:37:30 +0100
Message-ID: <20241206143718.014962712@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 		if (!ret)
@@ -557,7 +569,7 @@ static size_t arm_lpae_split_blk_unmap(s
 
 	if (size == split_sz) {
 		unmap_idx_start = ARM_LPAE_LVL_IDX(iova, lvl, data);
-		max_entries = ptes_per_table - unmap_idx_start;
+		max_entries = arm_lpae_max_entries(unmap_idx_start, data);
 		num_entries = min_t(int, pgcount, max_entries);
 	}
 
@@ -615,7 +627,7 @@ static size_t __arm_lpae_unmap(struct ar
 
 	/* If the size matches this level, we're in the right place */
 	if (size == ARM_LPAE_BLOCK_SIZE(lvl, data)) {
-		max_entries = ARM_LPAE_PTES_PER_TABLE(data) - unmap_idx_start;
+		max_entries = arm_lpae_max_entries(unmap_idx_start, data);
 		num_entries = min_t(int, pgcount, max_entries);
 
 		while (i < num_entries) {


