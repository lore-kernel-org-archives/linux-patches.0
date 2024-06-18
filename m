Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C89E18EFD7;
	Tue, 18 Jun 2024 13:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715844; cv=none; b=l4LFEIwgRuqAVwDRHiCUHqTFzjB2G1fDAjScbQTv7sLdXStUNq7UatgT6XmJ+wDMarXNdn2j20DaoG98Cg5L5EzFG3uSF9pj/FtNjkW5MAFxOz5LE0S4Q0aHY/8S87FZwRWQI+BPrIHBjQAMSSq3TTIgM6GL1+3jK9hJsVK4cZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715844; c=relaxed/simple;
	bh=jkB01OKKvyy3ZzTYgB+ejK3/QEW5KG3Bn5Ip/uISJVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxaupqZ4TBoCb7/pAPWMQJo+iL7LCMRulqdZrmUDmOrzM2tkLkZBOnrriAYI9iKxnZF/PqcmEcy67yf/Fkd4x3L3LLd3yeQ5qNHDceeShWmyBvLVebxE2yes+QhItMrA3p2mmZfnhyAWihRO/k5YXHPQqWwdoayW3cmHF1gw81g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JBdActW/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JBdActW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78614C3277B;
	Tue, 18 Jun 2024 13:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715843;
	bh=jkB01OKKvyy3ZzTYgB+ejK3/QEW5KG3Bn5Ip/uISJVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JBdActW/zr9qI3cQ5qBvIwP3r3zNLcNjV62T2n/WKYtTZ5+0BRFXj6PGj9Dgg7WvM
	 kr0O9t4CEgQV03u88it4Qf2rkxxIAWRJUmaz1Bhc1BiZHeXxkqbN2a7pOV1n28AU1Y
	 fwmtmWsD8wdk0aHA7ArnYDyTTxtDtWZwSl9Vru4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 414/770] fanotify: report old and/or new parent+name in FAN_RENAME event
Date: Tue, 18 Jun 2024 14:34:27 +0200
Message-ID: <20240618123423.265495799@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
index d69570db5efd2..e16b18fdf1a65 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -124,12 +124,29 @@ static int fanotify_fid_info_len(int fh_len, int name_len)
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
 
@@ -141,9 +158,8 @@ static size_t fanotify_event_len(unsigned int info_mode,
 
 	info = fanotify_event_info(event);
 
-	if (fanotify_event_has_dir_fh(event)) {
-		dir_fh_len = fanotify_event_dir_fh_len(event);
-		event_len += fanotify_fid_info_len(dir_fh_len, info->name_len);
+	if (fanotify_event_has_any_dir_fh(event)) {
+		event_len += fanotify_dir_name_info_len(event);
 	} else if ((info_mode & FAN_REPORT_NAME) &&
 		   (event->mask & FAN_ONDIR)) {
 		/*
@@ -374,6 +390,8 @@ static int copy_fid_info_to_user(__kernel_fsid_t *fsid, struct fanotify_fh *fh,
 			return -EFAULT;
 		break;
 	case FAN_EVENT_INFO_TYPE_DFID_NAME:
+	case FAN_EVENT_INFO_TYPE_OLD_DFID_NAME:
+	case FAN_EVENT_INFO_TYPE_NEW_DFID_NAME:
 		if (WARN_ON_ONCE(!name || !name_len))
 			return -EFAULT;
 		break;
@@ -473,11 +491,19 @@ static int copy_info_records_to_user(struct fanotify_event *event,
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
@@ -491,6 +517,22 @@ static int copy_info_records_to_user(struct fanotify_event *event,
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



