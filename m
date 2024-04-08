Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB436A352;
	Mon,  8 Apr 2024 13:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582770; cv=none; b=JtUrEJ612GyIHiaNOUyv4Sbu4M9zQL6wCXEiv1ANkpI9gIHn0toa9SMHeylYJkcYzRZ3PhI6LMjs6QPQp9KSFT/N5FAVF/v4nSMl8b7DEmnKqyrv1p1WKVjTDdbd+bR7OohN2oRuqhBjndIevU99v4TWtCT2GO2uyQoGC8dz+m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582770; c=relaxed/simple;
	bh=3xU3F7Xknc1TdgX9amYd7lFyaKrX/k//uiYIdbHNcNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogf2mBypvHagXv1d8Yhj7yghESmnFkMO0gi2vtfHRjUFTn8wpMLmuq51ks4gRMdLn5Ng4T6FwbuH4repFjaZ8wxhoDPX/TAJHIiXO9JExEhckodxXkyX5E5i5Me3RSlNNOObjEuAvhtklxueO5Tj3gpCJ7+nc5Auvex3ipbXiHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iecT7wjG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iecT7wjG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD3BC433C7;
	Mon,  8 Apr 2024 13:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582769;
	bh=3xU3F7Xknc1TdgX9amYd7lFyaKrX/k//uiYIdbHNcNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iecT7wjGhZS/pgi4d3frlX9lmft/RdRbIAktoxUKmP7wrPPfuJL+CXxKUkJDvRt8g
	 0u/rQz8rVtn1SN4zM0oVU9ouTQaMUKYIsYM96J4n8k1z9z/JETLhwBteOWx1jPmcYZ
	 mzzPcr3YM91cr1MNVFogTZXY+wHGUH8YG7/J3vnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 174/690] fsnotify: Add wrapper around fsnotify_add_event
Date: Mon,  8 Apr 2024 14:50:40 +0200
Message-ID: <20240408125405.866390094@linuxfoundation.org>
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

[ Upstream commit 1ad03c3a326a86e259389592117252c851873395 ]

fsnotify_add_event is growing in number of parameters, which in most
case are just passed a NULL pointer.  So, split out a new
fsnotify_insert_event function to clean things up for users who don't
need an insert hook.

Link: https://lore.kernel.org/r/20211025192746.66445-10-krisman@collabora.com
Suggested-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fanotify/fanotify.c        |  4 ++--
 fs/notify/inotify/inotify_fsnotify.c |  2 +-
 fs/notify/notification.c             | 12 ++++++------
 include/linux/fsnotify_backend.h     | 23 ++++++++++++++++-------
 4 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 310246f8d3f19..f82e20228999c 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -781,8 +781,8 @@ static int fanotify_handle_event(struct fsnotify_group *group, u32 mask,
 	}
 
 	fsn_event = &event->fse;
-	ret = fsnotify_add_event(group, fsn_event, fanotify_merge,
-				 fanotify_insert_event);
+	ret = fsnotify_insert_event(group, fsn_event, fanotify_merge,
+				    fanotify_insert_event);
 	if (ret) {
 		/* Permission events shouldn't be merged */
 		BUG_ON(ret == 1 && mask & FANOTIFY_PERM_EVENTS);
diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index b0530f75b274a..be3eb1cebdcce 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -123,7 +123,7 @@ int inotify_handle_inode_event(struct fsnotify_mark *inode_mark, u32 mask,
 	if (len)
 		strcpy(event->name, name->name);
 
-	ret = fsnotify_add_event(group, fsn_event, inotify_merge, NULL);
+	ret = fsnotify_add_event(group, fsn_event, inotify_merge);
 	if (ret) {
 		/* Our event wasn't used in the end. Free it. */
 		fsnotify_destroy_event(group, fsn_event);
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 32f45543b9c64..44bb10f507153 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -78,12 +78,12 @@ void fsnotify_destroy_event(struct fsnotify_group *group,
  * 2 if the event was not queued - either the queue of events has overflown
  *   or the group is shutting down.
  */
-int fsnotify_add_event(struct fsnotify_group *group,
-		       struct fsnotify_event *event,
-		       int (*merge)(struct fsnotify_group *,
-				    struct fsnotify_event *),
-		       void (*insert)(struct fsnotify_group *,
-				      struct fsnotify_event *))
+int fsnotify_insert_event(struct fsnotify_group *group,
+			  struct fsnotify_event *event,
+			  int (*merge)(struct fsnotify_group *,
+				       struct fsnotify_event *),
+			  void (*insert)(struct fsnotify_group *,
+					 struct fsnotify_event *))
 {
 	int ret = 0;
 	struct list_head *list = &group->notification_list;
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 749bc85e1d1c4..b323d0c4b9671 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -498,16 +498,25 @@ extern int fsnotify_fasync(int fd, struct file *file, int on);
 extern void fsnotify_destroy_event(struct fsnotify_group *group,
 				   struct fsnotify_event *event);
 /* attach the event to the group notification queue */
-extern int fsnotify_add_event(struct fsnotify_group *group,
-			      struct fsnotify_event *event,
-			      int (*merge)(struct fsnotify_group *,
-					   struct fsnotify_event *),
-			      void (*insert)(struct fsnotify_group *,
-					     struct fsnotify_event *));
+extern int fsnotify_insert_event(struct fsnotify_group *group,
+				 struct fsnotify_event *event,
+				 int (*merge)(struct fsnotify_group *,
+					      struct fsnotify_event *),
+				 void (*insert)(struct fsnotify_group *,
+						struct fsnotify_event *));
+
+static inline int fsnotify_add_event(struct fsnotify_group *group,
+				     struct fsnotify_event *event,
+				     int (*merge)(struct fsnotify_group *,
+						  struct fsnotify_event *))
+{
+	return fsnotify_insert_event(group, event, merge, NULL);
+}
+
 /* Queue overflow event to a notification group */
 static inline void fsnotify_queue_overflow(struct fsnotify_group *group)
 {
-	fsnotify_add_event(group, group->overflow_event, NULL, NULL);
+	fsnotify_add_event(group, group->overflow_event, NULL);
 }
 
 static inline bool fsnotify_is_overflow_event(u32 mask)
-- 
2.43.0



