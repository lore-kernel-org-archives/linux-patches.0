Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867D2145324;
	Wed, 19 Jun 2024 13:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802178; cv=none; b=s8MK9o3UzhccWciaTL5sLIY2dLTbtuUIdW1PvWqzqBjsAyL11LoiEj7WIE4bTDlLY5lBvMByx3tqMggUw2ROYu3wvWW884AahOG7pSc/RrEVTOic1yGIXnnvf10GdItz8AqSHJTvlEvU7bti4PVylDHN0BxCW3OxXpBuHJMSF1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802178; c=relaxed/simple;
	bh=r7NcuWAOyY/7qSpwCt8qwK9uDg2kYFWN3JeQ0+fb3L4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XlTP4qGWU9LOh+p/GlJ2cX5kduEaCEhg0SibLSvF8HXYQcaMmzm2YDGWY6pBNjXwT5JtY6uGDwT3xWk4n0MhYPIGJ6WM3lp6ENo4n5Te88U7eKS4Sjs7FQ/TD/OsowLrxcyAKBdH3pg2NDAeH8kwBKsbQbP6EEc93ihjDcvxEqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hN2xXsfs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hN2xXsfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095AFC4AF1D;
	Wed, 19 Jun 2024 13:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802178;
	bh=r7NcuWAOyY/7qSpwCt8qwK9uDg2kYFWN3JeQ0+fb3L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hN2xXsfsoC1N5ML8tBBvxtYgeAFaUhwSCPNeFaQZcSg3ls56O2/SYZVc4nN67yx8l
	 AVs1X1IZmb2fFXcOEVIKl/bOEo+dxEIlSG/8iiQXqCBJqRfzxw680eQye8FdK5eD/2
	 0vc5NW9dZT0eBkSG/489GWJqPzwj3saF5QoKWuw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/267] cachefiles: add spin_lock for cachefiles_ondemand_info
Date: Wed, 19 Jun 2024 14:54:19 +0200
Message-ID: <20240619125610.500255184@linuxfoundation.org>
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
index b9a90f1a0c015..33fe418aca770 100644
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
index 8e130de952f7d..8118649d30727 100644
--- a/fs/cachefiles/ondemand.c
+++ b/fs/cachefiles/ondemand.c
@@ -10,13 +10,16 @@ static int cachefiles_ondemand_fd_release(struct inode *inode,
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
@@ -116,6 +119,7 @@ int cachefiles_ondemand_copen(struct cachefiles_cache *cache, char *args)
 {
 	struct cachefiles_req *req;
 	struct fscache_cookie *cookie;
+	struct cachefiles_ondemand_info *info;
 	char *pid, *psize;
 	unsigned long id;
 	long size;
@@ -166,6 +170,33 @@ int cachefiles_ondemand_copen(struct cachefiles_cache *cache, char *args)
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
@@ -175,6 +206,7 @@ int cachefiles_ondemand_copen(struct cachefiles_cache *cache, char *args)
 	trace_cachefiles_ondemand_copen(req->object, id, size);
 
 	cachefiles_ondemand_set_object_open(req->object);
+	spin_unlock(&info->lock);
 	wake_up_all(&cache->daemon_pollwq);
 
 out:
@@ -552,6 +584,7 @@ int cachefiles_ondemand_init_obj_info(struct cachefiles_object *object,
 		return -ENOMEM;
 
 	object->ondemand->object = object;
+	spin_lock_init(&object->ondemand->lock);
 	INIT_WORK(&object->ondemand->ondemand_work, ondemand_object_worker);
 	return 0;
 }
-- 
2.43.0



