Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4731487F1;
	Wed, 19 Jun 2024 13:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802196; cv=none; b=AAVZAs3KheWfsE95PsouGTFfM7XfcTIy8kfBImcuobZQ9u7Dh1A2a9PGO+VHzjL8Z2vD9aVAz09KCjb14w6V/Lko7YAkquRtJ6HetP2O5XTB7LQURRivJ4zumeLf+VbuIUTkKeuczLkpkCg37EtTfbFICqwNNOF1Wv16H1McTWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802196; c=relaxed/simple;
	bh=LmnYjva5XnEY7dIm70pcZWK+0G/0L0udklOPDCyByVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhJD9ZnNdGNnvfOldDFYGVDGTLqKsOK0J6F/4+EMEMB54s6Oq5PWHpo+Rhx+nMHgWsnLPWqY7ur/QIi2Aefc8t84UUya4t/tLKZcjVyJ4V8/oWwChhhlOsGyokRuH7tqLHgPRtr3+wnCIL5DveqUNn/ochUx4ciz3HVAczEUVOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+WAhCnq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+WAhCnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82AEC2BBFC;
	Wed, 19 Jun 2024 13:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802196;
	bh=LmnYjva5XnEY7dIm70pcZWK+0G/0L0udklOPDCyByVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+WAhCnqY/MrBR5VXEmkov1BIYgR38S+FPuOGU3NFoV22V3/rkLyqrjAjuicFFTSx
	 YXbbaYSGaKcC/L41Kn9mfgMxSqjFhXJgK6k5IEdJEY7f3SZ3Ml+qxFIjiyuhbVgsnr
	 +wtjTaWpKYVCIGKZkyMm56IlfIsaFkjJBaLgQclM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 113/267] cachefiles: never get a new anonymous fd if ondemand_id is valid
Date: Wed, 19 Jun 2024 14:54:24 +0200
Message-ID: <20240619125610.689028587@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 4988e35e95fc938bdde0e15880fe72042fc86acf ]

Now every time the daemon reads an open request, it gets a new anonymous fd
and ondemand_id. With the introduction of "restore", it is possible to read
the same open request more than once, and therefore an object can have more
than one anonymous fd.

If the anonymous fd is not unique, the following concurrencies will result
in an fd leak:

     t1     |         t2         |          t3
------------------------------------------------------------
 cachefiles_ondemand_init_object
  cachefiles_ondemand_send_req
   REQ_A = kzalloc(sizeof(*req) + data_len)
   wait_for_completion(&REQ_A->done)
            cachefiles_daemon_read
             cachefiles_ondemand_daemon_read
              REQ_A = cachefiles_ondemand_select_req
              cachefiles_ondemand_get_fd
                load->fd = fd0
                ondemand_id = object_id0
                                  ------ restore ------
                                  cachefiles_ondemand_restore
                                   // restore REQ_A
                                  cachefiles_daemon_read
                                   cachefiles_ondemand_daemon_read
                                    REQ_A = cachefiles_ondemand_select_req
                                      cachefiles_ondemand_get_fd
                                        load->fd = fd1
                                        ondemand_id = object_id1
             process_open_req(REQ_A)
             write(devfd, ("copen %u,%llu", msg->msg_id, size))
             cachefiles_ondemand_copen
              xa_erase(&cache->reqs, id)
              complete(&REQ_A->done)
   kfree(REQ_A)
                                  process_open_req(REQ_A)
                                  // copen fails due to no req
                                  // daemon close(fd1)
                                  cachefiles_ondemand_fd_release
                                   // set object closed
 -- umount --
 cachefiles_withdraw_cookie
  cachefiles_ondemand_clean_object
   cachefiles_ondemand_init_close_req
    if (!cachefiles_ondemand_object_is_open(object))
      return -ENOENT;
    // The fd0 is not closed until the daemon exits.

However, the anonymous fd holds the reference count of the object and the
object holds the reference count of the cookie. So even though the cookie
has been relinquished, it will not be unhashed and freed until the daemon
exits.

