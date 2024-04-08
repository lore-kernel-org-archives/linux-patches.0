Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DC7524AF;
	Mon,  8 Apr 2024 13:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582807; cv=none; b=Oga8pAHX1RxX8TKb/cZAXHVVfg88j607+uclw6CFYUB52GS9NHTYf5QnevzEZjXN1Q9P8wP+aCAHF4W0JPo5lwg1SVQORAnWsmKlaOSb2gaud21YOd6j0v8zxYc4IbMzBeN3ExWcTmye9gnmUU8koZMdT0002m/kJFlfZssG4Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582807; c=relaxed/simple;
	bh=ZtUuV3wKMKhlXGy+uU0G4DZsdHMvcOSDtzo6JNt+x6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4pQjrt999N9c0dlDQ4iyHOQ7ps9IqM4GI+qRRMQjdLYhro17S6cBfMFy3ZWVul3H02KOkCMz1OGj2bkBGjrz4EqbGV0M8ihjxQTmSB3km17QwAUY2JBEvGdAZoNn1V5yXYHWuZ7B+liuN/0Diq0mhvL2aKbtxazvVVxcn+Ll9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y6jKsV0X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y6jKsV0X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F2EC433F1;
	Mon,  8 Apr 2024 13:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582807;
	bh=ZtUuV3wKMKhlXGy+uU0G4DZsdHMvcOSDtzo6JNt+x6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6jKsV0Xa6XN3pGxVLHUmcooTsDdaUTqT5FWV33nwcfZYe0Dj1fa8kWL4KJkzRs37
	 BFMIgr1aei8PF99qRZHhXG+it+edLhZUl7KDMi8MyalUTTLxQ4AdRI+xfj1/vLcqzs
	 Cy4BjPYXXP/Sj7KEkg0RjB2Uqp4faNkVpLkclYaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 177/690] fsnotify: Pass group argument to free_event
Date: Mon,  8 Apr 2024 14:50:43 +0200
Message-ID: <20240408125405.970264452@linuxfoundation.org>
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

[ Upstream commit 330ae77d2a5b0af32c0f29e139bf28ec8591de59 ]

For group-wide mempool backed events, like FS_ERROR, the free_event
callback will need to reference the group's mempool to free the memory.
Wire that argument into the current callers.

Link: https://lore.kernel.org/r/20211025192746.66445-13-krisman@collabora.com
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fanotify/fanotify.c        | 3 ++-
 fs/notify/group.c                    | 2 +-
 fs/notify/inotify/inotify_fsnotify.c | 3 ++-
 fs/notify/notification.c             | 2 +-
 include/linux/fsnotify_backend.h     | 2 +-
 5 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index f82e20228999c..c620b4f6fe123 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -835,7 +835,8 @@ static void fanotify_free_name_event(struct fanotify_event *event)
 	kfree(FANOTIFY_NE(event));
 }
 
-static void fanotify_free_event(struct fsnotify_event *fsn_event)
+static void fanotify_free_event(struct fsnotify_group *group,
+				struct fsnotify_event *fsn_event)
 {
 	struct fanotify_event *event;
 
diff --git a/fs/notify/group.c b/fs/notify/group.c
index fb89c351295d6..6a297efc47887 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -88,7 +88,7 @@ void fsnotify_destroy_group(struct fsnotify_group *group)
 	 * that deliberately ignores overflow events.
 	 */
 	if (group->overflow_event)
-		group->ops->free_event(group->overflow_event);
+		group->ops->free_event(group, group->overflow_event);
 
 	fsnotify_put_group(group);
 }
diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index be3eb1cebdcce..8279827836399 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -184,7 +184,8 @@ static void inotify_free_group_priv(struct fsnotify_group *group)
 		dec_inotify_instances(group->inotify_data.ucounts);
 }
 
-static void inotify_free_event(struct fsnotify_event *fsn_event)
+static void inotify_free_event(struct fsnotify_group *group,
+			       struct fsnotify_event *fsn_event)
 {
 	kfree(INOTIFY_E(fsn_event));
 }
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 44bb10f507153..9022ae650cf86 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -64,7 +64,7 @@ void fsnotify_destroy_event(struct fsnotify_group *group,
 		WARN_ON(!list_empty(&event->list));
 		spin_unlock(&group->notification_lock);
 	}
-	group->ops->free_event(event);
+	group->ops->free_event(group, event);
 }
 
 /*
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index b71dc788018e4..3a7c314361824 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -156,7 +156,7 @@ struct fsnotify_ops {
 			    const struct qstr *file_name, u32 cookie);
 	void (*free_group_priv)(struct fsnotify_group *group);
 	void (*freeing_mark)(struct fsnotify_mark *mark, struct fsnotify_group *group);
-	void (*free_event)(struct fsnotify_event *event);
+	void (*free_event)(struct fsnotify_group *group, struct fsnotify_event *event);
 	/* called on final put+free to free memory */
 	void (*free_mark)(struct fsnotify_mark *mark);
 };
-- 
2.43.0



