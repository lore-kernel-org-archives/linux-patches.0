Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3063F28641E;
	Tue, 21 Jul 2026 19:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663185; cv=none; b=Zi5YTiUhfug9rgVHEc22c1rNI4iWRjpVItINThO/XGTHXV1aKqw24kxhfCeeYmWq6UqxGS+vzvC+Wnet/E4vw+uzu3orV2KiTe/VPU271rq9BfaeYNFaae7d/KY1t2WjE5e9xBr7MQI22Ygv4He9/D+RRok26EGvqPJk0hfzvx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663185; c=relaxed/simple;
	bh=+QPuCa31njXmp5NPY54Pe+fHImuBJP5vpGXnxJ2IIuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2RjPWzhVTdNfkB9PWlQr51qpUk5/X78tQgkQAwJyhfmgchLkn4ZljgCBU9YmR7q7u5T77eeOEs+tmAOA6bp7IzKLm5M7gMVX/IeTkZSx88W348oDLvIYVVUUmNUrBKNRV60PShULjje8xd2Gac3uA8D/ELmMp5pkgBc/GbELW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dS5Kqxi3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dS5Kqxi3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955651F000E9;
	Tue, 21 Jul 2026 19:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663184;
	bh=cHykaonitBmlqOxfAXKi+aLoiwFfmWIsZU9pabFstoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dS5Kqxi3cO3T33vkVFfOdIxdCzTCaVZy5uB18OzvFtoE5tDShpbj9mLUGH9o3NId6
	 SOfdlXEPosDqMJznBN/6LRRJCKhXjh2qpWPejlcBrmmfkdKqRFNbnqTO67Jb9sXS6O
	 WH3H2szFiKSL3QjYpqPk2WrLvjTi4kWVKCJA7qr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0726/1276] fs: refuse O_TMPFILE creation with an unmapped fsuid or fsgid
Date: Tue, 21 Jul 2026 17:19:29 +0200
Message-ID: <20260721152502.333709705@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

[ Upstream commit 539dce1144651f7976fa418e618b0b574bf15eeb ]

vfs_tmpfile() never checked that the caller's fsuid and fsgid map into
the filesystem.  On an idmapped mount whose idmapping does not cover the
caller's fs{u,g}id, the ->tmpfile() instance initializes the new inode
through inode_init_owner(), where mapped_fsuid()/mapped_fsgid() return
INVALID_UID/INVALID_GID, and the tmpfile ends up owned by (uid_t)-1.

Every other creation path already refuses this: may_o_create() (O_CREAT)
and may_create_dentry() (mkdir, mknod, symlink, link) bail out with
-EOVERFLOW via fsuidgid_has_mapping() precisely so that an object cannot
be created with an owner the filesystem cannot represent.  An O_TMPFILE
is no exception: it is created I_LINKABLE and linkat(2) can splice it
into the namespace afterwards, so the same guarantee must hold.

Add the missing fsuidgid_has_mapping() check to vfs_tmpfile().  On a
non-idmapped mount the caller's fs{u,g}id always map in the superblock's
user namespace, so this is a no-op there and only takes effect on an
idmapped mount that does not map the caller.  It applies to every
filesystem that sets FS_ALLOW_IDMAP and implements ->tmpfile() (tmpfs,
ext4, btrfs, xfs, f2fs, ...), and to overlayfs, whose upper-layer
tmpfile creation funnels through vfs_tmpfile() via backing_tmpfile_open().

Fixes: 8e5389132ab4 ("fs: introduce fsuidgid_has_mapping() helper")
Link: https://patch.msgid.link/20260615-work-idmapped-tmpfile-v1-1-754a94d81f83@kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namei.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/namei.c b/fs/namei.c
index 1eb20cb5e58f9e..17fd9e3d0dc086 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3818,6 +3818,10 @@ int vfs_tmpfile(struct mnt_idmap *idmap,
 	int error;
 	int open_flag = file->f_flags;
 
+	/* A tmpfile is I_LINKABLE, so guard its owner like may_o_create(). */
+	if (!fsuidgid_has_mapping(dir->i_sb, idmap))
+		return -EOVERFLOW;
+
 	/* we want directory to be writable */
 	error = inode_permission(idmap, dir, MAY_WRITE | MAY_EXEC);
 	if (error)
-- 
2.53.0



