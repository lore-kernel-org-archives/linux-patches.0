Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21054156F22;
	Tue, 18 Jun 2024 13:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715728; cv=none; b=oT8usM7Erlr40Ssa6hBef3zcl5SUQuOqhnqCF6ppGPRIBRm4/ken0Umx8j2sgBqzjf111OK397di43y/9rELpsOXfwIszu/XqKSqo5XOY9jHK2FSQESlMFegvRqpmWNiajIMbY1yh//vKFDK2uADkhCCpX+NEe4yV5j2TXZV/RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715728; c=relaxed/simple;
	bh=tfJrf3VRhJmjsiWRBMtd/cfT2BpHrpT68PMYYHRJiXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxY1Yi4AZqfzPD93R9P2NU/CWgzQIryBnbo+PbEEUXYKhK2AQ7HSCzb2bcZOFvzBPWWboWfF/KLn3AjFod3o9ocXKUDCQ1tU2QtKK1cyLoSZ0uvNf5ZEALI366nSqIlEuBt9qXvvU1haDi/wJ3kUebiCB0hGd0HbLQfygm3w9us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XF3ic1Wt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XF3ic1Wt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED34C3277B;
	Tue, 18 Jun 2024 13:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715728;
	bh=tfJrf3VRhJmjsiWRBMtd/cfT2BpHrpT68PMYYHRJiXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XF3ic1Wtkgj+yPvxUlGTAxnxupdihNI17wUS0G7yGkTwbL/zXajAYk9QovR95EHJs
	 mDM8NafAGD9LKnLz3E2E1PJYgfeaGkCJNbzhqrro0LGLkr8GC5Vs4WfcosLerzImUz
	 xuCkXhi7zf7Nq/gGUKgs9Tt9/n8WhRUnF2NN6DvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 379/770] fanotify: Pre-allocate pool of error events
Date: Tue, 18 Jun 2024 14:33:52 +0200
Message-ID: <20240618123421.904554561@linuxfoundation.org>
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

[ Upstream commit 734a1a5eccc5f7473002b0669f788e135f1f64aa ]

Pre-allocate slots for file system errors to have greater chances of
succeeding, since error events can happen in GFP_NOFS context.  This
patch introduces a group-wide mempool of error events, shared by all
FAN_FS_ERROR marks in this group.

Link: https://lore.kernel.org/r/20211025192746.66445-20-krisman@collabora.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify.c      |  3 +++
 fs/notify/fanotify/fanotify.h      | 11 +++++++++++
 fs/notify/fanotify/fanotify_user.c | 26 +++++++++++++++++++++++++-
 include/linux/fsnotify_backend.h   |  2 ++
 4 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 8f152445d75c4..01d68dfc74aa2 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -819,6 +819,9 @@ static void fanotify_free_group_priv(struct fsnotify_group *group)
 	if (group->fanotify_data.ucounts)
 		dec_ucount(group->fanotify_data.ucounts,
 			   UCOUNT_FANOTIFY_GROUPS);
+
+	if (mempool_initialized(&group->fanotify_data.error_events_pool))
+		mempool_exit(&group->fanotify_data.error_events_pool);
 }
 
 static void fanotify_free_path_event(struct fanotify_event *event)
diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index c42cf8fd7d798..a577e87fac2b4 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -141,6 +141,7 @@ enum fanotify_event_type {
 	FANOTIFY_EVENT_TYPE_PATH,
 	FANOTIFY_EVENT_TYPE_PATH_PERM,
 	FANOTIFY_EVENT_TYPE_OVERFLOW, /* struct fanotify_event */
+	FANOTIFY_EVENT_TYPE_FS_ERROR, /* struct fanotify_error_event */
 	__FANOTIFY_EVENT_TYPE_NUM
 };
 
@@ -196,6 +197,16 @@ FANOTIFY_NE(struct fanotify_event *event)
 	return container_of(event, struct fanotify_name_event, fae);
 }
 
+struct fanotify_error_event {
+	struct fanotify_event fae;
+};
+
+static inline struct fanotify_error_event *
+FANOTIFY_EE(struct fanotify_event *event)
+{
+	return container_of(event, struct fanotify_error_event, fae);
+}
+
 static inline __kernel_fsid_t *fanotify_event_fsid(struct fanotify_event *event)
 {
 	if (event->type == FANOTIFY_EVENT_TYPE_FID)
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 34bf71108f7a3..8a2b7941fc986 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -30,6 +30,7 @@
 #define FANOTIFY_DEFAULT_MAX_EVENTS	16384
 #define FANOTIFY_OLD_DEFAULT_MAX_MARKS	8192
 #define FANOTIFY_DEFAULT_MAX_GROUPS	128
+#define FANOTIFY_DEFAULT_FEE_POOL_SIZE	32
 
 /*
  * Legacy fanotify marks limits (8192) is per group and we introduced a tunable
@@ -1049,6 +1050,15 @@ static struct fsnotify_mark *fanotify_add_new_mark(struct fsnotify_group *group,
 	return ERR_PTR(ret);
 }
 
+static int fanotify_group_init_error_pool(struct fsnotify_group *group)
+{
+	if (mempool_initialized(&group->fanotify_data.error_events_pool))
+		return 0;
+
+	return mempool_init_kmalloc_pool(&group->fanotify_data.error_events_pool,
+					 FANOTIFY_DEFAULT_FEE_POOL_SIZE,
+					 sizeof(struct fanotify_error_event));
+}
 
 static int fanotify_add_mark(struct fsnotify_group *group,
 			     fsnotify_connp_t *connp, unsigned int type,
@@ -1057,6 +1067,7 @@ static int fanotify_add_mark(struct fsnotify_group *group,
 {
 	struct fsnotify_mark *fsn_mark;
 	__u32 added;
+	int ret = 0;
 
 	mutex_lock(&group->mark_mutex);
 	fsn_mark = fsnotify_find_mark(connp, group);
@@ -1067,13 +1078,26 @@ static int fanotify_add_mark(struct fsnotify_group *group,
 			return PTR_ERR(fsn_mark);
 		}
 	}
+
+	/*
+	 * Error events are pre-allocated per group, only if strictly
+	 * needed (i.e. FAN_FS_ERROR was requested).
+	 */
+	if (!(flags & FAN_MARK_IGNORED_MASK) && (mask & FAN_FS_ERROR)) {
+		ret = fanotify_group_init_error_pool(group);
+		if (ret)
+			goto out;
+	}
+
 	added = fanotify_mark_add_to_mask(fsn_mark, mask, flags);
 	if (added & ~fsnotify_conn_mask(fsn_mark->connector))
 		fsnotify_recalc_mask(fsn_mark->connector);
+
+out:
 	mutex_unlock(&group->mark_mutex);
 
 	fsnotify_put_mark(fsn_mark);
-	return 0;
+	return ret;
 }
 
 static int fanotify_add_vfsmount_mark(struct fsnotify_group *group,
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 00dbaafbcf953..51ef2b079bfa0 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -19,6 +19,7 @@
 #include <linux/atomic.h>
 #include <linux/user_namespace.h>
 #include <linux/refcount.h>
+#include <linux/mempool.h>
 
 /*
  * IN_* from inotfy.h lines up EXACTLY with FS_*, this is so we can easily
@@ -246,6 +247,7 @@ struct fsnotify_group {
 			int flags;           /* flags from fanotify_init() */
 			int f_flags; /* event_f_flags from fanotify_init() */
 			struct ucounts *ucounts;
+			mempool_t error_events_pool;
 		} fanotify_data;
 #endif /* CONFIG_FANOTIFY */
 	};
-- 
2.43.0



