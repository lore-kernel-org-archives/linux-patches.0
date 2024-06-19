Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEE214900C;
	Wed, 19 Jun 2024 13:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803822; cv=none; b=Az4V9CULWG4od0S/EpEw8uVMvOU9T3OoWqgx9VexZTtksGmqR0VkxA+hwzKWCYfUkhpivG7MoHu4QgQ2n6TBTomRmUv8CXiIaQ+ItfuxSaYQ9Slog4b9kQPVzSlCXjFfXng7mAsPWjsGwkR/H++WBhE44UL9yVfbuHwE37oOhOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803822; c=relaxed/simple;
	bh=6rsBD8X9WLOrw+VG9UDKSlo7zAt/VxjjS6qFrOSG00M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3r74/BpXy23hM5ReHlSXB7nCX5R7Mhdn/uEBPT4jUAif4oHUvrdH9ynjF2bk+J6XiP4AdOtn3yp6TJO4H2y2tWR9oxKA7OsZK1rlUQvTX6GEz8lXvqGhgT14nKr6mgqICPi8Bt4noUAuXTc/Cm4wLh+DTWFG4YYlvInQqwQKG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ra73nYl7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ra73nYl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB264C2BBFC;
	Wed, 19 Jun 2024 13:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803822;
	bh=6rsBD8X9WLOrw+VG9UDKSlo7zAt/VxjjS6qFrOSG00M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ra73nYl7/nZ5CqqdEyiT+XFrOkbstMvjB/ANyB3HMvX5enSP2Ur1QRjdSc9JQcsWd
	 hvZY1rTHMMOyeT/8iEpui9cp9l4CIccV2SWH1fUji7UF57neN+TcZe8otVsiLV/JGJ
	 rfEQhD4qHhNcRT10VKVehstU+0LjS/U+OGVxL0Xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 116/217] cachefiles: defer exposing anon_fd until after copy_to_user() succeeds
Date: Wed, 19 Jun 2024 14:55:59 +0200
Message-ID: <20240619125601.164784945@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 4b4391e77a6bf24cba2ef1590e113d9b73b11039 ]

After installing the anonymous fd, we can now see it in userland and close
it. However, at this point we may not have gotten the reference count of
the cache, but we will put it during colse fd, so this may cause a cache
UAF.

So grab the cache reference count before fd_install(). In addition, by
kernel convention, fd is taken over by the user land after fd_install(),
and the kernel should not call close_fd() after that, i.e., it should call
fd_install() after everything is ready, thus fd_install() is called after
copy_to_user() succeeds.

Fixes: c8383054506c ("cachefiles: notify the user daemon when looking up cookie")
Suggested-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20240522114308.2402121-10-libaokun@huaweicloud.com
Acked-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/ondemand.c | 53 +++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 20 deletions(-)

diff --git a/fs/cachefiles/ondemand.c b/fs/cachefiles/ondemand.c
index 773c3b407a33b..a8cfa5047aaf8 100644
--- a/fs/cachefiles/ondemand.c
+++ b/fs/cachefiles/ondemand.c
@@ -4,6 +4,11 @@
 #include <linux/uio.h>
 #include "internal.h"
 
+struct ondemand_anon_file {
+	struct file *file;
+	int fd;
+};
+
 static inline void cachefiles_req_put(struct cachefiles_req *req)
 {
 	if (refcount_dec_and_test(&req->ref))
@@ -250,14 +255,14 @@ int cachefiles_ondemand_restore(struct cachefiles_cache *cache, char *args)
 	return 0;
 }
 
