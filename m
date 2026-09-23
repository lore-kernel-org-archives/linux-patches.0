Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65591377567;
	Wed, 23 Sep 2026 14:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172989; cv=none; b=JGv5fhwxU6/oplaWjypn76Ju7IDLKxdzvdez/YFCfiy6zOwVPUbiv6qDasX2ECyskgaLdltXujRzvTQ2Jf0GwoqSmFkgpmtkpmG2vAi6WPHjwP523CNbWVVvCuSuiT2hB0qmCteMSJl3c0lefipQ2FeXW1twYeJ5Llv0Nvue7As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172989; c=relaxed/simple;
	bh=scOdo1GTSNo/oCDOxNFqAmay6sUji7G3bfHVBtEfaGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QljSvyyufovbNZawiUSCoB+4AnoBDnVy/7YvWg0BU64LkykUdtCRACEJePUh7BDvJku1oLoZPrGJaOWqzCTCc6WZxKBBxocPuaEZBRT/+av2q3+HnVn6CQwDHP4VBqo0jRXMcb6W0MHdsep6nRJVp7Z+1qDsaypn/YFRP42lSF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MIawVFdN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MIawVFdN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4091F000FF;
	Wed, 23 Sep 2026 14:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172988;
	bh=eBmB51VNtiGZcS+sF7A4S+GurSBlb6+pNEqoo+71Ulo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MIawVFdNM59E4QohDJNJ1U6URmO6pzSMoc3exxNgVrbnTCjqb7R8PCgTEG2bAyRSw
	 hFSQJH6VEhif3efUSHh1F2+MzqExat9viK/r29mG0w+u3awuNNQmTaCL78by7i9peC
	 oMVGbCqdtDHXplh+SsadrU8QNdZxEKayaTZ0zcoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 122/438] ntfs: account for MFT records added during allocation
Date: Wed, 23 Sep 2026 16:02:23 +0200
Message-ID: <20260923140647.941740708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 631946431ddc66a472c5cc629cd654e62dfa1f88 ]

When no free MFT record is available in the initialized $MFT/$BITMAP,
ntfs_mft_record_alloc() extends $MFT/$DATA and formats the requested record
together with a dynamically sized tail reserve. Those records become
visible through the $MFT file size before charging the requested record to
the free-record counter.

Account for all newly visible records before releasing the MFT allocation
lock, then subtract the one record being allocated. Keep MFT counter
updates independent of the asynchronous free-cluster scan and update the
counter when a record is successfully cleared in the MFT bitmap.

Store the clamped result of the MFT bitmap scan and keep statfs from
exposing an invalid cached count if an accounting error occurs.

Fixes: 115380f9a2f9 ("ntfs: update mft operations")
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/mft.c    | 11 ++++++++---
 fs/ntfs/super.c  | 12 +++++++++---
 fs/ntfs/volume.h |  6 ------
 3 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
index 5fae9ad03858e..ed3aa4c423e81 100644
--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -1539,7 +1539,6 @@ static int ntfs_mft_bitmap_extend_initialized_nolock(struct ntfs_volume *vol)
 	ret = ntfs_attr_set(mftbmp_ni, old_initialized_size, 8, 0);
 	if (likely(!ret)) {
 		ntfs_debug("Done.  (Wrote eight initialized bytes to mft bitmap.");
-		ntfs_inc_free_mft_records(vol, 8 * 8);
 		return 0;
 	}
 	ntfs_error(vol->sb, "Failed to write to mft bitmap.");
