Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52023DEAED;
	Mon,  4 May 2026 14:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904873; cv=none; b=OqZRphr/+qxAQrSw6mvCRvYdO9fhTHleH1eEhawyvS4PL4g2l27CGOeHV8hTId4nFpEO+gpfrZ5cAuVnndEm9wUh3VITjRzn9AngU3L9vIhJ+oSL1BCNOmUDkRCZcCbuOR+qrWa0BljXXeKqsLC4uhhmTyIyVXRXbQrQD+H7Ig4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904873; c=relaxed/simple;
	bh=4ok1S+vS02XiyJBpsMRXMxLqxZyxmQt6XBZTyZEeJck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRfdmG8E2BNx0ttQQPcCneXajiBEGILADgYluJ4neFGN1+OHqFVBrjSNXmty4z+g8LuqaJz595wLMr+7G77lgBQJvGUyrZGKWNy6EfM0270gCX7YeilN3vjpRmMp4Mmf5es2cPuYwhshLIDUDtJC8VInKOFXrUTV/OR8ocIQwSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zapvcrWg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zapvcrWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B17C2BCB8;
	Mon,  4 May 2026 14:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904873;
	bh=4ok1S+vS02XiyJBpsMRXMxLqxZyxmQt6XBZTyZEeJck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zapvcrWglOpG3miswMLDV0o0idWkXgKEx8kMnokZQES3xK0uDZKPN5rnl9w25U0du
	 P+ZgTIB89O4jyP8ajIkuzeYo83MfZ4QYPE1yut7wItvRlWMWkPbnzXnYjM/TTaoH6u
	 XKVpMW0yENVx+OvqDaoiePCUULbbscd4MdXZGkwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alistair Popple <apopple@nvidia.com>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Balbir Singh <balbirs@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Liam Howlett <liam.howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 175/215] lib: test_hmm: evict device pages on file close to avoid use-after-free
Date: Mon,  4 May 2026 15:53:14 +0200
Message-ID: <20260504135136.589292274@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alistair Popple <apopple@nvidia.com>

[ Upstream commit 744dd97752ef1076a8d8672bb0d8aa2c7abc1144 ]

Patch series "Minor hmm_test fixes and cleanups".

Two bugfixes a cleanup for the HMM kernel selftests.  These were mostly
reported by Zenghui Yu with special thanks to Lorenzo for analysing and
pointing out the problems.

This patch (of 3):

When dmirror_fops_release() is called it frees the dmirror struct but
doesn't migrate device private pages back to system memory first.  This
leaves those pages with a dangling zone_device_data pointer to the freed
dmirror.

If a subsequent fault occurs on those pages (eg.  during coredump) the
dmirror_devmem_fault() callback dereferences the stale pointer causing a
kernel panic.  This was reported [1] when running mm/ksft_hmm.sh on arm64,
where a test failure triggered SIGABRT and the resulting coredump walked
the VMAs faulting in the stale device private pages.

Fix this by calling dmirror_device_evict_chunk() for each devmem chunk in
dmirror_fops_release() to migrate all device private pages back to system
memory before freeing the dmirror struct.  The function is moved earlier
in the file to avoid a forward declaration.

Link: https://lore.kernel.org/20260331063445.3551404-1-apopple@nvidia.com
Link: https://lore.kernel.org/20260331063445.3551404-2-apopple@nvidia.com
Fixes: b2ef9f5a5cb3 ("mm/hmm/test: add selftest driver for HMM")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
Closes: https://lore.kernel.org/linux-mm/8bd0396a-8997-4d2e-a13f-5aac033083d7@linux.dev/
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Tested-by: Zenghui Yu <zenghui.yu@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zenghui Yu <zenghui.yu@linux.dev>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ kept the existing simpler `dmirror_device_evict_chunk()` body instead of the upstream compound-folio version ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/test_hmm.c |   86 ++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 49 insertions(+), 37 deletions(-)

--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -183,11 +183,60 @@ static int dmirror_fops_open(struct inod
 	return 0;
 }
 
