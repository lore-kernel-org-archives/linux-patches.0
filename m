Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83573955C2;
	Tue, 12 May 2026 17:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608631; cv=none; b=uZvod/Mg23Fr+GAcF737Mj+rqgU60Ig52jVX1H83L32nuB0Ibi7S/jVIgYMhOvS7n+mX7XYaeLVkbSRhvpVOfbyBMZ2EdS70Xlbt+79eabl++1C/J169OqqVFrR3GGHGOY07ogfMgF1VDZqcNzuXBx+koTApEpTTdqCrL3RAYrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608631; c=relaxed/simple;
	bh=sGhdikC90yAauXZVLWT6Xdzfe3Yf75gElLAt05qZXl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AcgHUhjEr++rlzFkUnyx771PKaytmSsYz9B7SecCY7T9NU//nrcfZ66A3MpL539DIZdR18GVY+B0sAzcoCcpjHVaP5GwofHO0QsKXuby0HQ591Fxw1WAIKXquIND4QIsgiRwWbkT83sMANkTWNbBsqqEn4z+W9mpmEWuOwJjqIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xIGifl+P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xIGifl+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC5CC2BCB0;
	Tue, 12 May 2026 17:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608631;
	bh=sGhdikC90yAauXZVLWT6Xdzfe3Yf75gElLAt05qZXl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xIGifl+P2yUXBLo3ASmXX9LZFN7hv3oLcY+4QIbVG+MI8UhKLfgYSt9x6exutnv+v
	 UXFqz+VMMJe6UsMy9lS/FPuFVCLNpi4xeE4XXeSAMmjOu4HFZFhUZGR7KK6nPl42fK
	 U65AisugAv21AinjTNA4GsAqu2z/P9IXFivCGoSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 153/270] eventfs: Hold eventfs_mutex and SRCU when remount walks events
Date: Tue, 12 May 2026 19:39:14 +0200
Message-ID: <20260512173941.670563056@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit 07004a8c4b572171934390148ee48c4175c77eed upstream.

Commit 340f0c7067a9 ("eventfs: Update all the eventfs_inodes from the
events descriptor") had eventfs_set_attrs() recurse through ei->children
on remount.  The walk only holds the rcu_read_lock() taken by
tracefs_apply_options() over tracefs_inodes, which is wrong:

  - list_for_each_entry over ei->children races with the list_del_rcu()
    in eventfs_remove_rec() -- LIST_POISON1 deref, same shape as
    d2603279c7d6.
  - eventfs_inodes are freed via call_srcu(&eventfs_srcu, ...).
    rcu_read_lock() does not extend an SRCU grace period, so ti->private
    can be reclaimed under the walk.
  - The writes to ei->attr race with eventfs_set_attr(), which holds
    eventfs_mutex.

Reproducer:

  while :; do mount -o remount,uid=$((RANDOM%1000)) /sys/kernel/tracing; done &
  while :; do
      echo "p:kp submit_bio" > /sys/kernel/tracing/kprobe_events
      echo > /sys/kernel/tracing/kprobe_events
  done

Wrap the events portion of tracefs_apply_options() in
eventfs_remount_lock()/_unlock() that take eventfs_mutex and
srcu_read_lock(&eventfs_srcu).  eventfs_set_attrs() doesn't sleep so the
nested rcu_read_lock() is fine; lockdep_assert_held() pins the contract.

Comment in tracefs_drop_inode() said "RCU cycle" -- it is SRCU.

Fixes: 340f0c7067a9 ("eventfs: Update all the eventfs_inodes from the events descriptor")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260418191737.10289-1-devnexen@gmail.com
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   14 ++++++++++++++
 fs/tracefs/inode.c       |    5 ++++-
 fs/tracefs/internal.h    |    3 +++
 3 files changed, 21 insertions(+), 1 deletion(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -250,6 +250,8 @@ static void eventfs_set_attrs(struct eve
 {
 	struct eventfs_inode *ei_child;
 
+	lockdep_assert_held(&eventfs_mutex);
+
 	/* Update events/<system>/<event> */
 	if (WARN_ON_ONCE(level > 3))
 		return;
@@ -912,3 +914,15 @@ void eventfs_remove_events_dir(struct ev
 	d_invalidate(dentry);
 	dput(dentry);
 }
+
+int eventfs_remount_lock(void)
+{
+	mutex_lock(&eventfs_mutex);
+	return srcu_read_lock(&eventfs_srcu);
+}
+
+void eventfs_remount_unlock(int srcu_idx)
+{
+	srcu_read_unlock(&eventfs_srcu, srcu_idx);
+	mutex_unlock(&eventfs_mutex);
+}
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -336,6 +336,7 @@ static int tracefs_apply_options(struct
 	struct inode *inode = d_inode(sb->s_root);
 	struct tracefs_inode *ti;
 	bool update_uid, update_gid;
+	int srcu_idx;
 	umode_t tmp_mode;
 
 	/*
@@ -360,6 +361,7 @@ static int tracefs_apply_options(struct
 		update_uid = fsi->opts & BIT(Opt_uid);
 		update_gid = fsi->opts & BIT(Opt_gid);
 
+		srcu_idx = eventfs_remount_lock();
 		rcu_read_lock();
 		list_for_each_entry_rcu(ti, &tracefs_inodes, list) {
 			if (update_uid) {
@@ -381,6 +383,7 @@ static int tracefs_apply_options(struct
 				eventfs_remount(ti, update_uid, update_gid);
 		}
 		rcu_read_unlock();
+		eventfs_remount_unlock(srcu_idx);
 	}
 
 	return 0;
@@ -426,7 +429,7 @@ static int tracefs_drop_inode(struct ino
 	 * This inode is being freed and cannot be used for
 	 * eventfs. Clear the flag so that it doesn't call into
 	 * eventfs during the remount flag updates. The eventfs_inode
-	 * gets freed after an RCU cycle, so the content will still
+	 * gets freed after an SRCU cycle, so the content will still
 	 * be safe if the iteration is going on now.
 	 */
 	ti->flags &= ~TRACEFS_EVENT_INODE;
--- a/fs/tracefs/internal.h
+++ b/fs/tracefs/internal.h
@@ -76,4 +76,7 @@ struct inode *tracefs_get_inode(struct s
 void eventfs_remount(struct tracefs_inode *ti, bool update_uid, bool update_gid);
 void eventfs_d_release(struct dentry *dentry);
 
+int eventfs_remount_lock(void);
+void eventfs_remount_unlock(int srcu_idx);
+
 #endif /* _TRACEFS_INTERNAL_H */


