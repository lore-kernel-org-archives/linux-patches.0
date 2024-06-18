Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8617139D0C;
	Tue, 18 Jun 2024 13:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715629; cv=none; b=HnnPVulhzLy285RHMvoOcxvTb/AH+NlPaThN4ahiTfeWfrAF8sIXzaSBLsWxm0N5qZy+le6qSui2/WqLhMiIBH+bcL8WCDos0YqY1wHTYZJ+qyXsgUVj08e8gLD+5tp9BjIIWfAd6wx7uZH5X8E9Wv3AnTz3Er5By/yJB4dT+pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715629; c=relaxed/simple;
	bh=Dq10ZN2xVFt9d5ywxpytc0ze7CEN3COzIn2TnIfq2xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCtYThdR2tz+5j4JT/PSGgqsS/krtkxwOX4o6KUP+NABey3dnOp3PMs5Q8EMdjTIxd2SQ2U1NaAjhK6Ocsfhe764bGhpSyZ0xX2JKRFP+bp/h60AlTjtL6Hrf2acfxf18CQ3CMWdiiWHO6CjPLFTFyMQ6Epn4YkYe9uPfqMza4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vsLDhQHH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vsLDhQHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632BDC3277B;
	Tue, 18 Jun 2024 13:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715629;
	bh=Dq10ZN2xVFt9d5ywxpytc0ze7CEN3COzIn2TnIfq2xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vsLDhQHHq797Nkckc+Z/JoCN1+3WeV35X4AgEaHEOdiaNqs2bECLjDKUiJsTawBmB
	 +SBGDPWYBJcrstMq76zd1kJDofP1e5uYnF4e2BlTPyD3btb2SGKtEPkuJWeRK1u2CP
	 o6R9RvF4SQkCeE6g+oAyrVYu89WRViTdj+d8FCeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 372/770] fsnotify: Pass group argument to free_event
Date: Tue, 18 Jun 2024 14:33:45 +0200
Message-ID: <20240618123421.629618350@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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



