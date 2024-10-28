Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BF32AF07;
	Mon, 28 Oct 2024 06:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098227; cv=none; b=p9Qv7sr9gmxhO+BZbvN9lsqpLG9feqol6TopOrGBoALYEyuext1r59mwNPeHBPXoO6HocP1N3iYApTOfhnDHa1okZFRKVEtftvrBg+Uc77+9wZ//IY1907svtmsUZkwjyGvvCH/kWtHBxPYY06k+eVH1hTtKdMPI4K5vg6bJ2Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098227; c=relaxed/simple;
	bh=6spZfGpXXVuJ//jq4YMYaJ7i06lQRFjGvBGLK7Hiogg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tx8jxefwcCFCD+uJC27LHZKWOIeDD3AJfZZZ1kiVOCluzJt1eB6aRGeMNH+S7cmM835sewj6X2i+y35aUYU0L5IsCAOOTmGaYXJm7ekFap2BIFzshrokXDi30B/y9bpg8/ocx8m1pvry8uyFniDxTBBL8liVRW7HlOxw4W7Foyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AXjExNcF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AXjExNcF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB47C4CEC3;
	Mon, 28 Oct 2024 06:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098227;
	bh=6spZfGpXXVuJ//jq4YMYaJ7i06lQRFjGvBGLK7Hiogg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AXjExNcFukyI8+gv5bfwl3Py3vbblcEyvUchyj51o+UrIlpFUEfRUdxoyurgrFhRs
	 j6Yasvs4KZDjbKHTb+/JwRRqfV8C+o07OkuhT+ayla1jOaRDWE6zUxk87aubYWCEjF
	 6ljBnBjBW8Q1GARod7p6iSJcbGU2dWzrJrSxlfuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+701037856c25b143f1ad@syzkaller.appspotmail.com,
	Dmitry Vyukov <dvyukov@google.com>,
	Jan Kara <jack@suse.cz>,
	Josef Bacik <josef@toxicpanda.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 132/261] fsnotify: Avoid data race between fsnotify_recalc_mask() and fsnotify_object_watched()
Date: Mon, 28 Oct 2024 07:24:34 +0100
Message-ID: <20241028062315.351258709@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 35ceae44742e1101f9d20adadbbbd92c05d7d659 ]

When __fsnotify_recalc_mask() recomputes the mask on the watched object,
the compiler can "optimize" the code to perform partial updates to the
mask (including zeroing it at the beginning). Thus places checking
the object mask without conn->lock such as fsnotify_object_watched()
could see invalid states of the mask. Make sure the mask update is
performed by one memory store using WRITE_ONCE().

