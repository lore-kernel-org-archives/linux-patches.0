Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73244188CC9;
	Thu, 20 Aug 2026 17:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247036; cv=none; b=TCgx9p2adYkiJBkzFgKjClcZXcu6pc3UnMllTRdEtIuW10iBgZnyiOcxj0USsfVnfgb+trpSaGvFk2x7c9urklDuGdk9cwyVq3Agq0k72zy5LbOkJxMBoqbyxVqlB50MgC75OUYcA4l4wfDV7mFSh9fwVDGnycMiuxynHi/+t2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247036; c=relaxed/simple;
	bh=e77WhaQ0Q5S9H4neT3EolUhSDq4R7VXf4huvR2C8DcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCHURGZkB4DL1//HuLA+/RhqFBroTMkUWUFTlYzPiaCNz8pfADupXPTZhKOQV0IuDITaxlC//DbFx49GotiRtGbElUdaBtF7Ix7HVw7PppvdKAjuPyQ2AJXTn2lBqOpWp7ZVdihKt+c6KVTgI+25U9/RfWvdFfbeeNTVkYc7FpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aAlyCLiN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aAlyCLiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917D11F000E9;
	Thu, 20 Aug 2026 17:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247035;
	bh=isKDKsMQuBJFNd/dPmO8GL10Ivru/5oFKdf6ZDBeTN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aAlyCLiN70zMrk9u5eHlZC0vN/HCZrqF8fm1kIFPwCM6IfFr09VOHWS2TNZrc5I6x
	 VD4JNJqgAL66qWbdPjeTEgfIkAXHXCDIfnrUyC2cZ73uIXufwqITeeLQR+M0Ot1/lV
	 YvTVThTmg1F2rGIv2h+qgBieQCTYOZTR7U6B1Jr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 126/220] super: use a common iterator (Part 1)
Date: Thu, 20 Aug 2026 16:55:16 +0200
Message-ID: <20260820145227.259095844@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 2992476528aeecbaee17ba0a6396a817481205a3 ]

Use a common iterator for all callbacks.

Link: https://lore.kernel.org/r/20250329-work-freeze-v2-4-a47af37ecc3d@kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 749d7aa0377a ("super: fix emergency thaw deadlock on frozen block devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/super.c         |   67 ++++++++++-------------------------------------------
 include/linux/fs.h |    6 +++-
 2 files changed, 18 insertions(+), 55 deletions(-)

--- a/fs/super.c
+++ b/fs/super.c
@@ -887,37 +887,7 @@ void drop_super_exclusive(struct super_b
 }
 EXPORT_SYMBOL(drop_super_exclusive);
 
-static void __iterate_supers(void (*f)(struct super_block *))
-{
-	struct super_block *sb, *p = NULL;
-
-	spin_lock(&sb_lock);
-	list_for_each_entry(sb, &super_blocks, s_list) {
-		if (super_flags(sb, SB_DYING))
-			continue;
-		sb->s_count++;
-		spin_unlock(&sb_lock);
-
-		f(sb);
-
-		spin_lock(&sb_lock);
-		if (p)
-			__put_super(p);
-		p = sb;
-	}
-	if (p)
-		__put_super(p);
-	spin_unlock(&sb_lock);
-}
-/**
- *	iterate_supers - call function for all active superblocks
- *	@f: function to call
- *	@arg: argument to pass to it
- *
- *	Scans the superblock list and calls given function, passing it
- *	locked superblock and given argument.
- */
-void iterate_supers(void (*f)(struct super_block *, void *), void *arg)
+void __iterate_supers(void (*f)(struct super_block *, void *), void *arg, bool excl)
 {
 	struct super_block *sb, *p = NULL;
 
@@ -927,14 +897,13 @@ void iterate_supers(void (*f)(struct sup
 
 		if (super_flags(sb, SB_DYING))
 			continue;
-
 		sb->s_count++;
 		spin_unlock(&sb_lock);
 
-		locked = super_lock_shared(sb);
+		locked = super_lock(sb, excl);
 		if (locked) {
 			f(sb, arg);
-			super_unlock_shared(sb);
+			super_unlock(sb, excl);
 		}
 
 		spin_lock(&sb_lock);
@@ -1110,11 +1079,9 @@ cancel_readonly:
 	return retval;
 }
 
-static void do_emergency_remount_callback(struct super_block *sb)
+static void do_emergency_remount_callback(struct super_block *sb, void *unused)
 {
-	bool locked = super_lock_excl(sb);
-
-	if (locked && sb->s_root && sb->s_bdev && !sb_rdonly(sb)) {
+	if (sb->s_bdev && !sb_rdonly(sb)) {
 		struct fs_context *fc;
 
 		fc = fs_context_for_reconfigure(sb->s_root,
@@ -1125,13 +1092,11 @@ static void do_emergency_remount_callbac
 			put_fs_context(fc);
 		}
 	}
-	if (locked)
-		super_unlock_excl(sb);
 }
 
 static void do_emergency_remount(struct work_struct *work)
 {
-	__iterate_supers(do_emergency_remount_callback);
+	__iterate_supers(do_emergency_remount_callback, NULL, true);
 	kfree(work);
 	printk("Emergency Remount complete\n");
 }
@@ -1147,24 +1112,18 @@ void emergency_remount(void)
 	}
 }
 
-static void do_thaw_all_callback(struct super_block *sb)
+static void do_thaw_all_callback(struct super_block *sb, void *unused)
 {
-	bool locked = super_lock_excl(sb);
-
-	if (locked && sb->s_root) {
-		if (IS_ENABLED(CONFIG_BLOCK))
-			while (sb->s_bdev && !bdev_thaw(sb->s_bdev))
-				pr_warn("Emergency Thaw on %pg\n", sb->s_bdev);
-		thaw_super_locked(sb, FREEZE_HOLDER_USERSPACE);
-		return;
-	}
-	if (locked)
-		super_unlock_excl(sb);
+	if (IS_ENABLED(CONFIG_BLOCK))
+		while (sb->s_bdev && !bdev_thaw(sb->s_bdev))
+			pr_warn("Emergency Thaw on %pg\n", sb->s_bdev);
+	thaw_super_locked(sb, FREEZE_HOLDER_USERSPACE);
+	return;
 }
 
 static void do_thaw_all(struct work_struct *work)
 {
-	__iterate_supers(do_thaw_all_callback);
+	__iterate_supers(do_thaw_all_callback, NULL, true);
 	kfree(work);
 	printk(KERN_WARNING "Emergency Thaw complete\n");
 }
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3398,7 +3398,11 @@ extern void put_filesystem(struct file_s
 extern struct file_system_type *get_fs_type(const char *name);
 extern void drop_super(struct super_block *sb);
 extern void drop_super_exclusive(struct super_block *sb);
-extern void iterate_supers(void (*)(struct super_block *, void *), void *);
+void __iterate_supers(void (*f)(struct super_block *, void *), void *arg, bool excl);
+static inline void iterate_supers(void (*f)(struct super_block *, void *), void *arg)
+{
+	__iterate_supers(f, arg, false);
+}
 extern void iterate_supers_type(struct file_system_type *,
 			        void (*)(struct super_block *, void *), void *);
 


