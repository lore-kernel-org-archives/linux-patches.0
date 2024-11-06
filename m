Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C371DE3B5;
	Wed,  6 Nov 2024 12:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897426; cv=none; b=uv8OabVHF5KdI7+N+ysKbOqWlzbh+rB1Oo8fQZdc943YaHJvk139ZqOvgNCz1fDW96EWh/+v537Gm2TkR2CzKtqJojqhVk5gOC5NvsQAyHF1oLRu/Pgez8PCEjsRqZeS/bLYhSkHaSNGsyYu7ZFJCIqSNmF8VPoG5Ja6LxyX2ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897426; c=relaxed/simple;
	bh=krTkV7PxMpYXYJPkUvQmSaayJqaQqXl5T2s42Q2w0Fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMWBrNk1FVYRMSW57zHUMibNxEiJqgSt+XjgsbNGCqyKG9T0uNpUlhaSiKt0wOSBVeV5HckXBD5SHkHH6nvIU6LusePe6H90Vsaw2ARz5m3iZUGaqUbjSqbANxfkKnKsZLj4+89WUTZnp6IgVRzEqzlSEWPTJ9uYXBDjXtqw5kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NzydPB0H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NzydPB0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4E3C4CECD;
	Wed,  6 Nov 2024 12:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897426;
	bh=krTkV7PxMpYXYJPkUvQmSaayJqaQqXl5T2s42Q2w0Fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NzydPB0Hxd1aNyIpd7UHY2cZclnXHDiRnKA7J4wZgTGgEL7qSyPJkBZSCT8IWRl/n
	 +E398DcsO83xfGwI/gxcIZBgMrwJ+nl/Xp1nMIp12f1yphkDRE8HVFwEi0GlkIcGd/
	 htGGBhKC4wMWgJWgjzJSTVcjRDLnM69eG7cEBfjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/151] afs: Fix missing subdir edit when renamed between parent dirs
Date: Wed,  6 Nov 2024 13:03:58 +0100
Message-ID: <20241106120310.211476953@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit 247d65fb122ad560be1c8c4d87d7374fb28b0770 ]

When rename moves an AFS subdirectory between parent directories, the
subdir also needs a bit of editing: the ".." entry needs updating to point
to the new parent (though I don't make use of the info) and the DV needs
incrementing by 1 to reflect the change of content.  The server also sends
a callback break notification on the subdirectory if we have one, but we
can take care of recovering the promise next time we access the subdir.

This can be triggered by something like:

    mount -t afs %example.com:xfstest.test20 /xfstest.test/
    mkdir /xfstest.test/{aaa,bbb,aaa/ccc}
    touch /xfstest.test/bbb/ccc/d
    mv /xfstest.test/{aaa/ccc,bbb/ccc}
    touch /xfstest.test/bbb/ccc/e

When the pathwalk for the second touch hits "ccc", kafs spots that the DV
is incorrect and downloads it again (so the fix is not critical).

Fix this, if the rename target is a directory and the old and new
parents are different, by:

 (1) Incrementing the DV number of the target locally.

 (2) Editing the ".." entry in the target to refer to its new parent's
     vnode ID and uniquifier.

Link: https://lore.kernel.org/r/3340431.1729680010@warthog.procyon.org.uk
Fixes: 63a4681ff39c ("afs: Locally edit directory data for mkdir/create/unlink/...")
cc: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dir.c               | 25 +++++++++++
 fs/afs/dir_edit.c          | 91 +++++++++++++++++++++++++++++++++++++-
 fs/afs/internal.h          |  2 +
 include/trace/events/afs.h |  7 ++-
 4 files changed, 122 insertions(+), 3 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 5219182e52e1a..897569e1d3a90 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -12,6 +12,7 @@
 #include <linux/swap.h>
 #include <linux/ctype.h>
 #include <linux/sched.h>
+#include <linux/iversion.h>
 #include <linux/task_io_accounting_ops.h>
 #include "internal.h"
 #include "afs_fs.h"
@@ -1809,6 +1810,8 @@ static int afs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 
 static void afs_rename_success(struct afs_operation *op)
 {
+	struct afs_vnode *vnode = AFS_FS_I(d_inode(op->dentry));
+
 	_enter("op=%08x", op->debug_id);
 
 	op->ctime = op->file[0].scb.status.mtime_client;
@@ -1818,6 +1821,22 @@ static void afs_rename_success(struct afs_operation *op)
 		op->ctime = op->file[1].scb.status.mtime_client;
 		afs_vnode_commit_status(op, &op->file[1]);
 	}
+
+	/* If we're moving a subdir between dirs, we need to update
+	 * its DV counter too as the ".." will be altered.
+	 */
+	if (S_ISDIR(vnode->netfs.inode.i_mode) &&
+	    op->file[0].vnode != op->file[1].vnode) {
+		u64 new_dv;
+
+		write_seqlock(&vnode->cb_lock);
+
+		new_dv = vnode->status.data_version + 1;
+		vnode->status.data_version = new_dv;
+		inode_set_iversion_raw(&vnode->netfs.inode, new_dv);
+
+		write_sequnlock(&vnode->cb_lock);
+	}
 }
 
 static void afs_rename_edit_dir(struct afs_operation *op)
