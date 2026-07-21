Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB933F2101;
	Tue, 21 Jul 2026 18:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660034; cv=none; b=SHoKcxhG6X3mMk//T8Ndpj/1MWMO/rpgtqwau8Ar6tXdjhIY8Uh2hZu4F2w82AkZJ3n5W/II19ROk45/LsnGlr9buCCttOQG15z59N1PUNbGDonBDIDZj8sr5awLoDfVikhTh9zD/EWaJ/wxLE3HRdcumvbTS+mFk6qYMlT8MLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660034; c=relaxed/simple;
	bh=ff11rDfpePL/nsnkKs+AQs3GpKsT0ZoCqX3zEBNhW8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d2pGyam+BO6gOQVXLO3du3FhRnttO0JOyuZ4QPiFQWZisY/g05QOc3GsnkbTNBFU/oNJ9Gdc/rCuFU0E6MTL4C4Om879+aFBxW9d+YEp9GbWAGJ22FhK3RPkTXDGJX1VNh4m26UBsFj2yMy/UKr52+v+Okl4X0K8an5UI0BI/z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PP7gKm7r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PP7gKm7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375FD1F000E9;
	Tue, 21 Jul 2026 18:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660032;
	bh=Ue9I2RSNGGi5eAf3qrQBOx15UhhwA6FEM7XHgwnxqtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PP7gKm7rpsOq8hVywEQJkzAPI3ynoNtaz5YIuZuFiMWcRJmUORKZZRrvbgJ8wAxS3
	 Ae1bt49rJE0q8km48SwsbHnErSwEjOWZTjU31LQsX6gE2D/WVj6bHxff4ke0AKcU1q
	 jRkh1BUyYMB7FV4ISsjig19ehLKF6UC/2nsNoSHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b225d4dfce6219600c42@syzkaller.appspotmail.com,
	Aleksandr Nogikh <nogikh@google.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Joseph Qi <jiangqi903@gmail.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0824/2077] ocfs2: fix circular locking dependency in ocfs2_dio_end_io_write
Date: Tue, 21 Jul 2026 17:08:17 +0200
Message-ID: <20260721152612.222438424@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Nogikh <nogikh@google.com>

[ Upstream commit ff6f26c58421614b02694ac9d219ac61d924bc68 ]

A circular locking dependency involves INODE_ALLOC_SYSTEM_INODE,
EXTENT_ALLOC_SYSTEM_INODE, and ORPHAN_DIR_SYSTEM_INODE.

1. ocfs2_mknod() acquires INODE_ALLOC then EXTENT_ALLOC.

2. ocfs2_dio_end_io_write() acquires EXTENT_ALLOC for unwritten
   extents, then ORPHAN_DIR via ocfs2_del_inode_from_orphan() while still
   holding EXTENT_ALLOC.

3. ocfs2_wipe_inode() acquires ORPHAN_DIR then INODE_ALLOC via
   ocfs2_remove_inode.

Break the cycle in ocfs2_dio_end_io_write() by freeing the allocation
contexts (releasing EXTENT_ALLOC) before acquiring ORPHAN_DIR.

WARNING: possible circular locking dependency detected
------------------------------------------------------
is trying to acquire lock:
ffff8881e78b33a0
(&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at:
ocfs2_evict_inode+0x1539/0x43b0 fs/ocfs2/inode.c:1299

but task is already holding lock:
ffff8881e78b4fa0
(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at:
ocfs2_evict_inode+0xe97/0x43b0 fs/ocfs2/inode.c:1299

the existing dependency chain (in reverse order) is:

-> #2 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}:
       inode_lock include/linux/fs.h:1029 [inline]
       ocfs2_del_inode_from_orphan+0x12e/0x7a0 fs/ocfs2/namei.c:2728
       ocfs2_dio_end_io+0xf9c/0x1370 fs/ocfs2/aops.c:2418
       dio_complete+0x25b/0x790 fs/direct-io.c:281

-> #1 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       inode_lock include/linux/fs.h:1029 [inline]
       ocfs2_reserve_suballoc_bits+0x16d/0x4840 fs/ocfs2/suballoc.c:882
       ocfs2_reserve_new_metadata_blocks+0x415/0x9a0
       fs/ocfs2/suballoc.c:1078
       ocfs2_mknod+0x10f3/0x2260 fs/ocfs2/namei.c:351

-> #0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
       down_write+0x96/0x200 kernel/locking/rwsem.c:1625
       inode_lock include/linux/fs.h:1029 [inline]
       ocfs2_remove_inode fs/ocfs2/inode.c:733 [inline]
       ocfs2_wipe_inode fs/ocfs2/inode.c:896 [inline]
       ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
       ocfs2_evict_inode+0x1539/0x43b0 fs/ocfs2/inode.c:1299

Chain exists of:
  &ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE] -->
  &ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE] -->
  &ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
                               lock(&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);
                               lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
  lock(&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]);

 *** DEADLOCK ***

Link: https://lore.kernel.org/97c902a6-3bcf-43ea-9b70-f1f136a6c3f2@mail.kernel.org
Fixes: d647c5b2fbf8 ("ocfs2: split transactions in dio completion to avoid credit exhaustion")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+b225d4dfce6219600c42@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b225d4dfce6219600c42
Link: https://syzkaller.appspot.com/ai_job?id=0b53ce1e-2972-4192-aa85-8097a702762c
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/aops.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 6ec198bdab1211..4acdbb70882cdf 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2372,6 +2372,15 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 unlock:
 	up_write(&oi->ip_alloc_sem);
 
+	if (data_ac) {
+		ocfs2_free_alloc_context(data_ac);
+		data_ac = NULL;
+	}
+	if (meta_ac) {
+		ocfs2_free_alloc_context(meta_ac);
+		meta_ac = NULL;
+	}
+
 	/* everything looks good, let's start the cleanup */
 	if (!ret && dwc->dw_orphaned) {
 		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
@@ -2383,10 +2392,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
 out:
-	if (data_ac)
-		ocfs2_free_alloc_context(data_ac);
-	if (meta_ac)
-		ocfs2_free_alloc_context(meta_ac);
 	ocfs2_run_deallocs(osb, &dealloc);
 	ocfs2_dio_free_write_ctx(inode, dwc);
 
-- 
2.53.0



