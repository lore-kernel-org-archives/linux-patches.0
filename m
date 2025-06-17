Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8055420CCFB;
	Tue, 17 Jun 2025 16:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179108; cv=none; b=Cr052QrVnmMDQOPPfwxiaIu82TIzlj4tvq1wkWHFIrIqnaJ6p4NBkjo69x2fIBoGQa5E2Sb18oZTr6wltO7HRJJ2ksqZcdHcH0R3Ewcs1kelVb6l7vHeLPtqrVqSbbIo5EBlqXbcWPM8/h15q+m//uzd0yS7j84RSXPS7roez/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179108; c=relaxed/simple;
	bh=+sD7ObQsBwgkOrwZR7ZIEnW5/n66MnFMyPHsNXac0SA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4ng0GxBHLpRX4x5RdWni2c1ba/C/8a86fpu+5J1r1ISYOl19fEVEDKhvBCuntnxmxZn3+3ySldrJNafffO8nyeXDz0YHlKXaxZoepTx1hWKmSgSuteGp8vbxuGjRVgeSN7yBngubwW06uN/0foGUmLYlexljYCdnrEkvFbcQe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lrrJrFiK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lrrJrFiK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2FBC4CEE7;
	Tue, 17 Jun 2025 16:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179108;
	bh=+sD7ObQsBwgkOrwZR7ZIEnW5/n66MnFMyPHsNXac0SA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrrJrFiKtbXibbyUUdErHVMfioAuPeeRrlHRRlNg9rOLu5sZZcOX7LfnU8gWyB1cP
	 cgG+agMNIAsFIfCL8gN+cp8J5mi/1WYSjdknmjw3RShLZ7qUs+Q4ZYblp4LjDHd9IP
	 JcJc2BDGIBuwX5pA1aqCx0XZLY8DuOzpr/ZvSDUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Brennan <stephen.s.brennan@oracle.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 651/780] fs: convert mount flags to enum
Date: Tue, 17 Jun 2025 17:25:59 +0200
Message-ID: <20250617152517.987576316@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Brennan <stephen.s.brennan@oracle.com>

[ Upstream commit 101f2bbab541116ab861b9c3ac0ece07a7eaa756 ]

