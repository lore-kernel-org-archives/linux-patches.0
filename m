Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B52876058;
	Mon,  8 Apr 2024 13:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583207; cv=none; b=Zv3BD9FuqjvEAo0P0dAOS//m5XYU4Ii0JtcTRdKUvDwN+VVf7/UjzZaOXXyZz4ssAWRbRzvvRR0C8lrQIAiGwyc9AgPKcp64MQO5ecUXYofZjMX51FepVAmIXL/uh5bZwVXOe/mVSmvsx7qfsZecBC3zb0NwU2bEaCrDtFqvxsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583207; c=relaxed/simple;
	bh=nxVcDaaWdrS0XXwXmO933JKciSDYB5TzvODsER5ZYro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/cyrFzuvVVMa7y+QuXLVB61y2d8YvTBfpiaG44M3T8Nvodi09J5WA2DL1740k0iPmL2zKncULSLroVjXJahYIgpSG/RGphMVogF3W7jdF1yabL3qy1I2/88VXY+VFtYD2XEbzb3RqybTYbv6/Hf0ZcKZ1ROHWAqyhh5DbwyJMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qFt8CJsd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qFt8CJsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27053C433B1;
	Mon,  8 Apr 2024 13:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583206;
	bh=nxVcDaaWdrS0XXwXmO933JKciSDYB5TzvODsER5ZYro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qFt8CJsdLb+1xidknLsugieMP5S+sA6s6ZyR2GfTQr0pDG+YDrCQ33Dgqv3uQl289
	 tXt91GXeU7mlLXE3Pbo+xFvy/YGlnjxRA2NAcwlitfsHOQmEum0C9rLxsrZnB3hHQO
	 L8eEOMOKnbS7nKO3zvQ/9uzlRx0DpxFnEghQ32Lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 222/690] fanotify: report old and/or new parent+name in FAN_RENAME event
Date: Mon,  8 Apr 2024 14:51:28 +0200
Message-ID: <20240408125407.587974233@linuxfoundation.org>
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

[ Upstream commit 7326e382c21e9c23c89c88369afdc90b82a14da8 ]

In the special case of FAN_RENAME event, we report old or new or both
old and new parent+name.

A single info record will be reported if either the old or new dir
is watched and two records will be reported if both old and new dir
(or their filesystem) are watched.

The old and new parent+name are reported using new info record types
FAN_EVENT_INFO_TYPE_{OLD,NEW}_DFID_NAME, so if a single info record
is reported, it is clear to the application, to which dir entry the
fid+name info is referring to.

