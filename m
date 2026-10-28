Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207190;
	b=blRqFl6cAmRBhcauY0pwNCDzMnSniM2AMPiONBBrG+zu+MLKum6Wbgox9YisidLPvw/d
	 MSwsiYHpet1/Nj591pOHblfWy3VhlbBz0D8Rzq4sSZ+M/ep+uIaZKKh5NyEZRKnEnswN9
	 rsghNBVa1IJOUKVjcwYbxrSMu2Ze5oLAVRrfKMPxCJb8NyYwREvsnSdnz8eQtlsUjhVRG
	 DWwn2HO2LBiIYt+ZHNled8t0aS5ejOjvIUEDZTDJZrmNronO+cRZWJafdytwndZj/+9Qr
	 POWaal1tfejhaM6LPemHaMykbLc5OVV+PkjQXvMDapGxOvlKGirEumf2C+U9iRrTuNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207190;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QoNTB3ZQ455lb5PkN6dA2EH0FXjjRnJQ5aVqJxXPVGo=;
	b=5COKBedIS2MBllTg+9S43ea64K/aRW0XN7avWw8+L8JEeTL+TRPtxQgjW9PC6UD0EarJ
	 kOOR932ZYNxsYaIhFCN97OpGHAh2UAP/nLrPkMn4vElq4+Zy8ameXpiP6nbWxeATOsDBb
	 3Fd7fL8U2s14NRkfLmSd/EfBj6ZC5da9Si8+4TrMetbqiBCiyBty0Rdw1sxLas43CcnZ4
	 I2b1a7gMksWaFgq7840l+fJgA9TX5LR9RKfyxtPVO9Y7A/zfmMg2Ndr6DCvOX8/p6+njG
	 tX0qnK1xALekrmJAGNq/VLVwoibEGh5O0qZKSy8UcNBb2T0kjMdZY1/Ho4ACfHFNNxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s++SrB99;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A529606A31A;
	Wed, 28 Oct 2026 17:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s++SrB99
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B78E1F01825;
	Wed, 28 Oct 2026 17:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207190;
	bh=QoNTB3ZQ455lb5PkN6dA2EH0FXjjRnJQ5aVqJxXPVGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s++SrB99EzrFjCGFAf57ue2v5Iw2G62z1fRrDAgj1O6wD2RQpbeaZU+9+Kl8/CGLX
	 b50IaIqyI5Kf4ExiHtqWXerO2zjjzk2q7qoxtPY9zN7d2m28/26xMBWeM5bDzNIK2+
	 XqujohGhEUFhdYaUa4+gji6YdQiyqMqrsEw5nnp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 03/88] ntfs: take invalidate_lock in ntfs_filemap_page_mkwrite()
Date: Wed, 28 Oct 2026 17:59:11 +0100
Message-ID: <20261028165942.192822618@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 0fecc393f2060e6bc25138df32cb923ec7071c6b ]

ntfs_filemap_page_mkwrite() calls iomap_page_mkwrite() without holding
mapping->invalidate_lock, so a concurrent truncate or fallocate can be in
the middle of invalidating pagecache and rewriting the runlist while the write
fault maps blocks and dirties the folio. This races with ntfs_attr_fallocate(),
which merges clusters into the in-memory runlist, drops the runlist lock, and
only afterwards zeroes the newly allocated clusters on disk; and with the
punch-hole/insert/collapse paths that free clusters after truncating the cache.

Per Documentation/filesystems/locking.rst, ->page_mkwrite() must ensure there
are no truncate/invalidate races, "usually mapping->invalidate_lock is suitable
for proper serialization". xfs takes its mmaplock (= the invalidate_lock
rwsem) shared in exactly this path.

Take invalidate_lock shared around iomap_page_mkwrite(). The read-only fault
path is already covered because filemap_fault() itself grabs invalidate_lock
shared on instantiation/read paths; only page_mkwrite was bypassing it in this
driver.

Fixes: 9c87959601e8 ("ntfs: update file operations")
Cc: stable@vger.kernel.org
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Co-developed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/file.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 317bb249150fd..8515560e2a4b2 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -620,12 +620,20 @@ static ssize_t ntfs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 static vm_fault_t ntfs_filemap_page_mkwrite(struct vm_fault *vmf)
 {
 	struct inode *inode = file_inode(vmf->vma->vm_file);
+	struct address_space *mapping = inode->i_mapping;
 	vm_fault_t ret;
 
 	sb_start_pagefault(inode->i_sb);
 	file_update_time(vmf->vma->vm_file);
 
+	/*
+	 * Serialize against truncate/fallocate which hold the lock
+	 * exclusively while invalidating pagecache and changing extents.
+	 */
+	filemap_invalidate_lock_shared(mapping);
 	ret = iomap_page_mkwrite(vmf, &ntfs_page_mkwrite_iomap_ops, NULL);
+	filemap_invalidate_unlock_shared(mapping);
+
 	sb_end_pagefault(inode->i_sb);
 	return ret;
 }
@@ -1119,13 +1127,13 @@ static long ntfs_fallocate(struct file *file, int mode, loff_t offset, loff_t le
 
 	err = file_modified(file);
 out:
+	if (!err && mode == 0 && NInoNonResident(ni) &&
+	    offset > old_size) {
+		truncate_pagecache(vi, old_size);
+		pagecache_isize_extended(vi, old_size, offset);
+	}
 	filemap_invalidate_unlock(vi->i_mapping);
 	if (!err) {
-		if (mode == 0 && NInoNonResident(ni) &&
-		    offset > old_size) {
-			truncate_pagecache(vi, old_size);
-			pagecache_isize_extended(vi, old_size, offset);
-		}
 		NInoSetFileNameDirty(ni);
 		inode_set_mtime_to_ts(vi, inode_set_ctime_current(vi));
 		mark_inode_dirty(vi);
-- 
2.53.0



