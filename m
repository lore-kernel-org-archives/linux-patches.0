Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F1F7474
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBA0C433EF;
	Tue, 10 Jan 2023 18:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375700;
	bh=9baCp2m3s7/PPep/alrLW0G6tVleKuOWzUhYvU2Rg7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cmvk89Vm2tKmPWLyzFHZlMWutfQ9l0qrg9wgZk91WDPAFOVwpECK4UyElbdGyTv9W
	 gTt9kybZBNMPkGqp7cYEOp40Nlw5s4l0L3zYcyLGkgGmGKgO0RK2Sw62R0zO71VKjr
	 9MytqVRONBM4o4wMY152fIREYT4AnZLAaOVPi67o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 242/290] ceph: switch to vfs_inode_has_locks() to fix file lock bug
Date: Tue, 10 Jan 2023 19:05:34 +0100
Message-Id: <20230110180040.366260296@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit 461ab10ef7e6ea9b41a0571a7fc6a72af9549a3c ]

For the POSIX locks they are using the same owner, which is the
thread id. And multiple POSIX locks could be merged into single one,
so when checking whether the 'file' has locks may fail.

For a file where some openers use locking and others don't is a
really odd usage pattern though. Locks are like stoplights -- they
only work if everyone pays attention to them.

Just switch ceph_get_caps() to check whether any locks are set on
the inode. If there are POSIX/OFD/FLOCK locks on the file at the
time, we should set CHECK_FILELOCK, regardless of what fd was used
to set the lock.

Fixes: ff5d913dfc71 ("ceph: return -EIO if read/write against filp that lost file locks")
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c  | 2 +-
 fs/ceph/locks.c | 4 ----
 fs/ceph/super.h | 1 -
 3 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index be96fe615bec..67b782b0a90a 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2872,7 +2872,7 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
 
 	while (true) {
 		flags &= CEPH_FILE_MODE_MASK;
-		if (atomic_read(&fi->num_locks))
+		if (vfs_inode_has_locks(inode))
 			flags |= CHECK_FILELOCK;
 		_got = 0;
 		ret = try_get_cap_refs(inode, need, want, endoff,
diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
index bdeb271f47d9..3e3b8be76b21 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -32,18 +32,14 @@ void __init ceph_flock_init(void)
 
 static void ceph_fl_copy_lock(struct file_lock *dst, struct file_lock *src)
 {
-	struct ceph_file_info *fi = dst->fl_file->private_data;
 	struct inode *inode = file_inode(dst->fl_file);
 	atomic_inc(&ceph_inode(inode)->i_filelock_ref);
-	atomic_inc(&fi->num_locks);
 }
 
 static void ceph_fl_release_lock(struct file_lock *fl)
 {
-	struct ceph_file_info *fi = fl->fl_file->private_data;
 	struct inode *inode = file_inode(fl->fl_file);
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	atomic_dec(&fi->num_locks);
 	if (atomic_dec_and_test(&ci->i_filelock_ref)) {
 		/* clear error when all locks are released */
 		spin_lock(&ci->i_ceph_lock);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 14f951cd5b61..8c9021d0f837 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -773,7 +773,6 @@ struct ceph_file_info {
 	struct list_head rw_contexts;
 
 	u32 filp_gen;
-	atomic_t num_locks;
 };
 
 struct ceph_dir_file_info {
-- 
2.35.1



