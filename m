Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40573524AF;
	Mon,  8 Apr 2024 13:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584127; cv=none; b=KDcXmrghrzFPsHgfp9UpT3cTJajZXWwor7L5TA35gBENIShGTbnu+nNZEy+kr3hY4/OwszdRisJEEikuIqGgzanPUZUTkqJacWXpevVff8bSRXFcLgA8DhQgv7vGdi0Xz1ef4k7X6QFwo54TuoWpuYZZee3yQAbj9xhredigpjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584127; c=relaxed/simple;
	bh=w9o0PurTtFbThhc72EpakqWt6d9H3KnZY8i3fOGXN+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hpcW1D7rDusoup7K3r8DFEEAH4FTd/uSnAnA0lv/HJLf/qcNQ4D6wr1PkJlaOy7IqYWgzwNemsYXdlrYOrfpjBBow61rPoMwV8F5cdFJFhHQOg8wYckqLpJTV1tlrrF96BB3xjiDYFdncyLK8A0F7XmzFkZBWfUoe+2ba5nNOhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pgd2S4F7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pgd2S4F7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01BEC433C7;
	Mon,  8 Apr 2024 13:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584127;
	bh=w9o0PurTtFbThhc72EpakqWt6d9H3KnZY8i3fOGXN+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgd2S4F7dlSGzo+C7OeW0qAaS17qwrLJapPPCZI8dkAoCkKcbqeHwBaLkugXBZ3Na
	 JTDy+6WP3SFMAVbkrKK4qz0NDh9Qg1owYEfVbCO+IFEaq3bfDzCG3+MbYmbNLTBprX
	 jK34spsrztMs9mzmGgqLzEJVQrsx3HdzpUsVQbyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 338/690] fanotify: cleanups for fanotify_mark() input validations
Date: Mon,  8 Apr 2024 14:53:24 +0200
Message-ID: <20240408125411.859099615@linuxfoundation.org>
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

[ Upstream commit 8afd7215aa97f8868d033f6e1d01a276ab2d29c0 ]

Create helper fanotify_may_update_existing_mark() for checking for
conflicts between existing mark flags and fanotify_mark() flags.

Use variable mark_cmd to make the checks for mark command bits
cleaner.

Link: https://lore.kernel.org/r/20220629144210.2983229-3-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fanotify/fanotify_user.c | 30 +++++++++++++++++++++---------
 include/linux/fanotify.h           |  9 +++++----
 2 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 9367216263cab..870db0f361f4c 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1183,6 +1183,19 @@ static int fanotify_group_init_error_pool(struct fsnotify_group *group)
 					 sizeof(struct fanotify_error_event));
 }
 
+static int fanotify_may_update_existing_mark(struct fsnotify_mark *fsn_mark,
+					      unsigned int fan_flags)
+{
+	/*
+	 * Non evictable mark cannot be downgraded to evictable mark.
+	 */
+	if (fan_flags & FAN_MARK_EVICTABLE &&
+	    !(fsn_mark->flags & FSNOTIFY_MARK_FLAG_NO_IREF))
+		return -EEXIST;
+
+	return 0;
+}
+
 static int fanotify_add_mark(struct fsnotify_group *group,
 			     fsnotify_connp_t *connp, unsigned int obj_type,
 			     __u32 mask, unsigned int fan_flags,
@@ -1204,13 +1217,11 @@ static int fanotify_add_mark(struct fsnotify_group *group,
 	}
 
 	/*
-	 * Non evictable mark cannot be downgraded to evictable mark.
+	 * Check if requested mark flags conflict with an existing mark flags.
 	 */
-	if (fan_flags & FAN_MARK_EVICTABLE &&
-	    !(fsn_mark->flags & FSNOTIFY_MARK_FLAG_NO_IREF)) {
-		ret = -EEXIST;
+	ret = fanotify_may_update_existing_mark(fsn_mark, fan_flags);
+	if (ret)
 		goto out;
-	}
 
 	/*
 	 * Error events are pre-allocated per group, only if strictly
@@ -1567,6 +1578,7 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
 	__kernel_fsid_t __fsid, *fsid = NULL;
 	u32 valid_mask = FANOTIFY_EVENTS | FANOTIFY_EVENT_FLAGS;
 	unsigned int mark_type = flags & FANOTIFY_MARK_TYPE_BITS;
+	unsigned int mark_cmd = flags & FANOTIFY_MARK_CMD_BITS;
 	bool ignore = flags & FAN_MARK_IGNORED_MASK;
 	unsigned int obj_type, fid_mode;
 	u32 umask = 0;
@@ -1596,7 +1608,7 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
 		return -EINVAL;
 	}
 
-	switch (flags & (FAN_MARK_ADD | FAN_MARK_REMOVE | FAN_MARK_FLUSH)) {
+	switch (mark_cmd) {
 	case FAN_MARK_ADD:
 	case FAN_MARK_REMOVE:
 		if (!mask)
@@ -1685,7 +1697,7 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
 	if (mask & FAN_RENAME && !(fid_mode & FAN_REPORT_NAME))
 		goto fput_and_out;
 
-	if (flags & FAN_MARK_FLUSH) {
+	if (mark_cmd == FAN_MARK_FLUSH) {
 		ret = 0;
 		if (mark_type == FAN_MARK_MOUNT)
 			fsnotify_clear_vfsmount_marks_by_group(group);
@@ -1701,7 +1713,7 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
 	if (ret)
 		goto fput_and_out;
 
-	if (flags & FAN_MARK_ADD) {
+	if (mark_cmd == FAN_MARK_ADD) {
 		ret = fanotify_events_supported(group, &path, mask, flags);
 		if (ret)
 			goto path_put_and_out;
@@ -1739,7 +1751,7 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
 	}
 
 	/* create/update an inode mark */
-	switch (flags & (FAN_MARK_ADD | FAN_MARK_REMOVE)) {
+	switch (mark_cmd) {
 	case FAN_MARK_ADD:
 		if (mark_type == FAN_MARK_MOUNT)
 			ret = fanotify_add_vfsmount_mark(group, mnt, mask,
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 4f6cbe6c6e235..c9e185407ebcb 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -61,15 +61,16 @@ extern struct ctl_table fanotify_table[]; /* for sysctl */
 #define FANOTIFY_MARK_TYPE_BITS	(FAN_MARK_INODE | FAN_MARK_MOUNT | \
 				 FAN_MARK_FILESYSTEM)
 
+#define FANOTIFY_MARK_CMD_BITS	(FAN_MARK_ADD | FAN_MARK_REMOVE | \
+				 FAN_MARK_FLUSH)
+
 #define FANOTIFY_MARK_FLAGS	(FANOTIFY_MARK_TYPE_BITS | \
-				 FAN_MARK_ADD | \
-				 FAN_MARK_REMOVE | \
+				 FANOTIFY_MARK_CMD_BITS | \
 				 FAN_MARK_DONT_FOLLOW | \
 				 FAN_MARK_ONLYDIR | \
 				 FAN_MARK_IGNORED_MASK | \
 				 FAN_MARK_IGNORED_SURV_MODIFY | \
-				 FAN_MARK_EVICTABLE | \
-				 FAN_MARK_FLUSH)
+				 FAN_MARK_EVICTABLE)
 
 /*
  * Events that can be reported with data type FSNOTIFY_EVENT_PATH.
-- 
2.43.0



