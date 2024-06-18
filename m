Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F02515820C;
	Tue, 18 Jun 2024 13:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716056; cv=none; b=Mm8ODc+Wq/S338mQsPcoo3tEbfGjAKwR8XrLOb0GvKwQFh6KGpGU7WoM2KA6ia8uuM4jW1EpvsAb7HXCESUlx4m74+du1GWJYhVm1TPzgGdby5HedgVdyfhnYmF85ZZyiySioDpaChL5d1GzVvJYyVagWCMsg7lCWB+BU7Cm1cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716056; c=relaxed/simple;
	bh=J6/1/yhAqh9huVPUQEY92Cf4GWogc6xJhog6NcjTzB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZxyGZQpEeFEAPgSRRCRd8JHhG9Blld/008nmXnQ8di9Q0dTpmZTLZfgSjxNoMRE/offOm1bdL0y5S1G1C6rFAQJ9R7uk7GR+GsgUNynej6ECVaFJpSID4bYb2wYjgh3hPWz8xKhqvd9AOi+CK3+s+a0jKgs5/zrZc2mlqHhu3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2L6M8mC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2L6M8mC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B316C3277B;
	Tue, 18 Jun 2024 13:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716056;
	bh=J6/1/yhAqh9huVPUQEY92Cf4GWogc6xJhog6NcjTzB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2L6M8mCuI89zTgl7EFUDzmvwbVUA/Tln4BHUt56wlEEzVzvvpgiYt0Ub2wEp/fHm
	 CkSae/d8V1bh8QSDjp/geOFN2ruP8ZkuqEYXDPGn7C3ZaMn7KKP6XjCdGv72k2jr92
	 RMdjg+7w9d4PQEbyBjk/dwg2j3wnxCm233voHbeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 486/770] fsnotify: optimize FS_MODIFY events with no ignored masks
Date: Tue, 18 Jun 2024 14:35:39 +0200
Message-ID: <20240618123426.076634198@linuxfoundation.org>
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

[ Upstream commit 04e317ba72d07901b03399b3d1525e83424df5b3 ]

fsnotify() treats FS_MODIFY events specially - it does not skip them
even if the FS_MODIFY event does not apear in the object's fsnotify
mask.  This is because send_to_group() checks if FS_MODIFY needs to
clear ignored mask of marks.

The common case is that an object does not have any mark with ignored
mask and in particular, that it does not have a mark with ignored mask
and without the FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY flag.

Set FS_MODIFY in object's fsnotify mask during fsnotify_recalc_mask()
if object has a mark with an ignored mask and without the
FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY flag and remove the special
treatment of FS_MODIFY in fsnotify(), so that FS_MODIFY events could
be optimized in the common case.

Call fsnotify_recalc_mask() from fanotify after adding or removing an
ignored mask from a mark without FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY
or when adding the FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY flag to a mark
with ignored mask (the flag cannot be removed by fanotify uapi).

Performance results for doing 10000000 write(2)s to tmpfs:

				vanilla		patched
without notification mark	25.486+-1.054	24.965+-0.244
with notification mark		30.111+-0.139	26.891+-1.355

So we can see the overhead of notification subsystem has been
drastically reduced.

Link: https://lore.kernel.org/r/20220223151438.790268-3-amir73il@gmail.com
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify_user.c | 32 +++++++++++++++++++++++-------
 fs/notify/fsnotify.c               |  8 +++++---
 include/linux/fsnotify_backend.h   |  4 ++++
 3 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 12fb209e60419..64abec874d8e3 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1069,8 +1069,28 @@ static int fanotify_remove_inode_mark(struct fsnotify_group *group,
 				    flags, umask);
 }
 
