Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207187;
	b=IYOm4i3CFrbGWD0bouo99eEV/IKzneR7FvpiBBfka6+Bs8I6AMx3sp/i+qUDhAtcHAP4
	 omIspitRlcvGu/1xMuVZbkvXeNIWXsvRhuf9erhdSIC7P1pI2LL6YMw4Xgn8vmmyL8H1K
	 e98KpGDZLMWobMuqwDky9qItd1L42zS7RiHtlCcKGZEU2rYtB58Xz9sCpihpXlu3BPUbz
	 WXdf33gHD+oWDvJLwBEcV2B8n0qjKS++6Yu9h2SIxXcBtTv2HH86LHfp2PQX1xMoRde5D
	 Si/tJ/KGiduWeTHZYAWHMIK4wbA4XH+ja/3cpTpyzjxQVMtO+xAKgwNHTjSwCALwgRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207187;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SnO9l+Hn3v7bDBgWbIJAdqc8qBSje/qPMHPZWzV+vWQ=;
	b=jYNLjUc5i2CZHgKNENeP+27W5tXv4RbusNeZGii0ZOsE1idAIoIL/ips7OpWmnY1Bll4
	 jiGfCYvZs+3eUXp+4omFz4dMUS7gzRqMyioe5buIgk+woDMdJNkriNcTOnbNQKCPXNUDq
	 exWaiIaB1HH4gHQeGm2Nwi13K7jxYGLTc9xFWLwfIkm7Gc8hWmoYr1PmotzYII2NlJ9Sm
	 I0XFrNv9S5n2fhsuPBXhXc67UbawItEc6uy7ApY1f17SHcptwAJ3vaDgyRTBDDVmItVIi
	 7c3c4g8TNGK8EAgsfx5zh/Bvenn55jr255ZVkgQIpgwo8DaJFTX6J+fBWGBs+QLDmYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1HXrfmyD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66882606A31A;
	Wed, 28 Oct 2026 17:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1HXrfmyD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B739D1F01828;
	Wed, 28 Oct 2026 17:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207187;
	bh=SnO9l+Hn3v7bDBgWbIJAdqc8qBSje/qPMHPZWzV+vWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1HXrfmyDwPhBfUT00irGQgVQPttEDAhSE/ulU4pak8hsDFgJM2bee6EUF0sC2y/7f
	 K5/eSXBTHg1snIUNK5v60NUg4YGANVf+cZFX6Ss/joPDr17oD7ourF1crPkJH98MiI
	 by3SS9NdUHeu7F1fjD274YJc/2JO4F/Lz5AaRJ0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 02/88] ntfs: fix race between fallocate and mmap reads
Date: Wed, 28 Oct 2026 17:59:10 +0100
Message-ID: <20261028165942.169861736@linuxfoundation.org>
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

[ Upstream commit 67aded1da114dc44808315f249bd9e7e440f799d ]

The fallocate implementation only takes invalidate_lock for punch hole,
collapse range, and insert range operations. For standard allocation modes
(mode == 0, FALLOC_FL_KEEP_SIZE), the lock is not held.

During ntfs_attr_fallocate(), new clusters are mapped to the runlist via
ntfs_attr_map_cluster() before being zeroed by ntfs_dio_zero_range(). This
creates a window where concurrent mmap page faults can read uninitialized
disk data.

Since mmap uses filemap_fault() which takes invalidate_lock in shared mode,
it can fault in pages during this window and expose old disk contents to
userspace. This is an information leak and data integrity issue.

Fix by taking invalidate_lock for all fallocate operations, not just for
punch/collapse/insert modes. This prevents concurrent page faults from
accessing unzeroed clusters during the allocation window.

Fixes: 495e90fa3348 ("ntfs: update attrib operations")
Cc: stable@vger.kernel.org
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: 0fecc393f206 ("ntfs: take invalidate_lock in ntfs_filemap_page_mkwrite")
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/file.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index fb8e525743970..317bb249150fd 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -1061,7 +1061,6 @@ static long ntfs_fallocate(struct file *file, int mode, loff_t offset, loff_t le
 	struct ntfs_volume *vol = ni->vol;
 	int err = 0;
 	loff_t old_size;
-	bool map_locked = false;
 
 	if (mode & ~(NTFS_FALLOC_FL_SUPPORTED))
 		return -EOPNOTSUPP;
@@ -1090,16 +1089,12 @@ static long ntfs_fallocate(struct file *file, int mode, loff_t offset, loff_t le
 
 	inode_lock(vi);
 	if (NInoCompressed(ni) || NInoEncrypted(ni)) {
-		err = -EOPNOTSUPP;
-		goto out;
+		inode_unlock(vi);
+		return -EOPNOTSUPP;
 	}
 
 	inode_dio_wait(vi);
-	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE |
-		    FALLOC_FL_INSERT_RANGE)) {
-		filemap_invalidate_lock(vi->i_mapping);
-		map_locked = true;
-	}
+	filemap_invalidate_lock(vi->i_mapping);
 
 	switch (mode & FALLOC_FL_MODE_MASK) {
 	case FALLOC_FL_ALLOCATE_RANGE:
@@ -1124,8 +1119,7 @@ static long ntfs_fallocate(struct file *file, int mode, loff_t offset, loff_t le
 
 	err = file_modified(file);
 out:
-	if (map_locked)
-		filemap_invalidate_unlock(vi->i_mapping);
+	filemap_invalidate_unlock(vi->i_mapping);
 	if (!err) {
 		if (mode == 0 && NInoNonResident(ni) &&
 		    offset > old_size) {
-- 
2.53.0



