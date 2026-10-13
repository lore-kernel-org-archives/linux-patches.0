Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7832D3E5EF8;
	Tue, 13 Oct 2026 12:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893277; cv=none; b=MDOnhKvrayPKBvSXEAIsopsO1eDzJSAGqWzLebtI4PXUaSSl8YvZsYVBTnjXPdcQbKdR1GIZ84YoSiiDI8DeXH6jwgLu0moiVdj4nwF6oJYJ3xDO6meEtP8Ouk5zoSrEN2VJRZ4Qb7hdShDq52D4NVUeZiipxVA1Rd95O/1iWf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893277; c=relaxed/simple;
	bh=Sz7xi1AKCKnneXU8FKZZjb4ix6iuhESfaFIbbx6oEpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OsEGfjcgoH91ERZtVUbSSg/KsfrhMDZkrA3TQzAg1wnaU0LJmbVZBTX0Dm971v+YxCSL3jGrUFydam6CtUybAsxk29kFTAs2XWnppZCkkVcLranyyTTJxlSOCrDjerflbU8fVtjul27Mqd12lxdHmqrEzQsXvNlclRYIWyaEFHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+cM5NyM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+cM5NyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84711F000FF;
	Tue, 13 Oct 2026 12:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893276;
	bh=0t0NsgaFGNGuqQ0yrysXaN1ckf8r8BpCO699BhBQdpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+cM5NyMpapqOxwydsXobYOdGuh1FkDDDoKAJO14UjKAyaZkpBzH1l0vC8cAq0bRe
	 LmRstES2YvDRA6hY/ctQWDTnQnfWqlVdj9aTxgx0gj9J7p+88h+pFS6YuOd1HWsupC
	 dOP/ltPHwLW5pP5IhlNREhFAXLCepaz7mplGk8bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>,
	Nuno Das Neves <nunodasneves@linux.microsoft.com>,
	"Anirudh Rayabharam (Microsoft)" <anirudh@anirudhrb.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 173/621] mshv: Refactor and rename memory region handling functions
Date: Tue, 13 Oct 2026 13:32:48 +0200
Message-ID: <20261013112924.969010181@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>

[ Upstream commit df4ff5f6cf7864714d66c65ec7df582240a596a4 ]

Simplify and unify memory region management to improve code clarity and
reliability. Consolidate pinning and invalidation logic, adopt consistent
naming, and remove redundant checks to reduce complexity.

Enhance documentation and update call sites for maintainability.

Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Reviewed-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>
Reviewed-by: Anirudh Rayabharam (Microsoft) <anirudh@anirudhrb.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Stable-dep-of: c0e296f25767 ("mshv: Fix error handling in mshv_region_pin")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/mshv_root_main.c | 80 +++++++++++++++++--------------------
 1 file changed, 36 insertions(+), 44 deletions(-)

diff --git a/drivers/hv/mshv_root_main.c b/drivers/hv/mshv_root_main.c
index 3a356b34774bd..20e9528110e89 100644
--- a/drivers/hv/mshv_root_main.c
+++ b/drivers/hv/mshv_root_main.c
@@ -1094,8 +1094,8 @@ mshv_region_map(struct mshv_mem_region *region)
 }
 
 static void
