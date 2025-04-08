Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBAB2641CC;
	Tue,  8 Apr 2025 11:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112811; cv=none; b=Y6SYaD111/cyCbbM2HlyapWkk/pgQxBv/Ptl1iVFgTwf7Q0cuU4VPDy3XirGGVA+P/aJj7fuZNxyeFtlVGm6KrpQ8lalLeukOcaJgJ9TbOIFjvs+8DTIyUyrVopGfBqJN3UEVvSUFHxn93JKGu2aGA8zX8fe4cBKcoLz81PBy3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112811; c=relaxed/simple;
	bh=j/tfrOXLtPQI2ELXQdEYDCuD838Ultnwt/2GcBG0nx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jS9By4JuEwxNSUDnM1AsREr5pS6JVY5Fj+pVS7EM5kliTT3wHdT3SUYl50JErlgFe/9GvL4pbYSymIr0IjAWX95yPQiM2AzCCAAGwKeIMMYUo0mrhthTmqi8mENjuGIKFqbSGHXHoGgZg/THlsptuMOrVETVObnv2Lx0GEBoRiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=shkfMDcw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="shkfMDcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C93C4CEE5;
	Tue,  8 Apr 2025 11:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112811;
	bh=j/tfrOXLtPQI2ELXQdEYDCuD838Ultnwt/2GcBG0nx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=shkfMDcwLXnIZLqXJMcmt1rR6M3JWUc8/0oHi9qFcyynIcxDmJfy21KL+kYsx95W9
	 Cl3pithDBoWPyDut7UMdzGMw7Z8NbrOVOWcPt74KbHMyE/iVLSj4Izvz+gv3jc01sg
	 Ra/9btqZT+wfAYlP3F/899+clr/HkCT0YndOaRw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alistair Popple <apopple@nvidia.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Asahi Lina <lina@asahilina.net>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Christoph Hellwig <hch@lst.de>,
	Chunyan Zhang <zhang.lyra@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Ira Weiny <ira.weiny@intel.com>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	linmiaohe <linmiaohe@huawei.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	"Matthew Wilcow (Oracle)" <willy@infradead.org>,
	=?UTF-8?q?Michael=20 Camp=20Drill=20Sergeant =20Ellerman?= <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Ted Tso <tytso@mit.edu>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	WANG Xuerui <kernel@xen0n.name>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 204/279] fuse: fix dax truncate/punch_hole fault path
Date: Tue,  8 Apr 2025 12:49:47 +0200
Message-ID: <20250408104831.844341522@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alistair Popple <apopple@nvidia.com>

[ Upstream commit 7851bf649d423edd7286b292739f2eefded3d35c ]

Patch series "fs/dax: Fix ZONE_DEVICE page reference counts", v9.

Device and FS DAX pages have always maintained their own page reference
counts without following the normal rules for page reference counting.  In
particular pages are considered free when the refcount hits one rather
than zero and refcounts are not added when mapping the page.

Tracking this requires special PTE bits (PTE_DEVMAP) and a secondary
mechanism for allowing GUP to hold references on the page (see
get_dev_pagemap).  However there doesn't seem to be any reason why FS DAX
pages need their own reference counting scheme.

By treating the refcounts on these pages the same way as normal pages we
can remove a lot of special checks.  In particular pXd_trans_huge()
becomes the same as pXd_leaf(), although I haven't made that change here.
It also frees up a valuable SW define PTE bit on architectures that have
devmap PTE bits defined.

It also almost certainly allows further clean-up of the devmap managed
functions, but I have left that as a future improvment.  It also enables
support for compound ZONE_DEVICE pages which is one of my primary
motivators for doing this work.

This patch (of 20):

FS DAX requires file systems to call into the DAX layout prior to
unlinking inodes to ensure there is no ongoing DMA or other remote access
to the direct mapped page.  The fuse file system implements
fuse_dax_break_layouts() to do this which includes a comment indicating
that passing dmap_end == 0 leads to unmapping of the whole file.

However this is not true - passing dmap_end == 0 will not unmap anything
before dmap_start, and further more dax_layout_busy_page_range() will not
scan any of the range to see if there maybe ongoing DMA access to the
range.  Fix this by passing -1 for dmap_end to fuse_dax_break_layouts()
which will invalidate the entire file range to
dax_layout_busy_page_range().

Link: https://lkml.kernel.org/r/cover.8068ad144a7eea4a813670301f4d2a86a8e68ec4.1740713401.git-series.apopple@nvidia.com
Link: https://lkml.kernel.org/r/f09a34b6c40032022e4ddee6fadb7cc676f08867.1740713401.git-series.apopple@nvidia.com
Fixes: 6ae330cad6ef ("virtiofs: serialize truncate/punch_hole and dax fault path")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Co-developed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Asahi Lina <lina@asahilina.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: linmiaohe <linmiaohe@huawei.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michael "Camp Drill Sergeant" Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dax.c  | 1 -
 fs/fuse/dir.c  | 2 +-
 fs/fuse/file.c | 4 ++--
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index 3e7aafe2e9533..d3ebb02626e2f 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -681,7 +681,6 @@ static int __fuse_dax_break_layouts(struct inode *inode, bool *retry,
 			0, 0, fuse_wait_dax_page(inode));
 }
 
-/* dmap_end == 0 leads to unmapping of whole file */
 int fuse_dax_break_layouts(struct inode *inode, u64 dmap_start,
 				  u64 dmap_end)
 {
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 03dadc44e9b1c..1b8bf81d6c16b 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1600,7 +1600,7 @@ int fuse_do_setattr(struct dentry *dentry, struct iattr *attr,
 	if (FUSE_IS_DAX(inode) && is_truncate) {
 		filemap_invalidate_lock(mapping);
 		fault_blocked = true;
-		err = fuse_dax_break_layouts(inode, 0, 0);
+		err = fuse_dax_break_layouts(inode, 0, -1);
 		if (err) {
 			filemap_invalidate_unlock(mapping);
 			return err;
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 8702ef9ff8b9e..40fdb4dac5bbc 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -242,7 +242,7 @@ int fuse_open_common(struct inode *inode, struct file *file, bool isdir)
 
 	if (dax_truncate) {
 		filemap_invalidate_lock(inode->i_mapping);
-		err = fuse_dax_break_layouts(inode, 0, 0);
+		err = fuse_dax_break_layouts(inode, 0, -1);
 		if (err)
 			goto out_inode_unlock;
 	}
@@ -2962,7 +2962,7 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 	inode_lock(inode);
 	if (block_faults) {
 		filemap_invalidate_lock(inode->i_mapping);
-		err = fuse_dax_break_layouts(inode, 0, 0);
+		err = fuse_dax_break_layouts(inode, 0, -1);
 		if (err)
 			goto out;
 	}
-- 
2.39.5



