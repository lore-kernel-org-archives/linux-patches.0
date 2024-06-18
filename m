Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55F219E81E;
	Tue, 18 Jun 2024 13:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716027; cv=none; b=bAV5tlQ56Vk0TQvjP0ss5u4c46O5GLQDrcKzSNjt3s/1/ydGmmtF1XNNkY58xNACD4KRAogKr+H2IJ9F9a0SERHF1yedLNQFj565QaxijN/EcZ6oO4374ZZaQk+n7JuGvo4Pj3eWFhNYuqHD9jMmhIVPvNseYgjsGi/dO8aYhGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716027; c=relaxed/simple;
	bh=Tcm4YDUqJvEC5KXdwSjsRpluQt9vMI+CSbkPuMyyuCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nC3d0JpU1DY3OsGxIw9hUD2/Z3r5aZogVIzDscT0ahdVI5hDIWL87tyCJBjaEMj/HDqUy0WzIDoRZ9KLRZ0NbwAqpcHhJGiLtqlnRyQhqBV3vPND+haj4T6jk/73LkHz3ufwWRZAc1dbwnJjBq/Yh2ypbMrzerjHNigUu8glhWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zz+vSYlg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zz+vSYlg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23004C3277B;
	Tue, 18 Jun 2024 13:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716026;
	bh=Tcm4YDUqJvEC5KXdwSjsRpluQt9vMI+CSbkPuMyyuCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zz+vSYlgE3ivMhRrfwmhm3CCosHLmkayKRz+FAf9hEpisALeygxZkDZlKvJI2YPLk
	 0aP/Uk7r/MCZ1m9uq27J+fC5Y0PPZKsJX+4/uXgspztNWcgd1Ukbv7LEjFYEwNf10H
	 M8cAq3NvcT+aYhO0QjmKomtWIdsk6eXpAcwK5wzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 507/770] fsnotify: consistent behavior for parent not watching children
Date: Tue, 18 Jun 2024 14:36:00 +0200
Message-ID: <20240618123426.882968866@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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



