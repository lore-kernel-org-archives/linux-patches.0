Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033616;
	b=eiOzSy9P+yJ3jwb5hQPmAml8tCQHqbxtO4CxnHZeFqVRmZKKoepVFLt59rnLa+Li8ZJs
	 vXLjvTu+TnIdDtPMklw52JesaVBPMxU8jqWKcHGL1nH1/A6UP95u7rUs8X8Z6F3T3PvWR
	 ZNf2jDHzoKBOLTz5k5FwSxgUZQS0e36qaYnUNwVK4uh2/VBkta3ngXR3Cl/reWxgNebA6
	 nxgtVeD150Bg19V9V1bbaVT9zB2hkgWYv4lc9i7ZN9DML+knwfLuMje0gj3QOjUj7UK1L
	 IPxId05ejL0TXZupkhzeWvLbMM6wtuGe30zPK+BnV9XHkRFBD2TLi5kfXRg7tLYmjvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fYa//S8SC/VgnFa5psLJEzeJ1dc54Ivkp4ATj6JRqSI=;
	b=fn7GJ434Wtoaz7DofxbgPQ4n4gjEwoGmE3TJc7dYESc95ourD+xxA4JU8TYgKJILDmT6
	 nAGTcwrhCRBC1Pofqdt4o+E5+Z7InmlRnKfaOhwCJxinEDHOSKbnxLnqlt6EVmvLaVlVd
	 zAWHbEFxGCA0jsXzD5K4aSxkQ3ycAByvnArrhuKtcE/B7JTyZe8ymzIIYHGL6JOHrXpyT
	 Dy0BgZdKwhMsr5rUiuPkRrhqaWC7bpJtg0tOycXvcU/FMHlmSMRUECh1IhW73ijxEjc/4
	 kL1wdP3clqaj8wpPlje15Vhh9OwTfeuu0TsAss29N5q6II1Y8PxTvAzVS4NmgmFxdEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lVfboI2O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB36606A325;
	Wed, 18 Nov 2026 20:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lVfboI2O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B941F000C4;
	Wed, 18 Nov 2026 20:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033616;
	bh=fYa//S8SC/VgnFa5psLJEzeJ1dc54Ivkp4ATj6JRqSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lVfboI2OEC268WSAxGNbQDRDQol6XVQKUD3bDCaDmFVqSHmpd1ereDNZHKeOx93vR
	 yGbhmpzIzqwG03XYCByTOJbiZbTlI41rGafiEldxAbkzf/3HFykOQKtLvjPRfyvQ/z
	 DFT67PVYGtj6C39R24G9Qc8gwnzaTZ5TUt0Xo4Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6a680377e13041c19d50@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0079/3318] udf: avoid recursive s_alloc_mutex deadlock when freeing AED blocks
Date: Wed, 18 Nov 2026 15:11:41 +0100
Message-ID: <20261118150316.451720685@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit 31e5e0c8c8e2617eb9f7a20c1cf5df23f592ade2 ]

udf_table_prealloc_blocks() and udf_table_new_block() call
udf_delete_aext() on the unallocated-space-table inode while holding
sbi->s_alloc_mutex. When the deleted allocation descriptor empties an
allocation-extent (AED) block, udf_delete_aext() returns that block to
free space via udf_free_blocks(). For a table-managed partition that
path is udf_free_blocks() -> udf_table_free_blocks() ->
mutex_lock(&sbi->s_alloc_mutex), i.e. the task tries to acquire a mutex
it already holds.

On a PREEMPT_RT kernel the rtmutex deadlock detector reports this as
-EDEADLK:

  rtmutex deadlock detected
  WARNING: kernel/locking/rtmutex.c:1698 at rt_mutex_handle_deadlock
  udf_table_free_blocks fs/udf/balloc.c:376 [inline]
  udf_free_blocks+0xa8c/0x1900 fs/udf/balloc.c:678
  udf_delete_aext+0x4f5/0xc00 fs/udf/inode.c:2381
  udf_table_prealloc_blocks fs/udf/balloc.c:544 [inline]
  udf_prealloc_blocks+0xbd4/0x10e0 fs/udf/balloc.c:702

On a non-RT kernel the same path is a hard self-deadlock (or a lockdep
recursive-locking splat). It is reachable from a crafted UDF image via
the write/sendfile path.

The allocator already refuses to recurse on the add side: see the
comment in udf_table_free_blocks() explaining why it must not call
udf_add_aext() while holding s_alloc_mutex. Apply the same rule to the
delete side. Let udf_delete_aext() report the AED block it would
otherwise free through a new out-parameter, and have the two callers
that hold s_alloc_mutex free it after dropping the lock. The block is
already unlinked from the inode's descriptor chain by then, so nothing
can reference it in the meantime. All other callers pass NULL and keep
freeing the block inline, exactly as before.

The out-parameter is pre-initialised with the reserved partition number
0xFFFF, which can never name a real block, so the caller can tell
whether a block was handed back.

