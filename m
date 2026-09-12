Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35610374A12;
	Sat, 12 Sep 2026 09:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204931; cv=none; b=qQCOlkAfqgLwqe1RqhyyJrH+fe6MPdLbAhlj2qrs523t6cKq5OI7STn8wkvBwk6mjbcL1cwo/HpPPUx2HfeuJYn8/DdUaeL9cIBqUC1+1uJOC6J8tscUEOjOEm2M/e07nneYBcCsOBoqNqlmgTu3lnaCHj3yjU6z+dvLWfXnvAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204931; c=relaxed/simple;
	bh=CIfGP5lXmGWLdfo4cw4P28OarzWLBOUKeqIn0RR6ujE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G74DASRTsw0WGVj+y7rUjNQq5WbyGCoAwqqiNWJK1Fvuvd9gejEZszQY0gSYVx20+vw3+XQVCJH1KYD9VfX23zfToBg5l47veqpNk8gWv47f34ZHA8rGSMOHxUKQRXPvCxMBsCKqM30fIlyx6/iCBGH5Tp6XsYfX+srz9uerBu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zAYzYCO3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zAYzYCO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AE81F00893;
	Sat, 12 Sep 2026 09:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204930;
	bh=Xo1w6x1XzPZ+JXMOfQ4B9Qec7+SymifWadiBCZvEtX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zAYzYCO3q0Vf5s5e5soAuGjTLItN+7tZS4LGrQdxkEmsDOZu4DBWf2X6+BpyM83tR
	 IMfM+Q0b0bsAJ5gsXORY4+gULTY8wqtY9OCBTBv/JNBHKZPnjVg/GiBMQ7y7wrIqVJ
	 slzuWZn8nMriRnsTtInSPVuQrFz5HGox2a9C3a4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seongjae Jeong <jsjlee1020@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1714/1815] f2fs: use adjusted write range after f2fs_write_checks()
Date: Sat, 12 Sep 2026 08:57:44 +0200
Message-ID: <20260912065729.212058022@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Seongjae Jeong <jsjlee1020@gmail.com>

[ Upstream commit 3b2c5d35cf4398edf47c4a3ad076838654a30015 ]

generic_write_checks() in f2fs_write_checks() can adjust iocb->ki_pos
for append writes and truncate the iterator to limit the number of bytes
to write.

In f2fs_file_write_iter(), the pinned-file overwrite check currently
uses the position and count saved before f2fs_write_checks(), so it
can check a range different from the actual write range.

The forced buffered I/O cleanup also uses orig_pos saved before
f2fs_write_checks(). For O_APPEND writes, this can make the cleanup
flush and invalidate the wrong page cache range.

Move the pinned-file overwrite check after f2fs_write_checks() and use
the adjusted iocb->ki_pos and iov_iter_count(from). Also save the
adjusted write position and use it for the forced buffered I/O cleanup.

Fixes: 3fdd89b452c2 ("f2fs: prevent writing without fallocate() for pinned files")
Fixes: 92318f20d703 ("f2fs: preserve direct write semantics when buffering is forced")
Signed-off-by: Seongjae Jeong <jsjlee1020@gmail.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 67fcea7408b1b..f5c169dced2dd 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -5379,9 +5379,8 @@ static ssize_t f2fs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	bool dio;
 	bool may_need_sync = true;
 	int preallocated;
-	const loff_t pos = iocb->ki_pos;
-	const ssize_t count = iov_iter_count(from);
 	ssize_t ret;
+	loff_t bufio_start_pos;
 
 	if (unlikely(f2fs_cp_error(F2FS_I_SB(inode)))) {
 		ret = -EIO;
@@ -5402,15 +5401,17 @@ static ssize_t f2fs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		inode_lock(inode);
 	}
 
+	ret = f2fs_write_checks(iocb, from);
+	if (ret <= 0)
+		goto out_unlock;
+
 	if (f2fs_is_pinned_file(inode) &&
-	    !f2fs_overwrite_io(inode, pos, count)) {
+	    !f2fs_overwrite_io(inode, iocb->ki_pos, iov_iter_count(from))) {
 		ret = -EIO;
 		goto out_unlock;
 	}
 
-	ret = f2fs_write_checks(iocb, from);
-	if (ret <= 0)
-		goto out_unlock;
+	bufio_start_pos = iocb->ki_pos;
 
 	/* Determine whether we will do a direct write or a buffered write. */
 	dio = f2fs_should_use_dio(inode, iocb, from);
@@ -5465,8 +5466,8 @@ static ssize_t f2fs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	 */
 	if (ret > 0 && !dio && (iocb->ki_flags & IOCB_DIRECT))
 		f2fs_flush_buffered_write(iocb->ki_filp->f_mapping,
-					  orig_pos,
-					  orig_pos + ret - 1);
+					  bufio_start_pos,
+					  bufio_start_pos + ret - 1);
 
 	return ret;
 }
-- 
2.53.0



