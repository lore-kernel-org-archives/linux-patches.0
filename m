Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84081581F6;
	Tue, 18 Jun 2024 13:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716012; cv=none; b=g80JqSlRx2L6tMs41B6OzH5jqWETweE9CMhiNbpJH2UESThMXNOCgwuCbDDX80zA/FiTMixvUmzueY/tiOwdJ5SnylB+a5ApGuFwHMxJaDEtvlwh2+HhM5XuVEq5t9kti0aU5cFFLFqQ/0FwZejXRjZHESumWVvTJpi+FUfMOxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716012; c=relaxed/simple;
	bh=x2eH0RTlo+T7nVF2LjP7z2jmsnZBrSO09ouIg21seWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDw23LWRtiM4e4vpgY06HAklOsjFlOASjev34u3f+IRJ0h5V+z8rA+rKFlh0Me0Xtr/YbmbEn26bm3h9RAm4TPAV7STQx+EWKW2nr45Z3aCF7AJa0zgI3ayuFVnCh1PGpH1oIiEUQ4U9KOanXpOZ29IM8eEKaOqDMf3S+hwg4Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gl8fj64K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gl8fj64K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71505C32786;
	Tue, 18 Jun 2024 13:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716011;
	bh=x2eH0RTlo+T7nVF2LjP7z2jmsnZBrSO09ouIg21seWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gl8fj64Khjp4LEggxgSL23UR/x2YPwJo5foBjz1WUFV7kiWFpctcCcfl8Yf1MAWTl
	 q+sFYoa5+qneEY4awOKvtsW9NB3+uO2kQ/PGm553X/UdwLw4yg7PipICRE8TdK74n5
	 CEnbUmrUOvzBkAbW4N1t/b0/mW7w1Vz0QC9YzgW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 502/770] fanotify: factor out helper fanotify_mark_update_flags()
Date: Tue, 18 Jun 2024 14:35:55 +0200
Message-ID: <20240618123426.693108796@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify_user.c | 47 ++++++++++++++++--------------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 731bd7f64e018..f0206e3d11a75 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1069,42 +1069,45 @@ static int fanotify_remove_inode_mark(struct fsnotify_group *group,
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
@@ -1158,11 +1161,11 @@ static int fanotify_group_init_error_pool(struct fsnotify_group *group)
 
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
@@ -1179,14 +1182,14 @@ static int fanotify_add_mark(struct fsnotify_group *group,
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