-mshv_region_evict_pages(struct mshv_mem_region *region,
-			u64 page_offset, u64 page_count)
+mshv_region_invalidate_pages(struct mshv_mem_region *region,
+			     u64 page_offset, u64 page_count)
 {
 	if (region->flags.range_pinned)
 		unpin_user_pages(region->pages + page_offset, page_count);
@@ -1105,29 +1105,24 @@ mshv_region_evict_pages(struct mshv_mem_region *region,
 }
 
 static void
-mshv_region_evict(struct mshv_mem_region *region)
+mshv_region_invalidate(struct mshv_mem_region *region)
 {
-	mshv_region_evict_pages(region, 0, region->nr_pages);
+	mshv_region_invalidate_pages(region, 0, region->nr_pages);
 }
 
 static int
-mshv_region_populate_pages(struct mshv_mem_region *region,
-			   u64 page_offset, u64 page_count)
+mshv_region_pin(struct mshv_mem_region *region)
 {
 	u64 done_count, nr_pages;
 	struct page **pages;
 	__u64 userspace_addr;
 	int ret;
 
-	if (page_offset + page_count > region->nr_pages)
-		return -EINVAL;
-
-	for (done_count = 0; done_count < page_count; done_count += ret) {
-		pages = region->pages + page_offset + done_count;
+	for (done_count = 0; done_count < region->nr_pages; done_count += ret) {
+		pages = region->pages + done_count;
 		userspace_addr = region->start_uaddr +
-				(page_offset + done_count) *
-				HV_HYP_PAGE_SIZE;
-		nr_pages = min(page_count - done_count,
+				 done_count * HV_HYP_PAGE_SIZE;
+		nr_pages = min(region->nr_pages - done_count,
 			       MSHV_PIN_PAGES_BATCH_SIZE);
 
 		/*
@@ -1138,34 +1133,23 @@ mshv_region_populate_pages(struct mshv_mem_region *region,
 		 * with the FOLL_LONGTERM flag does a large temporary
 		 * allocation of contiguous memory.
 		 */
-		if (region->flags.range_pinned)
-			ret = pin_user_pages_fast(userspace_addr,
-						  nr_pages,
-						  FOLL_WRITE | FOLL_LONGTERM,
-						  pages);
-		else
-			ret = -EOPNOTSUPP;
-
+		ret = pin_user_pages_fast(userspace_addr, nr_pages,
+					  FOLL_WRITE | FOLL_LONGTERM,
+					  pages);
 		if (ret < 0)
 			goto release_pages;
 	}
 
-	if (PageHuge(region->pages[page_offset]))
+	if (PageHuge(region->pages[0]))
 		region->flags.large_pages = true;
 
 	return 0;
 
 release_pages:
-	mshv_region_evict_pages(region, page_offset, done_count);
+	mshv_region_invalidate_pages(region, 0, done_count);
 	return ret;
 }
 
-static int
-mshv_region_populate(struct mshv_mem_region *region)
-{
-	return mshv_region_populate_pages(region, 0, region->nr_pages);
-}
-
 static struct mshv_mem_region *
 mshv_partition_region_by_gfn(struct mshv_partition *partition, u64 gfn)
 {
@@ -1229,19 +1213,27 @@ static int mshv_partition_create_region(struct mshv_partition *partition,
 	return 0;
 }
 
-/*
- * Map guest ram. if snp, make sure to release that from the host first
- * Side Effects: In case of failure, pages are unpinned when feasible.
+/**
+ * mshv_prepare_pinned_region - Pin and map memory regions
+ * @region: Pointer to the memory region structure
+ *
+ * This function processes memory regions that are explicitly marked as pinned.
+ * Pinned regions are preallocated, mapped upfront, and do not rely on fault-based
+ * population. The function ensures the region is properly populated, handles
+ * encryption requirements for SNP partitions if applicable, maps the region,
+ * and performs necessary sharing or eviction operations based on the mapping
+ * result.
+ *
+ * Return: 0 on success, negative error code on failure.
  */
-static int
-mshv_partition_mem_region_map(struct mshv_mem_region *region)
+static int mshv_prepare_pinned_region(struct mshv_mem_region *region)
 {
 	struct mshv_partition *partition = region->partition;
 	int ret;
 
-	ret = mshv_region_populate(region);
+	ret = mshv_region_pin(region);
 	if (ret) {
-		pt_err(partition, "Failed to populate memory region: %d\n",
+		pt_err(partition, "Failed to pin memory region: %d\n",
 		       ret);
 		goto err_out;
 	}
@@ -1259,7 +1251,7 @@ mshv_partition_mem_region_map(struct mshv_mem_region *region)
 			pt_err(partition,
 			       "Failed to unshare memory region (guest_pfn: %llu): %d\n",
 			       region->start_gfn, ret);
-			goto evict_region;
+			goto invalidate_region;
 		}
 	}
 
@@ -1269,7 +1261,7 @@ mshv_partition_mem_region_map(struct mshv_mem_region *region)
 
 		shrc = mshv_partition_region_share(region);
 		if (!shrc)
-			goto evict_region;
+			goto invalidate_region;
 
 		pt_err(partition,
 		       "Failed to share memory region (guest_pfn: %llu): %d\n",
@@ -1283,8 +1275,8 @@ mshv_partition_mem_region_map(struct mshv_mem_region *region)
 
 	return 0;
 
-evict_region:
-	mshv_region_evict(region);
+invalidate_region:
+	mshv_region_invalidate(region);
 err_out:
 	return ret;
 }
@@ -1333,7 +1325,7 @@ mshv_map_user_memory(struct mshv_partition *partition,
 		ret = hv_call_map_mmio_pages(partition->pt_id, mem.guest_pfn,
 					     mmio_pfn, HVPFN_DOWN(mem.size));
 	else
-		ret = mshv_partition_mem_region_map(region);
+		ret = mshv_prepare_pinned_region(region);
 
 	if (ret)
 		goto errout;
@@ -1378,7 +1370,7 @@ mshv_unmap_user_memory(struct mshv_partition *partition,
 	hv_call_unmap_gpa_pages(partition->pt_id, region->start_gfn,
 				region->nr_pages, unmap_flags);
 
-	mshv_region_evict(region);
+	mshv_region_invalidate(region);
 
 	vfree(region);
 	return 0;
@@ -1792,7 +1784,7 @@ static void destroy_partition(struct mshv_partition *partition)
 			}
 		}
 
-		mshv_region_evict(region);
+		mshv_region_invalidate(region);
 
 		vfree(region);
 	}
-- 
2.53.0