+static void dmirror_device_evict_chunk(struct dmirror_chunk *chunk)
+{
+	unsigned long start_pfn = chunk->pagemap.range.start >> PAGE_SHIFT;
+	unsigned long end_pfn = chunk->pagemap.range.end >> PAGE_SHIFT;
+	unsigned long npages = end_pfn - start_pfn + 1;
+	unsigned long i;
+	unsigned long *src_pfns;
+	unsigned long *dst_pfns;
+
+	src_pfns = kvcalloc(npages, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
+	dst_pfns = kvcalloc(npages, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
+
+	migrate_device_range(src_pfns, start_pfn, npages);
+	for (i = 0; i < npages; i++) {
+		struct page *dpage, *spage;
+
+		spage = migrate_pfn_to_page(src_pfns[i]);
+		if (!spage || !(src_pfns[i] & MIGRATE_PFN_MIGRATE))
+			continue;
+
+		if (WARN_ON(!is_device_private_page(spage) &&
+			    !is_device_coherent_page(spage)))
+			continue;
+		spage = BACKING_PAGE(spage);
+		dpage = alloc_page(GFP_HIGHUSER_MOVABLE | __GFP_NOFAIL);
+		lock_page(dpage);
+		copy_highpage(dpage, spage);
+		dst_pfns[i] = migrate_pfn(page_to_pfn(dpage));
+		if (src_pfns[i] & MIGRATE_PFN_WRITE)
+			dst_pfns[i] |= MIGRATE_PFN_WRITE;
+	}
+	migrate_device_pages(src_pfns, dst_pfns, npages);
+	migrate_device_finalize(src_pfns, dst_pfns, npages);
+	kvfree(src_pfns);
+	kvfree(dst_pfns);
+}
+
 static int dmirror_fops_release(struct inode *inode, struct file *filp)
 {
 	struct dmirror *dmirror = filp->private_data;
+	struct dmirror_device *mdevice = dmirror->mdevice;
+	int i;
 
 	mmu_interval_notifier_remove(&dmirror->notifier);
+
+	if (mdevice->devmem_chunks) {
+		for (i = 0; i < mdevice->devmem_count; i++) {
+			struct dmirror_chunk *devmem =
+				mdevice->devmem_chunks[i];
+
+			dmirror_device_evict_chunk(devmem);
+		}
+	}
+
 	xa_destroy(&dmirror->pt);
 	kfree(dmirror);
 	return 0;
@@ -1214,43 +1263,6 @@ static int dmirror_snapshot(struct dmirr
 	return ret;
 }
 
-static void dmirror_device_evict_chunk(struct dmirror_chunk *chunk)
-{
-	unsigned long start_pfn = chunk->pagemap.range.start >> PAGE_SHIFT;
-	unsigned long end_pfn = chunk->pagemap.range.end >> PAGE_SHIFT;
-	unsigned long npages = end_pfn - start_pfn + 1;
-	unsigned long i;
-	unsigned long *src_pfns;
-	unsigned long *dst_pfns;
-
-	src_pfns = kvcalloc(npages, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
-	dst_pfns = kvcalloc(npages, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
-
-	migrate_device_range(src_pfns, start_pfn, npages);
-	for (i = 0; i < npages; i++) {
-		struct page *dpage, *spage;
-
-		spage = migrate_pfn_to_page(src_pfns[i]);
-		if (!spage || !(src_pfns[i] & MIGRATE_PFN_MIGRATE))
-			continue;
-
-		if (WARN_ON(!is_device_private_page(spage) &&
-			    !is_device_coherent_page(spage)))
-			continue;
-		spage = BACKING_PAGE(spage);
-		dpage = alloc_page(GFP_HIGHUSER_MOVABLE | __GFP_NOFAIL);
-		lock_page(dpage);
-		copy_highpage(dpage, spage);
-		dst_pfns[i] = migrate_pfn(page_to_pfn(dpage));
-		if (src_pfns[i] & MIGRATE_PFN_WRITE)
-			dst_pfns[i] |= MIGRATE_PFN_WRITE;
-	}
-	migrate_device_pages(src_pfns, dst_pfns, npages);
-	migrate_device_finalize(src_pfns, dst_pfns, npages);
-	kvfree(src_pfns);
-	kvfree(dst_pfns);
-}
-
 /* Removes free pages from the free list so they can't be re-allocated */
 static void dmirror_remove_free_pages(struct dmirror_chunk *devmem)
 {


