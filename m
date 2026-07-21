Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDDF3B0AC6;
	Tue, 21 Jul 2026 20:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666868; cv=none; b=YteD6ZMyuMVEj8fSQJsKEDn9hfkIJtpCTBYNLyGOB83Cu8lXcKsXQ+WH/ZtdK935BIuqTMhbG8DWqU/kNqzlgwijhIylJR53fHL4J0rWJdXRGR6hPhddBsp1odF8fPfiGr2zKlZVrgY6nBPgPGnbt7JIeQcxKSYxFsU5kntdwlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666868; c=relaxed/simple;
	bh=r8AygU/1euFvf2AUNo786HuTE6S6Pwxu3cuRDAQNXN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjflAP+ij5PotcPps+2sBv6TEXnEISJZm+IytwMdtmyOch3PzCOgQ8RADL6RqplW2pODx6QkXDPVuk+aNn1IpdTPKNPp4IY9eKKxVS8OTtmTrTdR0P4yOjq9UYPQxr2oEeggNXzmoS9ZsRY6mhgNy90uh9gSmlcIJspwCQf4qqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ct7f17H6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ct7f17H6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D227B1F00A3A;
	Tue, 21 Jul 2026 20:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666866;
	bh=scCVB4xEPgdvvpDyvtZ1J+/Lnog4U/snTshhIyKrJdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ct7f17H6Byme44Xw/Hxbb9GgFpRHFu1zot4ZjR7G0koWOS9MtvVEBmiln6lgnmLDB
	 h4SWRgHqSwUevtrMTkXiXfUyepKKkPL4JURaALxE1ffnXxoZv1W+87T30Wg3N9FrDl
	 jUB4e04wu3+Cv+eX1oAJBEJHctADLGgQzvgwaNjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0828/1266] fs: refuse O_TMPFILE creation with an unmapped fsuid or fsgid
Date: Tue, 21 Jul 2026 17:21:05 +0200
Message-ID: <20260721152500.384294491@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 02b0c273129824..861390e523b2a0 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3676,6 +3676,10 @@ static int vfs_tmpfile(struct mnt_idmap *idmap,
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



