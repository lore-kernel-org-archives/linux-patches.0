Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5277D400994;
	Tue, 25 Aug 2026 13:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665773; cv=none; b=NBfqzaQ80RSYVmpwDMoFPCRUYpeDa4x859hEoq63mi6+Z06djiQKi9F08dlV6IceS0Q4UKxI/dfqtArmYsZRkix9GmfeHjfi5f0QLc25gi5JieRGjP2+z8/jy3PuYSO4/d5J4glaJFkFH8VuZDTGwX6dL+kjaZbxJJQ6o8/No5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665773; c=relaxed/simple;
	bh=Z5WvbPzWlxAXBWNOW3vYmuDsu4yN5jFr+MquY0TM0/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcg1VgyTxPgolhE8AN97abzQJ8lbG5VQkYxCaLfpJzv9Pp74cE3ExT+sgPTuax2nexsvtXc/2HvxFPDXx6KqpH7JQgRX77QdnMDAd1stGjgBG18DiLvH/n/QuTDVeRQkJdLiAmIHcJbAjXr+4J9fuSS1IQfF4ictpqsDMs2kMW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BxyuWlkU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BxyuWlkU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903EE1F000E9;
	Tue, 25 Aug 2026 13:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665772;
	bh=fwuieYzOp+zkykrPAY5tokGn0PoXIN6kFIURansbxjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BxyuWlkUsLkbpuz3Dj9aFqsw+sSYoHqeZwUYURrXJKuB54Z0rBiIHBG1j18v9s4ZQ
	 yPBw78it665XVIg94V190MNS8eh6vdgasUVUo0bDN+NuaolFX4avi1qf300Nv82zzj
	 ztyNU9zR4KkmZ5tNeH3sEm2K8+4DYeuCyLx8LbnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	syzbot+e538032956b1157914a3@syzkaller.appspotmail.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 23/87] ocfs2: fix missing metadata reservation for large xattrs
Date: Tue, 25 Aug 2026 15:25:46 +0200
Message-ID: <20260825132542.746739394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Bridges <icb@fastmail.org>

commit 0cdc7dde00ec63ac714271fa8b2918d630b8da1a upstream.

[BUG]
lsetxattr() panics the kernel when setting a large xattr value on a
fragmented filesystem where the file already has an external xattr
block.

[CAUSE]
ocfs2_calc_xattr_set_need() never reserves metadata blocks for a new
xattr value's extent tree when the file already has an external xattr
block. The not_found path leaves meta_add at zero, so meta_ac is NULL
when ocfs2_xattr_extend_allocation() runs.

A new value root has room for a single extent record. On a fragmented
filesystem, the allocator cannot satisfy the xattr value in one
contiguous run, so each non-contiguous run requires its own extent
record. When the value root's extent list is full and meta_ac is NULL,
ocfs2_add_clusters_in_btree() returns RESTART_META, and
ocfs2_xattr_extend_allocation() hits BUG_ON(why == RESTART_META).

[FIX]
The case where no xattr block exists yet already calls
ocfs2_extend_meta_needed(&def_xv.xv.xr_list) to reserve value tree
metadata. Add the same reservation to the case where an xattr block
already exists, making the two cases consistent.

Replace the BUG_ON with a -ENOSPC return so that if RESTART_META is
returned despite the reservation, the error propagates to userspace
instead of panicking the kernel.

Link: https://lore.kernel.org/amLwn3i9tET8yhG7@dev
Fixes: a78f9f466894 ("ocfs2: make xattr extension work with new local alloc reservation.")
Signed-off-by: Ian Bridges <icb@fastmail.org>
Reported-by: syzbot+e538032956b1157914a3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e538032956b1157914a3
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/xattr.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -736,12 +736,10 @@ static int ocfs2_xattr_extend_allocation
 					 prev_clusters;
 
 		if (why != RESTART_NONE && clusters_to_add) {
-			/*
-			 * We can only fail in case the alloc file doesn't give
-			 * up enough clusters.
-			 */
-			BUG_ON(why == RESTART_META);
-
+			if (why == RESTART_META) {
+				status = -ENOSPC;
+				break;
+			}
 			credits = ocfs2_calc_extend_credits(inode->i_sb,
 							    &vb->vb_xv->xr_list);
 			status = ocfs2_extend_trans(handle, credits);
@@ -3211,6 +3209,14 @@ meta_guess:
 			credits += OCFS2_SUBALLOC_ALLOC + 1;
 
 		/*
+		 * Reserve metadata for the new xattr's value extent tree.
+		 * The not_found path above adds credits for this tree but
+		 * omits meta_add, leaving meta_ac NULL for large values.
+		 */
+		if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE)
+			meta_add += ocfs2_extend_meta_needed(&def_xv.xv.xr_list);
+
+		/*
 		 * This cluster will be used either for new bucket or for
 		 * new xattr block.
 		 * If the cluster size is the same as the bucket size, one


