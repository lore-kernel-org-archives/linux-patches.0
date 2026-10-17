Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DAB2E8DEB;
	Sat, 17 Oct 2026 15:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252506; cv=none; b=bTOmMo+YFQM2NykAaOa02jWbdsW8vUPRBhjnqWWGJNOjRC1tnqtx5HbZkslUHaEiD+6w4AI82Z4YxvQPrOiZf1TFO7xi44ap/+niKL6pq+eA/W3Fj/Zb4HIrjDgPD0LTQxe/ccU3Ql6Y0YS15zARpv21WnKA9a0Z6JO3iChI6r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252506; c=relaxed/simple;
	bh=oUmLcF2BoXQxlBx9fC52hRceq3Ku5xe7P8LXrLvxiYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/P49tzP5egZTPwXO6OlUaoX0jB7ua2Xs+tBc4g0QCOVfXs+S8G3C0/b2taIj55EwT6rXTxkpGVER8q+YwwdE1zn+HcElOLytDCNA5z100l4xUsuxl6iEtfkzQyk37qdCtTFxycQlD88l0+I8jdcZIWdFXYGr+bUsjvhZVamXfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XxIYdv2q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XxIYdv2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C381F000C4;
	Sat, 17 Oct 2026 15:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252505;
	bh=nVKSVUb+XsMBqfeAUKsj9BQboTtO4imLicCUJgB9dko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XxIYdv2qn2HdJloRXdd2rDNVEfiHChmM563Gbn1zpfAshQteJG871TTk1MKgaU7py
	 Br9JqImhFTfpF/B/V2v+SQ/tTNWmeWpy/gQ1dvNku0VXR8Ault6x27iD+i0BE8waXy
	 pOWNxOmrW5nSp5hl2MzCO3ZbvovlDe+KlWg73k5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 05/10] nullfs: refuse file locks
Date: Sat, 17 Oct 2026 17:54:34 +0200
Message-ID: <20261017155059.891144460@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155059.698368299@linuxfoundation.org>
References: <20261017155059.698368299@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 31a1fb90624d7e275db775a29a0e00a7f8b3df63 ]

Refuse flock() and POSIX locks on nullfs. Its one inode is the root of
every kernel thread and the following patches make it the directory
that stands in for an unmounted mount, so a lock taken through one such
directory would block the locks of every other holder and F_GETLK would
tell them the pid of the holder. Give the directory file operations of
its own: what libfs gives an empty directory plus ->lock and ->flock
that fail with ENOLCK, the way a filesystem without lock support does.

Link: https://patch.msgid.link/20261002-work-mount-fixes-4-v1-17-dd44b89d44ce@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: e08f57a7dcb8 ("readdir: take no inode lock on an immutable directory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nullfs.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/fs/nullfs.c b/fs/nullfs.c
index 20d3aa627a47d..fc79ca42bb178 100644
--- a/fs/nullfs.c
+++ b/fs/nullfs.c
@@ -8,6 +8,34 @@ static const struct super_operations nullfs_super_operations = {
 	.statfs	= simple_statfs,
 };
 
+static loff_t nullfs_dir_llseek(struct file *file, loff_t offset, int whence)
+{
+	/* an empty directory has two entries . and .. at offsets 0 and 1 */
+	return generic_file_llseek_size(file, offset, whence, 2, 2);
+}
+
+static int nullfs_dir_readdir(struct file *file, struct dir_context *ctx)
+{
+	dir_emit_dots(file, ctx);
+	return 0;
+}
+
+/* the one inode of nullfs is shared by every holder, so no locks on it */
+static int nullfs_nolock(struct file *file, int cmd, struct file_lock *fl)
+{
+	return -ENOLCK;
+}
+
+/* what libfs gives an empty directory, plus the refusal of file locks */
+static const struct file_operations nullfs_dir_operations = {
+	.llseek		= nullfs_dir_llseek,
+	.read		= generic_read_dir,
+	.iterate_shared	= nullfs_dir_readdir,
+	.fsync		= noop_fsync,
+	.lock		= nullfs_nolock,
+	.flock		= nullfs_nolock,
+};
+
 static int nullfs_fs_fill_super(struct super_block *s, struct fs_context *fc)
 {
 	struct inode *inode;
@@ -28,6 +56,7 @@ static int nullfs_fs_fill_super(struct super_block *s, struct fs_context *fc)
 
 	/* nullfs is permanently empty... */
 	make_empty_dir_inode(inode);
+	inode->i_fop = &nullfs_dir_operations;
 	simple_inode_init_ts(inode);
 	inode->i_ino	= 1;
 	/* ... and immutable, reading it leaves no trace either. */
-- 
2.53.0



