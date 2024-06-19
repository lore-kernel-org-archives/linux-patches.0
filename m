Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C5F143873;
	Wed, 19 Jun 2024 13:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802172; cv=none; b=LA/mCOyR+Kd24VT86QFNZI/q8cPhmAqvEhwGL+wJ1JqboGiWHYKgS1jARAv/tp8XSfSZJjK1iuDLrZDUFHdK5VuorlVcY7NpfO3no7MLCqFd8tbe8+sYW1CrBTQauh1N1KDt3v/QjiuOJrUUfUj5/l0EP1VdZ5Np1HyGgt9S3nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802172; c=relaxed/simple;
	bh=tHUOVqGubLS+z0+EeK5QYpSYdrtL0ejpImV6zVrCBXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DdqL5tNDqoRysWYAVulli/095UrwhXy6OmaYS9w7S5PHDS1wW3hhbJqFFEjnF/M6kuGu8vH8n5bk1rRnzexWA34m5P7jO9teK2AYZl/0LMP7/HCGkMtiw1FR/R/6UAaii5AYk5Z3y5xfs79VUcssB8x2BYzejLfsCfXwwQknRIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L3pkboXc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L3pkboXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE90C2BBFC;
	Wed, 19 Jun 2024 13:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802172;
	bh=tHUOVqGubLS+z0+EeK5QYpSYdrtL0ejpImV6zVrCBXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L3pkboXckgvYNI1QxW5ig0BP2DrbBrbCIGzX5TXCgg7M/ZBG4L5oAkuCI/kPAem+J
	 12YK6I3x0E8t0tEGDB0dQ6FSqD0fqS7ppi3oPAa74nwLQpXulinFER12JMuJTx3H32
	 goiUaS66WO8uJqgo23KwLRFoxpB3ERYNvMbDR5xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Zhu <zhujia.zj@bytedance.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 106/267] cachefiles: extract ondemand info field from cachefiles_object
Date: Wed, 19 Jun 2024 14:54:17 +0200
Message-ID: <20240619125610.423508064@linuxfoundation.org>
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

From: Jia Zhu <zhujia.zj@bytedance.com>

[ Upstream commit 3c5ecfe16e7699011c12c2d44e55437415331fa3 ]

We'll introduce a @work_struct field for @object in subsequent patches,
it will enlarge the size of @object.
As the result of that, this commit extracts ondemand info field from
@object.

Signed-off-by: Jia Zhu <zhujia.zj@bytedance.com>
Link: https://lore.kernel.org/r/20231120041422.75170-3-zhujia.zj@bytedance.com
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 0a790040838c ("cachefiles: add spin_lock for cachefiles_ondemand_info")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/interface.c |  7 ++++++-
 fs/cachefiles/internal.h  | 26 ++++++++++++++++++++++----
 fs/cachefiles/ondemand.c  | 34 ++++++++++++++++++++++++++++------
 3 files changed, 56 insertions(+), 11 deletions(-)

diff --git a/fs/cachefiles/interface.c b/fs/cachefiles/interface.c
index 40052bdb33655..35ba2117a6f65 100644
--- a/fs/cachefiles/interface.c
+++ b/fs/cachefiles/interface.c
@@ -31,6 +31,11 @@ struct cachefiles_object *cachefiles_alloc_object(struct fscache_cookie *cookie)
 	if (!object)
 		return NULL;
 
+	if (cachefiles_ondemand_init_obj_info(object, volume)) {
+		kmem_cache_free(cachefiles_object_jar, object);
+		return NULL;
+	}
+
 	refcount_set(&object->ref, 1);
 
 	spin_lock_init(&object->lock);
