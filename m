Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1A246D543;
	Tue, 21 Jul 2026 15:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648945; cv=none; b=aEtauY8e/Qpj2ojco0SQ/sPBTIoawKQQIBWUkplZVp7nqgzCIPm2OryUHTZTIRD9MsCiJIVq51koYBvL1BsjYO/hEMx4iQ4i/chkP9vysXeb8rDMcOmJCfOmZ/Iv/jamYVpzWb34AiQvTVoEuN3BPgqA5K5a0rhsVWVlUXjhSGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648945; c=relaxed/simple;
	bh=rOOuq1DxXRs2pmUoHWRgWd4Y9J9OWyvGEw8dV3Bpo9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZ0fiSIyWqlr4QZcN+zhEiWJb+I3aLI+yxAM0r3SMcnjaBm+4uSMWsatuwSmfsmKrkRtBI7sbItt8+NYMWzmD4Bn5V1NU/cz/OX+HfxnCAVAj68a+YrQah0PduaZzadBxFTGBW3PRl4Oxj1qz4aJAo2Kaq6gHaB4t/h5Z6L93OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X77yIOdY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X77yIOdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0161F000E9;
	Tue, 21 Jul 2026 15:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648944;
	bh=u50VVOgT2vFxoAX1SIy+I2F9Y08u31D+2XhfNQZDgi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X77yIOdYok8d8AkyTaus9eGgZvkfsnslWWJYoLimwfWThKDmCdxtAOak8oSWFUUPC
	 cIh27+oPbCP/RdTJNNMnnDoIX/XYJYHGs0PgOu9nwud4ir3JvY4E9N3jt4Al8xf/jO
	 c7QRWSd9d6stig7p0ljHWX1SjaI9WoU1QX8xCGvw=
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
Subject: [PATCH 7.1 0364/2077] ocfs2: kill osb->system_file_mutex lock
Date: Tue, 21 Jul 2026 17:00:37 +0200
Message-ID: <20260721152601.273534167@linuxfoundation.org>
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
index 7b50e03dfa664a..62cad6522c7a31 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -494,8 +494,6 @@ struct ocfs2_super
 	struct rb_root	osb_rf_lock_tree;
 	struct ocfs2_refcount_tree *osb_ref_tree_lru;
 
-	struct mutex system_file_mutex;
-
 	/*
 	 * OCFS2 needs to schedule several different types of work which
 	 * require cluster locking, disk I/O, recovery waits, etc. Since these
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index b875f01c97564d..6dd45c2153f88e 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1997,8 +1997,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	spin_lock_init(&osb->osb_xattr_lock);
 	ocfs2_init_steal_slots(osb);
 
-	mutex_init(&osb->system_file_mutex);
-
 	atomic_set(&osb->alloc_stats.moves, 0);
 	atomic_set(&osb->alloc_stats.local_data, 0);
 	atomic_set(&osb->alloc_stats.bitmap_data, 0);
diff --git a/fs/ocfs2/sysfile.c b/fs/ocfs2/sysfile.c
index d53a6cc866bef6..67e492f4b828b6 100644
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



