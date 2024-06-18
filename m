Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569751607AA;
	Tue, 18 Jun 2024 12:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715085; cv=none; b=tvC43la5zbILxp/3DWwDV3qCw8yDji36UEtuCa5FFIV8o7BxJUoMAD1ma29gjaCkyiAom3k2X02x3dG40djKZx+LQlZwfQ2xtZrHc8f/KgkbLb5e0EOqxaKFydcGNela1K4VP/ThgJOJ1wCbgl99uGsELnBY8vah9kLt4YFLP/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715085; c=relaxed/simple;
	bh=/Q/z7aQsDm4Jk8O1xkrcQtAb1rwonjkYOK+ngTWuwRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDsKZyxD9sA/OPK7qwDel3c4LksauYcFhRMCBu+tyvRdQHFRYBv/W/iNMGtDsw63NIu7lofLxfYaabaZnXoM+GaGA16rpImYfyep6mCg6IgGF3OlopECvhOcW3MjNmi2jaBdS49PS4yHlC7aigeQ+9EKBJXsNyVxbG+NTdxqUUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zp3j/vcL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zp3j/vcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AC9C4AF48;
	Tue, 18 Jun 2024 12:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715085;
	bh=/Q/z7aQsDm4Jk8O1xkrcQtAb1rwonjkYOK+ngTWuwRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zp3j/vcLtzTDPC+kacIxaQyrZx4CNXA0xeL4VF+3YaoqMjxVYhcdDztFrX0U8D3rY
	 bxzHw0r2axj+KltVRlzvXE37ruCcie5zBCProUQuTSVCMaxiddDELe+S0SXL9WHwsP
	 IzX7FbwtWuLDGXhEX5KhfLn91FCYckK5YNAaktRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Shakeel Butt <shakeelb@google.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 190/770] inotify, memcg: account inotify instances to kmemcg
Date: Tue, 18 Jun 2024 14:30:43 +0200
Message-ID: <20240618123414.610820103@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shakeel Butt <shakeelb@google.com>

[ Upstream commit ac7b79fd190b02e7151bc7d2b9da692f537657f3 ]

Currently the fs sysctl inotify/max_user_instances is used to limit the
number of inotify instances on the system. For systems running multiple
workloads, the per-user namespace sysctl max_inotify_instances can be
used to further partition inotify instances. However there is no easy
way to set a sensible system level max limit on inotify instances and
further partition it between the workloads. It is much easier to charge
the underlying resource (i.e. memory) behind the inotify instances to
the memcg of the workload and let their memory limits limit the number
of inotify instances they can create.

With inotify instances charged to memcg, the admin can simply set
max_user_instances to INT_MAX and let the memcg limits of the jobs limit
their inotify instances.

Link: https://lore.kernel.org/r/20201220044608.1258123-1-shakeelb@google.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify_user.c |  2 +-
 fs/notify/group.c                  | 25 ++++++++++++++++++++-----
 fs/notify/inotify/inotify_user.c   |  4 ++--
 include/linux/fsnotify_backend.h   |  1 +
 4 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 84de9f97bbc09..3e905b2e1b9c3 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -976,7 +976,7 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 		f_flags |= O_NONBLOCK;
 
 	/* fsnotify_alloc_group takes a ref.  Dropped in fanotify_release */
-	group = fsnotify_alloc_group(&fanotify_fsnotify_ops);
+	group = fsnotify_alloc_user_group(&fanotify_fsnotify_ops);
 	if (IS_ERR(group)) {
 		free_uid(user);
 		return PTR_ERR(group);
diff --git a/fs/notify/group.c b/fs/notify/group.c
index a4a4b1c64d32a..ffd723ffe46de 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -111,14 +111,12 @@ void fsnotify_put_group(struct fsnotify_group *group)
 }
 EXPORT_SYMBOL_GPL(fsnotify_put_group);
 
-/*
- * Create a new fsnotify_group and hold a reference for the group returned.
- */
-struct fsnotify_group *fsnotify_alloc_group(const struct fsnotify_ops *ops)
+static struct fsnotify_group *__fsnotify_alloc_group(
+				const struct fsnotify_ops *ops, gfp_t gfp)
 {
 	struct fsnotify_group *group;
 
-	group = kzalloc(sizeof(struct fsnotify_group), GFP_KERNEL);
+	group = kzalloc(sizeof(struct fsnotify_group), gfp);
 	if (!group)
 		return ERR_PTR(-ENOMEM);
 
@@ -139,8 +137,25 @@ struct fsnotify_group *fsnotify_alloc_group(const struct fsnotify_ops *ops)
 
 	return group;
 }
+
+/*
+ * Create a new fsnotify_group and hold a reference for the group returned.
+ */
+struct fsnotify_group *fsnotify_alloc_group(const struct fsnotify_ops *ops)
+{
+	return __fsnotify_alloc_group(ops, GFP_KERNEL);
+}
 EXPORT_SYMBOL_GPL(fsnotify_alloc_group);
 
+/*
+ * Create a new fsnotify_group and hold a reference for the group returned.
+ */
+struct fsnotify_group *fsnotify_alloc_user_group(const struct fsnotify_ops *ops)
+{
+	return __fsnotify_alloc_group(ops, GFP_KERNEL_ACCOUNT);
+}
+EXPORT_SYMBOL_GPL(fsnotify_alloc_user_group);
+
 int fsnotify_fasync(int fd, struct file *file, int on)
 {
 	struct fsnotify_group *group = file->private_data;
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index b564a32403aa5..ad8fb4bca6dc1 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -632,11 +632,11 @@ static struct fsnotify_group *inotify_new_group(unsigned int max_events)
 	struct fsnotify_group *group;
 	struct inotify_event_info *oevent;
 
-	group = fsnotify_alloc_group(&inotify_fsnotify_ops);
+	group = fsnotify_alloc_user_group(&inotify_fsnotify_ops);
 	if (IS_ERR(group))
 		return group;
 
-	oevent = kmalloc(sizeof(struct inotify_event_info), GFP_KERNEL);
+	oevent = kmalloc(sizeof(struct inotify_event_info), GFP_KERNEL_ACCOUNT);
 	if (unlikely(!oevent)) {
 		fsnotify_destroy_group(group);
 		return ERR_PTR(-ENOMEM);
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index a2e42d3cd87cf..e5409b83e7313 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -470,6 +470,7 @@ static inline void fsnotify_update_flags(struct dentry *dentry)
 
 /* create a new group */
 extern struct fsnotify_group *fsnotify_alloc_group(const struct fsnotify_ops *ops);
+extern struct fsnotify_group *fsnotify_alloc_user_group(const struct fsnotify_ops *ops);
 /* get reference to a group */
 extern void fsnotify_get_group(struct fsnotify_group *group);
 /* drop reference on a group from fsnotify_alloc_group */
-- 
2.43.0



