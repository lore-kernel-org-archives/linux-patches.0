Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3339B46F48E;
	Tue, 21 Jul 2026 18:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659685; cv=none; b=tIb0Fk7oF3roKq9A6e6ewFnJ3pyA+J7V9L0+4BwWJveAnDrf8a4xMvD2EN2zBkpTVyEPDSzt1kKLjxacbhBX1IT6Ndsq3E5Ih64HlMWHGHT+yV7LcDDqyEY9KG+O/vstX2QQtef9Zlm/74lYgLoG5igGWmCRsGOstJVV7Nt4A8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659685; c=relaxed/simple;
	bh=jepx9Szc637yM1A637VbBdrRb/pfBE2p5OM2noZ8J98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4zmrRBz7uJAuSt+s2zanBWCWZPHjmAce+BZToGy26o+B2NMWCa5FzsWDkbbH33cef7dhbsxN+3aBGruQtSfBUsL8R1y0DdTL8gnilrf8InNsVDlUaae79Nml8cT296o4ox9aomb8t+Nzcv8wVUKxVPVWzxx1+aTEuIGa7/NrFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJclkihx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJclkihx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4352F1F000E9;
	Tue, 21 Jul 2026 18:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659682;
	bh=JyLNrrugLvD339RfbIi+heOxtHos6iRVNZbt8sckFgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lJclkihxDcOIYfzpbHuYM33jGW4sMCIk4EyX37PLh/fvTGiDxOqS389VccSrXUKnV
	 OeQoqhILaQ72lBu07o0/Pz92R0y+o7xWOxNxWRNfoyct5lXMh/iQCVhTbFGfU1oQBd
	 380jjAG8JUqel8ZIVMIodUjJB44PJRwUm5W+OyNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1578/1611] new helper: simple_remove_by_name()
Date: Tue, 21 Jul 2026 17:28:14 +0200
Message-ID: <20260721152550.964598006@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 4051a9115ad24bb9a691774730ca9c1dd56de665 ]

simple_recursive_removal(), but instead of victim dentry it takes
parent + name.

Used to be open-coded in fs/fuse/control.c, but there's no need to expose
the guts of that thing there and there are other potential users, so
let's lift it into libfs...

Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: 3137b243c939 ("usb: gadget: f_fs: initialize reset_work at allocation time")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/control.c  |    7 +------
 fs/libfs.c         |   13 +++++++++++++
 include/linux/fs.h |    2 ++
 3 files changed, 16 insertions(+), 6 deletions(-)

--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -290,18 +290,13 @@ static void remove_one(struct dentry *de
  */
 void fuse_ctl_remove_conn(struct fuse_conn *fc)
 {
-	struct dentry *dentry;
 	char name[32];
 
 	if (!fuse_control_sb || fc->no_control)
 		return;
 
 	sprintf(name, "%u", fc->dev);
-	dentry = lookup_noperm_positive_unlocked(&QSTR(name), fuse_control_sb->s_root);
-	if (!IS_ERR(dentry)) {
-		simple_recursive_removal(dentry, remove_one);
-		dput(dentry);	// paired with lookup_noperm_positive_unlocked()
-	}
+	simple_remove_by_name(fuse_control_sb->s_root, name, remove_one);
 }
 
 static int fuse_ctl_fill_super(struct super_block *sb, struct fs_context *fsc)
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -647,6 +647,19 @@ void simple_recursive_removal(struct den
 }
 EXPORT_SYMBOL(simple_recursive_removal);
 
+void simple_remove_by_name(struct dentry *parent, const char *name,
+                           void (*callback)(struct dentry *))
+{
+	struct dentry *dentry;
+
+	dentry = lookup_noperm_positive_unlocked(&QSTR(name), parent);
+	if (!IS_ERR(dentry)) {
+		simple_recursive_removal(dentry, callback);
+		dput(dentry);	// paired with lookup_noperm_positive_unlocked()
+	}
+}
+EXPORT_SYMBOL(simple_remove_by_name);
+
 /* caller holds parent directory with I_MUTEX_PARENT */
 void locked_recursive_removal(struct dentry *dentry,
                               void (*callback)(struct dentry *))
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3655,6 +3655,8 @@ extern int simple_rename(struct mnt_idma
 			 unsigned int);
 extern void simple_recursive_removal(struct dentry *,
                               void (*callback)(struct dentry *));
+extern void simple_remove_by_name(struct dentry *, const char *,
+                              void (*callback)(struct dentry *));
 extern void locked_recursive_removal(struct dentry *,
                               void (*callback)(struct dentry *));
 extern int noop_fsync(struct file *, loff_t, loff_t, int);


