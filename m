Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4742B7C6C8;
	Mon,  8 Apr 2024 13:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583253; cv=none; b=rD8OWc3Vkiq9o4AFbyTDgmbyeMJ813wnIJH2SWaxIpD2pUbhG+4oO6YxhDWsqG+jafu8Kpbdv/58atCM60bbR4nk5YS2S+HNc3E2Fjd3UvP4WPqi7NwLqQ3c11uZexwwD1AUQMBnXejIq5ilPjOalz35YwZBCKiTjnjF4S+3u20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583253; c=relaxed/simple;
	bh=XqZSVPoDI5+wBE5+ruu+FpU7rF5ujWGzdnlbOGQ4GNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5t0lXPb2Qov0pEh9oauNwOdXxOJiZxE4dYvDFg8oSfTqW2dOMkapHULk1xS8S0XDkZVNOXM6zfJv7TPVtPx5qohLwVyooatuwMA/V8uoxo2uKSF2LLBg2oYq3H0nyr4KdX6rUEmTvFHLJYbJjAIbp5gfjVBOrB3inOSl3e9wi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PDO7O4hS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PDO7O4hS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C107AC433C7;
	Mon,  8 Apr 2024 13:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583253;
	bh=XqZSVPoDI5+wBE5+ruu+FpU7rF5ujWGzdnlbOGQ4GNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PDO7O4hSNScBk2f0nm+N9bK+G/s8T8qGudXmZyy0r7SQBE6dN/lxPdB+3Qw8Owbhx
	 FOdIY3DdeUFI9eXBbfggnkJXpP2zlU/ioK1dOwJUF39xF3DUy5UILObuCtpHl/Znb7
	 lt9rC/EKxYA66mhKO04N8sJDrxExDd+mYV/E9wDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 215/690] fanotify: introduce group flag FAN_REPORT_TARGET_FID
Date: Mon,  8 Apr 2024 14:51:21 +0200
Message-ID: <20240408125407.320399827@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit d61fd650e9d206a71fda789f02a1ced4b19944c4 ]

FAN_REPORT_FID is ambiguous in that it reports the fid of the child for
some events and the fid of the parent for create/delete/move events.

The new FAN_REPORT_TARGET_FID flag is an implicit request to report
the fid of the target object of the operation (a.k.a the child inode)
also in create/delete/move events in addition to the fid of the parent
and the name of the child.

To reduce the test matrix for uninteresting use cases, the new
FAN_REPORT_TARGET_FID flag requires both FAN_REPORT_NAME and
FAN_REPORT_FID.  The convenience macro FAN_REPORT_DFID_NAME_TARGET
combines FAN_REPORT_TARGET_FID with all the required flags.

