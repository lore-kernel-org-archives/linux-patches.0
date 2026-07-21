Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8674A46C4B9;
	Tue, 21 Jul 2026 18:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658054; cv=none; b=djHboIMzOZyPxfn3OPL/FXB+HiBQ0CzKLqXF/e9mJZ0cQIieMqLfSeOm2qI0TGje9W5CsvAm6c1GsODojMc5l/UrjnEqHRqUTJ3KNJfwD1A8DDDazo1Wb/D/B3RxvP1A0lT8NFxnTqJ2VPs3UfcT3sePjiYSXIUzFfqvzVlgu2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658054; c=relaxed/simple;
	bh=7uoWyQ37cmkA16G8VJ/Dq+i20fYQoF9Y2TZhNC/rkbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfFlnuC7oO04Hfb2A5lZEufuPKB+mpMaoW2/6Z6s8TY7cnvSZlhYB/XC5gjT6+xTrccU8E0DIsePlg41xD7CCMEEFWv5kD19+AOhh3bOQUTNUCXJdORGevYqie+AEW/FsqGWZCaQsKi37jDIAuALTDZNZq4nI11kolBiDRd0uE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fYc/UkHr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fYc/UkHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7501F00A3A;
	Tue, 21 Jul 2026 18:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658053;
	bh=QTIadD5dQsD2eHczhiUlG5S6yYqTdOdIo5eFTg8LQlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fYc/UkHrIbGrUrosDuVGskcw02rkPRuOZtGIDKpRqx0WzH3lybllvlCSHgCBw0zMr
	 l/JyMQFiuX+9h1pNMxLffjLEakGv+TYzZ4DKSvOq+F2hoVR8uAEJVcWjUPI+oOZ4By
	 oKnbHz49HuYrAgBY6les2QrJu/Hh5rjeQ0qCf3i8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0998/1611] fs: refuse O_TMPFILE creation with an unmapped fsuid or fsgid
Date: Tue, 21 Jul 2026 17:18:34 +0200
Message-ID: <20260721152537.838730209@linuxfoundation.org>
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
index 7377020a2cba02..003c9a1b2f9041 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4011,6 +4011,10 @@ int vfs_tmpfile(struct mnt_idmap *idmap,
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



