Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038358;
	b=45vuLEaMaiuqQeW4fgVy5iK4Q02Grwm5TILuJAP7mMlpNbFeliVP2wsXDNeugaqBybmG
	 4BFSg84JPcD7Faqd15L2W9TLR/wi8PgaOEMgi3B3i2B/yA3swfGpw2Nn2ClpWS0M+YWy8
	 mxuQaKayw197JfbXaLqpjsmg71DjQ2xVOModQpcyGYomLI+iD1TSNe9Y0aIgW+gwpRctU
	 LR8m8hVnShRz0pKciW+c8epl0kcnKaSK0CEn2cgtarDUs4/SE8ZnPdJcQz8lyoF6Jvonv
	 f6vYzB1ePv5qF7AS3ULYPe7PQvQmubsvyfROfBwUVo1nQQ0JEVLdu93mG3US8zXT71A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1OvSq2S3byfP3TTye5r5TNYAJFkNifXeGDMARO3DAjY=;
	b=God8G3L30URgD0YaFAEUbN72xgmyaqi3nD6DuB2I9ASHc+PnuFIEvK4l+V2326DDB04X
	 yvtQ4TkXTtPyNjixLEBW5yZHBD77825XhNkr+1yPnkjVRlLIm3RyPZy9RGuONqhmOe2wz
	 FHLSXAFdz1XvcqubL1i9am/9vJpgEU8DB7lQ3Aqfoor5loFfLgFY/mXKH3fgYanj1x8ez
	 cBWC+Lu6Ek4HtB2E29+4Hd0mO8h6m1Y7i+iQBbwXD4eF+kJ+/pQz1RqpJo0P65pcTnO64
	 MlzwlMGMZ1UGWYgFl7FTTziNR5DQlqWtfGXsnTNOmbYxGG7ilGfORK9KG5oj9ZTT/cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kqwewJaD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE05606A325;
	Wed, 18 Nov 2026 21:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kqwewJaD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8541F000C5;
	Wed, 18 Nov 2026 21:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038358;
	bh=1OvSq2S3byfP3TTye5r5TNYAJFkNifXeGDMARO3DAjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kqwewJaDpmqF317p31rLSsv4K72sygDnLb1cH+Iv62C0IXeTu5ka07kDu4eVGzU0B
	 9EX4FcCupoGTmdyld7+l7kAgbpD1Jnju14TOZc9sHb/2lymcRk0u2EBWP7bF8R2mDu
	 brulEFfnjHYZhBtse3ahuuAr2acYb0jqvUKKynjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1716/3318] f2fs: atomic: fix to forbid dio in atomic_file
Date: Wed, 18 Nov 2026 15:38:58 +0100
Message-ID: <20261118150413.346984804@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit b2c160f4f3cfe9334b3e6bb52cb89a3a20ef0385 ]

atomic write can only be used via buffered IO, let's fail direct IO on
atomic_file and return -EOPNOTSUPP.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 06dfe4a7eb69 ("f2fs: disallow mmap write and data-modifying fallocate on atomic files")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index f4863d7331802..65aa0d889435c 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2275,6 +2275,7 @@ static int f2fs_ioc_start_atomic_write(struct file *filp, bool truncate)
 		goto out;
 
 	f2fs_down_write(&fi->i_gc_rwsem[WRITE]);
+	f2fs_down_write(&fi->i_gc_rwsem[READ]);
 
 	/*
 	 * Should wait end_io to count F2FS_WB_CP_DATA correctly by
@@ -2284,10 +2285,8 @@ static int f2fs_ioc_start_atomic_write(struct file *filp, bool truncate)
 		f2fs_warn(sbi, "Unexpected flush for atomic writes: ino=%lu, npages=%u",
 			  inode->i_ino, get_dirty_pages(inode));
 	ret = filemap_write_and_wait_range(inode->i_mapping, 0, LLONG_MAX);
-	if (ret) {
-		f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
-		goto out;
-	}
+	if (ret)
+		goto out_unlock;
 
 	/* Check if the inode already has a COW inode */
 	if (fi->cow_inode == NULL) {
@@ -2296,10 +2295,8 @@ static int f2fs_ioc_start_atomic_write(struct file *filp, bool truncate)
 		struct inode *dir = d_inode(dentry->d_parent);
 
 		ret = f2fs_get_tmpfile(idmap, dir, &fi->cow_inode);
-		if (ret) {
-			f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
-			goto out;
-		}
+		if (ret)
+			goto out_unlock;
 
 		set_inode_flag(fi->cow_inode, FI_COW_FILE);
 		clear_inode_flag(fi->cow_inode, FI_INLINE_DATA);
@@ -2313,10 +2310,8 @@ static int f2fs_ioc_start_atomic_write(struct file *filp, bool truncate)
 		invalidate_mapping_pages(fi->cow_inode->i_mapping, 0, -1);
 
 		ret = f2fs_do_truncate_blocks(fi->cow_inode, 0, true);
-		if (ret) {
-			f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
-			goto out;
-		}
+		if (ret)
+			goto out_unlock;
 	}
 
 	f2fs_write_inode(inode, NULL);
@@ -2335,7 +2330,11 @@ static int f2fs_ioc_start_atomic_write(struct file *filp, bool truncate)
 	}
 	f2fs_i_size_write(fi->cow_inode, isize);
 
+out_unlock:
+	f2fs_up_write(&fi->i_gc_rwsem[READ]);
 	f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
+	if (ret)
+		goto out;
 
 	f2fs_update_time(sbi, REQ_TIME);
 	fi->atomic_write_task = current;
@@ -4729,6 +4728,13 @@ static ssize_t f2fs_dio_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		f2fs_down_read(&fi->i_gc_rwsem[READ]);
 	}
 
+	/* dio is not compatible w/ atomic file */
+	if (f2fs_is_atomic_file(inode)) {
+		f2fs_up_read(&fi->i_gc_rwsem[READ]);
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
 	/*
 	 * We have to use __iomap_dio_rw() and iomap_dio_complete() instead of
 	 * the higher-level function iomap_dio_rw() in order to ensure that the
@@ -5134,6 +5140,12 @@ static ssize_t f2fs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	/* Determine whether we will do a direct write or a buffered write. */
 	dio = f2fs_should_use_dio(inode, iocb, from);
 
+	/* dio is not compatible w/ atomic write */
+	if (dio && f2fs_is_atomic_file(inode)) {
+		ret = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
 	/* Possibly preallocate the blocks for the write. */
 	target_size = iocb->ki_pos + iov_iter_count(from);
 	preallocated = f2fs_preallocate_blocks(iocb, from, dio);
-- 
2.53.0