@@ -88,7 +93,7 @@ void cachefiles_put_object(struct cachefiles_object *object,
 		ASSERTCMP(object->file, ==, NULL);
 
 		kfree(object->d_name);
-
+		cachefiles_ondemand_deinit_obj_info(object);
 		cache = object->volume->cache->cache;
 		fscache_put_cookie(object->cookie, fscache_cookie_put_object);
 		object->cookie = NULL;
diff --git a/fs/cachefiles/internal.h b/fs/cachefiles/internal.h
index 00beedeaec183..b0fe76964bc0d 100644
--- a/fs/cachefiles/internal.h
+++ b/fs/cachefiles/internal.h
@@ -49,6 +49,12 @@ enum cachefiles_object_state {
 	CACHEFILES_ONDEMAND_OBJSTATE_OPEN, /* Anonymous fd associated with object is available */
 };
 
+struct cachefiles_ondemand_info {
+	int				ondemand_id;
+	enum cachefiles_object_state	state;
+	struct cachefiles_object	*object;
+};
+
 /*
  * Backing file state.
  */
@@ -66,8 +72,7 @@ struct cachefiles_object {
 	unsigned long			flags;
 #define CACHEFILES_OBJECT_USING_TMPFILE	0		/* Have an unlinked tmpfile */
 #ifdef CONFIG_CACHEFILES_ONDEMAND
-	int				ondemand_id;
-	enum cachefiles_object_state	state;
+	struct cachefiles_ondemand_info	*ondemand;
 #endif
 };
 
@@ -302,17 +307,21 @@ extern void cachefiles_ondemand_clean_object(struct cachefiles_object *object);
 extern int cachefiles_ondemand_read(struct cachefiles_object *object,
 				    loff_t pos, size_t len);
 
+extern int cachefiles_ondemand_init_obj_info(struct cachefiles_object *obj,
+					struct cachefiles_volume *volume);
+extern void cachefiles_ondemand_deinit_obj_info(struct cachefiles_object *obj);
+
 #define CACHEFILES_OBJECT_STATE_FUNCS(_state, _STATE)	\
 static inline bool								\
 cachefiles_ondemand_object_is_##_state(const struct cachefiles_object *object) \
 {												\
-	return object->state == CACHEFILES_ONDEMAND_OBJSTATE_##_STATE; \
+	return object->ondemand->state == CACHEFILES_ONDEMAND_OBJSTATE_##_STATE; \
 }												\
 												\
 static inline void								\
 cachefiles_ondemand_set_object_##_state(struct cachefiles_object *object) \
 {												\
-	object->state = CACHEFILES_ONDEMAND_OBJSTATE_##_STATE; \
+	object->ondemand->state = CACHEFILES_ONDEMAND_OBJSTATE_##_STATE; \
 }
 
 CACHEFILES_OBJECT_STATE_FUNCS(open, OPEN);
@@ -338,6 +347,15 @@ static inline int cachefiles_ondemand_read(struct cachefiles_object *object,
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int cachefiles_ondemand_init_obj_info(struct cachefiles_object *obj,
+						struct cachefiles_volume *volume)
+{
+	return 0;
+}
+static inline void cachefiles_ondemand_deinit_obj_info(struct cachefiles_object *obj)
+{
+}
 #endif
 
 /*
diff --git a/fs/cachefiles/ondemand.c b/fs/cachefiles/ondemand.c
index 90456b8a4b3e0..deb7e3007aa1d 100644
--- a/fs/cachefiles/ondemand.c
+++ b/fs/cachefiles/ondemand.c
@@ -9,12 +9,13 @@ static int cachefiles_ondemand_fd_release(struct inode *inode,
 {
 	struct cachefiles_object *object = file->private_data;
 	struct cachefiles_cache *cache = object->volume->cache;
-	int object_id = object->ondemand_id;
+	struct cachefiles_ondemand_info *info = object->ondemand;
+	int object_id = info->ondemand_id;
 	struct cachefiles_req *req;
 	XA_STATE(xas, &cache->reqs, 0);
 
 	xa_lock(&cache->reqs);
-	object->ondemand_id = CACHEFILES_ONDEMAND_ID_CLOSED;
+	info->ondemand_id = CACHEFILES_ONDEMAND_ID_CLOSED;
 	cachefiles_ondemand_set_object_close(object);
 
 	/*
@@ -222,7 +223,7 @@ static int cachefiles_ondemand_get_fd(struct cachefiles_req *req)
 	load = (void *)req->msg.data;
 	load->fd = fd;
 	req->msg.object_id = object_id;
-	object->ondemand_id = object_id;
+	object->ondemand->ondemand_id = object_id;
 
 	cachefiles_get_unbind_pincount(cache);
 	trace_cachefiles_ondemand_open(object, &req->msg, load);
@@ -368,7 +369,7 @@ static int cachefiles_ondemand_send_req(struct cachefiles_object *object,
 
 		if (opcode != CACHEFILES_OP_OPEN &&
 			!cachefiles_ondemand_object_is_open(object)) {
-			WARN_ON_ONCE(object->ondemand_id == 0);
+			WARN_ON_ONCE(object->ondemand->ondemand_id == 0);
 			xas_unlock(&xas);
 			ret = -EIO;
 			goto out;
@@ -438,7 +439,7 @@ static int cachefiles_ondemand_init_close_req(struct cachefiles_req *req,
 	if (!cachefiles_ondemand_object_is_open(object))
 		return -ENOENT;
 
-	req->msg.object_id = object->ondemand_id;
+	req->msg.object_id = object->ondemand->ondemand_id;
 	trace_cachefiles_ondemand_close(object, &req->msg);
 	return 0;
 }
@@ -454,7 +455,7 @@ static int cachefiles_ondemand_init_read_req(struct cachefiles_req *req,
 	struct cachefiles_object *object = req->object;
 	struct cachefiles_read *load = (void *)req->msg.data;
 	struct cachefiles_read_ctx *read_ctx = private;
-	int object_id = object->ondemand_id;
+	int object_id = object->ondemand->ondemand_id;
 
 	/* Stop enqueuing requests when daemon has closed anon_fd. */
 	if (!cachefiles_ondemand_object_is_open(object)) {
@@ -500,6 +501,27 @@ void cachefiles_ondemand_clean_object(struct cachefiles_object *object)
 			cachefiles_ondemand_init_close_req, NULL);
 }
 
+int cachefiles_ondemand_init_obj_info(struct cachefiles_object *object,
+				struct cachefiles_volume *volume)
+{
+	if (!cachefiles_in_ondemand_mode(volume->cache))
+		return 0;
+
+	object->ondemand = kzalloc(sizeof(struct cachefiles_ondemand_info),
+					GFP_KERNEL);
+	if (!object->ondemand)
+		return -ENOMEM;
+
+	object->ondemand->object = object;
+	return 0;
+}
+
+void cachefiles_ondemand_deinit_obj_info(struct cachefiles_object *object)
+{
+	kfree(object->ondemand);
+	object->ondemand = NULL;
+}
+
 int cachefiles_ondemand_read(struct cachefiles_object *object,
 			     loff_t pos, size_t len)
 {
-- 
2.43.0



