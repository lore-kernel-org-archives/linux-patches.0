Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622065;
	b=l+jPAxwx0HLLg5s++YJkGWJSbcRjasQTg5GawC7ayIYHyDSbIeWjLRZE/6qvuBdmdbol
	 DJzgt219HtJCAqF6vB3wA8eKdFBB2aQtt0JQsJbQdJ8sbmSYsuy1COiqGRqgPsjZCAGMw
	 IK55i5gxSsbs3Qdzr8Ba8oNCcCxG+VJESvW+cg14KhP5bHlYAGQsTR+hqnkjSOIZv3b/Y
	 JTRdd4GLNdp/hMGJsi0hx5FYVxmFCjRgQK8qowP1PMg6/TKKG5CLV+C42I84yc6twLQZm
	 dbI2JUMBXTUFj1OToYo2Z6cB5C+qBkBzam/6EApxWRe2wXptKohw14GDBtPyEWxmtbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622065;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dx3zT5FacfObAkg/R4tUXW3owfL9W7WM+lMOyY+ui8s=;
	b=DzHfj3WL2OTI6DwE72d7HsT80yiIhoXe0PnJEx1Exs9oQGfWCjLb0V0HuAko65phMEI9
	 g064r4R2szy210VxmbdhCE1bYgSBYNehq2AB/l3pRYqDl2T6LAfGmPgZkxp8CXOBBAS+f
	 iRiZEj76/pZUsWZ+O6AMzaUdE16ntxrsnUygmqJK0FvaZ95oWDyRIcznSYSOof7Onta6F
	 635aoAyXZcRDvIcuMKgIR01NYnZ/rfTWVyxdeu00kPzVC3n1t4IhE4VV8ByeZ23OEfBT3
	 tB9WbkDNT5GRnpUqk5E916M3wiyMZ/aqnW2g46Q5jhIBsXUaDRalrjKYkyAnV3pBXhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1RM5CrEX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C649606A32D;
	Wed, 25 Nov 2026 15:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1RM5CrEX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FA71F00A3D;
	Wed, 25 Nov 2026 15:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622065;
	bh=Dx3zT5FacfObAkg/R4tUXW3owfL9W7WM+lMOyY+ui8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1RM5CrEXfOOK8NiJAeWyc2TeG12ErFewttt3Yer86jQPCVVXiLpeuxWXswIhxqRAo
	 gNqajBlYbkYzvb/yI+ZPkLisIbKXGMWhZtAfUkH38ep2/dCVaIK9pSUHgaxezc7OKS
	 lJmPeBphmTs9lzrx7Ur+No+ssy5VSQsZwmMGfVO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	"Denis V. Lunev" <den@openvz.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 419/990] ovl: release the upperdir/workdir in-use locks before the umount sync
Date: Wed, 25 Nov 2026 15:29:46 +0100
Message-ID: <20261125143831.913946477@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis V. Lunev <den@openvz.org>

[ Upstream commit cb6c084182d4c69b7eeff0bd519dd7e018749602 ]

The in-use locks on upperdir and workdir are released by ovl_free_fs()
from ->put_super(). generic_shutdown_super() calls sync_filesystem()
before that, and ovl_sync_fs() syncs the whole upper filesystem, so the
locks stay held across a journal commit and a cache flush of the upper
fs after the overlay is gone. With index=on a new overlay that uses the
same upperdir, or uses it as a lowerdir, fails to mount in that window:

  overlayfs: upperdir is in-use as upperdir/workdir of another mount,
  mount with '-o index=off' to override exclusive upperdir protection.

Userspace hits this when the last reference is not dropped by umount(2)
itself. Docker with the containerd snapshotter mounts a snapshot on a
thread with a private mount namespace for docker cp and for buildkit,
and the superblock dies when that thread exits, after the reply to the
client has gone out. The next request then gets EBUSY. The window grows
with the flush latency of the upper fs and is there even if nothing was
written through the overlay, as the mount itself dirties the upper.

