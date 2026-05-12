Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042CC3EDE61;
	Tue, 12 May 2026 18:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609170; cv=none; b=V/H+n3yGA3ABrPb3tkggnvMCfJuDsha/6WgHz5+/6YwVlH6O3kPYxmJkaFImum59fTNjVN31kdfw5+HBk43mIVy2nQ6upcTRIq7vez4Xnt+UDziegGG064YANMH3PvM77D9VvZ7zImAkxIwR7A8pf4+yLoKulgFT91EfT3SZw8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609170; c=relaxed/simple;
	bh=5wOuXH3400GUIgZIMN5z/QmriLZwugMO94nURtVNOSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ieb5nJIhX2jjYVElWLgDgx0ERkpCIDqACVfz0tnCzUJ8pgy9B8fFV5y9chD09+oBaTMYhnLwCTfFHXDJJrEXEl48zmfyBApvcJbPJLne0CSOrINeffASTLpK6ZWX1hfylNDieQxKhaMwsOp134TpRJejrPhkVpke/Y2oWQfqlJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WfxEcncc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WfxEcncc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A06C2BCB0;
	Tue, 12 May 2026 18:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609169;
	bh=5wOuXH3400GUIgZIMN5z/QmriLZwugMO94nURtVNOSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WfxEcncct7aTWax+BHMIy1G/Sji/9hLcWmIe+zDBT1+T1gVugCAF1gjuaVgPqiT8B
	 nMMJmus93juuPmEx3tna0BTfcdUQH5Ri1Qzg4ntVwDSqxm7dAUqH+wtaUz+uFu6Rxd
	 nrWLzhOQjK2U2POQYIavhyBT76TIYkq7uqnYxyrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 7.0 092/307] fanotify: fix false positive on permission events
Date: Tue, 12 May 2026 19:38:07 +0200
Message-ID: <20260512173942.069660653@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

commit 7746e3bd4cc19b5092e00d32d676e329bfcb6900 upstream.

fsnotify_get_mark_safe() may return false for a mark on an unrelated group,
which results in bypassing the permission check.

Fix by skipping over detached marks that are not in the current group.

CC: stable@vger.kernel.org
Fixes: abc77577a669 ("fsnotify: Provide framework for dropping SRCU lock in ->handle_event")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Link: https://patch.msgid.link/20260410144950.156160-1-mszeredi@redhat.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/notify/fsnotify.c             |    2 +-
 fs/notify/mark.c                 |   18 +++++++++++-------
 include/linux/fsnotify_backend.h |    1 +
 3 files changed, 13 insertions(+), 8 deletions(-)

--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -388,7 +388,7 @@ static struct fsnotify_mark *fsnotify_fi
 	return hlist_entry_safe(node, struct fsnotify_mark, obj_list);
 }
 
-static struct fsnotify_mark *fsnotify_next_mark(struct fsnotify_mark *mark)
+struct fsnotify_mark *fsnotify_next_mark(struct fsnotify_mark *mark)
 {
 	struct hlist_node *node = NULL;
 
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -457,9 +457,6 @@ EXPORT_SYMBOL_GPL(fsnotify_put_mark);
  */
 static bool fsnotify_get_mark_safe(struct fsnotify_mark *mark)
 {
-	if (!mark)
-		return true;
-
 	if (refcount_inc_not_zero(&mark->refcnt)) {
 		spin_lock(&mark->lock);
 		if (mark->flags & FSNOTIFY_MARK_FLAG_ATTACHED) {
@@ -500,15 +497,22 @@ bool fsnotify_prepare_user_wait(struct f
 	int type;
 
 	fsnotify_foreach_iter_type(type) {
+		struct fsnotify_mark *mark = iter_info->marks[type];
+
 		/* This can fail if mark is being removed */
-		if (!fsnotify_get_mark_safe(iter_info->marks[type])) {
-			__release(&fsnotify_mark_srcu);
-			goto fail;
+		while (mark && !fsnotify_get_mark_safe(mark)) {
+			if (mark->group == iter_info->current_group) {
+				__release(&fsnotify_mark_srcu);
+				goto fail;
+			}
+			/* This is a mark in an unrelated group, skip */
+			mark = fsnotify_next_mark(mark);
+			iter_info->marks[type] = mark;
 		}
 	}
 
 	/*
-	 * Now that both marks are pinned by refcount in the inode / vfsmount
+	 * Now that all marks are pinned by refcount in the inode / vfsmount / etc
 	 * lists, we can drop SRCU lock, and safely resume the list iteration
 	 * once userspace returns.
 	 */
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -915,6 +915,7 @@ extern void fsnotify_clear_marks_by_grou
 					  unsigned int obj_type);
 extern void fsnotify_get_mark(struct fsnotify_mark *mark);
 extern void fsnotify_put_mark(struct fsnotify_mark *mark);
+struct fsnotify_mark *fsnotify_next_mark(struct fsnotify_mark *mark);
 extern void fsnotify_finish_user_wait(struct fsnotify_iter_info *iter_info);
 extern bool fsnotify_prepare_user_wait(struct fsnotify_iter_info *iter_info);
 


