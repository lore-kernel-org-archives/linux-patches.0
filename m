Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE719388371;
	Sat, 17 Oct 2026 15:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252509; cv=none; b=q62KKalrzOwhfxtxp4rHelDl2IhxgrrHoVI2Jy0RJX0492JNS+n8mUEe+esdGiqpEJAEvJRaUVmg7QGlVrSyCEtm2KoUSY8b2ioCy0EpIg5PS35tWbConXMcG/NUsxOyWBVPVHUgE+OYDo6s7dfw8oJsJMSvZ453GGZilBraW5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252509; c=relaxed/simple;
	bh=HIHV+sQSkf7ZRsKIImJf7be5E+XFifwmb5z6Q7fl76M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzdHpsEna0xV9pt/bNFiqax7LzTUaK6ZYB+Yeh3kEZ7DsK63nQ/BqSP4PeGCtMWTZpyrUrVZ6+NSRFoiO9stTBfl+OaCUKTahMsMUzTxxmkL80pwZOrM2AXXthz1D/RpbhGxKR3fnX2D1ZU/8zpVmyft76RfCVKGky7sEooV6eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kTfx9RKe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kTfx9RKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC98E1F000C4;
	Sat, 17 Oct 2026 15:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252508;
	bh=HgfUVYL/il9ntcvlZdTUrTahyNk5GpQpXZnU7nLTx20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kTfx9RKeP5lcrHA9WNqVGJ5ZWFNbzrG8kDaTIBQxPulPXmyg4tpf1z+0yfNeaM4RY
	 wixmvPqKBDbS4D1U89wDZBqjyHnd+tpmsk6Cn5bndQiffOTDmkKr8+aHLvSCRQU7V4
	 2kpOlncJblZ6lFXBhRWElAe8qKy6mqen9FGI2Yd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 06/10] readdir: take no inode lock on an immutable directory
Date: Sat, 17 Oct 2026 17:54:35 +0200
Message-ID: <20261017155059.923953476@linuxfoundation.org>
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

[ Upstream commit e08f57a7dcb83818c058e415988c23beb6c5a47f ]

iterate_dir() takes the directory's i_rwsem shared and holds it across
->iterate_shared(). For a directory that never has an entry and is
never removed the lock keeps nothing still, it only orders every reader
and every writer of that inode behind each other.

For the directory of a nullfs instance that matters. The instance of
the initial mount namespace is the root of every empty mount namespace
and the private instance is the root of every kernel thread, so one
inode is shared across users who have nothing else in common. And a
reader can hold the lock for as long as it likes: back the getdents()
buffer with a mapping of a file on a FUSE mount of your own, let the
copy of "." and ".." fault and let the server wait. Queue an exclusive
taker behind it, a mkdir() in that directory goes through start_dirop()
before the read-only mount is reported, and from then on every lookup
that misses the dcache in that directory, every create and every mount
on it waits until the server answers. One user of an empty mount
namespace stalls all the others.

Add FOP_IMMUTABLE for the file operations of a directory that never
changes and is never removed and let iterate_dir() skip the lock for
it. The flag never changes for a file, ->f_pos is protected by
f_pos_lock since directories are FMODE_ATOMIC_POS, IS_DEADDIR can't be
set on such a directory and neither touch_atime() nor fsnotify take
i_rwsem. Set it on the nullfs directory. The placeholder directories of
libfs never have an entry either but their owners remove them, so they
keep the lock.

Fixes: 9d4e752a24f7 ("namespace: allow creating empty mount namespaces")
Cc: stable@vger.kernel.org # v7.1+
Link: https://patch.msgid.link/20261002-work-mount-fixes-4-v1-19-dd44b89d44ce@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nullfs.c        |  1 +
 fs/readdir.c       | 13 +++++++++----
 include/linux/fs.h |  2 ++
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/nullfs.c b/fs/nullfs.c
index fc79ca42bb178..c89181daf208c 100644
--- a/fs/nullfs.c
+++ b/fs/nullfs.c
@@ -34,6 +34,7 @@ static const struct file_operations nullfs_dir_operations = {
 	.fsync		= noop_fsync,
 	.lock		= nullfs_nolock,
 	.flock		= nullfs_nolock,
+	.fop_flags	= FOP_IMMUTABLE,
 };
 
 static int nullfs_fs_fill_super(struct super_block *s, struct fs_context *fc)
diff --git a/fs/readdir.c b/fs/readdir.c
index 76bb1ae3a4504..f2288841337ad 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -87,6 +87,8 @@ EXPORT_SYMBOL(wrap_directory_iterator);
 int iterate_dir(struct file *file, struct dir_context *ctx)
 {
 	struct inode *inode = file_inode(file);
+	/* never an entry, never removed: nothing for the lock to keep still */
+	bool locked = !(file->f_op->fop_flags & FOP_IMMUTABLE);
 	int res = -ENOTDIR;
 
 	if (!file->f_op->iterate_shared)
@@ -100,9 +102,11 @@ int iterate_dir(struct file *file, struct dir_context *ctx)
 	if (res)
 		goto out;
 
-	res = down_read_killable(&inode->i_rwsem);
-	if (res)
-		goto out;
+	if (locked) {
+		res = down_read_killable(&inode->i_rwsem);
+		if (res)
+			goto out;
+	}
 
 	res = -ENOENT;
 	if (!IS_DEADDIR(inode)) {
@@ -112,7 +116,8 @@ int iterate_dir(struct file *file, struct dir_context *ctx)
 		fsnotify_access(file);
 		file_accessed(file);
 	}
-	inode_unlock_shared(inode);
+	if (locked)
+		inode_unlock_shared(inode);
 out:
 	return res;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 09de7bf6f1d28..a07031fd4ae24 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1980,6 +1980,8 @@ struct file_operations {
 #define FOP_ASYNC_LOCK		((__force fop_flags_t)(1 << 6))
 /* File system supports uncached read/write buffered IO */
 #define FOP_DONTCACHE		((__force fop_flags_t)(1 << 7))
+/* Never changes and is never removed, readdir of a directory takes no lock */
+#define FOP_IMMUTABLE		((__force fop_flags_t)(1 << 8))
 
 /* Wrap a directory iterator that needs exclusive inode access */
 int wrap_directory_iterator(struct file *, struct dir_context *,
-- 
2.53.0



