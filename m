Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AFB2FDC4F;
	Tue, 12 Aug 2025 19:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025342; cv=none; b=d+S0cEFEGl+o8/cTHNnjCfhG4eYLq9mmWqmLP+VJ5Jy5j0SDz6SV8eY4Lm3BmUPiQmB1n4Y131WTMof3aEZBm+KfV7jtD0AMST9cWpT+gPjKp03NbC/6Ij2vIxtGbddK3MJi9JAK1AT8ta9xU+LooDwjT966DMxSZtNKaV9kNmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025342; c=relaxed/simple;
	bh=nxKpRbyD6UiqflP9aldHY/iecx03YI/Q20Zk6P/Nvnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8THXUiYqFOJ/eL3ZthpRChvtaWUl3e9rtfMI91RKlZsYnL2DKvfjo98WPweE5WYkay5HMpjL3EipJ/lK7ASGg1blTfn7W0mJ4nL2heqXAA1nd7bKdCmy8LMLJQVvO1IedgGGWUppGjI9x15Xx3QKUYg3yGUCsK4oNTGUlHkTew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yhIn6eNI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yhIn6eNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F238C4CEF0;
	Tue, 12 Aug 2025 19:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025342;
	bh=nxKpRbyD6UiqflP9aldHY/iecx03YI/Q20Zk6P/Nvnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yhIn6eNI0uWu2SZAMfGy28wrLaqunkOwJMcbGyIAEUdzgRbT27Z1C6pO5GeOMSbU8
	 Gc76ip5daIjgyRCWwkl0Pp4A5KCblwo438fz8pBaIbuO5QLH92mstFx/eC3pnlMkxY
	 syr1JmuUkFG0isJ0WUSLYadUzcIulnhnVPbChvgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1aa90f0eb1fc3e77d969@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 014/480] fs/ntfs3: cancle set bad inode after removing name fails
Date: Tue, 12 Aug 2025 19:43:42 +0200
Message-ID: <20250812174357.900887943@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit d99208b91933fd2a58ed9ed321af07dacd06ddc3 ]

The reproducer uses a file0 on a ntfs3 file system with a corrupted i_link.
When renaming, the file0's inode is marked as a bad inode because the file
name cannot be deleted.

The underlying bug is that make_bad_inode() is called on a live inode.
In some cases it's "icache lookup finds a normal inode, d_splice_alias()
is called to attach it to dentry, while another thread decides to call
make_bad_inode() on it - that would evict it from icache, but we'd already
found it there earlier".
In some it's outright "we have an inode attached to dentry - that's how we
got it in the first place; let's call make_bad_inode() on it just for shits
and giggles".

Fixes: 78ab59fee07f ("fs/ntfs3: Rework file operations")
Reported-by: syzbot+1aa90f0eb1fc3e77d969@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1aa90f0eb1fc3e77d969
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c |  7 +++----
 fs/ntfs3/namei.c   | 10 +++-------
 fs/ntfs3/ntfs_fs.h |  3 +--
 3 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index b7a83200f2cc..83593ecbe57e 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -3003,8 +3003,7 @@ int ni_add_name(struct ntfs_inode *dir_ni, struct ntfs_inode *ni,
  * ni_rename - Remove one name and insert new name.
  */
 int ni_rename(struct ntfs_inode *dir_ni, struct ntfs_inode *new_dir_ni,
-	      struct ntfs_inode *ni, struct NTFS_DE *de, struct NTFS_DE *new_de,
-	      bool *is_bad)
+	      struct ntfs_inode *ni, struct NTFS_DE *de, struct NTFS_DE *new_de)
 {
 	int err;
 	struct NTFS_DE *de2 = NULL;
@@ -3027,8 +3026,8 @@ int ni_rename(struct ntfs_inode *dir_ni, struct ntfs_inode *new_dir_ni,
 	err = ni_add_name(new_dir_ni, ni, new_de);
 	if (!err) {
 		err = ni_remove_name(dir_ni, ni, de, &de2, &undo);
-		if (err && ni_remove_name(new_dir_ni, ni, new_de, &de2, &undo))
-			*is_bad = true;
+		WARN_ON(err && ni_remove_name(new_dir_ni, ni, new_de, &de2,
+			&undo));
 	}
 
 	/*
diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
index 652735a0b0c4..fec451381a88 100644
--- a/fs/ntfs3/namei.c
+++ b/fs/ntfs3/namei.c
@@ -244,7 +244,7 @@ static int ntfs_rename(struct mnt_idmap *idmap, struct inode *dir,
 	struct ntfs_inode *ni = ntfs_i(inode);
 	struct inode *new_inode = d_inode(new_dentry);
 	struct NTFS_DE *de, *new_de;
-	bool is_same, is_bad;
+	bool is_same;
 	/*
 	 * de		- memory of PATH_MAX bytes:
 	 * [0-1024)	- original name (dentry->d_name)
@@ -313,12 +313,8 @@ static int ntfs_rename(struct mnt_idmap *idmap, struct inode *dir,
 	if (dir_ni != new_dir_ni)
 		ni_lock_dir2(new_dir_ni);
 
-	is_bad = false;
-	err = ni_rename(dir_ni, new_dir_ni, ni, de, new_de, &is_bad);
-	if (is_bad) {
-		/* Restore after failed rename failed too. */
-		_ntfs_bad_inode(inode);
-	} else if (!err) {
+	err = ni_rename(dir_ni, new_dir_ni, ni, de, new_de);
+	if (!err) {
 		simple_rename_timestamp(dir, dentry, new_dir, new_dentry);
 		mark_inode_dirty(inode);
 		mark_inode_dirty(dir);
diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index d628977e2556..a79cf4a63b25 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -581,8 +581,7 @@ int ni_add_name(struct ntfs_inode *dir_ni, struct ntfs_inode *ni,
 		struct NTFS_DE *de);
 
 int ni_rename(struct ntfs_inode *dir_ni, struct ntfs_inode *new_dir_ni,
-	      struct ntfs_inode *ni, struct NTFS_DE *de, struct NTFS_DE *new_de,
-	      bool *is_bad);
+	      struct ntfs_inode *ni, struct NTFS_DE *de, struct NTFS_DE *new_de);
 
 bool ni_is_dirty(struct inode *inode);
 int ni_set_compress(struct inode *inode, bool compr);
-- 
2.39.5



