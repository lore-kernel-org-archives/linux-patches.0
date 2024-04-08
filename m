Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F047E59F;
	Mon,  8 Apr 2024 13:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583896; cv=none; b=OBKj416G9YwhAbBKB99BLddOlJjxJE2EgjH3Mso85GiU0dGuVLSKO3CQYuKgo3+gHWALswpkntQzO3TLaptytg3BeFUTt+S/zP86JnXwrlrsjZMIbPxpaMjmIQuS8HpOCdpjioZUDyIppiQ9brFDMccczowZ/NkoJk+e8MLiZ2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583896; c=relaxed/simple;
	bh=ZhkQivp2y1t5jRBTjc+HWKf2TzTLSTO9XDt8YEGcyBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftxFh4i//SNX2GBwIsBZFvwTvc7lHG536LULQX0NCsGE6iMeNi190kN7F1Osp26CXV6I1NNwcaNVhsgpZkplUS532VTTmRxuneo9d3mfe6zlPwGxVFjry6pp1gleq5/feG+6OQTTvn5hrii0AHu4Dchaib60+plE4VWwH+Odem0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kKnCOMd6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kKnCOMd6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BDBC433F1;
	Mon,  8 Apr 2024 13:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583896;
	bh=ZhkQivp2y1t5jRBTjc+HWKf2TzTLSTO9XDt8YEGcyBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kKnCOMd6Gyx8GF1kAo6tVmRLFeX7QjJomHtFdcJawFmEb90VmwbrQ8JXDHzJaKFUC
	 uUej4rWxy3qmJqGZFAePUg5svgZR0+eaq+e4Q3Ll+P2CyQx7TgQ5oyLwYY0ohzbPrI
	 h/RPDEFK9ociWXkzg8nghBy0tIj7s+esQg3QBkuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 300/690] fanotify: implement "evictable" inode marks
Date: Mon,  8 Apr 2024 14:52:46 +0200
Message-ID: <20240408125410.465600912@linuxfoundation.org>
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

[ Upstream commit 7d5e005d982527e4029b0139823d179986e34cdc ]

When an inode mark is created with flag FAN_MARK_EVICTABLE, it will not
pin the marked inode to inode cache, so when inode is evicted from cache
due to memory pressure, the mark will be lost.

When an inode mark with flag FAN_MARK_EVICATBLE is updated without using
this flag, the marked inode is pinned to inode cache.

When an inode mark is updated with flag FAN_MARK_EVICTABLE but an
existing mark already has the inode pinned, the mark update fails with
error EEXIST.

Evictable inode marks can be used to setup inode marks with ignored mask
to suppress events from uninteresting files or directories in a lazy
manner, upon receiving the first event, without having to iterate all
the uninteresting files or directories before hand.

The evictbale inode mark feature allows performing this lazy marks setup
without exhausting the system memory with pinned inodes.

This change does not enable the feature yet.

Link: https://lore.kernel.org/linux-fsdevel/CAOQ4uxiRDpuS=2uA6+ZUM7yG9vVU-u212tkunBmSnP_u=mkv=Q@mail.gmail.com/
Link: https://lore.kernel.org/r/20220422120327.3459282-15-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fanotify/fanotify.h      |  2 ++
 fs/notify/fanotify/fanotify_user.c | 38 ++++++++++++++++++++++++++++--
 include/uapi/linux/fanotify.h      |  1 +
 3 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index 87142bc0131a4..80e0ec95b1131 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -497,6 +497,8 @@ static inline unsigned int fanotify_mark_user_flags(struct fsnotify_mark *mark)
 
 	if (mark->flags & FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY)
 		mflags |= FAN_MARK_IGNORED_SURV_MODIFY;