-static int cachefiles_ondemand_get_fd(struct cachefiles_req *req)
+static int cachefiles_ondemand_get_fd(struct cachefiles_req *req,
+				      struct ondemand_anon_file *anon_file)
 {
 	struct cachefiles_object *object;
 	struct cachefiles_cache *cache;
 	struct cachefiles_open *load;
-	struct file *file;
 	u32 object_id;
-	int ret, fd;
+	int ret;
 
 	object = cachefiles_grab_object(req->object,
 			cachefiles_obj_get_ondemand_fd);
@@ -269,16 +274,16 @@ static int cachefiles_ondemand_get_fd(struct cachefiles_req *req)
 	if (ret < 0)
 		goto err;
 
-	fd = get_unused_fd_flags(O_WRONLY);
-	if (fd < 0) {
-		ret = fd;
+	anon_file->fd = get_unused_fd_flags(O_WRONLY);
+	if (anon_file->fd < 0) {
+		ret = anon_file->fd;
 		goto err_free_id;
 	}
 
-	file = anon_inode_getfile("[cachefiles]", &cachefiles_ondemand_fd_fops,
-				  object, O_WRONLY);
-	if (IS_ERR(file)) {
-		ret = PTR_ERR(file);
+	anon_file->file = anon_inode_getfile("[cachefiles]",
+				&cachefiles_ondemand_fd_fops, object, O_WRONLY);
+	if (IS_ERR(anon_file->file)) {
+		ret = PTR_ERR(anon_file->file);
 		goto err_put_fd;
 	}
 
@@ -286,16 +291,15 @@ static int cachefiles_ondemand_get_fd(struct cachefiles_req *req)
 	if (object->ondemand->ondemand_id > 0) {
 		spin_unlock(&object->ondemand->lock);
 		/* Pair with check in cachefiles_ondemand_fd_release(). */
-		file->private_data = NULL;
+		anon_file->file->private_data = NULL;
 		ret = -EEXIST;
 		goto err_put_file;
 	}
 
-	file->f_mode |= FMODE_PWRITE | FMODE_LSEEK;
-	fd_install(fd, file);
+	anon_file->file->f_mode |= FMODE_PWRITE | FMODE_LSEEK;
 
 	load = (void *)req->msg.data;
-	load->fd = fd;
+	load->fd = anon_file->fd;
 	object->ondemand->ondemand_id = object_id;
 	spin_unlock(&object->ondemand->lock);
 
@@ -304,9 +308,11 @@ static int cachefiles_ondemand_get_fd(struct cachefiles_req *req)
 	return 0;
 
 err_put_file:
-	fput(file);
+	fput(anon_file->file);
+	anon_file->file = NULL;
 err_put_fd:
-	put_unused_fd(fd);
+	put_unused_fd(anon_file->fd);
+	anon_file->fd = ret;
 err_free_id:
 	xa_erase(&cache->ondemand_ids, object_id);
 err:
@@ -363,6 +369,7 @@ ssize_t cachefiles_ondemand_daemon_read(struct cachefiles_cache *cache,
 	struct cachefiles_msg *msg;
 	size_t n;
 	int ret = 0;
+	struct ondemand_anon_file anon_file;
 	XA_STATE(xas, &cache->reqs, cache->req_id_next);
 
 	xa_lock(&cache->reqs);
@@ -396,7 +403,7 @@ ssize_t cachefiles_ondemand_daemon_read(struct cachefiles_cache *cache,
 	xa_unlock(&cache->reqs);
 
 	if (msg->opcode == CACHEFILES_OP_OPEN) {
-		ret = cachefiles_ondemand_get_fd(req);
+		ret = cachefiles_ondemand_get_fd(req, &anon_file);
 		if (ret)
 			goto out;
 	}
@@ -404,10 +411,16 @@ ssize_t cachefiles_ondemand_daemon_read(struct cachefiles_cache *cache,
 	msg->msg_id = xas.xa_index;
 	msg->object_id = req->object->ondemand->ondemand_id;
 
-	if (copy_to_user(_buffer, msg, n) != 0) {
+	if (copy_to_user(_buffer, msg, n) != 0)
 		ret = -EFAULT;
-		if (msg->opcode == CACHEFILES_OP_OPEN)
-			close_fd(((struct cachefiles_open *)msg->data)->fd);
+
+	if (msg->opcode == CACHEFILES_OP_OPEN) {
+		if (ret < 0) {
+			fput(anon_file.file);
+			put_unused_fd(anon_file.fd);
+			goto out;
+		}
+		fd_install(anon_file.fd, anon_file.file);
 	}
 out:
 	cachefiles_put_object(req->object, cachefiles_obj_put_read_req);
-- 
2.43.0



