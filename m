Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F0A79F0;
	Mon,  8 Apr 2024 13:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582924; cv=none; b=SL5wuVF8LMq+P/men08hLRWiqfag9GKnzkMuuBsHUBIqwAAYfDaegPQb2LuRAqlQv/aQ2sb+HoDgdzZy0FpFkciFr0OOLs5ahidQEKYqsOfmiJUXZzTc2xL3WQQmWjx+GbG81IP+W57vqG86Lr6jmJqFg+DgnqBcXdKg6yj8k3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582924; c=relaxed/simple;
	bh=A0Q33ay748Y3GCmpnA5oWScd0OyXTmWqjmiPyDU5+qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W32bSwoRJO2O0eiCnpJ+cWvmp5p8Hp8L3leVZPwpVgVbPGnVl3lkgzZ/oe703YaMN44HwbVDP9FolnhNiOZJXEwE/ntnV7ZYo0SjaTfBmPhb5bAG29n4IIT5+LXDv3SFno1YKeiSzqaKp0W8h2CGxrHvSvpB2C0iecr149LWvpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNcYSqlr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNcYSqlr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC39C433C7;
	Mon,  8 Apr 2024 13:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582924;
	bh=A0Q33ay748Y3GCmpnA5oWScd0OyXTmWqjmiPyDU5+qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QNcYSqlr8//j0gA/AejambLy035c/CUs6KOZeCLs7C/8AmnA2PPKN7ce5SY2/o8OY
	 n5ipie7UxVBbqp6RZpSgWQR0P/ZzH1WtSGph3GZyrf4rClQxA8fZvTKuvu2hIwZ0vO
	 9eMHBFnlsGGlMSu2DldR6OiX9z3lY89xd73Q4+KY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 188/690] fanotify: Add helpers to decide whether to report FID/DFID
Date: Mon,  8 Apr 2024 14:50:54 +0200
Message-ID: <20240408125406.375032205@linuxfoundation.org>
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

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit 4bd5a5c8e6e5cd964e9738e6ef87f6c2cb453edf ]

Now that there is an event that reports FID records even for a zeroed
file handle, wrap the logic that deides whether to issue the records
into helper functions.  This shouldn't have any impact on the code, but
simplifies further patches.

Link: https://lore.kernel.org/r/20211025192746.66445-24-krisman@collabora.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fanotify/fanotify.h      | 10 ++++++++++
 fs/notify/fanotify/fanotify_user.c | 13 +++++++------
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index 3510d06654ed0..80af269eebb89 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -264,6 +264,16 @@ static inline int fanotify_event_dir_fh_len(struct fanotify_event *event)
 	return info ? fanotify_info_dir_fh_len(info) : 0;
 }
 
+static inline bool fanotify_event_has_object_fh(struct fanotify_event *event)
+{
+	return fanotify_event_object_fh_len(event) > 0;
+}
+
+static inline bool fanotify_event_has_dir_fh(struct fanotify_event *event)
+{
+	return fanotify_event_dir_fh_len(event) > 0;
+}
+
 struct fanotify_path_event {
 	struct fanotify_event fae;
 	struct path path;
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index b3cbcb0e71c99..c053038e1cf3c 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -140,10 +140,9 @@ static size_t fanotify_event_len(unsigned int info_mode,
 		return event_len;
 
 	info = fanotify_event_info(event);
-	dir_fh_len = fanotify_event_dir_fh_len(event);
-	fh_len = fanotify_event_object_fh_len(event);
 
-	if (dir_fh_len) {
+	if (fanotify_event_has_dir_fh(event)) {
+		dir_fh_len = fanotify_event_dir_fh_len(event);
 		event_len += fanotify_fid_info_len(dir_fh_len, info->name_len);
 	} else if ((info_mode & FAN_REPORT_NAME) &&
 		   (event->mask & FAN_ONDIR)) {
@@ -157,8 +156,10 @@ static size_t fanotify_event_len(unsigned int info_mode,
 	if (info_mode & FAN_REPORT_PIDFD)
 		event_len += FANOTIFY_PIDFD_INFO_HDR_LEN;
 
-	if (fh_len)
+	if (fanotify_event_has_object_fh(event)) {
+		fh_len = fanotify_event_object_fh_len(event);
 		event_len += fanotify_fid_info_len(fh_len, dot_len);
+	}
 
 	return event_len;
 }
@@ -451,7 +452,7 @@ static int copy_info_records_to_user(struct fanotify_event *event,
 	/*
 	 * Event info records order is as follows: dir fid + name, child fid.
 	 */
-	if (fanotify_event_dir_fh_len(event)) {
+	if (fanotify_event_has_dir_fh(event)) {
 		info_type = info->name_len ? FAN_EVENT_INFO_TYPE_DFID_NAME :
 					     FAN_EVENT_INFO_TYPE_DFID;
 		ret = copy_fid_info_to_user(fanotify_event_fsid(event),
@@ -467,7 +468,7 @@ static int copy_info_records_to_user(struct fanotify_event *event,
 		total_bytes += ret;
 	}
 
-	if (fanotify_event_object_fh_len(event)) {
+	if (fanotify_event_has_object_fh(event)) {
 		const char *dot = NULL;
 		int dot_len = 0;
 
-- 
2.43.0



