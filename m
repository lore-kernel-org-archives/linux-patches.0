Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A975416DC1E;
	Tue, 18 Jun 2024 12:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715354; cv=none; b=JX0MFbVTQffPHVgLapbKa8FmbwR8mcjk2FxnXovC1GQn6YIkRKjk1889Zp8fiW/x/rt1MtJ7RivaLuYerUs4/WGf0JYm9QyJOXguAtGo3eGcVBLiB7qyuUSENRUteL/F/8AM4HIZb+GH2fqy2BztMEBCONIhuhcUUmqad2ZrENQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715354; c=relaxed/simple;
	bh=rmc0fL/M9MCQqN6JWtnQq02eEA7/3HGyOiEkYQflhrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zca/BE9ujNO3pbhXGfqeiBI3y9jrfdXpgZxp85G2PHSp/yZZz6wLJOXPGJJiYXryRq6kz0wRNxp4CwxTuJ5HIWlv/VNFPpZUE8qRCN+KSuanFnFVU6r50ZA/ZAekojbEG7I4x4Xw4Et4kaf587NaMSQ2I1SrmENdIrBv6oF0Wyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=refzi567; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="refzi567"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3112BC3277B;
	Tue, 18 Jun 2024 12:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715354;
	bh=rmc0fL/M9MCQqN6JWtnQq02eEA7/3HGyOiEkYQflhrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=refzi567MQewgf/ARHW0o1EnnL5MswMvTfeIN7mdEpGLLMsbBUK/V2ihMKMPFEyKZ
	 VWJtKtkfk7n5s1Ce89yesA11ZaMdQLzu8d947WWOudfS1u2wfZxRCCanctt2VhSNBl
	 Vgv9SNJMaIt1Az8vboUXfD1eRhRMLVgXY75xKsDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 249/770] fsnotify: allow fsnotify_{peek,remove}_first_event with empty queue
Date: Tue, 18 Jun 2024 14:31:42 +0200
Message-ID: <20240618123416.890216974@linuxfoundation.org>
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

[ Upstream commit 6f73171e192366ff7c98af9fb50615ef9615f8a7 ]

Current code has an assumtion that fsnotify_notify_queue_is_empty() is
called to verify that queue is not empty before trying to peek or remove
an event from queue.

Remove this assumption by moving the fsnotify_notify_queue_is_empty()
into the functions, allow them to return NULL value and check return
value by all callers.

This is a prep patch for multi event queues.