+	if (mark->flags & FSNOTIFY_MARK_FLAG_NO_IREF)
+		mflags |= FAN_MARK_EVICTABLE;
 
 	return mflags;
 }
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 0ea0047c6340a..9bb182dc3f9b3 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1080,6 +1080,7 @@ static int fanotify_remove_inode_mark(struct fsnotify_group *group,
 static bool fanotify_mark_update_flags(struct fsnotify_mark *fsn_mark,
 				       unsigned int fan_flags)
 {
+	bool want_iref = !(fan_flags & FAN_MARK_EVICTABLE);
 	bool recalc = false;
 
 	/*
@@ -1095,7 +1096,18 @@ static bool fanotify_mark_update_flags(struct fsnotify_mark *fsn_mark,
 			recalc = true;
 	}
 
-	return recalc;
+	if (fsn_mark->connector->type != FSNOTIFY_OBJ_TYPE_INODE ||
+	    want_iref == !(fsn_mark->flags & FSNOTIFY_MARK_FLAG_NO_IREF))
+		return recalc;
+
+	/*
+	 * NO_IREF may be removed from a mark, but not added.
+	 * When removed, fsnotify_recalc_mask() will take the inode ref.
+	 */
+	WARN_ON_ONCE(!want_iref);
+	fsn_mark->flags &= ~FSNOTIFY_MARK_FLAG_NO_IREF;
+
+	return true;
 }
 
 static bool fanotify_mark_add_to_mask(struct fsnotify_mark *fsn_mark,
@@ -1121,6 +1133,7 @@ static bool fanotify_mark_add_to_mask(struct fsnotify_mark *fsn_mark,
 static struct fsnotify_mark *fanotify_add_new_mark(struct fsnotify_group *group,
 						   fsnotify_connp_t *connp,
 						   unsigned int obj_type,
+						   unsigned int fan_flags,
 						   __kernel_fsid_t *fsid)
 {
 	struct ucounts *ucounts = group->fanotify_data.ucounts;
@@ -1143,6 +1156,9 @@ static struct fsnotify_mark *fanotify_add_new_mark(struct fsnotify_group *group,
 	}
 
 	fsnotify_init_mark(mark, group);
+	if (fan_flags & FAN_MARK_EVICTABLE)
+		mark->flags |= FSNOTIFY_MARK_FLAG_NO_IREF;
+
 	ret = fsnotify_add_mark_locked(mark, connp, obj_type, 0, fsid);
 	if (ret) {
 		fsnotify_put_mark(mark);
@@ -1179,13 +1195,23 @@ static int fanotify_add_mark(struct fsnotify_group *group,
 	mutex_lock(&group->mark_mutex);
 	fsn_mark = fsnotify_find_mark(connp, group);
 	if (!fsn_mark) {
-		fsn_mark = fanotify_add_new_mark(group, connp, obj_type, fsid);
+		fsn_mark = fanotify_add_new_mark(group, connp, obj_type,
+						 fan_flags, fsid);
 		if (IS_ERR(fsn_mark)) {
 			mutex_unlock(&group->mark_mutex);
 			return PTR_ERR(fsn_mark);
 		}
 	}
 
+	/*
+	 * Non evictable mark cannot be downgraded to evictable mark.
+	 */
+	if (fan_flags & FAN_MARK_EVICTABLE &&
+	    !(fsn_mark->flags & FSNOTIFY_MARK_FLAG_NO_IREF)) {
+		ret = -EEXIST;
+		goto out;
+	}
+
 	/*
 	 * Error events are pre-allocated per group, only if strictly
 	 * needed (i.e. FAN_FS_ERROR was requested).
@@ -1615,6 +1641,14 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
 	    mark_type != FAN_MARK_FILESYSTEM)
 		goto fput_and_out;
 
+	/*
+	 * Evictable is only relevant for inode marks, because only inode object
+	 * can be evicted on memory pressure.
+	 */
+	if (flags & FAN_MARK_EVICTABLE &&
+	     mark_type != FAN_MARK_INODE)
+		goto fput_and_out;
+
 	/*
 	 * Events that do not carry enough information to report
 	 * event->fd require a group that supports reporting fid.  Those
diff --git a/include/uapi/linux/fanotify.h b/include/uapi/linux/fanotify.h
index e8ac38cc2fd6d..f1f89132d60e2 100644
--- a/include/uapi/linux/fanotify.h
+++ b/include/uapi/linux/fanotify.h
@@ -82,6 +82,7 @@
 #define FAN_MARK_IGNORED_SURV_MODIFY	0x00000040
 #define FAN_MARK_FLUSH		0x00000080
 /* FAN_MARK_FILESYSTEM is	0x00000100 */
+#define FAN_MARK_EVICTABLE	0x00000200
 
 /* These are NOT bitwise flags.  Both bits can be used togther.  */
 #define FAN_MARK_INODE		0x00000000
-- 
2.43.0



