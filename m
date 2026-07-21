Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1990401A18;
	Tue, 21 Jul 2026 17:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654407; cv=none; b=DGgGzsQfFPt/+foBlqIqQFXTY98vQRiWDJiymDUcealOQ3ch8WfNlc8lCKZuZ7Ky/N8W4Nd32DwPMisIQojiPyfAynROCzFhMxjR8Q3MGWpZ3nUOB7izcnjvd3b3U+5XWXss8Z/ba3jGBObjsSnaLx/AMr4jbS/6l1nI3FakNPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654407; c=relaxed/simple;
	bh=Q4vp48S/PAT1E6qXU9sLcDZx39lu4CaE1g2DEfjgq6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKVa/Sh/adlnQwDzwbxCdgpx19ymDpdYbNMGiLiQqlBzR9uQcjcNC8ka9fz5qslRE8ZmBdGYK54srwEn83py2cne/4i4WFB+aM8mSeuPmsY5NyJnR927C285wSdsAjDoRVKURjvIuquF9YrR6jua495EdLUNkscze1mhSP0Cqxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ni+tV80P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ni+tV80P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E7A1F000E9;
	Tue, 21 Jul 2026 17:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654404;
	bh=9CS+jtF7hXT2alXQp+5k3E2BEjWhCWATEqGpJeuN/oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ni+tV80PFP1YhCWKpulKKgySfShhJFos+7VnzfjRHnANpBOK/u00iH6auc2sN8x4e
	 CdZnXOl4fGP1HGRhG+eFGbACHRL/NZERXsRiQYK3zpG3jd7zDYJmmpfcaB5sZBJzbe
	 ZxZTHrWJD4yjEfwutloPdSn+y8xU12+5OKOsSab0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 1691/2077] ntfs: skip extent mft records in writeback to prevent deadlock
Date: Tue, 21 Jul 2026 17:22:44 +0200
Message-ID: <20260721152632.639094117@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunchul Lee <hyc.lee@gmail.com>

commit 76bc14c7097ff678b2b5dbfd4fa33b46897d87ce upstream.

