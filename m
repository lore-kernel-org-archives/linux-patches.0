Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA35B481644;
	Tue, 25 Aug 2026 13:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665439; cv=none; b=YQslPKHODkZ52TcX8xHyVgqNqtS2F1qDk1D0Ja4zTgKs2XmOuSiWmlqcK9xKvJFfH7KO7LaSOd35c5346R1t8b92/2y1ZY+oBn9FTTaE4u9yfFyiY1tw86iv7bPEPC8/qfg2LmZPUjEsbGJKWXWhdkHsmkqVpZcrcSva9s98Ldw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665439; c=relaxed/simple;
	bh=wyS4F+zAM8/mDrJl4tWvi94nhjzafTxtflqkGq9prpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBy73/BAyXTBJV6Yb9yO0cslDTF2sOs4Snnqtwh/oUUdMMqvNFwjORprCslLpTRtlAfu/D6xOMwBrUL7FobcgusvyFjAv/n+5iSO9kPd7FM4UVENf2b84Cabju/5tPL2CaBTQgaObSHpApPF41GGufwyMfMgXNf0Hyvvh6ihFWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tNadGf3X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tNadGf3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26451F000E9;
	Tue, 25 Aug 2026 13:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665437;
	bh=d1HK2svxK/icNPdFWNr5UQVC2VA4aiDpELtW3+B2kzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tNadGf3XcBLdMDnRfk6YeAA++RIrbPr8Dc3UhDAzMICQx8t7soPND9Rm1Cv38b84d
	 ryAZ9AwRN1XplBEnWgXAFrL/r5DlPqI17KvvFrQ2Y+JebuDAnQUoXWaZ+F8qHP6Qn0
	 y2/xr5Zry8JEtl7NNzopdoZSud7MUclaaqrKbqpM=
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
Subject: [PATCH 6.12 26/77] ocfs2: fix missing metadata reservation for large xattrs
Date: Tue, 25 Aug 2026 15:25:48 +0200
Message-ID: <20260825132542.593998648@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


