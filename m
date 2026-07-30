Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D00E399013;
	Thu, 30 Jul 2026 16:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428229; cv=none; b=p/swykSTDzIoz/5uqpM+1jGIwqyfAlVBY6znTfhkDJ2JNMKL7dGjF4xCku0DXu0JoVEn3czR7VXZ+l2T0X/Jdp4O95ifml2vlecGXUYpsNtdiCKnx2uvy41XOd6Qi1XlnE1VA7s/gSEAxKGcyWfkxrl40kRr5MuK5CjMBcGfI2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428229; c=relaxed/simple;
	bh=zBMTStDsUXLcgTBP6a+SEG4AAgozmCdYJWJUDk5pTtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ESYcmIKdcyMKCQBt2ICkTSaaAwXbBYy8UFMnFkjS/UG2rhKN1wlmI3T5VVXtxLQkqGRSS8tJNslgozchB0FuAMJk1fFmlI6NCTv6shSAEb6UsvjuWYCB+gLPg1QlVPSSUuhYOymwbDzE/tx1FFNc3h6KQGmLXwW+1X6Kdx8xt5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V0SJUsHC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V0SJUsHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2380A1F000E9;
	Thu, 30 Jul 2026 16:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428227;
	bh=ddgS/t6pFdsSqMsRhZ1j3MmAm4NTOxQy4sIHcOLACrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V0SJUsHClUWufoLh0W8W/fpdZ0c7z/kweEmZDyJd4zwagcBKtT8v/i6iS1k6jan+A
	 YcngYXCR+ulub2vEsbjSuutx87uJyqL+QU3TZMk5LieZyBmQC9kVpUjB++1rQ8dqn0
	 YZBTbRV41nNSAyLpIe7NcUeLXBusBm5BS1LYYuhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Souvik Banerjee <souvik@amlalabs.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 447/484] ovl: use linked upper dentry in copy-up tmpfile
Date: Thu, 30 Jul 2026 16:15:44 +0200
Message-ID: <20260730141433.193520432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Souvik Banerjee <souvik@amlalabs.com>

[ Upstream commit e348eecd4d8fa8d18a5157ff59f7be1dc59c5928 ]

ovl_copy_up_tmpfile() stores the disconnected O_TMPFILE dentry as the
overlay's upper dentry reference via ovl_inode_update().  vfs_tmpfile()
allocated this dentry via d_alloc(parentpath->dentry, &slash_name), so
d_name is "/" and d_parent is c->workdir.  Local upper filesystems
(ext4, btrfs, xfs, ...) immediately rename it to "#<inum>" via
d_mark_tmpfile() inside their ->tmpfile() op; FUSE and virtiofs do
not, so both fields stay that way.  Neither identifies the destination
directory and filename where ovl_do_link() actually linked the file.

When the upper filesystem implements ->d_revalidate() (e.g. FUSE or
virtiofs), ovl_revalidate_real() calls it with the dentry's parent
inode and a snapshot of d_name.  The server tries to look up "/" inside
c->workdir, fails, and overlayfs reports -ESTALE.

This causes persistent ESTALE errors for any file that was copied up via
the tmpfile path, breaking dpkg, apt, and other tools that do
rename-over-existing on overlayfs with a FUSE/virtiofs upper.

Before commit 6b52243f633e ("ovl: fold copy-up helpers into callers"),
the tmpfile copy-up path used a dedicated helper ovl_link_tmpfile()
that captured the linked destination dentry returned by ovl_do_link():

    err = ovl_do_link(temp, udir, upper);
    ...
    if (!err)
        *newdentry = dget(upper);

and published it via ovl_inode_update(d_inode(c->dentry), newdentry).
The fold inlined ovl_do_link() into ovl_copy_up_tmpfile() but dropped
the dget(upper) capture, and rewrote the publish line as
ovl_inode_update(d_inode(c->dentry), dget(temp)) — where temp is the
disconnected O_TMPFILE dentry.

Fix by keeping a reference to the linked destination dentry after
ovl_do_link() succeeds, and publishing that dentry at the existing
ovl_inode_update() call site.  The non-tmpfile/workdir path continues to
publish the renamed temporary dentry.

Reproducer:
  - Mount overlayfs with virtiofs (or a FUSE fs whose server advertises
    FUSE_TMPFILE) as upper
  - Run: dpkg -i <any .deb>
  - Observe: "error installing new file '...': Stale file handle"

Fixes: 6b52243f633e ("ovl: fold copy-up helpers into callers")
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Souvik Banerjee <souvik@amlalabs.com>
Link: https://patch.msgid.link/20260501232735.2610824-1-souvik@amlalabs.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ adapted scoped credential and creation helpers to explicit credential, locking, lookup, and cleanup handling ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/copy_up.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -793,7 +793,7 @@ static int ovl_copy_up_tmpfile(struct ov
 {
 	struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
 	struct inode *udir = d_inode(c->destdir);
-	struct dentry *temp, *upper;
+	struct dentry *temp, *upper, *newdentry = NULL;
 	struct file *tmpfile;
 	struct ovl_cu_creds cc;
 	int err;
@@ -826,6 +826,14 @@ static int ovl_copy_up_tmpfile(struct ov
 	err = PTR_ERR(upper);
 	if (!IS_ERR(upper)) {
 		err = ovl_do_link(ofs, temp, udir, upper);
+		if (!err) {
+			/*
+			 * Record the linked dentry -- not the disconnected
+			 * O_TMPFILE dentry -- so that ->d_revalidate() on
+			 * the upper fs sees the real parent/name.
+			 */
+			newdentry = dget(upper);
+		}
 		dput(upper);
 	}
 	inode_unlock(udir);
@@ -841,7 +849,7 @@ static int ovl_copy_up_tmpfile(struct ov
 
 	if (!c->metacopy)
 		ovl_set_upperdata(d_inode(c->dentry));
-	ovl_inode_update(d_inode(c->dentry), dget(temp));
+	ovl_inode_update(d_inode(c->dentry), newdentry);
 
 out_fput:
 	fput(tmpfile);