Link: https://lore.kernel.org/r/20211129201537.1932819-4-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fanotify/fanotify.c      | 48 ++++++++++++++++++++++--------
 fs/notify/fanotify/fanotify_user.c | 11 ++++++-
 include/linux/fanotify.h           |  2 +-
 include/uapi/linux/fanotify.h      |  4 +++
 4 files changed, 51 insertions(+), 14 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 652fe84cb8acd..85e542b164c8c 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -458,17 +458,41 @@ static int fanotify_encode_fh(struct fanotify_fh *fh, struct inode *inode,
 }
 
 /*
- * The inode to use as identifier when reporting fid depends on the event.
- * Report the modified directory inode on dirent modification events.
- * Report the "victim" inode otherwise.
+ * FAN_REPORT_FID is ambiguous in that it reports the fid of the child for
+ * some events and the fid of the parent for create/delete/move events.
+ *
+ * With the FAN_REPORT_TARGET_FID flag, the fid of the child is reported
+ * also in create/delete/move events in addition to the fid of the parent
+ * and the name of the child.
+ */
+static inline bool fanotify_report_child_fid(unsigned int fid_mode, u32 mask)
+{
+	if (mask & ALL_FSNOTIFY_DIRENT_EVENTS)
+		return (fid_mode & FAN_REPORT_TARGET_FID);
+
+	return (fid_mode & FAN_REPORT_FID) && !(mask & FAN_ONDIR);
+}
+
+/*
+ * The inode to use as identifier when reporting fid depends on the event
+ * and the group flags.
+ *
+ * With the group flag FAN_REPORT_TARGET_FID, always report the child fid.
+ *
+ * Without the group flag FAN_REPORT_TARGET_FID, report the modified directory
+ * fid on dirent events and the child fid otherwise.
+ *
  * For example:
- * FS_ATTRIB reports the child inode even if reported on a watched parent.
- * FS_CREATE reports the modified dir inode and not the created inode.
+ * FS_ATTRIB reports the child fid even if reported on a watched parent.
+ * FS_CREATE reports the modified dir fid without FAN_REPORT_TARGET_FID.
+ *       and reports the created child fid with FAN_REPORT_TARGET_FID.
  */
 static struct inode *fanotify_fid_inode(u32 event_mask, const void *data,
-					int data_type, struct inode *dir)
+					int data_type, struct inode *dir,
+					unsigned int fid_mode)
 {
-	if (event_mask & ALL_FSNOTIFY_DIRENT_EVENTS)
+	if ((event_mask & ALL_FSNOTIFY_DIRENT_EVENTS) &&
+	    !(fid_mode & FAN_REPORT_TARGET_FID))
 		return dir;
 
 	return fsnotify_data_inode(data, data_type);
@@ -647,10 +671,11 @@ static struct fanotify_event *fanotify_alloc_event(struct fsnotify_group *group,
 {
 	struct fanotify_event *event = NULL;
 	gfp_t gfp = GFP_KERNEL_ACCOUNT;
-	struct inode *id = fanotify_fid_inode(mask, data, data_type, dir);
+	unsigned int fid_mode = FAN_GROUP_FLAG(group, FANOTIFY_FID_BITS);
+	struct inode *id = fanotify_fid_inode(mask, data, data_type, dir,
+					      fid_mode);
 	struct inode *dirid = fanotify_dfid_inode(mask, data, data_type, dir);
 	const struct path *path = fsnotify_data_path(data, data_type);
-	unsigned int fid_mode = FAN_GROUP_FLAG(group, FANOTIFY_FID_BITS);
 	struct mem_cgroup *old_memcg;
 	struct inode *child = NULL;
 	bool name_event = false;
@@ -660,11 +685,10 @@ static struct fanotify_event *fanotify_alloc_event(struct fsnotify_group *group,
 
 	if ((fid_mode & FAN_REPORT_DIR_FID) && dirid) {
 		/*
-		 * With both flags FAN_REPORT_DIR_FID and FAN_REPORT_FID, we
-		 * report the child fid for events reported on a non-dir child
+		 * For certain events and group flags, report the child fid
 		 * in addition to reporting the parent fid and maybe child name.
 		 */
-		if ((fid_mode & FAN_REPORT_FID) && id != dirid && !ondir)
+		if (fanotify_report_child_fid(fid_mode, mask) && id != dirid)
 			child = id;
 
 		id = dirid;
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index e8f6c843e9204..bfafda0447ea7 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1275,6 +1275,15 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 	if ((fid_mode & FAN_REPORT_NAME) && !(fid_mode & FAN_REPORT_DIR_FID))
 		return -EINVAL;
 
+	/*
+	 * FAN_REPORT_TARGET_FID requires FAN_REPORT_NAME and FAN_REPORT_FID
+	 * and is used as an indication to report both dir and child fid on all
+	 * dirent events.
+	 */
+	if ((fid_mode & FAN_REPORT_TARGET_FID) &&
+	    (!(fid_mode & FAN_REPORT_NAME) || !(fid_mode & FAN_REPORT_FID)))
+		return -EINVAL;
+
 	f_flags = O_RDWR | FMODE_NONOTIFY;
 	if (flags & FAN_CLOEXEC)
 		f_flags |= O_CLOEXEC;
@@ -1685,7 +1694,7 @@ static int __init fanotify_user_setup(void)
 				     FANOTIFY_DEFAULT_MAX_USER_MARKS);
 
 	BUILD_BUG_ON(FANOTIFY_INIT_FLAGS & FANOTIFY_INTERNAL_GROUP_FLAGS);
-	BUILD_BUG_ON(HWEIGHT32(FANOTIFY_INIT_FLAGS) != 11);
+	BUILD_BUG_ON(HWEIGHT32(FANOTIFY_INIT_FLAGS) != 12);
 	BUILD_BUG_ON(HWEIGHT32(FANOTIFY_MARK_FLAGS) != 9);
 
 	fanotify_mark_cache = KMEM_CACHE(fsnotify_mark,
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 616af2ea20f30..376e050e6f384 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -25,7 +25,7 @@ extern struct ctl_table fanotify_table[]; /* for sysctl */
 
 #define FANOTIFY_CLASS_BITS	(FAN_CLASS_NOTIF | FANOTIFY_PERM_CLASSES)
 
-#define FANOTIFY_FID_BITS	(FAN_REPORT_FID | FAN_REPORT_DFID_NAME)
+#define FANOTIFY_FID_BITS	(FAN_REPORT_DFID_NAME_TARGET)
 
 #define FANOTIFY_INFO_MODES	(FANOTIFY_FID_BITS | FAN_REPORT_PIDFD)
 
diff --git a/include/uapi/linux/fanotify.h b/include/uapi/linux/fanotify.h
index bd1932c2074d5..60f73639a896a 100644
--- a/include/uapi/linux/fanotify.h
+++ b/include/uapi/linux/fanotify.h
@@ -57,9 +57,13 @@
 #define FAN_REPORT_FID		0x00000200	/* Report unique file id */
 #define FAN_REPORT_DIR_FID	0x00000400	/* Report unique directory id */
 #define FAN_REPORT_NAME		0x00000800	/* Report events with name */
+#define FAN_REPORT_TARGET_FID	0x00001000	/* Report dirent target id  */
 
 /* Convenience macro - FAN_REPORT_NAME requires FAN_REPORT_DIR_FID */
 #define FAN_REPORT_DFID_NAME	(FAN_REPORT_DIR_FID | FAN_REPORT_NAME)
+/* Convenience macro - FAN_REPORT_TARGET_FID requires all other FID flags */
+#define FAN_REPORT_DFID_NAME_TARGET (FAN_REPORT_DFID_NAME | \
+				     FAN_REPORT_FID | FAN_REPORT_TARGET_FID)
 
 /* Deprecated - do not use this in programs and do not add new flags here! */
 #define FAN_ALL_INIT_FLAGS	(FAN_CLOEXEC | FAN_NONBLOCK | \
-- 
2.43.0



