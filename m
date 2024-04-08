Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1153B7C0AB;
	Mon,  8 Apr 2024 13:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583772; cv=none; b=NmUxWTke8fHypr1EMJyvPPJni83vDUE6mj7TFkXO7+6fV+U3ta188O9EPFXqT5leRlUYA85Pa/MvQ6+hv+u/jcBNVXebN1eXlj4hSK20lz+GCFWTQdckPghPefVju3JpxveWQAuSxA4ki9adHnP4BPZIaSc53DAAdUfXVq1u2lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583772; c=relaxed/simple;
	bh=/WpKZlFTXk/hnd43MrgWoviqopoQe4nID2RZCzbdF2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZd/8SWEqYs1FNY+dh5R22PU7efJJG0WS5BJVQOZ8FNwTmFc9Zh20NMknS2eQMrIF7BCnwJBGDlDyujkSN4S5p6k/Zs53WSvBestQjqnbUToRc83zYq57uyXxX10+jS6AWyW0eP7Tx+sVFtu1QX72NMpTAxRdmea3ieLrMXDoyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B/NHaOcV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B/NHaOcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0DAC433C7;
	Mon,  8 Apr 2024 13:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583771;
	bh=/WpKZlFTXk/hnd43MrgWoviqopoQe4nID2RZCzbdF2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B/NHaOcV6A2KLlUf1+Rt0Cmw9CiHVexpRfpXjJWBodRQ3rZAh1SKDdVX9B6DoCfUg
	 tDacAWDvdoE4LTK9kZXDxJYf8t41xg3JD9pGit+jyNHe5cYCilZbO/prC6x2VRx8E2
	 0G5fJS6xJsZynZeiGHi+ENWsYLmutU3GEKeS2Tgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 283/690] fsnotify: fix merge with parents ignored mask
Date: Mon,  8 Apr 2024 14:52:29 +0200
Message-ID: <20240408125409.863692483@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 4f0b903ded728c505850daf2914bfc08841f0ae6 ]

fsnotify_parent() does not consider the parent's mark at all unless
the parent inode shows interest in events on children and in the
specific event.

So unless parent added an event to both its mark mask and ignored mask,
the event will not be ignored.

Fix this by declaring the interest of an object in an event when the
event is in either a mark mask or ignored mask.

Link: https://lore.kernel.org/r/20220223151438.790268-2-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fanotify/fanotify_user.c | 17 +++++++++--------
 fs/notify/mark.c                   |  4 ++--
 include/linux/fsnotify_backend.h   | 15 +++++++++++++++
 3 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index ce84eb8443b10..9ed9d7f6c2b50 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -999,17 +999,18 @@ static __u32 fanotify_mark_remove_from_mask(struct fsnotify_mark *fsn_mark,
 					    __u32 mask, unsigned int flags,
 					    __u32 umask, int *destroy)
 {
-	__u32 oldmask = 0;
+	__u32 oldmask, newmask;
 
 	/* umask bits cannot be removed by user */
 	mask &= ~umask;
 	spin_lock(&fsn_mark->lock);
+	oldmask = fsnotify_calc_mask(fsn_mark);
 	if (!(flags & FAN_MARK_IGNORED_MASK)) {
-		oldmask = fsn_mark->mask;
 		fsn_mark->mask &= ~mask;
 	} else {
 		fsn_mark->ignored_mask &= ~mask;
 	}
+	newmask = fsnotify_calc_mask(fsn_mark);
 	/*
 	 * We need to keep the mark around even if remaining mask cannot
 	 * result in any events (e.g. mask == FAN_ONDIR) to support incremenal
@@ -1019,7 +1020,7 @@ static __u32 fanotify_mark_remove_from_mask(struct fsnotify_mark *fsn_mark,
 	*destroy = !((fsn_mark->mask | fsn_mark->ignored_mask) & ~umask);
 	spin_unlock(&fsn_mark->lock);
 
-	return mask & oldmask;
+	return oldmask & ~newmask;
 }
 
 static int fanotify_remove_mark(struct fsnotify_group *group,
@@ -1077,23 +1078,23 @@ static int fanotify_remove_inode_mark(struct fsnotify_group *group,
 }
 
 static __u32 fanotify_mark_add_to_mask(struct fsnotify_mark *fsn_mark,
-				       __u32 mask,
-				       unsigned int flags)
+				       __u32 mask, unsigned int flags)
 {
-	__u32 oldmask = -1;
+	__u32 oldmask, newmask;
 
 	spin_lock(&fsn_mark->lock);
+	oldmask = fsnotify_calc_mask(fsn_mark);
 	if (!(flags & FAN_MARK_IGNORED_MASK)) {
-		oldmask = fsn_mark->mask;
 		fsn_mark->mask |= mask;
 	} else {
 		fsn_mark->ignored_mask |= mask;
 		if (flags & FAN_MARK_IGNORED_SURV_MODIFY)
 			fsn_mark->flags |= FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY;
 	}
+	newmask = fsnotify_calc_mask(fsn_mark);
 	spin_unlock(&fsn_mark->lock);
 
-	return mask & ~oldmask;
+	return newmask & ~oldmask;
 }
 
 static struct fsnotify_mark *fanotify_add_new_mark(struct fsnotify_group *group,
diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index b42629d2fc1c6..c86982be2d505 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -127,7 +127,7 @@ static void __fsnotify_recalc_mask(struct fsnotify_mark_connector *conn)
 		return;
 	hlist_for_each_entry(mark, &conn->list, obj_list) {
 		if (mark->flags & FSNOTIFY_MARK_FLAG_ATTACHED)
-			new_mask |= mark->mask;
+			new_mask |= fsnotify_calc_mask(mark);
 	}
 	*fsnotify_conn_mask_p(conn) = new_mask;
 }
@@ -692,7 +692,7 @@ int fsnotify_add_mark_locked(struct fsnotify_mark *mark,
 	if (ret)
 		goto err;
 
-	if (mark->mask)
+	if (mark->mask || mark->ignored_mask)
 		fsnotify_recalc_mask(mark->connector);
 
 	return ret;
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 790c31844db5d..5f9c960049b07 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -601,6 +601,21 @@ extern void fsnotify_remove_queued_event(struct fsnotify_group *group,
 
 /* functions used to manipulate the marks attached to inodes */
 
+/* Get mask for calculating object interest taking ignored mask into account */
+static inline __u32 fsnotify_calc_mask(struct fsnotify_mark *mark)
+{
+	__u32 mask = mark->mask;
+
+	if (!mark->ignored_mask)
+		return mask;
+
+	/*
+	 * If mark is interested in ignoring events on children, the object must
+	 * show interest in those events for fsnotify_parent() to notice it.
+	 */
+	return mask | (mark->ignored_mask & ALL_FSNOTIFY_EVENTS);
+}
+
 /* Get mask of events for a list of marks */
 extern __u32 fsnotify_conn_mask(struct fsnotify_mark_connector *conn);
 /* Calculate mask of events for a list of marks */
-- 
2.43.0



