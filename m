Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905B3745D6;
	Mon,  8 Apr 2024 13:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583934; cv=none; b=a27z0wnsr05cjrU1j8bquHazJT655HlleRqYGUbQzyIt8nIiG80PgbQ2Rl4SuXYWUkgc0ynVwhjN6d8WQ35Cc+ciUoMaJEZ830MUZ1qMCx9uFeqvfG+AL33Hk/VHTdG98u6khvid/HRSBoQj31K47r4octrB40LdLbDZ4qREIZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583934; c=relaxed/simple;
	bh=gwy070tA5wVQT10/J5O3LA/YFdkYho1vop4u8twhLfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9bVYoGix7rDTSbOOlJjQxpxDu2g4BuVHjrPEEj99e7DFvflWPlaQoKc4beP8ThaKY9+2xmasTG+ARQhqy0WP9/FG2JrcWUUdJ9ouctyxoGs9R8Z87k2aJWoAuf9d9Ijw5R2bCaSf4BmFb6RVF4mGohDjL3yWg+XLGpAwZJ+RDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nF9Jqa0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nF9Jqa0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19310C433C7;
	Mon,  8 Apr 2024 13:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583934;
	bh=gwy070tA5wVQT10/J5O3LA/YFdkYho1vop4u8twhLfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nF9Jqa0U7OdgVfLZN4/6QNMIP+4dUCRKz45OB0vO7crbomdScH/ZLdFpLxKGACJ01
	 nQHSWcJ4fKYqpH4zpExLrQYPUBltvJ2yLMMhh1Ovw+JVCvjh4RKEMGBhe1B8OIwh+p
	 zj8skcvZhaUH/S/CleqUo63ZXJ6qQMUCNfGeFltM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 304/690] fsnotify: consistent behavior for parent not watching children
Date: Mon,  8 Apr 2024 14:52:50 +0200
Message-ID: <20240408125410.613172862@linuxfoundation.org>
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

[ Upstream commit e730558adffb88a52e562db089e969ee9510184a ]

The logic for handling events on child in groups that have a mark on
the parent inode, but without FS_EVENT_ON_CHILD flag in the mask is
duplicated in several places and inconsistent.

Move the logic into the preparation of mark type iterator, so that the
parent mark type will be excluded from all mark type iterations in that
case.

This results in several subtle changes of behavior, hopefully all
desired changes of behavior, for example:

- Group A has a mount mark with FS_MODIFY in mask
- Group A has a mark with ignore mask that does not survive FS_MODIFY
  and does not watch children on directory D.
- Group B has a mark with FS_MODIFY in mask that does watch children
  on directory D.
- FS_MODIFY event on file D/foo should not clear the ignore mask of
  group A, but before this change it does

And if group A ignore mask was set to survive FS_MODIFY:
- FS_MODIFY event on file D/foo should be reported to group A on account
  of the mount mark, but before this change it is wrongly ignored

Fixes: 2f02fd3fa13e ("fanotify: fix ignore mask logic for events on child and on dir")
Reported-by: Jan Kara <jack@suse.com>
Link: https://lore.kernel.org/linux-fsdevel/20220314113337.j7slrb5srxukztje@quack3.lan/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220511190213.831646-3-amir73il@gmail.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fanotify/fanotify.c | 10 +---------
 fs/notify/fsnotify.c          | 34 +++++++++++++++++++---------------
 2 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 263d303d8f8f1..4f897e1095470 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -320,7 +320,7 @@ static u32 fanotify_group_event_mask(struct fsnotify_group *group,
 	}
 
 	fsnotify_foreach_iter_mark_type(iter_info, mark, type) {
-		/* Apply ignore mask regardless of ISDIR and ON_CHILD flags */
+		/* Apply ignore mask regardless of mark's ISDIR flag */
 		marks_ignored_mask |= mark->ignored_mask;
 
 		/*
@@ -330,14 +330,6 @@ static u32 fanotify_group_event_mask(struct fsnotify_group *group,
 		if (event_mask & FS_ISDIR && !(mark->mask & FS_ISDIR))
 			continue;
 
-		/*
-		 * If the event is on a child and this mark is on a parent not
-		 * watching children, don't send it!
-		 */
-		if (type == FSNOTIFY_ITER_TYPE_PARENT &&
-		    !(mark->mask & FS_EVENT_ON_CHILD))
-			continue;
-
 		marks_mask |= mark->mask;
 
 		/* Record the mark types of this group that matched the event */
diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 35740a64ee453..0b3e74935cb4f 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -290,22 +290,15 @@ static int fsnotify_handle_event(struct fsnotify_group *group, __u32 mask,
 	}
 
 	if (parent_mark) {
-		/*
-		 * parent_mark indicates that the parent inode is watching
-		 * children and interested in this event, which is an event
-		 * possible on child. But is *this mark* watching children and
-		 * interested in this event?
-		 */
-		if (parent_mark->mask & FS_EVENT_ON_CHILD) {
-			ret = fsnotify_handle_inode_event(group, parent_mark, mask,
-							  data, data_type, dir, name, 0);
-			if (ret)
-				return ret;
-		}
-		if (!inode_mark)
-			return 0;
+		ret = fsnotify_handle_inode_event(group, parent_mark, mask,
+						  data, data_type, dir, name, 0);
+		if (ret)
+			return ret;
 	}
 
+	if (!inode_mark)
+		return 0;
+
 	if (mask & FS_EVENT_ON_CHILD) {
 		/*
 		 * Some events can be sent on both parent dir and child marks
@@ -422,8 +415,19 @@ static bool fsnotify_iter_select_report_types(
 	iter_info->report_mask = 0;
 	fsnotify_foreach_iter_type(type) {
 		mark = iter_info->marks[type];
-		if (mark && mark->group == iter_info->current_group)
+		if (mark && mark->group == iter_info->current_group) {
+			/*
+			 * FSNOTIFY_ITER_TYPE_PARENT indicates that this inode
+			 * is watching children and interested in this event,
+			 * which is an event possible on child.
+			 * But is *this mark* watching children?
+			 */
+			if (type == FSNOTIFY_ITER_TYPE_PARENT &&
+			    !(mark->mask & FS_EVENT_ON_CHILD))
+				continue;
+
 			fsnotify_iter_set_report_type(iter_info, type);
+		}
 	}
 
 	return true;
-- 
2.43.0