In prior kernel versions (5.8-6.8), commit 9f6c61f96f2d9 ("proc/mounts:
add cursor") introduced MNT_CURSOR, a flag used by readers from
/proc/mounts to keep their place while reading the file. Later, commit
2eea9ce4310d8 ("mounts: keep list of mounts in an rbtree") removed this
flag and its value has since been repurposed.

For debuggers iterating over the list of mounts, cursors should be
skipped as they are irrelevant. Detecting whether an element is a cursor
can be difficult. Since the MNT_CURSOR flag is a preprocessor constant,
it's not present in debuginfo, and since its value is repurposed, we
cannot hard-code it. For this specific issue, cursors are possible to
detect in other ways, but ideally, we would be able to read the mount
flag definitions out of the debuginfo. For that reason, convert the
mount flags to an enum.

Link: https://github.com/osandov/drgn/pull/496
Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
Link: https://lore.kernel.org/20250507223402.2795029-1-stephen.s.brennan@oracle.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: bab77c0d191e ("finish_automount(): don't leak MNT_LOCKED from parent to child")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mount.h | 87 ++++++++++++++++++++++---------------------
 1 file changed, 45 insertions(+), 42 deletions(-)

diff --git a/include/linux/mount.h b/include/linux/mount.h
index dcc17ce8a959e..6904ad33ee7a3 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -22,48 +22,51 @@ struct fs_context;
 struct file;
 struct path;
 
-#define MNT_NOSUID	0x01
-#define MNT_NODEV	0x02
-#define MNT_NOEXEC	0x04
-#define MNT_NOATIME	0x08
-#define MNT_NODIRATIME	0x10
-#define MNT_RELATIME	0x20
-#define MNT_READONLY	0x40	/* does the user want this to be r/o? */
-#define MNT_NOSYMFOLLOW	0x80
-
-#define MNT_SHRINKABLE	0x100
-#define MNT_WRITE_HOLD	0x200
-
-#define MNT_SHARED	0x1000	/* if the vfsmount is a shared mount */
-#define MNT_UNBINDABLE	0x2000	/* if the vfsmount is a unbindable mount */
-/*
- * MNT_SHARED_MASK is the set of flags that should be cleared when a
- * mount becomes shared.  Currently, this is only the flag that says a
- * mount cannot be bind mounted, since this is how we create a mount
- * that shares events with another mount.  If you add a new MNT_*
- * flag, consider how it interacts with shared mounts.
- */
-#define MNT_SHARED_MASK	(MNT_UNBINDABLE)
-#define MNT_USER_SETTABLE_MASK  (MNT_NOSUID | MNT_NODEV | MNT_NOEXEC \
-				 | MNT_NOATIME | MNT_NODIRATIME | MNT_RELATIME \
-				 | MNT_READONLY | MNT_NOSYMFOLLOW)
-#define MNT_ATIME_MASK (MNT_NOATIME | MNT_NODIRATIME | MNT_RELATIME )
-
-#define MNT_INTERNAL_FLAGS (MNT_SHARED | MNT_WRITE_HOLD | MNT_INTERNAL | \
-			    MNT_DOOMED | MNT_SYNC_UMOUNT | MNT_MARKED)
-
-#define MNT_INTERNAL	0x4000
-
-#define MNT_LOCK_ATIME		0x040000
-#define MNT_LOCK_NOEXEC		0x080000
-#define MNT_LOCK_NOSUID		0x100000
-#define MNT_LOCK_NODEV		0x200000
-#define MNT_LOCK_READONLY	0x400000
-#define MNT_LOCKED		0x800000
-#define MNT_DOOMED		0x1000000
-#define MNT_SYNC_UMOUNT		0x2000000
-#define MNT_MARKED		0x4000000
-#define MNT_UMOUNT		0x8000000
+enum mount_flags {
+	MNT_NOSUID	= 0x01,
+	MNT_NODEV	= 0x02,
+	MNT_NOEXEC	= 0x04,
+	MNT_NOATIME	= 0x08,
+	MNT_NODIRATIME	= 0x10,
+	MNT_RELATIME	= 0x20,
+	MNT_READONLY	= 0x40, /* does the user want this to be r/o? */
+	MNT_NOSYMFOLLOW	= 0x80,
+
+	MNT_SHRINKABLE	= 0x100,
+	MNT_WRITE_HOLD	= 0x200,
+
+	MNT_SHARED	= 0x1000, /* if the vfsmount is a shared mount */
+	MNT_UNBINDABLE	= 0x2000, /* if the vfsmount is a unbindable mount */
+
+	MNT_INTERNAL	= 0x4000,
+
+	MNT_LOCK_ATIME		= 0x040000,
+	MNT_LOCK_NOEXEC		= 0x080000,
+	MNT_LOCK_NOSUID		= 0x100000,
+	MNT_LOCK_NODEV		= 0x200000,
+	MNT_LOCK_READONLY	= 0x400000,
+	MNT_LOCKED		= 0x800000,
+	MNT_DOOMED		= 0x1000000,
+	MNT_SYNC_UMOUNT		= 0x2000000,
+	MNT_MARKED		= 0x4000000,
+	MNT_UMOUNT		= 0x8000000,
+
+	/*
+	 * MNT_SHARED_MASK is the set of flags that should be cleared when a
+	 * mount becomes shared.  Currently, this is only the flag that says a
+	 * mount cannot be bind mounted, since this is how we create a mount
+	 * that shares events with another mount.  If you add a new MNT_*
+	 * flag, consider how it interacts with shared mounts.
+	 */
+	MNT_SHARED_MASK	= MNT_UNBINDABLE,
+	MNT_USER_SETTABLE_MASK  = MNT_NOSUID | MNT_NODEV | MNT_NOEXEC
+				  | MNT_NOATIME | MNT_NODIRATIME | MNT_RELATIME
+				  | MNT_READONLY | MNT_NOSYMFOLLOW,
+	MNT_ATIME_MASK = MNT_NOATIME | MNT_NODIRATIME | MNT_RELATIME,
+
+	MNT_INTERNAL_FLAGS = MNT_SHARED | MNT_WRITE_HOLD | MNT_INTERNAL |
+			     MNT_DOOMED | MNT_SYNC_UMOUNT | MNT_MARKED,
+};
 
 struct vfsmount {
 	struct dentry *mnt_root;	/* root of the mounted tree */
-- 
2.39.5



