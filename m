Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285A21AB6FC;
	Mon, 14 Oct 2024 15:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918714; cv=none; b=BjEge144dEFp4FpReZ156J4g0tLHw68rvDmP38XtRC807RgcHap37/6q6WK10E9/2jag1QDX82vW+bqOrZJlFBKAmut+Dk9d9uEJszyQh1NjgD+Tj1idHoV4gYldZ0DxpHBUJPVRrFZ1sWyHiToiNaL4AZVmjyuZ4B5Rc3qFnNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918714; c=relaxed/simple;
	bh=UxDW5M3YAYv02NrJp4hDCwR3bONhrHA8w2wyLuM6NuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T33DIkKCNVDeXeiivOZqCnoLitOwlhpLtxj5FkjYYCesFmiJN2GkU65QnIJ3+0IWQTJ+JcU5xUFb38IUEvxHd6fspBoG5GaMd1WuU+I68g/zdWEDdG1PPXHr3FYUs5c3kJQcwgFP2wcrDwX8WuQMw095FY6YDPU6okDqSyJenew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/FMbKGt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/FMbKGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7C2C4CEC3;
	Mon, 14 Oct 2024 15:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918714;
	bh=UxDW5M3YAYv02NrJp4hDCwR3bONhrHA8w2wyLuM6NuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/FMbKGtXWrd/hvuY4r0XaPlaAAUFgY3IUfuJr7/bymKrS/LYLoZ7HF+pkivEuHmy
	 H6OOZRnZhNnWBHMiRL7yCNC61r/78l/iSCLDE+tErIrAHGm1lqn/YTQORFAj9d5Y5l
	 QEjjYv0TAQ2Z+ZQVBsaa7Bvf3Hq8LTrJ+J/7tfas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Alistair Popple <apopple@nvidia.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Chinner <david@fromorbit.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 402/798] fsdax,xfs: port unshare to fsdax
Date: Mon, 14 Oct 2024 16:15:56 +0200
Message-ID: <20241014141233.740568579@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Shiyang Ruan <ruansy.fnst@fujitsu.com>

[ Upstream commit d984648e428bf88cbd94ebe346c73632cb92fffb ]

Implement unshare in fsdax mode: copy data from srcmap to iomap.

Link: https://lkml.kernel.org/r/1669908753-169-1-git-send-email-ruansy.fnst@fujitsu.com
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: a311a08a4237 ("iomap: constrain the file range passed to iomap_file_unshare")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dax.c             | 52 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.c |  8 +++++--
 include/linux/dax.h  |  2 ++
 3 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 1c6867810cbd6..626745bc1ad86 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1221,6 +1221,58 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 }
 #endif /* CONFIG_FS_DAX_PMD */
 
+static s64 dax_unshare_iter(struct iomap_iter *iter)
+{
+	struct iomap *iomap = &iter->iomap;
+	const struct iomap *srcmap = iomap_iter_srcmap(iter);
+	loff_t pos = iter->pos;
+	loff_t length = iomap_length(iter);
+	int id = 0;
+	s64 ret = 0;
+	void *daddr = NULL, *saddr = NULL;
+
+	/* don't bother with blocks that are not shared to start with */
+	if (!(iomap->flags & IOMAP_F_SHARED))
+		return length;
+	/* don't bother with holes or unwritten extents */
+	if (srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN)
+		return length;
+
+	id = dax_read_lock();
+	ret = dax_iomap_direct_access(iomap, pos, length, &daddr, NULL);
+	if (ret < 0)
+		goto out_unlock;
+
+	ret = dax_iomap_direct_access(srcmap, pos, length, &saddr, NULL);
+	if (ret < 0)
+		goto out_unlock;
+
+	ret = copy_mc_to_kernel(daddr, saddr, length);
+	if (ret)
+		ret = -EIO;
+
+out_unlock:
+	dax_read_unlock(id);
+	return ret;
+}
+
+int dax_file_unshare(struct inode *inode, loff_t pos, loff_t len,
+		const struct iomap_ops *ops)
+{
+	struct iomap_iter iter = {
+		.inode		= inode,
+		.pos		= pos,
+		.len		= len,
+		.flags		= IOMAP_WRITE | IOMAP_UNSHARE | IOMAP_DAX,
+	};
+	int ret;
+
+	while ((ret = iomap_iter(&iter, ops)) > 0)
+		iter.processed = dax_unshare_iter(&iter);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dax_file_unshare);
+
 static int dax_memzero(struct iomap_iter *iter, loff_t pos, size_t size)
 {
 	const struct iomap *iomap = &iter->iomap;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 93bdd25680bc9..fe46bce8cae63 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1693,8 +1693,12 @@ xfs_reflink_unshare(
 
 	inode_dio_wait(inode);
 
-	error = iomap_file_unshare(inode, offset, len,
-			&xfs_buffered_write_iomap_ops);
+	if (IS_DAX(inode))
+		error = dax_file_unshare(inode, offset, len,
+				&xfs_dax_write_iomap_ops);
+	else
+		error = iomap_file_unshare(inode, offset, len,
+				&xfs_buffered_write_iomap_ops);
 	if (error)
 		goto out;
 
diff --git a/include/linux/dax.h b/include/linux/dax.h
index ba985333e26bf..2b5ecb5910591 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -205,6 +205,8 @@ static inline void dax_unlock_mapping_entry(struct address_space *mapping,
 }
 #endif
 
+int dax_file_unshare(struct inode *inode, loff_t pos, loff_t len,
+		const struct iomap_ops *ops);
 int dax_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
 		const struct iomap_ops *ops);
 int dax_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
-- 
2.43.0