Link: https://lore.kernel.org/r/20211129201537.1932819-11-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fanotify/fanotify.c      |  7 ++++
 fs/notify/fanotify/fanotify.h      | 18 +++++++++++
 fs/notify/fanotify/fanotify_user.c | 52 +++++++++++++++++++++++++++---
 include/uapi/linux/fanotify.h      |  6 ++++
 4 files changed, 78 insertions(+), 5 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 14bc0f12cc9f3..0da305b6f3e2f 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -153,6 +153,13 @@ static bool fanotify_should_merge(struct fanotify_event *old,
 	if ((old->mask & FS_ISDIR) != (new->mask & FS_ISDIR))
 		return false;
 
+	/*
+	 * FAN_RENAME event is reported with special info record types,
+	 * so we cannot merge it with other events.
+	 */
+	if ((old->mask & FAN_RENAME) != (new->mask & FAN_RENAME))
+		return false;
+
 	switch (old->type) {
 	case FANOTIFY_EVENT_TYPE_PATH:
 		return fanotify_path_equal(fanotify_event_path(old),
diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index 8fa3bc0effd45..a3d5b751cac5b 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -373,6 +373,13 @@ static inline int fanotify_event_dir_fh_len(struct fanotify_event *event)
 	return info ? fanotify_info_dir_fh_len(info) : 0;
 }
 
+static inline int fanotify_event_dir2_fh_len(struct fanotify_event *event)
+{
+	struct fanotify_info *info = fanotify_event_info(event);
+
+	return info ? fanotify_info_dir2_fh_len(info) : 0;
+}
+
 static inline bool fanotify_event_has_object_fh(struct fanotify_event *event)
 {
 	/* For error events, even zeroed fh are reported. */
@@ -386,6 +393,17 @@ static inline bool fanotify_event_has_dir_fh(struct fanotify_event *event)
 	return fanotify_event_dir_fh_len(event) > 0;
 }
 
+static inline bool fanotify_event_has_dir2_fh(struct fanotify_event *event)
+{
+	return fanotify_event_dir2_fh_len(event) > 0;
+}
+
+static inline bool fanotify_event_has_any_dir_fh(struct fanotify_event *event)
+{
+	return fanotify_event_has_dir_fh(event) ||
+		fanotify_event_has_dir2_fh(event);
+}
+
 struct fanotify_path_event {
 	struct fanotify_event fae;
 	struct path path;
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 526e3b5a98f34..b3ac2d877e1ee 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -129,12 +129,29 @@ static int fanotify_fid_info_len(int fh_len, int name_len)
 		       FANOTIFY_EVENT_ALIGN);
 }
 
+/* FAN_RENAME may have one or two dir+name info records */
+static int fanotify_dir_name_info_len(struct fanotify_event *event)
+{
+	struct fanotify_info *info = fanotify_event_info(event);
+	int dir_fh_len = fanotify_event_dir_fh_len(event);
+	int dir2_fh_len = fanotify_event_dir2_fh_len(event);
+	int info_len = 0;
+
+	if (dir_fh_len)
+		info_len += fanotify_fid_info_len(dir_fh_len,
+						  info->name_len);
+	if (dir2_fh_len)
+		info_len += fanotify_fid_info_len(dir2_fh_len,
+						  info->name2_len);
+
+	return info_len;
+}
+
 static size_t fanotify_event_len(unsigned int info_mode,
 				 struct fanotify_event *event)
 {
 	size_t event_len = FAN_EVENT_METADATA_LEN;
 	struct fanotify_info *info;
-	int dir_fh_len;
 	int fh_len;
 	int dot_len = 0;
 
@@ -146,9 +163,8 @@ static size_t fanotify_event_len(unsigned int info_mode,
 
 	info = fanotify_event_info(event);
 
-	if (fanotify_event_has_dir_fh(event)) {
-		dir_fh_len = fanotify_event_dir_fh_len(event);
-		event_len += fanotify_fid_info_len(dir_fh_len, info->name_len);
+	if (fanotify_event_has_any_dir_fh(event)) {
+		event_len += fanotify_dir_name_info_len(event);
 	} else if ((info_mode & FAN_REPORT_NAME) &&
 		   (event->mask & FAN_ONDIR)) {
 		/*
@@ -379,6 +395,8 @@ static int copy_fid_info_to_user(__kernel_fsid_t *fsid, struct fanotify_fh *fh,
 			return -EFAULT;
 		break;
 	case FAN_EVENT_INFO_TYPE_DFID_NAME:
+	case FAN_EVENT_INFO_TYPE_OLD_DFID_NAME:
+	case FAN_EVENT_INFO_TYPE_NEW_DFID_NAME:
 		if (WARN_ON_ONCE(!name || !name_len))
 			return -EFAULT;
 		break;
@@ -478,11 +496,19 @@ static int copy_info_records_to_user(struct fanotify_event *event,
 	unsigned int pidfd_mode = info_mode & FAN_REPORT_PIDFD;
 
 	/*
-	 * Event info records order is as follows: dir fid + name, child fid.
+	 * Event info records order is as follows:
+	 * 1. dir fid + name
+	 * 2. (optional) new dir fid + new name
+	 * 3. (optional) child fid
 	 */
 	if (fanotify_event_has_dir_fh(event)) {
 		info_type = info->name_len ? FAN_EVENT_INFO_TYPE_DFID_NAME :
 					     FAN_EVENT_INFO_TYPE_DFID;
+
+		/* FAN_RENAME uses special info types */
+		if (event->mask & FAN_RENAME)
+			info_type = FAN_EVENT_INFO_TYPE_OLD_DFID_NAME;
+
 		ret = copy_fid_info_to_user(fanotify_event_fsid(event),
 					    fanotify_info_dir_fh(info),
 					    info_type,
@@ -496,6 +522,22 @@ static int copy_info_records_to_user(struct fanotify_event *event,
 		total_bytes += ret;
 	}
 
+	/* New dir fid+name may be reported in addition to old dir fid+name */
+	if (fanotify_event_has_dir2_fh(event)) {
+		info_type = FAN_EVENT_INFO_TYPE_NEW_DFID_NAME;
+		ret = copy_fid_info_to_user(fanotify_event_fsid(event),
+					    fanotify_info_dir2_fh(info),
+					    info_type,
+					    fanotify_info_name2(info),
+					    info->name2_len, buf, count);
+		if (ret < 0)
+			return ret;
+
+		buf += ret;
+		count -= ret;
+		total_bytes += ret;
+	}
+
 	if (fanotify_event_has_object_fh(event)) {
 		const char *dot = NULL;
 		int dot_len = 0;
diff --git a/include/uapi/linux/fanotify.h b/include/uapi/linux/fanotify.h
index 9d0e2dc5767b5..e8ac38cc2fd6d 100644
--- a/include/uapi/linux/fanotify.h
+++ b/include/uapi/linux/fanotify.h
@@ -134,6 +134,12 @@ struct fanotify_event_metadata {
 #define FAN_EVENT_INFO_TYPE_PIDFD	4
 #define FAN_EVENT_INFO_TYPE_ERROR	5
 
+/* Special info types for FAN_RENAME */
+#define FAN_EVENT_INFO_TYPE_OLD_DFID_NAME	10
+/* Reserved for FAN_EVENT_INFO_TYPE_OLD_DFID	11 */
+#define FAN_EVENT_INFO_TYPE_NEW_DFID_NAME	12
+/* Reserved for FAN_EVENT_INFO_TYPE_NEW_DFID	13 */
+
 /* Variable length info record following event metadata */
 struct fanotify_event_info_header {
 	__u8 info_type;
-- 
2.43.0



