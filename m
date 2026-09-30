Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8663850279A;
	Wed, 30 Sep 2026 18:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793842; cv=none; b=Z9EhZ3XoDnuoWKHnEtBW5l/2d/XnI8oUuqChp+YEpr+16Q2QGviE+uk26Fy5SXzivgigHuo8zsmkV03xQ8IZZvcVdkA9yjfjjXUXvuJPqulHUF9j/ElRlo2qr5Ee8r0XtxNZ7r+qUDeedrHSE24s/3OOXThXwbuiOFZ7F0E3sZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793842; c=relaxed/simple;
	bh=yBCP4Uy8RqTWjUoZV2mdPDbrCB5lNwM9aRm4g2Nf9sU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0YVLo4LEW8u5NIWFAJCNCQdb8vwy34OVMAq7Wh98k3V6pcOc54VmsOPvd4W3BRn0TdiB3inaY1xQMYxiF++j+ZCfYtQteoTxxM7YI4kryd1DdwjCk6ZYO1M/4tRlUm3+HLJ0bU15ebisWWfSD2CYb9rTESUqv1M1I8K3BY9DHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7KG0EAs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7KG0EAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA251F000FF;
	Wed, 30 Sep 2026 18:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793841;
	bh=KqR/ipp/PIUsDRKjH41+mmBPfaYLMPM+WRX4CmzQF9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e7KG0EAskoewcE9TobDX0fFKG58z5yI/xKOsCUTeaF+lkHXh3TtA95G0MLTvowhI2
	 AzFIiI0oJKd76rx5XPmt9zxnR2AlZvcTB+jVtbD6YwTbxvh3oD5JdCmExFyq7umT0M
	 moOWDxdIQefaKMsOP1DGtfq4Kx/L5siAe3YWxdqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 366/395] super: make iterate_supers_type() deletion-safe
Date: Wed, 30 Sep 2026 17:30:28 +0200
Message-ID: <20260930152348.631901136@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 2d2a2d7aa98741b58f54cacc99b52024e4d865f9 ]

iterate_supers_type() drops sb_lock while invoking the callback and keeps
only a passive reference to the current superblock. That reference keeps
the object allocated, but does not keep its s_instances node linked.

After the iterator releases s_umount, final teardown can unlink the current
s_instances node. The iterator then advances through a reinitialized node.
With the current hlist it stops without visiting the remaining superblocks.
The unlink moved from generic_shutdown_super() to kill_super_notify(), but
the cursor lifetime has been unsafe since the helper was introduced.

The CIFS DFS lookup can consequently miss a matching superblock and return
-EINVAL.

Move removal from fs_supers to put_super(), alongside removal from
super_blocks, so a passive reference keeps both list nodes linked. Keep
the filesystem module reference until then, since unlinking s_instances
may touch type->fs_supers.

Make sget_fc() skip SB_DEAD superblocks before invoking test(), and set
SB_DEAD under sb_lock to serialize with those callbacks. This allows
kernfs to free its private information after kill_anon_super() returns.
Keep matching SB_DYING superblocks until SB_DEAD is set so concurrent
mounts still wait for teardown before retrying.

Fixes: 43e15cdbefea ("new helper: iterate_supers_type()")
Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
Closes: https://lore.kernel.org/r/20260903013336.92081-1-kmehltretter@gmail.com
Suggested-by: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org
Tested-by: Karl Mehltretter <kmehltretter@gmail.com>
[kmehltretter: supplied the commit message]
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260909193034.7467-1-kmehltretter@gmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ Adapted s_passive reference counting to s_count using the existing __put_super() helper. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/kernfs/mount.c |    4 ++--
 fs/super.c        |   43 +++++++++++++++++++++++--------------------
 2 files changed, 25 insertions(+), 22 deletions(-)

