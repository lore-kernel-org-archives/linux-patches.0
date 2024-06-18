Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F3A18E749;
	Tue, 18 Jun 2024 13:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715752; cv=none; b=hTEiy5Ay4639qBvoVAgNKke+5cGmj+87jWOWV7jLa2pNhI+sWDOv3Edrf+kXpXBHai/JXAWZIVENJdHtUrxp03q+LApR9gYIiv75U4KNs1pRp0D9ufPyfAGJbhvbq7frnwvthnGxVeqgMt9OKqLA5WF9usyfJ9xWroH7w5G/YLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715752; c=relaxed/simple;
	bh=UEXqFo0cNL2gdZgBsyAdgMRUMh375powSOrx/WPnV5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hmjJUB2MqtucTBoraG5gqIidf39lW9TliVVBLZULNRGWJ42zw7SfZ2lD0hX3PDTVRxk9o9zi8/K9Zvzk83GjKMY9XVAPOwl7C5P9AZ/1ODNQgdcoBPKgvK4Rc0Pxbk2h6Lx6xYwnzuy46OZf7q4yoDLOtBkYu68aLD8olqpd/hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iW3IBBpB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iW3IBBpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C976C3277B;
	Tue, 18 Jun 2024 13:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715751;
	bh=UEXqFo0cNL2gdZgBsyAdgMRUMh375powSOrx/WPnV5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iW3IBBpBrfYnUg2qBB1ZxqYOkYyTAdxyFWIfoK5SUm0fZiOBiCMTetACXOTSp1eQS
	 PwuGe3TSDbn4Sl1g84L+Tlgxk6FuuUR2V0YCiB5l4y313ZLUaXqxm+HH4t3Se6oBd8
	 CmfXTl7EfjQ5OnGVD2BXs+PyMs+8Mlrf0uEcuD/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 383/770] fanotify: Add helpers to decide whether to report FID/DFID
Date: Tue, 18 Jun 2024 14:33:56 +0200
Message-ID: <20240618123422.059083858@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
index 8a2b7941fc986..34ed30be0e4d4 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -135,10 +135,9 @@ static size_t fanotify_event_len(unsigned int info_mode,
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
@@ -152,8 +151,10 @@ static size_t fanotify_event_len(unsigned int info_mode,
 	if (info_mode & FAN_REPORT_PIDFD)
 		event_len += FANOTIFY_PIDFD_INFO_HDR_LEN;
 
-	if (fh_len)
+	if (fanotify_event_has_object_fh(event)) {
+		fh_len = fanotify_event_object_fh_len(event);
 		event_len += fanotify_fid_info_len(fh_len, dot_len);
+	}
 
 	return event_len;
 }
@@ -446,7 +447,7 @@ static int copy_info_records_to_user(struct fanotify_event *event,
 	/*
 	 * Event info records order is as follows: dir fid + name, child fid.
 	 */
-	if (fanotify_event_dir_fh_len(event)) {
+	if (fanotify_event_has_dir_fh(event)) {
 		info_type = info->name_len ? FAN_EVENT_INFO_TYPE_DFID_NAME :
 					     FAN_EVENT_INFO_TYPE_DFID;
 		ret = copy_fid_info_to_user(fanotify_event_fsid(event),
@@ -462,7 +463,7 @@ static int copy_info_records_to_user(struct fanotify_event *event,
 		total_bytes += ret;
 	}
 
-	if (fanotify_event_object_fh_len(event)) {
+	if (fanotify_event_has_object_fh(event)) {
 		const char *dot = NULL;
 		int dot_len = 0;
 
-- 
2.43.0



