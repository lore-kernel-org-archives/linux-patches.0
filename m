Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7051D9A42;
	Tue, 15 Oct 2024 11:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992166; cv=none; b=n/c1Y7NVDgL1Tq90jrnQ6Id58Tr0Ut/EXn/DInIzcQ7ZCKFFPIewfymBbPiZ5wsGkoWFTlAYCE+byahcdfAKp5Ta3QpFD+mhVol7BWdOUNKpPxG5LC2Qlgsa15tOQm/yZzjitho2xYXEJR7DedkeM4/E8eAkTFAx8W6I3f512TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992166; c=relaxed/simple;
	bh=om4eYwNCkdtCBaVVn6sIHNQLK//9KrGCR/CLYy/afb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUcySkV3FDOjpkYdEGjCBLOxCIUZAnxDck+zn18lJ5pLDAO/N9yI0MZyHr+Ug6LbCQj1dcK0wQMaXm0/p9/BGbWodZR4gzefE9PrwMrkWZDhZjG8RpXw13yd5cxDAOYeFfCl9HROzrEFY9CBfWLDw6lYnmtHZwou6wKKtRraoC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cmNymEd+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cmNymEd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA4CC4CEC6;
	Tue, 15 Oct 2024 11:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992166;
	bh=om4eYwNCkdtCBaVVn6sIHNQLK//9KrGCR/CLYy/afb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cmNymEd+GKT1j0UxOYra7pJkE84b8cK3C96yeErOkWvr8i4XGf3CH/i2HorGvGu/1
	 IicnCZ0qbSUxpO/rVrfWucyheAxy0he8hMO23TmV9W3TbKeDowtVdDvJIxzf4ABHlZ
	 JBJwKuR6ECgAXlbT045Tm5zzgy7oqVdCqwlPVGdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Gang He <ghe@suse.com>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 010/691] ocfs2: reserve space for inline xattr before attaching reflink tree
Date: Tue, 15 Oct 2024 13:19:18 +0200
Message-ID: <20241015112440.740499917@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>

commit 5ca60b86f57a4d9648f68418a725b3a7de2816b0 upstream.

One of our customers reported a crash and a corrupted ocfs2 filesystem.
The crash was due to the detection of corruption.  Upon troubleshooting,
the fsck -fn output showed the below corruption

[EXTENT_LIST_FREE] Extent list in owner 33080590 claims 230 as the next free chain record,
but fsck believes the largest valid value is 227.  Clamp the next record value? n

The stat output from the debugfs.ocfs2 showed the following corruption
where the "Next Free Rec:" had overshot the "Count:" in the root metadata
block.

        Inode: 33080590   Mode: 0640   Generation: 2619713622 (0x9c25a856)
        FS Generation: 904309833 (0x35e6ac49)
        CRC32: 00000000   ECC: 0000
        Type: Regular   Attr: 0x0   Flags: Valid
        Dynamic Features: (0x16) HasXattr InlineXattr Refcounted
        Extended Attributes Block: 0  Extended Attributes Inline Size: 256
        User: 0 (root)   Group: 0 (root)   Size: 281320357888
        Links: 1   Clusters: 141738
        ctime: 0x66911b56 0x316edcb8 -- Fri Jul 12 06:02:30.829349048 2024
        atime: 0x66911d6b 0x7f7a28d -- Fri Jul 12 06:11:23.133669517 2024
        mtime: 0x66911b56 0x12ed75d7 -- Fri Jul 12 06:02:30.317552087 2024
        dtime: 0x0 -- Wed Dec 31 17:00:00 1969
        Refcount Block: 2777346
        Last Extblk: 2886943   Orphan Slot: 0
        Sub Alloc Slot: 0   Sub Alloc Bit: 14
        Tree Depth: 1   Count: 227   Next Free Rec: 230
        ## Offset        Clusters       Block#
        0  0             2310           2776351
        1  2310          2139           2777375
        2  4449          1221           2778399
        3  5670          731            2779423
        4  6401          566            2780447
        .......          ....           .......
        .......          ....           .......

The issue was in the reflink workfow while reserving space for inline
xattr.  The problematic function is ocfs2_reflink_xattr_inline().  By the
time this function is called the reflink tree is already recreated at the
destination inode from the source inode.  At this point, this function
reserves space for inline xattrs at the destination inode without even
checking if there is space at the root metadata block.  It simply reduces
the l_count from 243 to 227 thereby making space of 256 bytes for inline
xattr whereas the inode already has extents beyond this index (in this
case up to 230), thereby causing corruption.

