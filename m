Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A82D1586C0;
	Tue, 18 Jun 2024 13:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716053; cv=none; b=hz3vSP+1q9wUGEvY3BSlIhJ/3iXlM8wKy4vgnQd5pz27gPPyLmH5Y+uwF06q604KuhoFQ+yLw5iu7khD3WaZByAc4aei2kxVBgYVLSY0H6JdFHhICM0j4Yy1s+wqlCZPTho+fG3kMjMdfx/MQHu5lyWHUFr9rAJZIz3LgAVyyWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716053; c=relaxed/simple;
	bh=09AuRYSQJuKc1i4109KJudT0jMpCMySmSa4/Io+ASgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KRajIqsAzG7DGdHubk4K7nm/lamp3YeYRwWMiEyR1JFS42bQwIGXwTmhM9/xl6S7WnXGb7l2gEt2lUiOpTcP8yBJKknR27pL+2oOCweW8F8NEIF9ZPMm5P605T2g4Kg9x9gDYoYLs7fst3NlmKeGBmSWdU0sQwFWfUpzLjev634=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MdsMmYXp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MdsMmYXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1470C3277B;
	Tue, 18 Jun 2024 13:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716053;
	bh=09AuRYSQJuKc1i4109KJudT0jMpCMySmSa4/Io+ASgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MdsMmYXpuuHSfsoKyDafddVgOGwszPrcaBe/vNyOaIDg5ZTYyTz4z8goX7CH/MqoL
	 Fo6GBp6jqNxiAJ+w76IDljhWcILdbgYq4c8FgfjWLmAIFH82IV/XKChd8t+ufirEBr
	 e6kwlj1siGdVPLRz84UNyp4b59oV87xOLqsarZ7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 485/770] fsnotify: fix merge with parents ignored mask
Date: Tue, 18 Jun 2024 14:35:38 +0200
Message-ID: <20240618123426.038061756@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify_user.c | 17 +++++++++--------
 fs/notify/mark.c                   |  4 ++--
 include/linux/fsnotify_backend.h   | 15 +++++++++++++++
 3 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 6679700574113..12fb209e60419 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -991,17 +991,18 @@ static __u32 fanotify_mark_remove_from_mask(struct fsnotify_mark *fsn_mark,
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
@@ -1011,7 +1012,7 @@ static __u32 fanotify_mark_remove_from_mask(struct fsnotify_mark *fsn_mark,
 	*destroy = !((fsn_mark->mask | fsn_mark->ignored_mask) & ~umask);
 	spin_unlock(&fsn_mark->lock);
 
-	return mask & oldmask;
+	return oldmask & ~newmask;
 }
 
 static int fanotify_remove_mark(struct fsnotify_group *group,
@@ -1069,23 +1070,23 @@ static int fanotify_remove_inode_mark(struct fsnotify_group *group,
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



