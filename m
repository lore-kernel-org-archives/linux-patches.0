Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03A733E36A;
	Sat, 30 May 2026 18:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165963; cv=none; b=tguUSN+dRGHHoK86fISXYnAXsAYfRi8fAtU6BsBoY3wyPi4/R2sSNGgxvqGR6knXiTkQCi6IKbmK5K1Y749bPz/TNlaI9eIB4NvHbOLFiHQWChVDjQvRJGAlhOWVm5mbcAA4QXjVCrGPIF1VzaFrSsiP/NyfAuY6+JJvRmzVFck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165963; c=relaxed/simple;
	bh=v+m7zKAcS+GbUINrwtViTH/QTiYdvcsTbRE/f/OEVbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PiojvHECbciAcfpJpCgg9qJT0/bIj5mgo+iOCtbnEIhz3y0EXq8N6rvdWkaCNaUidHg2aIk4M9CMiBkyys1xnWroctaKV7sm73UYfMl1+UzgiaVsWVb6UXa55qg4RCgEc/Q6YNYDki8+dMShi5QE7nRx0MW797JcjekpXnGvVpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MU/AW+tc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MU/AW+tc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284171F00893;
	Sat, 30 May 2026 18:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165962;
	bh=X5VR9EvsV6jNSxs6oOKGdhSYe+np/o9jREhyp6ux64A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MU/AW+tcElVL96CrxbB8r6V5fc1r60I7mao4mJZ7l3yuY7YY0ful96ewQ4QvL6AeM
	 B6inW4j1U55cr/uCmkpGhKWEQm+S0mC9Zb6CwhB3rLFv3N5rZN5MAb99T3JcpqoTVb
	 BbbVJmtL6KApWUj41Q3QdmGGSt2nnNhv950AizRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 5.10 233/589] fanotify: fix false positive on permission events
Date: Sat, 30 May 2026 18:01:54 +0200
Message-ID: <20260530160231.110032040@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -398,7 +398,7 @@ static struct fsnotify_mark *fsnotify_fi
 	return hlist_entry_safe(node, struct fsnotify_mark, obj_list);
 }
 
-static struct fsnotify_mark *fsnotify_next_mark(struct fsnotify_mark *mark)
+struct fsnotify_mark *fsnotify_next_mark(struct fsnotify_mark *mark)
 {
 	struct hlist_node *node = NULL;
 
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -380,9 +380,6 @@ EXPORT_SYMBOL_GPL(fsnotify_put_mark);
  */
 static bool fsnotify_get_mark_safe(struct fsnotify_mark *mark)
 {
-	if (!mark)
-		return true;
-
 	if (refcount_inc_not_zero(&mark->refcnt)) {
 		spin_lock(&mark->lock);
 		if (mark->flags & FSNOTIFY_MARK_FLAG_ATTACHED) {
@@ -423,15 +420,22 @@ bool fsnotify_prepare_user_wait(struct f
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
@@ -820,6 +820,7 @@ static inline void fsnotify_clear_sb_mar
 }
 extern void fsnotify_get_mark(struct fsnotify_mark *mark);
 extern void fsnotify_put_mark(struct fsnotify_mark *mark);
+struct fsnotify_mark *fsnotify_next_mark(struct fsnotify_mark *mark);
 extern void fsnotify_finish_user_wait(struct fsnotify_iter_info *iter_info);
 extern bool fsnotify_prepare_user_wait(struct fsnotify_iter_info *iter_info);
 