->kill_sb() is called once s_active drops to zero, with no mount and no
open file left. Release the locks there, before generic_shutdown_super()
runs. What the dying superblock still does to the upper fs, the sync and
dropping its references to upper dentries and inodes, does not touch the
contents of upperdir or workdir. ovl_free_fs() still releases the locks
for a failed mount, so clear the *_locked flags to keep it from
unlocking a second time and dropping the lock of a newer mount.

This takes the sync out of the window but does not close it: the final
mntput of a dying mount namespace runs from task_work, after the exiting
thread may have reported completion. Userspace that needs the
directories free should umount(2) before saying the job is done.

Fixes: 2cac0c00a6cd ("ovl: get exclusive ownership on upper/work dirs")
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Signed-off-by: Denis V. Lunev <den@openvz.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/params.c    |  5 +----
 fs/overlayfs/super.c     | 12 +++++++++++-
 fs/overlayfs/util.c      | 12 ++++++++++++
 4 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 7bd69773f33c9..a0a5f18b5f77d 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -575,6 +575,7 @@ static inline int ovl_set_impure_dir(struct dentry *dentry)
 bool ovl_inuse_trylock(struct dentry *dentry);
 void ovl_inuse_unlock(struct dentry *dentry);
 bool ovl_is_inuse(struct dentry *dentry);
+void ovl_inuse_unlock_all(struct ovl_fs *ofs);
 bool ovl_need_index(struct dentry *dentry);
 int ovl_nlink_start(struct dentry *dentry);
 void ovl_nlink_end(struct dentry *dentry);
diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 7d8bc6d3863c1..fc39caf0e4993 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -842,15 +842,12 @@ void ovl_free_fs(struct ovl_fs *ofs)
 	struct vfsmount **mounts;
 	unsigned i;
 
+	ovl_inuse_unlock_all(ofs);
 	iput(ofs->workbasedir_trap);
 	iput(ofs->workdir_trap);
 	dput(ofs->whiteout);
 	dput(ofs->workdir);
-	if (ofs->workdir_locked)
-		ovl_inuse_unlock(ofs->workbasedir);
 	dput(ofs->workbasedir);
-	if (ofs->upperdir_locked)
-		ovl_inuse_unlock(ovl_upper_mnt(ofs)->mnt_root);
 
 	/* Reuse ofs->config.lowerdirs as a vfsmount array before freeing it */
 	mounts = (struct vfsmount **) ofs->config.lowerdirs;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 71ce12e203ea0..f3a0fc8e12c17 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1606,13 +1606,23 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 	return err;
 }
 
+static void ovl_kill_sb(struct super_block *sb)
+{
+	struct ovl_fs *ofs = OVL_FS(sb);
+
+	/* Nothing can modify them now, do not hold them across the sync */
+	if (ofs)
+		ovl_inuse_unlock_all(ofs);
+	kill_anon_super(sb);
+}
+
 struct file_system_type ovl_fs_type = {
 	.owner			= THIS_MODULE,
 	.name			= "overlay",
 	.init_fs_context	= ovl_init_fs_context,
 	.parameters		= ovl_parameter_spec,
 	.fs_flags		= FS_USERNS_MOUNT | FS_ALLOW_IDMAP,
-	.kill_sb		= kill_anon_super,
+	.kill_sb		= ovl_kill_sb,
 };
 MODULE_ALIAS_FS("overlay");
 
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index f75e8009fb15f..27928c9ea0eb8 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -1064,6 +1064,18 @@ bool ovl_is_inuse(struct dentry *dentry)
 	return inuse;
 }
 
+void ovl_inuse_unlock_all(struct ovl_fs *ofs)
+{
+	if (ofs->workdir_locked) {
+		ovl_inuse_unlock(ofs->workbasedir);
+		ofs->workdir_locked = false;
+	}
+	if (ofs->upperdir_locked) {
+		ovl_inuse_unlock(ovl_upper_mnt(ofs)->mnt_root);
+		ofs->upperdir_locked = false;
+	}
+}
+
 /*
  * Does this overlay dentry need to be indexed on copy up?
  */
-- 
2.53.0