The fix for this is to reserve space for inline metadata at the destination
inode before the reflink tree gets recreated. The customer has verified the
fix.

Link: https://lkml.kernel.org/r/20240918063844.1830332-1-gautham.ananthakrishna@oracle.com
Fixes: ef962df057aa ("ocfs2: xattr: fix inlined xattr reflink")
Signed-off-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/refcounttree.c |   26 ++++++++++++++++++++++++--
 fs/ocfs2/xattr.c        |   11 +----------
 2 files changed, 25 insertions(+), 12 deletions(-)

--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -25,6 +25,7 @@
 #include "namei.h"
 #include "ocfs2_trace.h"
 #include "file.h"
+#include "symlink.h"
 
 #include <linux/bio.h>
 #include <linux/blkdev.h>
@@ -4182,8 +4183,9 @@ static int __ocfs2_reflink(struct dentry
 	int ret;
 	struct inode *inode = d_inode(old_dentry);
 	struct buffer_head *new_bh = NULL;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
-	if (OCFS2_I(inode)->ip_flags & OCFS2_INODE_SYSTEM_FILE) {
+	if (oi->ip_flags & OCFS2_INODE_SYSTEM_FILE) {
 		ret = -EINVAL;
 		mlog_errno(ret);
 		goto out;
@@ -4209,6 +4211,26 @@ static int __ocfs2_reflink(struct dentry
 		goto out_unlock;
 	}
 
+	if ((oi->ip_dyn_features & OCFS2_HAS_XATTR_FL) &&
+	    (oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL)) {
+		/*
+		 * Adjust extent record count to reserve space for extended attribute.
+		 * Inline data count had been adjusted in ocfs2_duplicate_inline_data().
+		 */
+		struct ocfs2_inode_info *new_oi = OCFS2_I(new_inode);
+
+		if (!(new_oi->ip_dyn_features & OCFS2_INLINE_DATA_FL) &&
+		    !(ocfs2_inode_is_fast_symlink(new_inode))) {
+			struct ocfs2_dinode *new_di = (struct ocfs2_dinode *)new_bh->b_data;
+			struct ocfs2_dinode *old_di = (struct ocfs2_dinode *)old_bh->b_data;
+			struct ocfs2_extent_list *el = &new_di->id2.i_list;
+			int inline_size = le16_to_cpu(old_di->i_xattr_inline_size);
+
+			le16_add_cpu(&el->l_count, -(inline_size /
+					sizeof(struct ocfs2_extent_rec)));
+		}
+	}
+
 	ret = ocfs2_create_reflink_node(inode, old_bh,
 					new_inode, new_bh, preserve);
 	if (ret) {
@@ -4216,7 +4238,7 @@ static int __ocfs2_reflink(struct dentry
 		goto inode_unlock;
 	}
 
-	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_HAS_XATTR_FL) {
+	if (oi->ip_dyn_features & OCFS2_HAS_XATTR_FL) {
 		ret = ocfs2_reflink_xattrs(inode, old_bh,
 					   new_inode, new_bh,
 					   preserve);
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -6515,16 +6515,7 @@ static int ocfs2_reflink_xattr_inline(st
 	}
 
 	new_oi = OCFS2_I(args->new_inode);
-	/*
-	 * Adjust extent record count to reserve space for extended attribute.
-	 * Inline data count had been adjusted in ocfs2_duplicate_inline_data().
-	 */
-	if (!(new_oi->ip_dyn_features & OCFS2_INLINE_DATA_FL) &&
-	    !(ocfs2_inode_is_fast_symlink(args->new_inode))) {
-		struct ocfs2_extent_list *el = &new_di->id2.i_list;
-		le16_add_cpu(&el->l_count, -(inline_size /
-					sizeof(struct ocfs2_extent_rec)));
-	}
+
 	spin_lock(&new_oi->ip_lock);
 	new_oi->ip_dyn_features |= OCFS2_HAS_XATTR_FL | OCFS2_INLINE_XATTR_FL;
 	new_di->i_dyn_features = cpu_to_le16(new_oi->ip_dyn_features);


