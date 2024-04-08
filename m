Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E0A78286;
	Mon,  8 Apr 2024 13:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582886; cv=none; b=Hm3mm73TWzCvncFIsFXFuvLb9bbKYJ+4KvdhuofcMql2o9gjrEblFOHbgJx/QkAbGfOnKY20mDmzlu7VHZ9Kt/jW2HDJTNlZRFUmqcFLdFC5tSibrRDlYN62F2eiIoxWlxyUoHugqDsvVmg5ilC6VAZqUOzjdschkfMF0kvRo/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582886; c=relaxed/simple;
	bh=g4Q0MRLXyWserf3xzFZ0cA19Y3oMltL8sXt2g/6Zyak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dqwLhEPb97dP6c+8UJLrkM6//rKts5kKH6Woce3aC2sAk6L2kd3YArh68Tftf8SVBOLULPEbn2HtC5JrmqyEQ1eiGnVn0MaNpz49CVhXJ6eo41qPgnn1VaZ+CfFUOPUzOPARe25tU3xObkm5+1ZWDp+IXZsQaP5jmGwWy558Nh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBj7h6mi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBj7h6mi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA41C433F1;
	Mon,  8 Apr 2024 13:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582886;
	bh=g4Q0MRLXyWserf3xzFZ0cA19Y3oMltL8sXt2g/6Zyak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBj7h6miNE0ClbjiSSz7m4svwgdounsd2XkVjodl0t18POJqLk3gA5vZRQmVryrBH
	 DJciaYNO8wyzHttIc3nyUilTXEGM2McIPOcwf4Nq7l3n169I6oR+ShPeCY9ukW2Ph3
	 ASbtO1tCnA5sZ3OlNfteXpVUt+GXc90b2oBX8ADQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 184/690] fanotify: Pre-allocate pool of error events
Date: Mon,  8 Apr 2024 14:50:50 +0200
Message-ID: <20240408125406.220129271@linuxfoundation.org>
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
index 8598b00f7e9c8..b3cbcb0e71c99 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -30,6 +30,7 @@
 #define FANOTIFY_DEFAULT_MAX_EVENTS	16384
 #define FANOTIFY_OLD_DEFAULT_MAX_MARKS	8192
 #define FANOTIFY_DEFAULT_MAX_GROUPS	128
+#define FANOTIFY_DEFAULT_FEE_POOL_SIZE	32
 
 /*
  * Legacy fanotify marks limits (8192) is per group and we introduced a tunable
@@ -1054,6 +1055,15 @@ static struct fsnotify_mark *fanotify_add_new_mark(struct fsnotify_group *group,
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
@@ -1062,6 +1072,7 @@ static int fanotify_add_mark(struct fsnotify_group *group,
 {
 	struct fsnotify_mark *fsn_mark;
 	__u32 added;
+	int ret = 0;
 
 	mutex_lock(&group->mark_mutex);
 	fsn_mark = fsnotify_find_mark(connp, group);
@@ -1072,13 +1083,26 @@ static int fanotify_add_mark(struct fsnotify_group *group,
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