@@ -1859,6 +1878,12 @@ static void afs_rename_edit_dir(struct afs_operation *op)
 				 &vnode->fid, afs_edit_dir_for_rename_2);
 	}
 
+	if (S_ISDIR(vnode->netfs.inode.i_mode) &&
+	    new_dvnode != orig_dvnode &&
+	    test_bit(AFS_VNODE_DIR_VALID, &vnode->flags))
+		afs_edit_dir_update_dotdot(vnode, new_dvnode,
+					   afs_edit_dir_for_rename_sub);
+
 	new_inode = d_inode(new_dentry);
 	if (new_inode) {
 		spin_lock(&new_inode->i_lock);
diff --git a/fs/afs/dir_edit.c b/fs/afs/dir_edit.c
index e2fa577b66fe0..1dcc75fd0cee3 100644
--- a/fs/afs/dir_edit.c
+++ b/fs/afs/dir_edit.c
@@ -127,10 +127,10 @@ static struct folio *afs_dir_get_folio(struct afs_vnode *vnode, pgoff_t index)
 /*
  * Scan a directory block looking for a dirent of the right name.
  */
-static int afs_dir_scan_block(union afs_xdr_dir_block *block, struct qstr *name,
+static int afs_dir_scan_block(const union afs_xdr_dir_block *block, const struct qstr *name,
 			      unsigned int blocknum)
 {
-	union afs_xdr_dirent *de;
+	const union afs_xdr_dirent *de;
 	u64 bitmap;
 	int d, len, n;
 
@@ -492,3 +492,90 @@ void afs_edit_dir_remove(struct afs_vnode *vnode,
 	clear_bit(AFS_VNODE_DIR_VALID, &vnode->flags);
 	goto out_unmap;
 }
+
+/*
+ * Edit a subdirectory that has been moved between directories to update the
+ * ".." entry.
+ */
+void afs_edit_dir_update_dotdot(struct afs_vnode *vnode, struct afs_vnode *new_dvnode,
+				enum afs_edit_dir_reason why)
+{
+	union afs_xdr_dir_block *block;
+	union afs_xdr_dirent *de;
+	struct folio *folio;
+	unsigned int nr_blocks, b;
+	pgoff_t index;
+	loff_t i_size;
+	int slot;
+
+	_enter("");
+
+	i_size = i_size_read(&vnode->netfs.inode);
+	if (i_size < AFS_DIR_BLOCK_SIZE) {
+		clear_bit(AFS_VNODE_DIR_VALID, &vnode->flags);
+		return;
+	}
+	nr_blocks = i_size / AFS_DIR_BLOCK_SIZE;
+
+	/* Find a block that has sufficient slots available.  Each folio
+	 * contains two or more directory blocks.
+	 */
+	for (b = 0; b < nr_blocks; b++) {
+		index = b / AFS_DIR_BLOCKS_PER_PAGE;
+		folio = afs_dir_get_folio(vnode, index);
+		if (!folio)
+			goto error;
+
+		block = kmap_local_folio(folio, b * AFS_DIR_BLOCK_SIZE - folio_pos(folio));
+
+		/* Abandon the edit if we got a callback break. */
+		if (!test_bit(AFS_VNODE_DIR_VALID, &vnode->flags))
+			goto invalidated;
+
+		slot = afs_dir_scan_block(block, &dotdot_name, b);
+		if (slot >= 0)
+			goto found_dirent;
+
+		kunmap_local(block);
+		folio_unlock(folio);
+		folio_put(folio);
+	}
+
+	/* Didn't find the dirent to clobber.  Download the directory again. */
+	trace_afs_edit_dir(vnode, why, afs_edit_dir_update_nodd,
+			   0, 0, 0, 0, "..");
+	clear_bit(AFS_VNODE_DIR_VALID, &vnode->flags);
+	goto out;
+
+found_dirent:
+	de = &block->dirents[slot];
+	de->u.vnode  = htonl(new_dvnode->fid.vnode);
+	de->u.unique = htonl(new_dvnode->fid.unique);
+
+	trace_afs_edit_dir(vnode, why, afs_edit_dir_update_dd, b, slot,
+			   ntohl(de->u.vnode), ntohl(de->u.unique), "..");
+
+	kunmap_local(block);
+	folio_unlock(folio);
+	folio_put(folio);
+	inode_set_iversion_raw(&vnode->netfs.inode, vnode->status.data_version);
+
+out:
+	_leave("");
+	return;
+
+invalidated:
+	kunmap_local(block);
+	folio_unlock(folio);
+	folio_put(folio);
+	trace_afs_edit_dir(vnode, why, afs_edit_dir_update_inval,
+			   0, 0, 0, 0, "..");
+	clear_bit(AFS_VNODE_DIR_VALID, &vnode->flags);
+	goto out;
+
+error:
+	trace_afs_edit_dir(vnode, why, afs_edit_dir_update_error,
+			   0, 0, 0, 0, "..");
+	clear_bit(AFS_VNODE_DIR_VALID, &vnode->flags);
+	goto out;
+}
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index c4bf8439bc9c9..8dcc09cf0adbe 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -1037,6 +1037,8 @@ extern void afs_check_for_remote_deletion(struct afs_operation *);
 extern void afs_edit_dir_add(struct afs_vnode *, struct qstr *, struct afs_fid *,
 			     enum afs_edit_dir_reason);
 extern void afs_edit_dir_remove(struct afs_vnode *, struct qstr *, enum afs_edit_dir_reason);
+void afs_edit_dir_update_dotdot(struct afs_vnode *vnode, struct afs_vnode *new_dvnode,
+				enum afs_edit_dir_reason why);
 
 /*
  * dir_silly.c
diff --git a/include/trace/events/afs.h b/include/trace/events/afs.h
index 54d10c69e55ec..d1ee4272d1cb8 100644
--- a/include/trace/events/afs.h
+++ b/include/trace/events/afs.h
@@ -295,7 +295,11 @@ enum yfs_cm_operation {
 	EM(afs_edit_dir_delete,			"delete") \
 	EM(afs_edit_dir_delete_error,		"d_err ") \
 	EM(afs_edit_dir_delete_inval,		"d_invl") \
-	E_(afs_edit_dir_delete_noent,		"d_nent")
+	EM(afs_edit_dir_delete_noent,		"d_nent") \
+	EM(afs_edit_dir_update_dd,		"u_ddot") \
+	EM(afs_edit_dir_update_error,		"u_fail") \
+	EM(afs_edit_dir_update_inval,		"u_invl") \
+	E_(afs_edit_dir_update_nodd,		"u_nodd")
 
 #define afs_edit_dir_reasons				  \
 	EM(afs_edit_dir_for_create,		"Create") \
@@ -304,6 +308,7 @@ enum yfs_cm_operation {
 	EM(afs_edit_dir_for_rename_0,		"Renam0") \
 	EM(afs_edit_dir_for_rename_1,		"Renam1") \
 	EM(afs_edit_dir_for_rename_2,		"Renam2") \
+	EM(afs_edit_dir_for_rename_sub,		"RnmSub") \
 	EM(afs_edit_dir_for_rmdir,		"RmDir ") \
 	EM(afs_edit_dir_for_silly_0,		"S_Ren0") \
 	EM(afs_edit_dir_for_silly_1,		"S_Ren1") \
-- 
2.43.0



