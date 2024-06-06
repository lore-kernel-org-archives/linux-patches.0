Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A4419DF6B;
	Thu,  6 Jun 2024 14:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683498; cv=none; b=gJbvnPPqRcQ8xATv116m8HziPAovZN5ossgj+KTJsj0CbNSGrBPEd9UOm/zc+UZFa5IderWY7K2FOiuGldNgWLfBtxdHuHjmit3sumKu6seAS5KI5yOz9i0WO6E/juWsehFihIByFmB4ToCMQK6/AfM+ZWjMHiJmjF9YhLi/Vb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683498; c=relaxed/simple;
	bh=8QKRzpr5h4Op4t6AeqRjiWy9baNiahcAAxP9MPhfL4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SpTRcwpJX1Fbh9Ezh557Yi7NWnCEAIPBEyxr/b4x56HQo8Lgcw25awOKPvUNrvkjf12NtMJafy+xMbXM0HW64W4Qni6gQQ9V84iI+pfpBJLlzrf/gqriX4OeESodTPmjJFoorqtmCkjSOM6/HhNQjVNkhSI9A5RbJAbcLWNPaKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SiOWwGO7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SiOWwGO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DD8C32781;
	Thu,  6 Jun 2024 14:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683498;
	bh=8QKRzpr5h4Op4t6AeqRjiWy9baNiahcAAxP9MPhfL4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SiOWwGO7Wy+lpzeD81L4o/ZGUSmB23c8K0dYRzmn4BK5DU1v3BBwJsWbxxaH9Zh4v
	 AcswwsBKcM3G+y3gQMu9LuzfCL1Opwp5tDuQESAjQEzypgEyai4PeWMC2c0eIyR328
	 hR0isVbjqdv1AJ8OQ09DEk7q9HP5TN5xvQ0twDic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 440/744] fs: move kiocb_start_write() into vfs_iocb_iter_write()
Date: Thu,  6 Jun 2024 16:01:52 +0200
Message-ID: <20240606131746.600659628@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 6ae654392bb516a0baa47fed1f085d84e8cad739 ]

In vfs code, sb_start_write() is usually called after the permission hook
in rw_verify_area().  vfs_iocb_iter_write() is an exception to this rule,
where kiocb_start_write() is called by its callers.

Move kiocb_start_write() from the callers into vfs_iocb_iter_write()
after the rw_verify_area() checks, to make them "start-write-safe".

The semantics of vfs_iocb_iter_write() is changed, so that the caller is
responsible for calling kiocb_end_write() on completion only if async
iocb was queued.  The completion handlers of both callers were adapted
to this semantic change.

This is needed for fanotify "pre content" events.

Suggested-by: Jan Kara <jack@suse.cz>
Suggested-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://lore.kernel.org/r/20231122122715.2561213-14-amir73il@gmail.com
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 7c98f7cb8fda ("remove call_{read,write}_iter() functions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/io.c  | 5 ++---
 fs/overlayfs/file.c | 8 ++++----
 fs/read_write.c     | 7 +++++++
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/cachefiles/io.c b/fs/cachefiles/io.c
index 009d23cd435b5..5857241c59181 100644
--- a/fs/cachefiles/io.c
+++ b/fs/cachefiles/io.c
@@ -259,7 +259,8 @@ static void cachefiles_write_complete(struct kiocb *iocb, long ret)
 
 	_enter("%ld", ret);
 
-	kiocb_end_write(iocb);
+	if (ki->was_async)
+		kiocb_end_write(iocb);
 
 	if (ret < 0)
 		trace_cachefiles_io_error(object, inode, ret,
@@ -319,8 +320,6 @@ int __cachefiles_write(struct cachefiles_object *object,
 		ki->iocb.ki_complete = cachefiles_write_complete;
 	atomic_long_add(ki->b_writing, &cache->b_writing);
 
-	kiocb_start_write(&ki->iocb);
-
 	get_file(ki->iocb.ki_filp);
 	cachefiles_grab_object(object, cachefiles_obj_get_ioreq);
 
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 9fd88579bfbfb..a1c64c2b8e204 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -295,10 +295,8 @@ static void ovl_aio_cleanup_handler(struct ovl_aio_req *aio_req)
 	struct kiocb *iocb = &aio_req->iocb;
 	struct kiocb *orig_iocb = aio_req->orig_iocb;
 
-	if (iocb->ki_flags & IOCB_WRITE) {
-		kiocb_end_write(iocb);
+	if (iocb->ki_flags & IOCB_WRITE)
 		ovl_file_modified(orig_iocb->ki_filp);
-	}
 
 	orig_iocb->ki_pos = iocb->ki_pos;
 	ovl_aio_put(aio_req);
@@ -310,6 +308,9 @@ static void ovl_aio_rw_complete(struct kiocb *iocb, long res)
 						   struct ovl_aio_req, iocb);
 	struct kiocb *orig_iocb = aio_req->orig_iocb;
 
+	if (iocb->ki_flags & IOCB_WRITE)
+		kiocb_end_write(iocb);
+
 	ovl_aio_cleanup_handler(aio_req);
 	orig_iocb->ki_complete(orig_iocb, res);
 }
@@ -421,7 +422,6 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 		aio_req->iocb.ki_flags = ifl;
 		aio_req->iocb.ki_complete = ovl_aio_rw_complete;
 		refcount_set(&aio_req->ref, 2);
-		kiocb_start_write(&aio_req->iocb);
 		ret = vfs_iocb_iter_write(real.file, &aio_req->iocb, iter);
 		ovl_aio_put(aio_req);
 		if (ret != -EIOCBQUEUED)
diff --git a/fs/read_write.c b/fs/read_write.c
index 4771701c896ba..9a56949f3b8d1 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -865,6 +865,10 @@ static ssize_t do_iter_write(struct file *file, struct iov_iter *iter,
 	return ret;
 }
 
+/*
+ * Caller is responsible for calling kiocb_end_write() on completion
+ * if async iocb was queued.
+ */
 ssize_t vfs_iocb_iter_write(struct file *file, struct kiocb *iocb,
 			    struct iov_iter *iter)
 {
@@ -885,7 +889,10 @@ ssize_t vfs_iocb_iter_write(struct file *file, struct kiocb *iocb,
 	if (ret < 0)
 		return ret;
 
+	kiocb_start_write(iocb);
 	ret = call_write_iter(file, iocb, iter);
+	if (ret != -EIOCBQUEUED)
+		kiocb_end_write(iocb);
 	if (ret > 0)
 		fsnotify_modify(file);
 
-- 
2.43.0