Reported-by: syzbot+6a680377e13041c19d50@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6a680377e13041c19d50
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Link: https://syzkaller.appspot.com/bug?extid=6a680377e13041c19d50
Link: https://patch.msgid.link/20260621035841.56194-1-kartikey406@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/balloc.c   | 12 ++++++++++--
 fs/udf/inode.c    | 19 ++++++++++++++++---
 fs/udf/truncate.c |  2 +-
 fs/udf/udfdecl.h  |  3 ++-
 4 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index e3bf8122b7dc1..e3a2d9426094b 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -519,6 +519,8 @@ static int udf_table_prealloc_blocks(struct super_block *sb,
 	int8_t etype = -1;
 	struct udf_inode_info *iinfo;
 	int ret = 0;
+	/* AED block freed by udf_delete_aext(), released after unlock */
+	struct kernel_lb_addr freed = { .partitionReferenceNum = 0xFFFF };
 
 	if (first_block >= sbi->s_partmaps[partition].s_partition_len)
 		return 0;
@@ -558,7 +560,7 @@ static int udf_table_prealloc_blocks(struct super_block *sb,
 			udf_write_aext(table, &epos, &eloc,
 					(etype << 30) | elen, 1);
 		} else
-			udf_delete_aext(table, epos);
+			udf_delete_aext(table, epos, &freed);
 	} else {
 		alloc_count = 0;
 	}
@@ -569,6 +571,8 @@ static int udf_table_prealloc_blocks(struct super_block *sb,
 	if (alloc_count)
 		udf_add_free_space(sb, partition, -alloc_count);
 	mutex_unlock(&sbi->s_alloc_mutex);
+	if (freed.partitionReferenceNum != 0xFFFF)
+		udf_free_blocks(sb, table, &freed, 0, 1);
 	return alloc_count;
 }
 
@@ -577,6 +581,8 @@ static udf_pblk_t udf_table_new_block(struct super_block *sb,
 			       uint32_t goal, int *err)
 {
 	struct udf_sb_info *sbi = UDF_SB(sb);
+	/* AED block freed by udf_delete_aext(), released after unlock */
+	struct kernel_lb_addr freed = { .partitionReferenceNum = 0xFFFF };
 	uint32_t spread = 0xFFFFFFFF, nspread = 0xFFFFFFFF;
 	udf_pblk_t newblock = 0;
 	uint32_t adsize;
@@ -660,12 +666,14 @@ static udf_pblk_t udf_table_new_block(struct super_block *sb,
 	if (goal_elen)
 		udf_write_aext(table, &goal_epos, &goal_eloc, goal_elen, 1);
 	else
-		udf_delete_aext(table, goal_epos);
+		udf_delete_aext(table, goal_epos, &freed);
 	brelse(goal_epos.bh);
 
 	udf_add_free_space(sb, partition, -1);
 
 	mutex_unlock(&sbi->s_alloc_mutex);
+	if (freed.partitionReferenceNum != 0xFFFF)
+		udf_free_blocks(sb, table, &freed, 0, 1);
 	*err = 0;
 	return newblock;
 }
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 55c55239f5e35..7e41dcc6c10d5 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1213,7 +1213,7 @@ static int udf_update_extents(struct inode *inode, struct kernel_long_ad *laarr,
 
 	if (startnum > endnum) {
 		for (i = 0; i < (startnum - endnum); i++)
-			udf_delete_aext(inode, *epos);
+			udf_delete_aext(inode, *epos, NULL);
 	} else if (startnum < endnum) {
 		for (i = 0; i < (endnum - startnum); i++) {
 			err = udf_insert_aext(inode, *epos,
@@ -2340,7 +2340,8 @@ static int udf_insert_aext(struct inode *inode, struct extent_position epos,
 	return ret;
 }
 
-int8_t udf_delete_aext(struct inode *inode, struct extent_position epos)
+int8_t udf_delete_aext(struct inode *inode, struct extent_position epos,
+			struct kernel_lb_addr *freed)
 {
 	struct extent_position oepos;
 	int adsize;
@@ -2390,7 +2391,19 @@ int8_t udf_delete_aext(struct inode *inode, struct extent_position epos)
 	elen = 0;
 
 	if (epos.bh != oepos.bh) {
-		udf_free_blocks(inode->i_sb, inode, &epos.block, 0, 1);
+		/*
+		 * The block that held the now-empty allocation extent must be
+		 * returned to free space.  When the caller already holds
+		 * s_alloc_mutex (the space-table allocator in balloc.c),
+		 * freeing it inline would recurse through udf_free_blocks()
+		 * into udf_table_free_blocks() and deadlock re-acquiring
+		 * s_alloc_mutex.  In that case report the block to the caller,
+		 *  which frees it after dropping the lock.
+		 */
+		if (freed)
+			*freed = epos.block;
+		else
+			udf_free_blocks(inode->i_sb, inode, &epos.block, 0, 1);
 		udf_write_aext(inode, &oepos, &eloc, elen, 1);
 		udf_write_aext(inode, &oepos, &eloc, elen, 1);
 		if (!oepos.bh) {
diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
index b4071c9cf8c95..da5a61306390c 100644
--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -159,7 +159,7 @@ void udf_discard_prealloc(struct inode *inode)
 
 	if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
 		lbcount -= elen;
-		udf_delete_aext(inode, prev_epos);
+		udf_delete_aext(inode, prev_epos, NULL);
 		udf_free_blocks(inode->i_sb, inode, &eloc, 0,
 				DIV_ROUND_UP(elen, bsize));
 	}
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index d159f20d61e89..db261d743b7f1 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -169,7 +169,8 @@ extern int udf_add_aext(struct inode *, struct extent_position *,
 			struct kernel_lb_addr *, uint32_t, int);
 extern void udf_write_aext(struct inode *, struct extent_position *,
 			   struct kernel_lb_addr *, uint32_t, int);
-extern int8_t udf_delete_aext(struct inode *, struct extent_position);
+extern int8_t udf_delete_aext(struct inode *, struct extent_position,
+			       struct kernel_lb_addr *);
 extern int udf_next_aext(struct inode *inode, struct extent_position *epos,
 			 struct kernel_lb_addr *eloc, uint32_t *elen,
 			 int8_t *etype, int inc);
-- 
2.53.0



