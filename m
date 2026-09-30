Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A045187D1;
	Wed, 30 Sep 2026 17:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788062; cv=none; b=DeHGrfHBKat6bILAHdetdzi+eBleD+LSrtoM8VMihsSnfLY+CzDRLS8VWl+sZ4CE84d018KhikqxpsBVTtk2pn2EMKXYNW/jSMA7o1TplzlXlhU3DWsXGEbV4KDK1ZimtdJ4NRN43LnyPqz3RMAY5ggvxxKAJt1h6FvkBC5YTIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788062; c=relaxed/simple;
	bh=cTfa+HQn81Fcw2Mp9/uK2WvAEF5g2jSoTauu10Cx/ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c6IMGe7eU/XFrUH3HZ2iuCdhA4UYmRnQUyzP/4mbRUvSCQJz5HxGzuZJRSHhhS6oSsNXsdrtMYQPIXqQ2qQ9X0LVLd3M3Sr9I9Pv3ymhxwvFqIXooPbVBYrkl1DRDW2SFYXNklh6lgEtv/dtiGxIABa6JMv0qMqUQ8l9sHwfWfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ek2jdL8G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ek2jdL8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 639081F000FF;
	Wed, 30 Sep 2026 17:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788060;
	bh=RntDzTRco0lKxwSFkkwpYkqWLHJT1c+CQqFSLkw+FJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ek2jdL8GH78btLm68RaGoCrn1tDCJ2unTuvp74lpiU+7r7dCCVDh0ojVCMEZuA8e2
	 sH9Vcd5L2KJIxpzch20R7aVM7r/ON0L9Kxyu5mNuR8LGDzS634okg53a7sL5qArSBL
	 M30DHuop+/f4qQkdPSk/Gy9h8cuDh38mOODbfnps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 443/457] super: take lock after last reference count
Date: Wed, 30 Sep 2026 17:29:08 +0200
Message-ID: <20260930152355.561332440@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 9c486f28994fdfc1a83f5f60129402cf4379957b ]

__put_super() required the caller to hold sb_lock, so put_super()
wrapped it. The per-device superblock table introduced later drops its
passive references from contexts that do not hold sb_lock, so make
put_super() self-locking: drop the count first and take sb_lock only for
the final list_del.

With the count now dropped outside sb_lock a superblock can briefly sit
on @super_blocks with s_passive == 0 before it is unlinked, so the list
walkers (__iterate_supers(), iterate_supers_type(), user_get_super())
switch to refcount_inc_not_zero() and skip it.

Link: https://patch.msgid.link/20260616-work-super-bdev_holder_global-v2-3-7df6b864028e@kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: 2d2a2d7aa987 ("super: make iterate_supers_type() deletion-safe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/super.c |   63 +++++++++++++++++++++++++++----------------------------------
 1 file changed, 28 insertions(+), 35 deletions(-)

--- a/fs/super.c
+++ b/fs/super.c
@@ -404,12 +404,17 @@ fail:
 /* Superblock refcounting  */
 
 /*
- * Drop a superblock's refcount.  The caller must hold sb_lock.
+ * Drop a superblock's passive reference.  Must be called WITHOUT sb_lock held;
+ * put_super() acquires sb_lock itself when the final reference is dropped.
  */