Link: https://lore.kernel.org/r/20210304104826.3993892-2-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify_user.c | 26 +++++++++++-------
 fs/notify/inotify/inotify_user.c   |  5 ++--
 fs/notify/notification.c           | 42 ++++++++++++++----------------
 include/linux/fsnotify_backend.h   |  8 +++++-
 4 files changed, 44 insertions(+), 37 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 829ead2792dfb..30651e8d1a6d5 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -100,24 +100,30 @@ static struct fanotify_event *get_one_event(struct fsnotify_group *group,
 {
 	size_t event_size = FAN_EVENT_METADATA_LEN;
 	struct fanotify_event *event = NULL;
+	struct fsnotify_event *fsn_event;
 	unsigned int fid_mode = FAN_GROUP_FLAG(group, FANOTIFY_FID_BITS);
 
 	pr_debug("%s: group=%p count=%zd\n", __func__, group, count);
 
 	spin_lock(&group->notification_lock);
-	if (fsnotify_notify_queue_is_empty(group))
+	fsn_event = fsnotify_peek_first_event(group);
+	if (!fsn_event)
 		goto out;
 
-	if (fid_mode) {
-		event_size += fanotify_event_info_len(fid_mode,
-			FANOTIFY_E(fsnotify_peek_first_event(group)));
-	}
+	event = FANOTIFY_E(fsn_event);
+	if (fid_mode)
+		event_size += fanotify_event_info_len(fid_mode, event);
 
 	if (event_size > count) {
 		event = ERR_PTR(-EINVAL);
 		goto out;
 	}
-	event = FANOTIFY_E(fsnotify_remove_first_event(group));
+
+	/*
+	 * Held the notification_lock the whole time, so this is the
+	 * same event we peeked above.
+	 */
+	fsnotify_remove_first_event(group);
 	if (fanotify_is_perm_event(event->mask))
 		FANOTIFY_PERM(event)->state = FAN_EVENT_REPORTED;
 out:
@@ -573,6 +579,7 @@ static ssize_t fanotify_write(struct file *file, const char __user *buf, size_t
 static int fanotify_release(struct inode *ignored, struct file *file)
 {
 	struct fsnotify_group *group = file->private_data;
+	struct fsnotify_event *fsn_event;
 
 	/*
 	 * Stop new events from arriving in the notification queue. since
@@ -601,13 +608,12 @@ static int fanotify_release(struct inode *ignored, struct file *file)
 	 * dequeue them and set the response. They will be freed once the
 	 * response is consumed and fanotify_get_response() returns.
 	 */
-	while (!fsnotify_notify_queue_is_empty(group)) {
-		struct fanotify_event *event;
+	while ((fsn_event = fsnotify_remove_first_event(group))) {
+		struct fanotify_event *event = FANOTIFY_E(fsn_event);
 
-		event = FANOTIFY_E(fsnotify_remove_first_event(group));
 		if (!(event->mask & FANOTIFY_PERM_EVENTS)) {
 			spin_unlock(&group->notification_lock);
-			fsnotify_destroy_event(group, &event->fse);
+			fsnotify_destroy_event(group, fsn_event);
 		} else {
 			finish_permission_event(group, FANOTIFY_PERM(event),
 						FAN_ALLOW);
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 82fc0cf86a7c3..c2018983832e5 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -146,10 +146,9 @@ static struct fsnotify_event *get_one_event(struct fsnotify_group *group,
 	size_t event_size = sizeof(struct inotify_event);
 	struct fsnotify_event *event;
 
-	if (fsnotify_notify_queue_is_empty(group))
-		return NULL;
-
 	event = fsnotify_peek_first_event(group);
+	if (!event)
+		return NULL;
 
 	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
 
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 75d79d6d3ef09..001cfe7d2e4e7 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -47,13 +47,6 @@ u32 fsnotify_get_cookie(void)
 }
 EXPORT_SYMBOL_GPL(fsnotify_get_cookie);
 
-/* return true if the notify queue is empty, false otherwise */
-bool fsnotify_notify_queue_is_empty(struct fsnotify_group *group)
-{
-	assert_spin_locked(&group->notification_lock);
-	return list_empty(&group->notification_list) ? true : false;
-}
-
 void fsnotify_destroy_event(struct fsnotify_group *group,
 			    struct fsnotify_event *event)
 {
@@ -141,33 +134,36 @@ void fsnotify_remove_queued_event(struct fsnotify_group *group,
 }
 
 /*
- * Remove and return the first event from the notification list.  It is the
- * responsibility of the caller to destroy the obtained event
+ * Return the first event on the notification list without removing it.
+ * Returns NULL if the list is empty.
  */
-struct fsnotify_event *fsnotify_remove_first_event(struct fsnotify_group *group)
+struct fsnotify_event *fsnotify_peek_first_event(struct fsnotify_group *group)
 {
-	struct fsnotify_event *event;
-
 	assert_spin_locked(&group->notification_lock);
 
-	pr_debug("%s: group=%p\n", __func__, group);
+	if (fsnotify_notify_queue_is_empty(group))
+		return NULL;
 
-	event = list_first_entry(&group->notification_list,
-				 struct fsnotify_event, list);
-	fsnotify_remove_queued_event(group, event);
-	return event;
+	return list_first_entry(&group->notification_list,
+				struct fsnotify_event, list);
 }
 
 /*
- * This will not remove the event, that must be done with
- * fsnotify_remove_first_event()
+ * Remove and return the first event from the notification list.  It is the
+ * responsibility of the caller to destroy the obtained event
  */
-struct fsnotify_event *fsnotify_peek_first_event(struct fsnotify_group *group)
+struct fsnotify_event *fsnotify_remove_first_event(struct fsnotify_group *group)
 {
-	assert_spin_locked(&group->notification_lock);
+	struct fsnotify_event *event = fsnotify_peek_first_event(group);
 
-	return list_first_entry(&group->notification_list,
-				struct fsnotify_event, list);
+	if (!event)
+		return NULL;
+
+	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
+
+	fsnotify_remove_queued_event(group, event);
+
+	return event;
 }
 
 /*
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index e5409b83e7313..7eb979bfc1413 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -495,7 +495,13 @@ static inline void fsnotify_queue_overflow(struct fsnotify_group *group)
 	fsnotify_add_event(group, group->overflow_event, NULL);
 }
 
-/* true if the group notification queue is empty */
+static inline bool fsnotify_notify_queue_is_empty(struct fsnotify_group *group)
+{
+	assert_spin_locked(&group->notification_lock);
+
+	return list_empty(&group->notification_list);
+}
+
 extern bool fsnotify_notify_queue_is_empty(struct fsnotify_group *group);
 /* return, but do not dequeue the first event on the notification queue */
 extern struct fsnotify_event *fsnotify_peek_first_event(struct fsnotify_group *group);
-- 
2.43.0



