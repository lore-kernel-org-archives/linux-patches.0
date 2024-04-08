Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F967C6C5;
	Mon,  8 Apr 2024 13:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583987; cv=none; b=sh3aSAaK8tt//WuQZEwXtvJ42FTR80x/ZuT73MdtNNBfuiygGz8/HT4XwkeWBpA0etN75wvKFFNnARYg5v89jruYZyBzAVJ9YbL20RZbb81xF6FbRgchka4n44ma77eps7RVF8jGpXHI6icTkfpxuQXqquLtgTwPAH1WVdJu7Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583987; c=relaxed/simple;
	bh=EfQ9DHszRWRE9bRKc8p9OMITwnTPK4tDw81p9UDnylY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RiMbVZPGQqbridDK8W6LQ6v28LJnEdzFNUUFl7EAkq5AQQkwCVjv0kegkLUu4O8IdIBEVyZZ1K2+6dqiKSpzMgz/rM+o0N6Iuld1fOI86YaUIlQ5KmJCoENAeaGpBXazXslJYf6l6Goj5VDZyB97tgSLYvgoKjJZ1rrZkk0mURI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wp8U/UJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wp8U/UJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A261DC433F1;
	Mon,  8 Apr 2024 13:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583987;
	bh=EfQ9DHszRWRE9bRKc8p9OMITwnTPK4tDw81p9UDnylY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wp8U/UJrLiU7ZrNviWUa4w+sbDYRiMkCBH9hrC0ZyA47aCeBFsTlorYVdZqy89Irk
	 GTzLYotlKHgT9PXtoyPYPaC1W2kunhLbp9MPxRm92w9pJj1rt9Ldm7fTpOGMQl8/8S
	 jmeVv2s8r2Wm2ADwBeNNfzRGgM8csXQgWrNML410=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.15 311/690] fs/lock: add 2 callbacks to lock_manager_operations to resolve conflict
Date: Mon,  8 Apr 2024 14:52:57 +0200
Message-ID: <20240408125410.859012521@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 2443da2259e97688f93d64d17ab69b15f466078a ]

Add 2 new callbacks, lm_lock_expirable and lm_expire_lock, to
lock_manager_operations to allow the lock manager to take appropriate
action to resolve the lock conflict if possible.

A new field, lm_mod_owner, is also added to lock_manager_operations.
The lm_mod_owner is used by the fs/lock code to make sure the lock
manager module such as nfsd, is not freed while lock conflict is being
resolved.

lm_lock_expirable checks and returns true to indicate that the lock
conflict can be resolved else return false. This callback must be
called with the flc_lock held so it can not block.

lm_expire_lock is called to resolve the lock conflict if the returned
value from lm_lock_expirable is true. This callback is called without
the flc_lock held since it's allowed to block. Upon returning from
this callback, the lock conflict should be resolved and the caller is
expected to restart the conflict check from the beginnning of the list.

Lock manager, such as NFSv4 courteous server, uses this callback to
resolve conflict by destroying lock owner, or the NFSv4 courtesy client
(client that has expired but allowed to maintains its states) that owns
the lock.

Reviewed-by: J. Bruce Fields <bfields@fieldses.org>
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 Documentation/filesystems/locking.rst |  4 ++++
 fs/locks.c                            | 33 ++++++++++++++++++++++++---
 include/linux/fs.h                    |  3 +++
 3 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index e2a27bb5dc411..dabf4f7c755ed 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -442,6 +442,8 @@ prototypes::
 	void (*lm_break)(struct file_lock *); /* break_lease callback */
 	int (*lm_change)(struct file_lock **, int);
 	bool (*lm_breaker_owns_lease)(struct file_lock *);
+        bool (*lm_lock_expirable)(struct file_lock *);
+        void (*lm_expire_lock)(void);
 
 locking rules:
 
@@ -453,6 +455,8 @@ lm_grant:		no		no			no
 lm_break:		yes		no			no
 lm_change		yes		no			no
 lm_breaker_owns_lease:	yes     	no			no