-static void __put_super(struct super_block *s)
+void put_super(struct super_block *s)
 {
 	if (refcount_dec_and_test(&s->s_passive)) {
+
+		spin_lock(&sb_lock);
 		list_del_init(&s->s_list);
+		spin_unlock(&sb_lock);
+
 		WARN_ON(s->s_dentry_lru.node);
 		WARN_ON(s->s_inode_lru.node);
 		WARN_ON(s->s_mounts);
@@ -417,20 +422,6 @@ static void __put_super(struct super_blo
 	}
 }
 
-/**
- *	put_super	-	drop a temporary reference to superblock
- *	@sb: superblock in question
- *
- *	Drops a temporary reference, frees superblock if there's no
- *	references left.
- */
-void put_super(struct super_block *sb)
-{
-	spin_lock(&sb_lock);
-	__put_super(sb);
-	spin_unlock(&sb_lock);
-}
-
 static void kill_super_notify(struct super_block *sb)
 {
 	lockdep_assert_not_held(&sb->s_umount);
@@ -479,11 +470,7 @@ void deactivate_locked_super(struct supe
 
 		kill_super_notify(s);
 
-		/*
-		 * Since list_lru_destroy() may sleep, we cannot call it from
-		 * put_super(), where we hold the sb_lock. Therefore we destroy
-		 * the lru lists right now.
-		 */
+		/* list_lru_destroy() may sleep; put_super() callers may not. */
 		list_lru_destroy(&s->s_dentry_lru);
 		list_lru_destroy(&s->s_inode_lru);
 
@@ -852,14 +839,17 @@ static void __iterate_supers(void (*f)(s
 	struct super_block *sb, *p = NULL;
 	bool excl = flags & SUPER_ITER_EXCL;
 
-	guard(spinlock)(&sb_lock);
+	spin_lock(&sb_lock);
 
 	for (sb = first_super(flags);
 	     !list_entry_is_head(sb, &super_blocks, s_list);
 	     sb = next_super(sb, flags)) {
 		if (super_flags(sb, SB_DYING))
 			continue;
-		refcount_inc(&sb->s_passive);
+
+		if (!refcount_inc_not_zero(&sb->s_passive))
+			continue;
+
 		spin_unlock(&sb_lock);
 
 		if (flags & SUPER_ITER_UNLOCKED) {
@@ -869,13 +859,14 @@ static void __iterate_supers(void (*f)(s
 			super_unlock(sb, excl);
 		}
 
-		spin_lock(&sb_lock);
 		if (p)
-			__put_super(p);
+			put_super(p);
 		p = sb;
+		spin_lock(&sb_lock);
 	}
+	spin_unlock(&sb_lock);
 	if (p)
-		__put_super(p);
+		put_super(p);
 }
 
 void iterate_supers(void (*f)(struct super_block *, void *), void *arg)
@@ -904,7 +895,9 @@ void iterate_supers_type(struct file_sys
 		if (super_flags(sb, SB_DYING))
 			continue;
 
-		refcount_inc(&sb->s_passive);
+		if (!refcount_inc_not_zero(&sb->s_passive))
+			continue;
+
 		spin_unlock(&sb_lock);
 
 		locked = super_lock_shared(sb);
@@ -913,14 +906,14 @@ void iterate_supers_type(struct file_sys
 			super_unlock_shared(sb);
 		}
 
-		spin_lock(&sb_lock);
 		if (p)
-			__put_super(p);
+			put_super(p);
 		p = sb;
+		spin_lock(&sb_lock);
 	}
-	if (p)
-		__put_super(p);
 	spin_unlock(&sb_lock);
+	if (p)
+		put_super(p);
 }
 
 EXPORT_SYMBOL(iterate_supers_type);
@@ -936,15 +929,17 @@ struct super_block *user_get_super(dev_t
 		if (sb->s_dev != dev)
 			continue;
 
-		refcount_inc(&sb->s_passive);
+		if (!refcount_inc_not_zero(&sb->s_passive))
+			continue;
+
 		spin_unlock(&sb_lock);
 
 		locked = super_lock(sb, excl);
 		if (locked)
 			return sb;
 
+		put_super(sb);
 		spin_lock(&sb_lock);
-		__put_super(sb);
 		break;
 	}
 	spin_unlock(&sb_lock);
@@ -1375,9 +1370,7 @@ static struct super_block *bdev_super_lo
 	lockdep_assert_not_held(&bdev->bd_disk->open_mutex);
 
 	/* Make sure sb doesn't go away from under us */
-	spin_lock(&sb_lock);
 	refcount_inc(&sb->s_passive);
-	spin_unlock(&sb_lock);
 
 	mutex_unlock(&bdev->bd_holder_lock);
 