@@ -2135,6 +2134,7 @@ int ntfs_mft_record_alloc(struct ntfs_volume *vol, const int mode,
 			  struct mft_record **ni_mrec, const s64 mft_data_vcn)
 {
 	s64 ll, bit, old_data_initialized, old_data_size;
+	s64 nr_new_mft_records = 0;
 	s64 max_mft_no = -1, reserve_start = -1, reserve_end = -1;
 	s64 candidate_reserve_end = -1;
 	s64 *reserve_endp;
@@ -2501,8 +2501,13 @@ int ntfs_mft_record_alloc(struct ntfs_volume *vol, const int mode,
 			mft_ni->initialized_size);
 	WARN_ON(i_size_read(vol->mft_ino) > mft_ni->allocated_size);
 	WARN_ON(mft_ni->initialized_size > i_size_read(vol->mft_ino));
+	nr_new_mft_records = (i_size_read(vol->mft_ino) - old_data_size) >>
+			     vol->mft_record_size_bits;
 	read_unlock_irqrestore(&mft_ni->size_lock, flags);
 mft_rec_already_initialized:
+	/* Account for newly visible MFT records before dropping the lock. */
+	if (nr_new_mft_records > 0)
+		ntfs_inc_free_mft_records(vol, nr_new_mft_records);
 	/*
 	 * We can finally drop the mft bitmap lock as the mft data attribute
 	 * has been fully updated.  The only disparity left is that the
@@ -2814,6 +2819,8 @@ int ntfs_mft_record_free(struct ntfs_volume *vol, struct ntfs_inode *ni)
 	if (base_ni->mft_no != FILE_MFT)
 		down_write(&vol->mftbmp_lock);
 	err = ntfs_bitmap_clear_bit(vol->mftbmp_ino, mft_no);
+	if (!err)
+		ntfs_inc_free_mft_records(vol, 1);
 	if (!err && base_ni->mft_no == FILE_MFT &&
 	    mft_no + 1 == vol->mft_record_reserve_pos &&
 	    mft_no < vol->mft_record_reserve_end)
@@ -2823,9 +2830,7 @@ int ntfs_mft_record_free(struct ntfs_volume *vol, struct ntfs_inode *ni)
 	memalloc_nofs_restore(memalloc_flags);
 	if (err)
 		goto bitmap_rollback;
-
 	unmap_mft_record(ni);
-	ntfs_inc_free_mft_records(vol, 1);
 	return 0;
 
 	/* Rollback what we did... */
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 63aa83ff77f5d..b5371d269f747 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -2064,8 +2064,7 @@ static unsigned long __get_nr_free_mft_records(struct ntfs_volume *vol,
 	/* If errors occurred we may well have gone below zero, fix this. */
 	if (nr_free < 0)
 		nr_free = 0;
-	else
-		atomic64_set(&vol->free_mft_records, nr_free);
+	atomic64_set(&vol->free_mft_records, nr_free);
 
 	ntfs_debug("Exiting.");
 	return nr_free;
@@ -2131,7 +2130,14 @@ static int ntfs_statfs(struct dentry *dentry, struct kstatfs *sfs)
 	read_unlock_irqrestore(&mft_ni->size_lock, flags);
 
 	/* Free inodes in fs (based on current total count). */
-	sfs->f_ffree = atomic64_read(&vol->free_mft_records);
+	size = atomic64_read(&vol->free_mft_records);
+	if (unlikely(size < 0 || size > (s64)sfs->f_files))
+		ntfs_warning(vol->sb, "Invalid free MFT record count %lld.", size);
+	if (size < 0)
+		size = 0;
+	else if (size > (s64)sfs->f_files)
+		size = sfs->f_files;
+	sfs->f_ffree = size;
 
 	/*
 	 * File system id. This is extremely *nix flavour dependent and even
diff --git a/fs/ntfs/volume.h b/fs/ntfs/volume.h
index 2b60d14fc7ef5..bc85a95922458 100644
--- a/fs/ntfs/volume.h
+++ b/fs/ntfs/volume.h
@@ -258,17 +258,11 @@ static inline void ntfs_dec_free_clusters(struct ntfs_volume *vol, s64 nr)
 
 static inline void ntfs_inc_free_mft_records(struct ntfs_volume *vol, s64 nr)
 {
-	if (!NVolFreeClusterKnown(vol))
-		return;
-
 	atomic64_add(nr, &vol->free_mft_records);
 }
 
 static inline void ntfs_dec_free_mft_records(struct ntfs_volume *vol, s64 nr)
 {
-	if (!NVolFreeClusterKnown(vol))
-		return;
-
 	atomic64_sub(nr, &vol->free_mft_records);
 }
 
-- 
2.53.0