In fscache_hash_cookie(), when the same cookie is found in the hash list,
if the cookie is set with the FSCACHE_COOKIE_RELINQUISHED bit, then the new
cookie waits for the old cookie to be unhashed, while the old cookie is
waiting for the leaked fd to be closed, if the daemon does not exit in time
it will trigger a hung task.

To avoid this, allocate a new anonymous fd only if no anonymous fd has
been allocated (ondemand_id == 0) or if the previously allocated anonymous
fd has been closed (ondemand_id == -1). Moreover, returns an error if
ondemand_id is valid, letting the daemon know that the current userland
restore logic is abnormal and needs to be checked.

Fixes: c8383054506c ("cachefiles: notify the user daemon when looking up cookie")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20240522114308.2402121-9-libaokun@huaweicloud.com
Acked-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 4b4391e77a6b ("cachefiles: defer exposing anon_fd until after copy_to_user() succeeds")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/ondemand.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/fs/cachefiles/ondemand.c b/fs/cachefiles/ondemand.c
index 99b4bffad4a4f..773c3b407a33b 100644
--- a/fs/cachefiles/ondemand.c
+++ b/fs/cachefiles/ondemand.c
@@ -14,11 +14,18 @@ static int cachefiles_ondemand_fd_release(struct inode *inode,
 					  struct file *file)
 {
 	struct cachefiles_object *object = file->private_data;
-	struct cachefiles_cache *cache = object->volume->cache;
-	struct cachefiles_ondemand_info *info = object->ondemand;
+	struct cachefiles_cache *cache;
+	struct cachefiles_ondemand_info *info;
 	int object_id;
 	struct cachefiles_req *req;
-	XA_STATE(xas, &cache->reqs, 0);
+	XA_STATE(xas, NULL, 0);
+
+	if (!object)
+		return 0;
+
+	info = object->ondemand;
+	cache = object->volume->cache;
+	xas.xa = &cache->reqs;
 
 	xa_lock(&cache->reqs);
 	spin_lock(&info->lock);
@@ -275,22 +282,39 @@ static int cachefiles_ondemand_get_fd(struct cachefiles_req *req)
 		goto err_put_fd;
 	}
 
+	spin_lock(&object->ondemand->lock);
+	if (object->ondemand->ondemand_id > 0) {
+		spin_unlock(&object->ondemand->lock);
+		/* Pair with check in cachefiles_ondemand_fd_release(). */
+		file->private_data = NULL;
+		ret = -EEXIST;
+		goto err_put_file;
+	}
+
 	file->f_mode |= FMODE_PWRITE | FMODE_LSEEK;
 	fd_install(fd, file);
 
 	load = (void *)req->msg.data;
 	load->fd = fd;
 	object->ondemand->ondemand_id = object_id;
+	spin_unlock(&object->ondemand->lock);
 
 	cachefiles_get_unbind_pincount(cache);
 	trace_cachefiles_ondemand_open(object, &req->msg, load);
 	return 0;
 
+err_put_file:
+	fput(file);
 err_put_fd:
 	put_unused_fd(fd);
 err_free_id:
 	xa_erase(&cache->ondemand_ids, object_id);
 err:
+	spin_lock(&object->ondemand->lock);
+	/* Avoid marking an opened object as closed. */
+	if (object->ondemand->ondemand_id <= 0)
+		cachefiles_ondemand_set_object_close(object);
+	spin_unlock(&object->ondemand->lock);
 	cachefiles_put_object(object, cachefiles_obj_put_ondemand_fd);
 	return ret;
 }
@@ -373,10 +397,8 @@ ssize_t cachefiles_ondemand_daemon_read(struct cachefiles_cache *cache,
 
 	if (msg->opcode == CACHEFILES_OP_OPEN) {
 		ret = cachefiles_ondemand_get_fd(req);
-		if (ret) {
-			cachefiles_ondemand_set_object_close(req->object);
+		if (ret)
 			goto out;
-		}
 	}
 
 	msg->msg_id = xas.xa_index;
-- 
2.43.0