--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -433,8 +433,8 @@ void kernfs_kill_sb(struct super_block *
 	up_write(&root->kernfs_supers_rwsem);
 
 	/*
-	 * Remove the superblock from fs_supers/s_instances
-	 * so we can't find it, before freeing kernfs_super_info.
+	 * Mark the superblock dead so sget_fc() can't find it,
+	 * before freeing kernfs_super_info.
 	 */
 	kill_anon_super(sb);
 	kfree(info);
--- a/fs/super.c
+++ b/fs/super.c
@@ -404,11 +404,16 @@ fail:
 static void __put_super(struct super_block *s)
 {
 	if (!--s->s_count) {
+		struct file_system_type *type = s->s_type;
+
 		list_del_init(&s->s_list);
+		hlist_del_init(&s->s_instances);
 		WARN_ON(s->s_dentry_lru.node);
 		WARN_ON(s->s_inode_lru.node);
 		WARN_ON(s->s_mounts);
 		call_rcu(&s->rcu, destroy_super_rcu);
+		/* The unlink above may touch type->fs_supers, so drop it last. */
+		put_filesystem(type);
 	}
 }
 
@@ -435,23 +440,16 @@ static void kill_super_notify(struct sup
 		return;
 
 	/*
-	 * Remove it from @fs_supers so it isn't found by new
-	 * sget{_fc}() walkers anymore. Any concurrent mounter still
-	 * managing to grab a temporary reference is guaranteed to
-	 * already see SB_DYING and will wait until we notify them about
-	 * SB_DEAD.
-	 */
-	spin_lock(&sb_lock);
-	hlist_del_init(&sb->s_instances);
-	spin_unlock(&sb_lock);
-
-	/*
 	 * Let concurrent mounts know that this thing is really dead.
-	 * We don't need @sb->s_umount here as every concurrent caller
-	 * will see SB_DYING and either discard the superblock or wait
-	 * for SB_DEAD.
+	 * sget{_fc}() skips SB_DEAD superblocks and calls test() under
+	 * sb_lock, so set it under sb_lock: once we return no test()
+	 * runs on this superblock anymore and none will start. Everyone
+	 * else already saw SB_DYING and either discarded the superblock
+	 * or waits for SB_DEAD.
 	 */
+	spin_lock(&sb_lock);
 	super_wake(sb, SB_DEAD);
+	spin_unlock(&sb_lock);
 }
 
 /**
@@ -482,7 +480,6 @@ void deactivate_locked_super(struct supe
 		list_lru_destroy(&s->s_dentry_lru);
 		list_lru_destroy(&s->s_inode_lru);
 
-		put_filesystem(fs);
 		put_super(s);
 	} else {
 		super_unlock_excl(s);
@@ -668,12 +665,12 @@ void generic_shutdown_super(struct super
 	}
 	/*
 	 * Broadcast to everyone that grabbed a temporary reference to this
-	 * superblock before we removed it from @fs_supers that the superblock
-	 * is dying. Every walker of @fs_supers outside of sget{_fc}() will now
-	 * discard this superblock and treat it as dead.
+	 * superblock that it is dying. Every walker of @fs_supers outside
+	 * of sget{_fc}() will now discard this superblock and treat it as
+	 * dead.
 	 *
-	 * We leave the superblock on @fs_supers so it can be found by
-	 * sget{_fc}() until we passed sb->kill_sb().
+	 * sget{_fc}() keeps finding the superblock until SB_DEAD is set, so
+	 * a concurrent mounter waits until we passed sb->kill_sb().
 	 */
 	super_wake(sb, SB_DYING);
 	super_unlock_excl(sb);
@@ -752,6 +749,9 @@ retry:
 	spin_lock(&sb_lock);
 	if (test) {
 		hlist_for_each_entry(old, &fc->fs_type->fs_supers, s_instances) {
+			/* Only unlinked at the last passive reference. */
+			if (super_flags(old, SB_DEAD))
+				continue;
 			if (test(old, fc))
 				goto share_extant_sb;
 		}
@@ -828,6 +828,9 @@ retry:
 	spin_lock(&sb_lock);
 	if (test) {
 		hlist_for_each_entry(old, &type->fs_supers, s_instances) {
+			/* Only unlinked at the last passive reference. */
+			if (super_flags(old, SB_DEAD))
+				continue;
 			if (!test(old, data))
 				continue;
 			if (user_ns != old->s_user_ns) {


