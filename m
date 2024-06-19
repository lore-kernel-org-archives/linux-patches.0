Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A399C82495;
	Wed, 19 Jun 2024 13:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803075; cv=none; b=imZlfaHbaJB2zzIDO2btBEbOl7vTI5uhTpBTaNFLHPjRUq4zHSgYoIJwqM2DIG5mUP7VT81jvmLP/DmYdMtFS/eGyaX1YsIY0CYXDTaYQV7x+DK/pWwtiQK1BLkWY/9G0xkbkv/uJqL1A8Ut1wa0CwC0mn9B3XvozyV6nE+xFUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803075; c=relaxed/simple;
	bh=20yK+tgX0e7JgBblRchSQ4W8dcMLIBYJlZqwKTcuAfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m67XhOSxQbcVGSVMwKnjf1TPJVpZ5IHB2IbDr3eELBTX749XvEPchbHIPegVWkpK+EIdlt2+v1QsgW+KsAu3IakKe4xvWe/FJN5WKarH38QIzbV5l+qaTQd/ysJr9q/rvBrJ/gDUPmqMed3TYj2onR0VCCpWjBTaCA29Mk7OL3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DBKu6ZHx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DBKu6ZHx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A5AC2BBFC;
	Wed, 19 Jun 2024 13:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803075;
	bh=20yK+tgX0e7JgBblRchSQ4W8dcMLIBYJlZqwKTcuAfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DBKu6ZHxA0n1rC5MssT3VidWQ8fXwHYrd1zb+ebaC8xwhaOVhPl8YrWIYbq+iFlu0
	 s7vJiK9u5LzW2hLPFVmYIEGh4ek/z069rW81j3fR7/shwfN0nDT/trGntIaXfB/v4l
	 8zJpOZfqAR+84Ch2AECbzeJcLzHElYb11Q/f/Atc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 114/281] cachefiles: add spin_lock for cachefiles_ondemand_info
Date: Wed, 19 Jun 2024 14:54:33 +0200
Message-ID: <20240619125614.234153684@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 0a790040838c736495d5afd6b2d636f159f817f1 ]

The following concurrency may cause a read request to fail to be completed
and result in a hung:

           t1             |             t2
---------------------------------------------------------
                            cachefiles_ondemand_copen
                              req = xa_erase(&cache->reqs, id)
// Anon fd is maliciously closed.
cachefiles_ondemand_fd_release
  xa_lock(&cache->reqs)
  cachefiles_ondemand_set_object_close(object)
  xa_unlock(&cache->reqs)
                              cachefiles_ondemand_set_object_open
                              // No one will ever close it again.
cachefiles_ondemand_daemon_read
  cachefiles_ondemand_select_req
  // Get a read req but its fd is already closed.
  // The daemon can't issue a cread ioctl with an closed fd, then hung.

So add spin_lock for cachefiles_ondemand_info to protect ondemand_id and
state, thus we can avoid the above problem in cachefiles_ondemand_copen()
by using ondemand_id to determine if fd has been closed.

Fixes: c8383054506c ("cachefiles: notify the user daemon when looking up cookie")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20240522114308.2402121-8-libaokun@huaweicloud.com
Acked-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/internal.h |  1 +
 fs/cachefiles/ondemand.c | 35 ++++++++++++++++++++++++++++++++++-
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/fs/cachefiles/internal.h b/fs/cachefiles/internal.h
index 7745b8abc3aa3..45c8bed605383 100644
--- a/fs/cachefiles/internal.h
+++ b/fs/cachefiles/internal.h
@@ -55,6 +55,7 @@ struct cachefiles_ondemand_info {
 	int				ondemand_id;
 	enum cachefiles_object_state	state;
 	struct cachefiles_object	*object;
+	spinlock_t			lock;
 };
 
 /*
diff --git a/fs/cachefiles/ondemand.c b/fs/cachefiles/ondemand.c
index 3dd002108a872..7b667ddc84ca5 100644
--- a/fs/cachefiles/ondemand.c
+++ b/fs/cachefiles/ondemand.c
@@ -16,13 +16,16 @@ static int cachefiles_ondemand_fd_release(struct inode *inode,
 	struct cachefiles_object *object = file->private_data;
 	struct cachefiles_cache *cache = object->volume->cache;
 	struct cachefiles_ondemand_info *info = object->ondemand;
-	int object_id = info->ondemand_id;
+	int object_id;
 	struct cachefiles_req *req;
 	XA_STATE(xas, &cache->reqs, 0);
 
 	xa_lock(&cache->reqs);
+	spin_lock(&info->lock);
+	object_id = info->ondemand_id;
 	info->ondemand_id = CACHEFILES_ONDEMAND_ID_CLOSED;
 	cachefiles_ondemand_set_object_close(object);
+	spin_unlock(&info->lock);
 
 	/* Only flush CACHEFILES_REQ_NEW marked req to avoid race with daemon_read */
 	xas_for_each_marked(&xas, req, ULONG_MAX, CACHEFILES_REQ_NEW) {
@@ -122,6 +125,7 @@ int cachefiles_ondemand_copen(struct cachefiles_cache *cache, char *args)
 {
 	struct cachefiles_req *req;
 	struct fscache_cookie *cookie;
+	struct cachefiles_ondemand_info *info;
 	char *pid, *psize;
 	unsigned long id;
 	long size;
@@ -172,6 +176,33 @@ int cachefiles_ondemand_copen(struct cachefiles_cache *cache, char *args)
 		goto out;
 	}
 
+	info = req->object->ondemand;
+	spin_lock(&info->lock);
+	/*
+	 * The anonymous fd was closed before copen ? Fail the request.
+	 *
+	 *             t1             |             t2
+	 * ---------------------------------------------------------
+	 *                             cachefiles_ondemand_copen
+	 *                             req = xa_erase(&cache->reqs, id)
+	 * // Anon fd is maliciously closed.
+	 * cachefiles_ondemand_fd_release
+	 * xa_lock(&cache->reqs)
+	 * cachefiles_ondemand_set_object_close(object)
+	 * xa_unlock(&cache->reqs)
+	 *                             cachefiles_ondemand_set_object_open
+	 *                             // No one will ever close it again.
+	 * cachefiles_ondemand_daemon_read
+	 * cachefiles_ondemand_select_req
+	 *
+	 * Get a read req but its fd is already closed. The daemon can't
+	 * issue a cread ioctl with an closed fd, then hung.
+	 */
+	if (info->ondemand_id == CACHEFILES_ONDEMAND_ID_CLOSED) {
+		spin_unlock(&info->lock);
+		req->error = -EBADFD;
+		goto out;
+	}
 	cookie = req->object->cookie;
 	cookie->object_size = size;
 	if (size)
@@ -181,6 +212,7 @@ int cachefiles_ondemand_copen(struct cachefiles_cache *cache, char *args)
 	trace_cachefiles_ondemand_copen(req->object, id, size);
 
 	cachefiles_ondemand_set_object_open(req->object);
+	spin_unlock(&info->lock);
 	wake_up_all(&cache->daemon_pollwq);
 
 out:
@@ -596,6 +628,7 @@ int cachefiles_ondemand_init_obj_info(struct cachefiles_object *object,
 		return -ENOMEM;
 
 	object->ondemand->object = object;
+	spin_lock_init(&object->ondemand->lock);
 	INIT_WORK(&object->ondemand->ondemand_work, ondemand_object_worker);
 	return 0;
 }
-- 
2.43.0



