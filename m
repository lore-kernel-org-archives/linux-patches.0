Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241D96FE35;
	Mon,  8 Apr 2024 13:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583888; cv=none; b=Nw3tWHD/G4j7Ii3Vnf7Sjjw3JgMpJiU74iTO1IbwtQMmPACf5PwvIigZZi4MhPMXITb2VlbKB7dtZepppLsrFFl0QKZeBtMU87w9Ixm8bGogrwwuWBHSmpK2Ngz9oj8GZM4wtqdVpGC+bCbg+xaus3+wP8ze/v6Z7L5mbeWxckU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583888; c=relaxed/simple;
	bh=qrf9yYzFB0n3KFsbz0hgkGlDtTs7C7hV+XCLKXpKJtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUPAm2L+WDHOh/kU9caYnzuIZXGjqiSk3HL9g1hetLjmUtj54IzbXdpeT7VgPVosiyMjS7AYbhKSy7EfSPhMN0wHqFrOx367LGBUyDGk37xWykVRAZbtmR1kFpx6XxRtgAVhY4m0Hkhn3eCOFvXdm96EqlsKnu/n6LhYMNqnH1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=szsEdFji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="szsEdFji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16ACC433C7;
	Mon,  8 Apr 2024 13:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583888;
	bh=qrf9yYzFB0n3KFsbz0hgkGlDtTs7C7hV+XCLKXpKJtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=szsEdFjim+cR8s9skKAoODpM5WiKKZhOOr5majwBYBLZhkgITwEvgUSCONwpJOVp0
	 AwbeHLE/vDQs2i35PwY/1j3wlXfCtXm4VAzDCygkPtfgBdrP7zx8rx0dAjI/qxw0zx
	 JapAQUkD0YOr9oiLvmjj8VDJcRR8JahlckH5sk1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 299/690] fanotify: factor out helper fanotify_mark_update_flags()
Date: Mon,  8 Apr 2024 14:52:45 +0200
Message-ID: <20240408125410.434725905@linuxfoundation.org>
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

[ Upstream commit 8998d110835e3781ccd3f1ae061a590b4aaba911 ]

Handle FAN_MARK_IGNORED_SURV_MODIFY flag change in a helper that
is called after updating the mark mask.

Replace the added and removed return values and help variables with
bool recalc return values and help variable, which makes the code a
bit easier to follow.

Rename flags argument to fan_flags to emphasize the difference from
mark->flags.

Link: https://lore.kernel.org/r/20220422120327.3459282-14-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fanotify/fanotify_user.c | 47 ++++++++++++++++--------------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index f23326be0d371..0ea0047c6340a 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1077,42 +1077,45 @@ static int fanotify_remove_inode_mark(struct fsnotify_group *group,
 				    flags, umask);
 }
 
-static void fanotify_mark_add_ignored_mask(struct fsnotify_mark *fsn_mark,
-					   __u32 mask, unsigned int flags,
-					   __u32 *removed)
+static bool fanotify_mark_update_flags(struct fsnotify_mark *fsn_mark,
+				       unsigned int fan_flags)
 {
-	fsn_mark->ignored_mask |= mask;
+	bool recalc = false;
 
 	/*
 	 * Setting FAN_MARK_IGNORED_SURV_MODIFY for the first time may lead to
 	 * the removal of the FS_MODIFY bit in calculated mask if it was set
 	 * because of an ignored mask that is now going to survive FS_MODIFY.
 	 */
-	if ((flags & FAN_MARK_IGNORED_SURV_MODIFY) &&
+	if ((fan_flags & FAN_MARK_IGNORED_MASK) &&
+	    (fan_flags & FAN_MARK_IGNORED_SURV_MODIFY) &&
 	    !(fsn_mark->flags & FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY)) {
 		fsn_mark->flags |= FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY;
 		if (!(fsn_mark->mask & FS_MODIFY))
-			*removed = FS_MODIFY;
+			recalc = true;
 	}
+
+	return recalc;
 }
 
-static __u32 fanotify_mark_add_to_mask(struct fsnotify_mark *fsn_mark,
-				       __u32 mask, unsigned int flags,
-				       __u32 *removed)
+static bool fanotify_mark_add_to_mask(struct fsnotify_mark *fsn_mark,
+				      __u32 mask, unsigned int fan_flags)
 {
-	__u32 oldmask, newmask;
+	bool recalc;
 
 	spin_lock(&fsn_mark->lock);
-	oldmask = fsnotify_calc_mask(fsn_mark);
-	if (!(flags & FAN_MARK_IGNORED_MASK)) {
+	if (!(fan_flags & FAN_MARK_IGNORED_MASK))
 		fsn_mark->mask |= mask;
-	} else {
-		fanotify_mark_add_ignored_mask(fsn_mark, mask, flags, removed);
-	}
-	newmask = fsnotify_calc_mask(fsn_mark);
+	else
+		fsn_mark->ignored_mask |= mask;
+
+	recalc = fsnotify_calc_mask(fsn_mark) &
+		~fsnotify_conn_mask(fsn_mark->connector);
+
+	recalc |= fanotify_mark_update_flags(fsn_mark, fan_flags);
 	spin_unlock(&fsn_mark->lock);
 
-	return newmask & ~oldmask;
+	return recalc;
 }
 
 static struct fsnotify_mark *fanotify_add_new_mark(struct fsnotify_group *group,
@@ -1166,11 +1169,11 @@ static int fanotify_group_init_error_pool(struct fsnotify_group *group)
 
 static int fanotify_add_mark(struct fsnotify_group *group,
 			     fsnotify_connp_t *connp, unsigned int obj_type,
-			     __u32 mask, unsigned int flags,
+			     __u32 mask, unsigned int fan_flags,
 			     __kernel_fsid_t *fsid)
 {
 	struct fsnotify_mark *fsn_mark;
-	__u32 added, removed = 0;
+	bool recalc;
 	int ret = 0;
 
 	mutex_lock(&group->mark_mutex);
@@ -1187,14 +1190,14 @@ static int fanotify_add_mark(struct fsnotify_group *group,
 	 * Error events are pre-allocated per group, only if strictly
 	 * needed (i.e. FAN_FS_ERROR was requested).
 	 */
-	if (!(flags & FAN_MARK_IGNORED_MASK) && (mask & FAN_FS_ERROR)) {
+	if (!(fan_flags & FAN_MARK_IGNORED_MASK) && (mask & FAN_FS_ERROR)) {
 		ret = fanotify_group_init_error_pool(group);
 		if (ret)
 			goto out;
 	}
 
-	added = fanotify_mark_add_to_mask(fsn_mark, mask, flags, &removed);
-	if (removed || (added & ~fsnotify_conn_mask(fsn_mark->connector)))
+	recalc = fanotify_mark_add_to_mask(fsn_mark, mask, fan_flags);
+	if (recalc)
 		fsnotify_recalc_mask(fsn_mark->connector);
 
 out:
-- 
2.43.0



