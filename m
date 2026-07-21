Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F54544AB62;
	Tue, 21 Jul 2026 22:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671515; cv=none; b=g2x9kndch8qYM+hglN2qErTjPX9wEnB0Cda9DkzXFkA+IzaKk1604ebBA7joC5+1CUmp5r/fM6vSRHBBdcDTp6t6X4vNk9AiKuYIVk9+8NKy+Cf7TeXe3AOIagAMNAcLbgrCM+qekeFOaJk7r3dpO6uIE5G9FRnEICega3M3ow0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671515; c=relaxed/simple;
	bh=No19bW8C5XppNi/W24R33VL1X9CEoAlVMTIffu3Y6qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lanBMvB6ydK1h2wBktlf66wWCF2Wwj3xJ7s13m4a2fvoC7x91NfFeyyYvAFI4GLylineQB3mZzGSigmoSL4YSdC4ruzN6ciBI3TMKuNG/DaF3/TJ+46H1Nljyn8n09UAgZkVH99ORWSHdHut+hOHFzbqA1Seldq2KjT+A0k2WlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aSmOq3Ka; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aSmOq3Ka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF4F1F000E9;
	Tue, 21 Jul 2026 22:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671514;
	bh=5Jh9g/nkLHsf28YciHJJOap2DgXpHOINm4eXbaiwNCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aSmOq3Ka93+H4rsB0GuGBmv2uXboTrJq7TanQyxJl2HwqVEpE5zTzCCgYRMw+zf/c
	 hKG4DtwtHU9qanGxRSnRy0MOJcP+0nWPpp/FQ3iq7BC7811fezqzYy847rKcNP5E3e
	 dpnvYW7+x1i+bj2BgspU0XMMqJW5xvGw7t/M+PG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Heming Zhao <heming.zhao@suse.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 276/843] ocfs2: kill osb->system_file_mutex lock
Date: Tue, 21 Jul 2026 17:18:31 +0200
Message-ID: <20260721152412.234350514@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit f5b1910e23f1233c8d4185268b2e659df2bc5dbf ]

Commit 43b10a20372d ("ocfs2: avoid system inode ref confusion by adding
mutex lock") tried to avoid a refcount leak caused by allowing multiple
threads to call igrab(inode).  But addition of osb->system_file_mutex made
locking dependency complicated and is causing lockdep to warn about
possibility of AB-BA deadlock.

Since _ocfs2_get_system_file_inode() returns the same inode for the same
input arguments, we don't need to serialize
_ocfs2_get_system_file_inode().  What we need to make sure is that
igrab(inode) is called for only once().  Therefore, replace
osb->system_file_mutex with cmpxchg()-based locking.

Link: https://lore.kernel.org/fea8d1fd-afb0-4302-a560-c202e2ef7afd@I-love.SAKURA.ne.jp
Fixes: 43b10a20372d ("ocfs2: avoid system inode ref confusion by adding mutex lock")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/ocfs2.h   | 2 --
 fs/ocfs2/super.c   | 2 --
 fs/ocfs2/sysfile.c | 9 +++------
 3 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 22882c636bfb89..9de838f1ac555d 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -467,8 +467,6 @@ struct ocfs2_super
 	struct rb_root	osb_rf_lock_tree;
 	struct ocfs2_refcount_tree *osb_ref_tree_lru;
 
-	struct mutex system_file_mutex;
-
 	/*
 	 * OCFS2 needs to schedule several different types of work which
 	 * require cluster locking, disk I/O, recovery waits, etc. Since these
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index bb174009206e71..eba75b608cccac 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2058,8 +2058,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	spin_lock_init(&osb->osb_xattr_lock);
 	ocfs2_init_steal_slots(osb);
 
-	mutex_init(&osb->system_file_mutex);
-
 	atomic_set(&osb->alloc_stats.moves, 0);
 	atomic_set(&osb->alloc_stats.local_data, 0);
 	atomic_set(&osb->alloc_stats.bitmap_data, 0);
diff --git a/fs/ocfs2/sysfile.c b/fs/ocfs2/sysfile.c
index 53a945da873bc0..b63af8d64904a2 100644
--- a/fs/ocfs2/sysfile.c
+++ b/fs/ocfs2/sysfile.c
@@ -98,11 +98,9 @@ struct inode *ocfs2_get_system_file_inode(struct ocfs2_super *osb,
 	} else
 		arr = get_local_system_inode(osb, type, slot);
 
-	mutex_lock(&osb->system_file_mutex);
 	if (arr && ((inode = *arr) != NULL)) {
 		/* get a ref in addition to the array ref */
 		inode = igrab(inode);
-		mutex_unlock(&osb->system_file_mutex);
 		BUG_ON(!inode);
 
 		return inode;
@@ -112,11 +110,10 @@ struct inode *ocfs2_get_system_file_inode(struct ocfs2_super *osb,
 	inode = _ocfs2_get_system_file_inode(osb, type, slot);
 
 	/* add one more if putting into array for first time */
-	if (arr && inode) {
-		*arr = igrab(inode);
-		BUG_ON(!*arr);
+	if (inode && arr && !*arr && !cmpxchg(&(*arr), NULL, inode)) {
+		inode = igrab(inode);
+		BUG_ON(!inode);
 	}
-	mutex_unlock(&osb->system_file_mutex);
 	return inode;
 }
 
-- 
2.53.0