Reported-by: syzbot+701037856c25b143f1ad@syzkaller.appspotmail.com
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Link: https://lore.kernel.org/all/CACT4Y+Zk0ohwwwHSD63U2-PQ=UuamXczr1mKBD6xtj2dyYKBvA@mail.gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20240717140623.27768-1-jack@suse.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fsnotify.c             | 21 ++++++++++++---------
 fs/notify/inotify/inotify_user.c |  2 +-
 fs/notify/mark.c                 |  8 ++++++--
 3 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 272c8a1dab3c2..82ae8254c068b 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -183,8 +183,10 @@ static bool fsnotify_event_needs_parent(struct inode *inode, __u32 mnt_mask,
 	BUILD_BUG_ON(FS_EVENTS_POSS_ON_CHILD & ~FS_EVENTS_POSS_TO_PARENT);
 
 	/* Did either inode/sb/mount subscribe for events with parent/name? */
-	marks_mask |= fsnotify_parent_needed_mask(inode->i_fsnotify_mask);
-	marks_mask |= fsnotify_parent_needed_mask(inode->i_sb->s_fsnotify_mask);
+	marks_mask |= fsnotify_parent_needed_mask(
+				READ_ONCE(inode->i_fsnotify_mask));
+	marks_mask |= fsnotify_parent_needed_mask(
+				READ_ONCE(inode->i_sb->s_fsnotify_mask));
 	marks_mask |= fsnotify_parent_needed_mask(mnt_mask);
 
 	/* Did they subscribe for this event with parent/name info? */
@@ -195,8 +197,8 @@ static bool fsnotify_event_needs_parent(struct inode *inode, __u32 mnt_mask,
 static inline bool fsnotify_object_watched(struct inode *inode, __u32 mnt_mask,
 					   __u32 mask)
 {
-	__u32 marks_mask = inode->i_fsnotify_mask | mnt_mask |
-			   inode->i_sb->s_fsnotify_mask;
+	__u32 marks_mask = READ_ONCE(inode->i_fsnotify_mask) | mnt_mask |
+			   READ_ONCE(inode->i_sb->s_fsnotify_mask);
 
 	return mask & marks_mask & ALL_FSNOTIFY_EVENTS;
 }
@@ -213,7 +215,8 @@ int __fsnotify_parent(struct dentry *dentry, __u32 mask, const void *data,
 		      int data_type)
 {
 	const struct path *path = fsnotify_data_path(data, data_type);
-	__u32 mnt_mask = path ? real_mount(path->mnt)->mnt_fsnotify_mask : 0;
+	__u32 mnt_mask = path ?
+		READ_ONCE(real_mount(path->mnt)->mnt_fsnotify_mask) : 0;
 	struct inode *inode = d_inode(dentry);
 	struct dentry *parent;
 	bool parent_watched = dentry->d_flags & DCACHE_FSNOTIFY_PARENT_WATCHED;
@@ -557,13 +560,13 @@ int fsnotify(__u32 mask, const void *data, int data_type, struct inode *dir,
 	    (!inode2 || !inode2->i_fsnotify_marks))
 		return 0;
 
-	marks_mask = sb->s_fsnotify_mask;
+	marks_mask = READ_ONCE(sb->s_fsnotify_mask);
 	if (mnt)
-		marks_mask |= mnt->mnt_fsnotify_mask;
+		marks_mask |= READ_ONCE(mnt->mnt_fsnotify_mask);
 	if (inode)
-		marks_mask |= inode->i_fsnotify_mask;
+		marks_mask |= READ_ONCE(inode->i_fsnotify_mask);
 	if (inode2)
-		marks_mask |= inode2->i_fsnotify_mask;
+		marks_mask |= READ_ONCE(inode2->i_fsnotify_mask);
 
 
 	/*
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 4ffc30606e0b9..e163a4b790224 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -569,7 +569,7 @@ static int inotify_update_existing_watch(struct fsnotify_group *group,
 		/* more bits in old than in new? */
 		int dropped = (old_mask & ~new_mask);
 		/* more bits in this fsn_mark than the inode's mask? */
-		int do_inode = (new_mask & ~inode->i_fsnotify_mask);
+		int do_inode = (new_mask & ~READ_ONCE(inode->i_fsnotify_mask));
 
 		/* update the inode with this new fsn_mark */
 		if (dropped || do_inode)
diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 5e170e7130886..c45b222cf9c11 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -128,7 +128,7 @@ __u32 fsnotify_conn_mask(struct fsnotify_mark_connector *conn)
 	if (WARN_ON(!fsnotify_valid_obj_type(conn->type)))
 		return 0;
 
-	return *fsnotify_conn_mask_p(conn);
+	return READ_ONCE(*fsnotify_conn_mask_p(conn));
 }
 
 static void fsnotify_get_sb_watched_objects(struct super_block *sb)
@@ -245,7 +245,11 @@ static void *__fsnotify_recalc_mask(struct fsnotify_mark_connector *conn)
 		    !(mark->flags & FSNOTIFY_MARK_FLAG_NO_IREF))
 			want_iref = true;
 	}
-	*fsnotify_conn_mask_p(conn) = new_mask;
+	/*
+	 * We use WRITE_ONCE() to prevent silly compiler optimizations from
+	 * confusing readers not holding conn->lock with partial updates.
+	 */
+	WRITE_ONCE(*fsnotify_conn_mask_p(conn), new_mask);
 
 	return fsnotify_update_iref(conn, want_iref);
 }
-- 
2.43.0