+static void fanotify_mark_add_ignored_mask(struct fsnotify_mark *fsn_mark,
+					   __u32 mask, unsigned int flags,
+					   __u32 *removed)
+{
+	fsn_mark->ignored_mask |= mask;
+
+	/*
+	 * Setting FAN_MARK_IGNORED_SURV_MODIFY for the first time may lead to
+	 * the removal of the FS_MODIFY bit in calculated mask if it was set
+	 * because of an ignored mask that is now going to survive FS_MODIFY.
+	 */
+	if ((flags & FAN_MARK_IGNORED_SURV_MODIFY) &&
+	    !(fsn_mark->flags & FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY)) {
+		fsn_mark->flags |= FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY;
+		if (!(fsn_mark->mask & FS_MODIFY))
+			*removed = FS_MODIFY;
+	}
+}
+
 static __u32 fanotify_mark_add_to_mask(struct fsnotify_mark *fsn_mark,
-				       __u32 mask, unsigned int flags)
+				       __u32 mask, unsigned int flags,
+				       __u32 *removed)
 {
 	__u32 oldmask, newmask;
 
@@ -1079,9 +1099,7 @@ static __u32 fanotify_mark_add_to_mask(struct fsnotify_mark *fsn_mark,
 	if (!(flags & FAN_MARK_IGNORED_MASK)) {
 		fsn_mark->mask |= mask;
 	} else {
-		fsn_mark->ignored_mask |= mask;
-		if (flags & FAN_MARK_IGNORED_SURV_MODIFY)
-			fsn_mark->flags |= FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY;
+		fanotify_mark_add_ignored_mask(fsn_mark, mask, flags, removed);
 	}
 	newmask = fsnotify_calc_mask(fsn_mark);
 	spin_unlock(&fsn_mark->lock);
@@ -1144,7 +1162,7 @@ static int fanotify_add_mark(struct fsnotify_group *group,
 			     __kernel_fsid_t *fsid)
 {
 	struct fsnotify_mark *fsn_mark;
-	__u32 added;
+	__u32 added, removed = 0;
 	int ret = 0;
 
 	mutex_lock(&group->mark_mutex);
@@ -1167,8 +1185,8 @@ static int fanotify_add_mark(struct fsnotify_group *group,
 			goto out;
 	}
 
-	added = fanotify_mark_add_to_mask(fsn_mark, mask, flags);
-	if (added & ~fsnotify_conn_mask(fsn_mark->connector))
+	added = fanotify_mark_add_to_mask(fsn_mark, mask, flags, &removed);
+	if (removed || (added & ~fsnotify_conn_mask(fsn_mark->connector)))
 		fsnotify_recalc_mask(fsn_mark->connector);
 
 out:
diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index ab81a0776ece5..494f653efbc6e 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -531,11 +531,13 @@ int fsnotify(__u32 mask, const void *data, int data_type, struct inode *dir,
 
 
 	/*
-	 * if this is a modify event we may need to clear the ignored masks
-	 * otherwise return if none of the marks care about this type of event.
+	 * If this is a modify event we may need to clear some ignored masks.
+	 * In that case, the object with ignored masks will have the FS_MODIFY
+	 * event in its mask.
+	 * Otherwise, return if none of the marks care about this type of event.
 	 */
 	test_mask = (mask & ALL_FSNOTIFY_EVENTS);
-	if (!(mask & FS_MODIFY) && !(test_mask & marks_mask))
+	if (!(test_mask & marks_mask))
 		return 0;
 
 	iter_info.srcu_idx = srcu_read_lock(&fsnotify_mark_srcu);
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 5f9c960049b07..0805b74cae441 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -609,6 +609,10 @@ static inline __u32 fsnotify_calc_mask(struct fsnotify_mark *mark)
 	if (!mark->ignored_mask)
 		return mask;
 
+	/* Interest in FS_MODIFY may be needed for clearing ignored mask */
+	if (!(mark->flags & FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY))
+		mask |= FS_MODIFY;
+
 	/*
 	 * If mark is interested in ignoring events on children, the object must
 	 * show interest in those events for fsnotify_parent() to notice it.
-- 
2.43.0



