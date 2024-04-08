Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22EAD78286;
	Mon,  8 Apr 2024 13:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582898; cv=none; b=vGZM+B4H4UQZvn/gd5/OBIUX+9kGCvVAPMG6aGnW/lAPWiRWgeMbvYS+gXdEvc/8A0djkM3kjL6E09ohodQYNbc5KD5Au8lfaLEJNlWuIYfQ9P+K84v1Ebqh2V67ZoHWG1l4T64c1s7ifAwgediV8iwBMTo28DqqImu7nGeXHTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582898; c=relaxed/simple;
	bh=2MPRWyLJkIecgB1VipRJujjuApP3UpQ0j4plQsL6eLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btBUKuLe9i+AgDGW+1mv+QOvc9zU/hs2sujc2Qek/og8WMc45kz5NUwLk2Lndjppu7qDcMJkJBGNtFsiVuBgRHgU1gunQVCpSS1EketptEgaV/juDaJ/gcr8bbGJ2qvE4LDlSwUuiaLnmCw8WN0Z6RhFtXF8aKLxzLE+IhXwYI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nBdUSAQk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nBdUSAQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828CBC433F1;
	Mon,  8 Apr 2024 13:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582897;
	bh=2MPRWyLJkIecgB1VipRJujjuApP3UpQ0j4plQsL6eLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nBdUSAQkA01CUGQ59FywbGQP//cVObqS3WgXOrfCmuIR0JXIM/OYbTgKItsN5dYn3
	 +Qgjp4UoFnRM7k6ISWBoMT73uE5WJkg6OiE17raYMjbMQ8fpEPwtgGvY8/Uuzl48L7
	 70c383uRZOYiZ8QDMpO5EPF8/LRDdzDKKQTbw3rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 185/690] fanotify: Support enqueueing of error events
Date: Mon,  8 Apr 2024 14:50:51 +0200
Message-ID: <20240408125406.260099480@linuxfoundation.org>
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

[ Upstream commit 83e9acbe13dc1b767f91b5c1350f7a65689b26f6 ]

Once an error event is triggered, enqueue it in the notification group,
similarly to what is done for other events.  FAN_FS_ERROR is not
handled specially, since the memory is now handled by a preallocated
mempool.

For now, make the event unhashed.  A future patch implements merging of
this kind of event.

Link: https://lore.kernel.org/r/20211025192746.66445-21-krisman@collabora.com
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fanotify/fanotify.c | 35 +++++++++++++++++++++++++++++++++++
 fs/notify/fanotify/fanotify.h |  6 ++++++
 2 files changed, 41 insertions(+)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 01d68dfc74aa2..1f195c95dfcd0 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -574,6 +574,27 @@ static struct fanotify_event *fanotify_alloc_name_event(struct inode *id,
 	return &fne->fae;
 }
 
+static struct fanotify_event *fanotify_alloc_error_event(
+						struct fsnotify_group *group,
+						__kernel_fsid_t *fsid,
+						const void *data, int data_type)
+{
+	struct fs_error_report *report =
+			fsnotify_data_error_report(data, data_type);
+	struct fanotify_error_event *fee;
+
+	if (WARN_ON_ONCE(!report))
+		return NULL;
+
+	fee = mempool_alloc(&group->fanotify_data.error_events_pool, GFP_NOFS);
+	if (!fee)
+		return NULL;
+
+	fee->fae.type = FANOTIFY_EVENT_TYPE_FS_ERROR;
+
+	return &fee->fae;
+}
+
 static struct fanotify_event *fanotify_alloc_event(struct fsnotify_group *group,
 						   u32 mask, const void *data,
 						   int data_type, struct inode *dir,
@@ -641,6 +662,9 @@ static struct fanotify_event *fanotify_alloc_event(struct fsnotify_group *group,
 
 	if (fanotify_is_perm_event(mask)) {
 		event = fanotify_alloc_perm_event(path, gfp);
+	} else if (fanotify_is_error_event(mask)) {
+		event = fanotify_alloc_error_event(group, fsid, data,
+						   data_type);
 	} else if (name_event && (file_name || child)) {
 		event = fanotify_alloc_name_event(id, fsid, file_name, child,
 						  &hash, gfp);
@@ -850,6 +874,14 @@ static void fanotify_free_name_event(struct fanotify_event *event)
 	kfree(FANOTIFY_NE(event));
 }
 
+static void fanotify_free_error_event(struct fsnotify_group *group,
+				      struct fanotify_event *event)
+{
+	struct fanotify_error_event *fee = FANOTIFY_EE(event);
+
+	mempool_free(fee, &group->fanotify_data.error_events_pool);
+}
+
 static void fanotify_free_event(struct fsnotify_group *group,
 				struct fsnotify_event *fsn_event)
 {
@@ -873,6 +905,9 @@ static void fanotify_free_event(struct fsnotify_group *group,
 	case FANOTIFY_EVENT_TYPE_OVERFLOW:
 		kfree(event);
 		break;
+	case FANOTIFY_EVENT_TYPE_FS_ERROR:
+		fanotify_free_error_event(group, event);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 	}
diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index a577e87fac2b4..ebef952481fa0 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -298,6 +298,11 @@ static inline struct fanotify_event *FANOTIFY_E(struct fsnotify_event *fse)
 	return container_of(fse, struct fanotify_event, fse);
 }
 
+static inline bool fanotify_is_error_event(u32 mask)
+{
+	return mask & FAN_FS_ERROR;
+}
+
 static inline bool fanotify_event_has_path(struct fanotify_event *event)
 {
 	return event->type == FANOTIFY_EVENT_TYPE_PATH ||
@@ -327,6 +332,7 @@ static inline struct path *fanotify_event_path(struct fanotify_event *event)
 static inline bool fanotify_is_hashed_event(u32 mask)
 {
 	return !(fanotify_is_perm_event(mask) ||
+		 fanotify_is_error_event(mask) ||
 		 fsnotify_is_overflow_event(mask));
 }
 
-- 
2.43.0



