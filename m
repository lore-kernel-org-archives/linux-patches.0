Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494DB21ABD0;
	Tue, 12 Aug 2025 18:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023255; cv=none; b=Z2Pw+IQm9TANchFN8eh7HOVRssQC1jRyyMOLTZ1LhzUz+CeROPUuxEXT/dIyCkQP0AvmmlOLYXt4sKsIyGNLjP822sUVCacuv9kA/Q83hxCPoOCq/vsj4sO8qYbX1NWtZQU4b1OmeorNEDdmnkmxjqNCKmhuIQHsBHh49m3r0TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023255; c=relaxed/simple;
	bh=02Yo3rBs0gShimZsyB+waqd6JJDgPH5NSuf7Qrm2UUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knUFPuJkvOcn88iWMyrSNtSd1nKWv8RZvd7BuSx/eZ6Itw2h4fiNrkXucsRF9ML7RMkUrkQBfK4wyd0mv+OlCyNWHMWIYxz/YqGzcD/ZQ3nIht1+aHK6hMit75OrhmJ+21BIxUbez0LHdde8qv3EO3Iq2swEMerYcNdtiWApxvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j1iMIEQh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j1iMIEQh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4BAC4CEF1;
	Tue, 12 Aug 2025 18:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023255;
	bh=02Yo3rBs0gShimZsyB+waqd6JJDgPH5NSuf7Qrm2UUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j1iMIEQhSJtmMHkruENhjkdGZrsI4FSk/TSyVG7psIwxM2ywLtrqXTqumcwxg56ty
	 zzfFm/FX5DWXlOWl8MZWznUEM5nF5pmBl+idNw4OQW4m9F1a7+D0qNMcjNbeXjSQ6V
	 LH2s4YR6xReu6A3C0TL9LxhJY4ZwZ6yP/LxCVY4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1aa90f0eb1fc3e77d969@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 006/627] fs/ntfs3: cancle set bad inode after removing name fails
Date: Tue, 12 Aug 2025 19:25:01 +0200
Message-ID: <20250812173419.563445446@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 756e1306fe6c..7afbb4418eb2 100644
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
index b807744fc6a9..0db7ca3b64ea 100644
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
index 36b8052660d5..f54635df18fa 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -577,8 +577,7 @@ int ni_add_name(struct ntfs_inode *dir_ni, struct ntfs_inode *ni,
 		struct NTFS_DE *de);
 
 int ni_rename(struct ntfs_inode *dir_ni, struct ntfs_inode *new_dir_ni,
-	      struct ntfs_inode *ni, struct NTFS_DE *de, struct NTFS_DE *new_de,
-	      bool *is_bad);
+	      struct ntfs_inode *ni, struct NTFS_DE *de, struct NTFS_DE *new_de);
 
 bool ni_is_dirty(struct inode *inode);
 
-- 
2.39.5



