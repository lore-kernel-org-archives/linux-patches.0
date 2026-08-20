Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C31D188CC9;
	Thu, 20 Aug 2026 17:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247039; cv=none; b=Gpo8oFweXvOeV2VZiyEBG0ivQCcsMrVC8Q2jgkmbDKLw9MUo0vw7i/Q+RS4N3+YOM5SrsT5ye7IzLzNtiobkNlihywQnnL69m+mFW5ZB1KZS6GKhVtoWgEyxHsnh2gOvqglCdHKadA84LIIkwoqbvjYDyo9vi/1EcR9Ou0IdvP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247039; c=relaxed/simple;
	bh=vdAPlKwEa6DMFSlkvqJhAab8BswNbrrG7t/ejjx8TcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LhKU1tNyhBHPvFX5LMUEobTr9BBrSi0808yAIthJMoGwtaJOWSoufHqrf3VUan1UCQJSRJ/e5ZexIZqjYuZTm6eZwsp4zyC6eiziM9Fz0MowSymKqobwScavQn5xb/yxMqcUELjISzJmH0fntIlYgN3yWb7S6G3VfHDBTn7rl+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lyj4Tf/6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lyj4Tf/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1F71F000E9;
	Thu, 20 Aug 2026 17:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247038;
	bh=GobRHBJbIy4LX2LEjYL6FiEcPz6UfOdUtTOY5hSO0xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lyj4Tf/686VWH4VMBrM0l5bwTjo6ONYseuF56U4ylAkS20IQkPeOIen7EWz0mojll
	 KKNzo64lM3EcUqasATxv/niOdlSR9TRnQYQNQcwNtY55LZsyXPWAdhtdDyhTiXVueO
	 GmMbPM3ZTCMTM20EkmACJbNJANDORg0DvXYm9LIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 127/220] super: use common iterator (Part 2)
Date: Thu, 20 Aug 2026 16:55:17 +0200
Message-ID: <20260820145227.287705782@linuxfoundation.org>
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

[ Upstream commit b47e42d10e8c20525febccbd6e0dc8528861aea4 ]

Use a common iterator for all callbacks. We could go for something even
more elaborate (advance step-by-step similar to iov_iter) but I really
don't think this is warranted.

Link: https://lore.kernel.org/r/20250329-work-freeze-v2-5-a47af37ecc3d@kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 749d7aa0377a ("super: fix emergency thaw deadlock on frozen block devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/super.c         |   48 +++++++++++++++++++++++++++++++++++++++---------
 include/linux/fs.h |    6 +-----
 2 files changed, 40 insertions(+), 14 deletions(-)

--- a/fs/super.c
+++ b/fs/super.c
@@ -887,21 +887,46 @@ void drop_super_exclusive(struct super_b
 }
 EXPORT_SYMBOL(drop_super_exclusive);
 
-void __iterate_supers(void (*f)(struct super_block *, void *), void *arg, bool excl)
+enum super_iter_flags_t {
+	SUPER_ITER_EXCL		= (1U << 0),
+	SUPER_ITER_UNLOCKED	= (1U << 1),
+	SUPER_ITER_REVERSE	= (1U << 2),
+};
+
+static inline struct super_block *first_super(enum super_iter_flags_t flags)
+{
+	if (flags & SUPER_ITER_REVERSE)
+		return list_last_entry(&super_blocks, struct super_block, s_list);
+	return list_first_entry(&super_blocks, struct super_block, s_list);
+}
+
+static inline struct super_block *next_super(struct super_block *sb,
+					     enum super_iter_flags_t flags)
+{
+	if (flags & SUPER_ITER_REVERSE)
+		return list_prev_entry(sb, s_list);
+	return list_next_entry(sb, s_list);
+}
+
+static void __iterate_supers(void (*f)(struct super_block *, void *), void *arg,
+			     enum super_iter_flags_t flags)
 {
 	struct super_block *sb, *p = NULL;
+	bool excl = flags & SUPER_ITER_EXCL;
 
-	spin_lock(&sb_lock);
-	list_for_each_entry(sb, &super_blocks, s_list) {
-		bool locked;
+	guard(spinlock)(&sb_lock);
 
+	for (sb = first_super(flags);
+	     !list_entry_is_head(sb, &super_blocks, s_list);
+	     sb = next_super(sb, flags)) {
 		if (super_flags(sb, SB_DYING))
 			continue;
 		sb->s_count++;
 		spin_unlock(&sb_lock);
 
-		locked = super_lock(sb, excl);
-		if (locked) {
+		if (flags & SUPER_ITER_UNLOCKED) {
+			f(sb, arg);
+		} else if (super_lock(sb, excl)) {
 			f(sb, arg);
 			super_unlock(sb, excl);
 		}
@@ -913,7 +938,11 @@ void __iterate_supers(void (*f)(struct s
 	}
 	if (p)
 		__put_super(p);
-	spin_unlock(&sb_lock);
+}
+
+void iterate_supers(void (*f)(struct super_block *, void *), void *arg)
+{
+	__iterate_supers(f, arg, 0);
 }
 
 /**
@@ -1096,7 +1125,8 @@ static void do_emergency_remount_callbac
 
 static void do_emergency_remount(struct work_struct *work)
 {
-	__iterate_supers(do_emergency_remount_callback, NULL, true);
+	__iterate_supers(do_emergency_remount_callback, NULL,
+			 SUPER_ITER_EXCL | SUPER_ITER_REVERSE);
 	kfree(work);
 	printk("Emergency Remount complete\n");
 }
@@ -1123,7 +1153,7 @@ static void do_thaw_all_callback(struct
 
 static void do_thaw_all(struct work_struct *work)
 {
-	__iterate_supers(do_thaw_all_callback, NULL, true);
+	__iterate_supers(do_thaw_all_callback, NULL, SUPER_ITER_EXCL);
 	kfree(work);
 	printk(KERN_WARNING "Emergency Thaw complete\n");
 }
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3398,11 +3398,7 @@ extern void put_filesystem(struct file_s
 extern struct file_system_type *get_fs_type(const char *name);
 extern void drop_super(struct super_block *sb);
 extern void drop_super_exclusive(struct super_block *sb);
-void __iterate_supers(void (*f)(struct super_block *, void *), void *arg, bool excl);
-static inline void iterate_supers(void (*f)(struct super_block *, void *), void *arg)
-{
-	__iterate_supers(f, arg, false);
-}
+extern void iterate_supers(void (*f)(struct super_block *, void *), void *arg);
 extern void iterate_supers_type(struct file_system_type *,
 			        void (*)(struct super_block *, void *), void *);
 