This patch fixes the ABBA deadlock between extent_lock and extent
mrec_lock triggered by xfstests generic/113, that occurs since the commit
6994acf33bae ("ntfs: use base mft_no when looking up base inode for
		extent record").

Path A (inode writeback):
  VFS writeback
    -> ntfs_write_inode()
      -> __ntfs_write_inode()
        -> mutex_lock(&ni->extent_lock)
        -> mutex_lock(&tni->mrec_lock)

Path B (MFT folio writeback):
  VFS writeback of $MFT dirty folios
    -> ntfs_mft_writepages()
      -> ntfs_write_mft_block()
        -> ntfs_may_write_mft_record()
          -> holds one extent mrec_lock from a previous iteration
          -> tries to acquire another base inode extent_lock

By removing all extent_lock and extent mrec_lock acquisition from the MFT
folio writeback path, the ABBA lock ordering is eliminated:

Path A: __ntfs_write_inode(): extent_lock -> mrec_lock
Path B (removed): ntfs_write_mft_block(): mrec_lock -> extent_lock

Path B is always redundant for extent records because:

1. mark_mft_record_dirty(ext_ni) does NOT dirty the MFT folio.
   It only sets NInoDirty(ext_ni) and marks the base VFS inode dirty
   via __mark_inode_dirty(I_DIRTY_DATASYNC), which triggers Path A.
   Therefore, normal extent modifications never create a situation where
   the MFT folio is dirty and Path B is not scheduled.

2. The MFT folio only gets dirtied via ntfs_mft_mark_dirty() inside
   ntfs_mft_record_alloc(). But all identified callers in attrib.c
   (ntfs_attr_add, ntfs_attr_record_move_away,
   ntfs_attr_make_non_resident, ntfs_attr_record_resize) follow through
   with mark_mft_record_dirty(), which triggers Path A to write the
   complete record.

3. ntfs_evict_big_inode() calls ntfs_commit_inode() before freeing extent
   inodes, ensuring all dirty extents are flushed via Path A before the
   base inode leaves the icache.

Cc: stable@vger.kernel.org # v7.1
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/mft.c |  129 +---------------------------------------------------------
 1 file changed, 4 insertions(+), 125 deletions(-)

--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -743,23 +743,6 @@ static int ntfs_test_inode_wb(struct ino
  *
  * If the mft record is not a FILE record or it is a base mft record, we can
  * safely write it and return 'true'.
- *
- * We now know the mft record is an extent mft record.  We check if the inode
- * corresponding to its base mft record is in icache. If it is not, we cannot
- * safely determine the state of the extent inode, so we return 'false'.
- *
- * We now have the base inode for the extent mft record.  We check if it has an
- * ntfs inode for the extent mft record attached. If not, it is safe to write
- * the extent mft record and we return 'true'.
- *
- * If the extent inode is attached, we check if it is dirty. If so, we return
- * 'false' (letting the standard write_inode path handle it).
- *
- * If it is not dirty, we attempt to lock the extent mft record. If the lock
- * was already taken, it is not safe to write and we return 'false'.
- *
- * If we manage to obtain the lock we have exclusive access to the extent mft
- * record. We set @locked_ni to the now locked ntfs inode and return 'true'.
  */
 static bool ntfs_may_write_mft_record(struct ntfs_volume *vol, const u64 mft_no,
 		const struct mft_record *m, struct ntfs_inode **locked_ni,
@@ -768,8 +751,7 @@ static bool ntfs_may_write_mft_record(st
 	struct super_block *sb = vol->sb;
 	struct inode *mft_vi = vol->mft_ino;
 	struct inode *vi;
-	struct ntfs_inode *ni, *eni, **extent_nis;
-	int i;
+	struct ntfs_inode *ni;
 	struct ntfs_attr na = {0};
 
 	ntfs_debug("Entering for inode 0x%llx.", mft_no);
@@ -849,100 +831,10 @@ static bool ntfs_may_write_mft_record(st
 				mft_no);
 		return true;
 	}
-	/*
-	 * This is an extent mft record.  Check if the inode corresponding to
-	 * its base mft record is in icache and obtain a reference to it if it
-	 * is.
-	 */
-	na.mft_no = MREF_LE(m->base_mft_record);
-	na.state = 0;
-	ntfs_debug("Mft record 0x%llx is an extent record.  Looking for base inode 0x%llx in icache.",
-			mft_no, na.mft_no);
-	if (!na.mft_no) {
-		/* Balance the below iput(). */
-		vi = igrab(mft_vi);
-		WARN_ON(vi != mft_vi);
-	} else {
-		vi = find_inode_nowait(sb, na.mft_no, ntfs_test_inode_wb, &na);
-		if (na.state == NI_BeingDeleted || na.state == NI_BeingCreated)
-			return false;
-	}
 
-	if (!vi)
-		return false;
-	ntfs_debug("Base inode 0x%llx is in icache.", na.mft_no);
-	/*
-	 * The base inode is in icache.  Check if it has the extent inode
-	 * corresponding to this extent mft record attached.
-	 */
-	ni = NTFS_I(vi);
-	mutex_lock(&ni->extent_lock);
-	if (ni->nr_extents <= 0) {
-		/*
-		 * The base inode has no attached extent inodes, write this
-		 * extent mft record.
-		 */
-		mutex_unlock(&ni->extent_lock);
-		*ref_vi = vi;
-		ntfs_debug("Base inode 0x%llx has no attached extent inodes, write the extent record.",
-				na.mft_no);
-		return true;
-	}
-	/* Iterate over the attached extent inodes. */
-	extent_nis = ni->ext.extent_ntfs_inos;
-	for (eni = NULL, i = 0; i < ni->nr_extents; ++i) {
-		if (mft_no == extent_nis[i]->mft_no) {
-			/*
-			 * Found the extent inode corresponding to this extent
-			 * mft record.
-			 */
-			eni = extent_nis[i];
-			break;
-		}
-	}
-	/*
-	 * If the extent inode was not attached to the base inode, write this
-	 * extent mft record.
-	 */
-	if (!eni) {
-		mutex_unlock(&ni->extent_lock);
-		*ref_vi = vi;
-		ntfs_debug("Extent inode 0x%llx is not attached to its base inode 0x%llx, write the extent record.",
-				mft_no, na.mft_no);
-		return true;
-	}
-	ntfs_debug("Extent inode 0x%llx is attached to its base inode 0x%llx.",
-			mft_no, na.mft_no);
-	/* Take a reference to the extent ntfs inode. */
-	atomic_inc(&eni->count);
-	mutex_unlock(&ni->extent_lock);
-
-	/* if extent inode is dirty, write_inode will write it */
-	if (NInoDirty(eni)) {
-		atomic_dec(&eni->count);
-		*ref_vi = vi;
-		return false;
-	}
-
-	/*
-	 * Found the extent inode coresponding to this extent mft record.
-	 * Try to take the mft record lock.
-	 */
-	if (unlikely(!mutex_trylock(&eni->mrec_lock))) {
-		atomic_dec(&eni->count);
-		*ref_vi = vi;
-		ntfs_debug("Extent mft record 0x%llx is already locked, do not write it.",
-				mft_no);
-		return false;
-	}
-	ntfs_debug("Managed to lock extent mft record 0x%llx, write it.",
-			mft_no);
-	/*
-	 * The write has to occur while we hold the mft record lock so return
-	 * the locked extent ntfs inode.
-	 */
-	*locked_ni = eni;
-	return true;
+	ntfs_debug("Mft record 0x%llx is an extent record, skip it.",
+		   mft_no);
+	return false;
 }
 
 static const char *es = "  Leaving inconsistent metadata.  Unmount and run chkdsk.";
@@ -2792,19 +2684,6 @@ static int ntfs_write_mft_block(struct f
 			s64 rl_len = 0;
 
 			/*
-			 * Skip $MFT extent mft records and let them being written
-			 * by writeback to avioid deadlocks. the $MFT runlist
-			 * lock must be taken before $MFT extent mrec_lock is taken.
-			 */
-			if (tni && tni->nr_extents < 0 &&
-				tni->ext.base_ntfs_ino == NTFS_I(vol->mft_ino)) {
-				mutex_unlock(&tni->mrec_lock);
-				atomic_dec(&tni->count);
-				iput(vol->mft_ino);
-				continue;
-			}
-
-			/*
 			 * The record should be written.  If a locked ntfs
 			 * inode was returned, add it to the array of locked
 			 * ntfs inodes.