+lm_lock_expirable	yes		no			no
+lm_expire_lock		no		no			yes
 ======================	=============	=================	=========
 
 buffer_head
diff --git a/fs/locks.c b/fs/locks.c
index f8c4844ebcce4..317c2ec17b943 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -982,6 +982,8 @@ posix_test_lock(struct file *filp, struct file_lock *fl)
 	struct file_lock *cfl;
 	struct file_lock_context *ctx;
 	struct inode *inode = locks_inode(filp);
+	void *owner;
+	void (*func)(void);
 
 	ctx = smp_load_acquire(&inode->i_flctx);
 	if (!ctx || list_empty_careful(&ctx->flc_posix)) {
@@ -989,12 +991,23 @@ posix_test_lock(struct file *filp, struct file_lock *fl)
 		return;
 	}
 
+retry:
 	spin_lock(&ctx->flc_lock);
 	list_for_each_entry(cfl, &ctx->flc_posix, fl_list) {
-		if (posix_locks_conflict(fl, cfl)) {
-			locks_copy_conflock(fl, cfl);
-			goto out;
+		if (!posix_locks_conflict(fl, cfl))
+			continue;
+		if (cfl->fl_lmops && cfl->fl_lmops->lm_lock_expirable
+			&& (*cfl->fl_lmops->lm_lock_expirable)(cfl)) {
+			owner = cfl->fl_lmops->lm_mod_owner;
+			func = cfl->fl_lmops->lm_expire_lock;
+			__module_get(owner);
+			spin_unlock(&ctx->flc_lock);
+			(*func)();
+			module_put(owner);
+			goto retry;
 		}
+		locks_copy_conflock(fl, cfl);
+		goto out;
 	}
 	fl->fl_type = F_UNLCK;
 out:
@@ -1168,6 +1181,8 @@ static int posix_lock_inode(struct inode *inode, struct file_lock *request,
 	int error;
 	bool added = false;
 	LIST_HEAD(dispose);
+	void *owner;
+	void (*func)(void);
 
 	ctx = locks_get_lock_context(inode, request->fl_type);
 	if (!ctx)
@@ -1186,6 +1201,7 @@ static int posix_lock_inode(struct inode *inode, struct file_lock *request,
 		new_fl2 = locks_alloc_lock();
 	}
 
+retry:
 	percpu_down_read(&file_rwsem);
 	spin_lock(&ctx->flc_lock);
 	/*
@@ -1197,6 +1213,17 @@ static int posix_lock_inode(struct inode *inode, struct file_lock *request,
 		list_for_each_entry(fl, &ctx->flc_posix, fl_list) {
 			if (!posix_locks_conflict(request, fl))
 				continue;
+			if (fl->fl_lmops && fl->fl_lmops->lm_lock_expirable
+				&& (*fl->fl_lmops->lm_lock_expirable)(fl)) {
+				owner = fl->fl_lmops->lm_mod_owner;
+				func = fl->fl_lmops->lm_expire_lock;
+				__module_get(owner);
+				spin_unlock(&ctx->flc_lock);
+				percpu_up_read(&file_rwsem);
+				(*func)();
+				module_put(owner);
+				goto retry;
+			}
 			if (conflock)
 				locks_copy_conflock(conflock, fl);
 			error = -EAGAIN;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9b7ce642d4f08..371d67c9221c5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1066,6 +1066,7 @@ struct file_lock_operations {
 };
 
 struct lock_manager_operations {
+	void *lm_mod_owner;
 	fl_owner_t (*lm_get_owner)(fl_owner_t);
 	void (*lm_put_owner)(fl_owner_t);
 	void (*lm_notify)(struct file_lock *);	/* unblock callback */
@@ -1074,6 +1075,8 @@ struct lock_manager_operations {
 	int (*lm_change)(struct file_lock *, int, struct list_head *);
 	void (*lm_setup)(struct file_lock *, void **);
 	bool (*lm_breaker_owns_lease)(struct file_lock *);
+	bool (*lm_lock_expirable)(struct file_lock *cfl);
+	void (*lm_expire_lock)(void);
 };
 
 struct lock_manager {
-- 
2.43.0



