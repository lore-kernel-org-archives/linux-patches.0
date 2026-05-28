Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB71257854;
	Thu, 28 May 2026 20:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999348; cv=none; b=A0+pgkOXKPm38UXGobZKV4w5NCN0spT5evWtjAsXdWdNqvDjGxt0Q/+GyN+9DvJhoIOgLgeu2m2q28qUPkynepnkEkLpRpFLKjPs53mljwpHZlOeR6HfQsbFSPZLeLYm35L1gJKzq1ET5QWtUuctdfaAFtDS79+ON4bF08gpJjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999348; c=relaxed/simple;
	bh=3QkunMW9uKVjVv6SrnJzAHiAXKHuXDWHSpFfw879swE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l9kryyKWBMBe3WTrGLcjY3tNnA3tRlUThHVGSCdGv/MhnvWAhZz9u1ovYd30lcm7tCGPsKux6x1v6e77Crw5MxT2B0R6ptQ4emKWyeLC1m6TW9jC27aqZskyD+2ZMnen4jP9oxEE1mC1qPcwaFLQEcdhnYzh/pfJSuqDY2VWXvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oz8kChi6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oz8kChi6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2841F000E9;
	Thu, 28 May 2026 20:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999347;
	bh=EBxLRaUQQv+29W0ybMO2Q1zvwu9wF7nltzpIVZ1IVNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oz8kChi6XeC39t2cHuaOG646VCXQEoskn2JoonusBu67oLnDZwO/YWtUK5fm8fRiG
	 TG33440vebkaQ+GOL823xkX+3o5lXjAdSErNmDIqq71vdDCAye2dz67ypXr9VzdUbc
	 qdd+Hr6SUm45dkdFjadjTihACsNPRCPU8NF4Okjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fdebb2dc960aa56c600a@syzkaller.appspotmail.com,
	Luis Henriques <luis@igalia.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 004/377] fuse: fix uninit-value in fuse_dentry_revalidate()
Date: Thu, 28 May 2026 21:44:02 +0200
Message-ID: <20260528194638.511441863@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Luis Henriques <luis@igalia.com>

commit 5a6baf204610589f8a5b5a1cd69d1fe661d9d3cd upstream.

fuse_dentry_revalidate() may be called with a dentry that didn't had
->d_time initialised.  The issue was found with KMSAN, where lookup_open()
calls __d_alloc(), followed by d_revalidate(), as shown below:

=====================================================
BUG: KMSAN: uninit-value in fuse_dentry_revalidate+0x150/0x13d0 fs/fuse/dir.c:394
 fuse_dentry_revalidate+0x150/0x13d0 fs/fuse/dir.c:394
 d_revalidate fs/namei.c:1030 [inline]
 lookup_open fs/namei.c:4405 [inline]
 open_last_lookups fs/namei.c:4583 [inline]
 path_openat+0x1614/0x64c0 fs/namei.c:4827
 do_file_open+0x2aa/0x680 fs/namei.c:4859
[...]

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:4466 [inline]
 slab_alloc_node mm/slub.c:4788 [inline]
 kmem_cache_alloc_lru_noprof+0x382/0x1280 mm/slub.c:4807
 __d_alloc+0x55/0xa00 fs/dcache.c:1740
 d_alloc_parallel+0x99/0x2740 fs/dcache.c:2604
 lookup_open fs/namei.c:4398 [inline]
 open_last_lookups fs/namei.c:4583 [inline]
 path_openat+0x135f/0x64c0 fs/namei.c:4827
 do_file_open+0x2aa/0x680 fs/namei.c:4859
[...]
=====================================================

Reported-by: syzbot+fdebb2dc960aa56c600a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69917e0d.050a0220.340abe.02e2.GAE@google.com
Fixes: 2396356a945b ("fuse: add more control over cache invalidation behaviour")
Signed-off-by: Luis Henriques <luis@igalia.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dir.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index ecaec0fea3a13..1bc6982b5d6aa 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -283,21 +283,33 @@ static int fuse_dentry_revalidate(struct inode *dir, const struct qstr *name,
 	goto out;
 }
 
-#if BITS_PER_LONG < 64
 static int fuse_dentry_init(struct dentry *dentry)
 {
+	int ret = 0;
+
+	/*
+	 * Initialising d_time (epoch) to '0' ensures the dentry is invalid
+	 * if compared to fc->epoch, which is initialized to '1'.
+	 */
+	dentry->d_time = 0;
+
+#if BITS_PER_LONG < 64
 	dentry->d_fsdata = kzalloc(sizeof(union fuse_dentry),
 				   GFP_KERNEL_ACCOUNT | __GFP_RECLAIMABLE);
 
-	return dentry->d_fsdata ? 0 : -ENOMEM;
+	ret = dentry->d_fsdata ? 0 : -ENOMEM;
+#endif
+
+	return ret;
 }
 static void fuse_dentry_release(struct dentry *dentry)
 {
+#if BITS_PER_LONG < 64
 	union fuse_dentry *fd = dentry->d_fsdata;
 
 	kfree_rcu(fd, rcu);
-}
 #endif
+}
 
 static int fuse_dentry_delete(const struct dentry *dentry)
 {
@@ -331,10 +343,8 @@ static struct vfsmount *fuse_dentry_automount(struct path *path)
 const struct dentry_operations fuse_dentry_operations = {
 	.d_revalidate	= fuse_dentry_revalidate,
 	.d_delete	= fuse_dentry_delete,
-#if BITS_PER_LONG < 64
 	.d_init		= fuse_dentry_init,
 	.d_release	= fuse_dentry_release,
-#endif
 	.d_automount	= fuse_dentry_automount,
 };
 
-- 
2.53.0



