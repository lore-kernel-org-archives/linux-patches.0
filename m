Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2B33BBF2;
	Mon, 14 Oct 2024 15:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918146; cv=none; b=Cjdc38FiqYidLn8IS7u1yFY5d6eLW8tcns6EXXH9xYQt9dUQ40yNbkrylepCC0uAhAWiqOvWvRdwa/P7Hbtfr0mWwA5niFosD5ADPBjHG9DAUyOuxCkosc3jo/kwQ7SEGcNL1zd7ekVHK+ZX4dnNusSnQh2WjsvHFV/PwrqiFOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918146; c=relaxed/simple;
	bh=FiBrUctCpVfyztz8zsqH8TS8uUaqVGCvwKN+j5cR6ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebmTfrynBxLx55arkNyjYzTHsvWKQGjKZjOfmIdqZyP7L1h+NkB4fbIKka4LPe0Y/yNV/50PF0kaJNY3WNsTFjLu9MGJx4W2F6ZUp0p6SPu6d1jctPqiPD3qjU8NpOjDRwnCeicsyUnIw0sNVbBk0aHc0lwgAaAj0K2qzegADbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CdZWOPWN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CdZWOPWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6880AC4CEC3;
	Mon, 14 Oct 2024 15:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918145;
	bh=FiBrUctCpVfyztz8zsqH8TS8uUaqVGCvwKN+j5cR6ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CdZWOPWNqI4ziq/TK//i0Z0nDzUpKdZWGoETbHsZ3Be84JIDxdxf7Qt/on/TWW3j0
	 1kSo+lccMZA+OMJiq6n3Hf66pcPD8i6pTzp0pFOIi3TWX4Gpl5j++QgcrfogG0Mirw
	 WHMSZEKxK5AekAAvOSc2oR16yE6TjykqdRBw51NA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 237/798] f2fs: factor the read/write tracing logic into a helper
Date: Mon, 14 Oct 2024 16:13:11 +0200
Message-ID: <20241014141227.230431730@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit a28bca0f47feb5cdfc22be0e563bd4da2aed74f7 ]

Factor the logic to log a path for reads and writs into a helper
shared between the read_iter and write_iter methods.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 0cac51185e65 ("f2fs: fix to avoid racing in between read and OPU dio write")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 61 +++++++++++++++++++++-----------------------------
 1 file changed, 26 insertions(+), 35 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 6ce8997fc61e0..81394c08ef850 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -4457,6 +4457,27 @@ static ssize_t f2fs_dio_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	return ret;
 }
 
+static void f2fs_trace_rw_file_path(struct kiocb *iocb, size_t count, int rw)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	char *buf, *path;
+
+	buf = f2fs_kmalloc(F2FS_I_SB(inode), PATH_MAX, GFP_KERNEL);
+	if (!buf)
+		return;
+	path = dentry_path_raw(file_dentry(iocb->ki_filp), buf, PATH_MAX);
+	if (IS_ERR(path))
+		goto free_buf;
+	if (rw == WRITE)
+		trace_f2fs_datawrite_start(inode, iocb->ki_pos, count,
+				current->pid, path, current->comm);
+	else
+		trace_f2fs_dataread_start(inode, iocb->ki_pos, count,
+				current->pid, path, current->comm);
+free_buf:
+	kfree(buf);
+}
+
 static ssize_t f2fs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
@@ -4466,24 +4487,9 @@ static ssize_t f2fs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	if (!f2fs_is_compress_backend_ready(inode))
 		return -EOPNOTSUPP;
 
-	if (trace_f2fs_dataread_start_enabled()) {
-		char *p = f2fs_kmalloc(F2FS_I_SB(inode), PATH_MAX, GFP_KERNEL);
-		char *path;
-
-		if (!p)
-			goto skip_read_trace;
+	if (trace_f2fs_dataread_start_enabled())
+		f2fs_trace_rw_file_path(iocb, iov_iter_count(to), READ);
 
-		path = dentry_path_raw(file_dentry(iocb->ki_filp), p, PATH_MAX);
-		if (IS_ERR(path)) {
-			kfree(p);
-			goto skip_read_trace;
-		}
-
-		trace_f2fs_dataread_start(inode, pos, iov_iter_count(to),
-					current->pid, path, current->comm);
-		kfree(p);
-	}
-skip_read_trace:
 	if (f2fs_should_use_dio(inode, iocb, to)) {
 		ret = f2fs_dio_read_iter(iocb, to);
 	} else {
@@ -4789,24 +4795,9 @@ static ssize_t f2fs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (preallocated < 0) {
 		ret = preallocated;
 	} else {
-		if (trace_f2fs_datawrite_start_enabled()) {
-			char *p = f2fs_kmalloc(F2FS_I_SB(inode),
-						PATH_MAX, GFP_KERNEL);
-			char *path;
-
-			if (!p)
-				goto skip_write_trace;
-			path = dentry_path_raw(file_dentry(iocb->ki_filp),
-								p, PATH_MAX);
-			if (IS_ERR(path)) {
-				kfree(p);
-				goto skip_write_trace;
-			}
-			trace_f2fs_datawrite_start(inode, orig_pos, orig_count,
-					current->pid, path, current->comm);
-			kfree(p);
-		}
-skip_write_trace:
+		if (trace_f2fs_datawrite_start_enabled())
+			f2fs_trace_rw_file_path(iocb, orig_count, WRITE);
+
 		/* Do the actual write. */
 		ret = dio ?
 			f2fs_dio_write_iter(iocb, from, &may_need_sync) :
-- 
2.43.0



