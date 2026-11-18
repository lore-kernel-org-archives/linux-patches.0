Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025715;
	b=AONkIvgqlK3RVlcoda9Kxd5LEksDdJKKNhgD4/guMvwL+bR4cX/Y+xqNV4T+9PkiERDe
	 NGSUkGVFejuSgMkAkF0BEC2SLj4xt+QpshelJQMfi0S17i3o5YeKWbfb+CSRPFXayicXf
	 a2LH3lqL1f8eV8SPsMtNA4aWxlamY5RmOWJcnQC6yEv1P2I8fewM1gJ4ULNlM/iyHsTwL
	 uJaZ8eB0Z2xm266KgCIgmnzTwuN9Lq3ooX5aWhkHP/SekWnZzrMcceGhjeINzS1JnV2Jq
	 LHSrXc+wyjxYoVetsZbl7aUChu2E0wGkL/amZOtAz+5ww/XzbxzN0MqzXHvSOjm8J4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025715;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dmWqGKc5ZDad+nj6zzni9T+oNsw6HCRYOxSPkwFoKzE=;
	b=UNa/+dgvfh2j+UhvM2UBWyO1WHDqp6P8o1J4Skm9m9an/qdXKUKSF/EccmSOYmsY5AF6
	 +wQ3rWe7RbaRkQ0crXB6GSoBHIzjDNRd8QOqZ4Pz5Hwi/dXugIeNC5hPtH/EtNMPS5d/b
	 Z4Fnrdqft+YrSKO4PCBFRzD5/e8575nfRh3Wa5GU2lQ0xQFDIxZP98KpOA+ZV/sK3fcGR
	 ePOP8GI1ePAW2B/mNyjjkeStfJopAk3WjXoA8EE0+Rx/Bv16jklc8kVaX9NdUG0GA9lMV
	 g06T02A05CH4WPxQstcRrGp4Kb1bMI3H+IIagw9qd69biy7bxYdmDzZd8ug5PeX7Q2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sgfh3YJN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAD0606A32A;
	Wed, 18 Nov 2026 18:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sgfh3YJN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058BB1F000C4;
	Wed, 18 Nov 2026 18:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025715;
	bh=dmWqGKc5ZDad+nj6zzni9T+oNsw6HCRYOxSPkwFoKzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sgfh3YJNj3kWJiAlBkieR5L3fOfZ6HjwYkD/zHkwFdmfE7eKLQH0lrHG7K5+i6vGG
	 2zGt+LqzZsDQm2SH4/BjaqkLtD0uEvzV6mhMyb/kbw9+8Q/DdOq94Wiq8Rbq3Fa0Zb
	 yRZXC235Y5/vpsyji3sZdVb+a/PvSmchd/RUtf5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	ZhengYuan Huang <gality369@gmail.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1177/2151] ocfs2: fix deadlock in inline-data truncate transactions
Date: Wed, 18 Nov 2026 15:48:32 +0100
Message-ID: <20261118150205.004802789@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit c204bf5ac3eeb66648904d0374d6f7b84d843aac ]

Updating an inode xattr can cause an ABBA deadlock with inline file
truncation:

  ocfs2_truncate_file()
    down_write(&oi->ip_alloc_sem)
    ocfs2_truncate_inline()
      ocfs2_start_trans()

  ocfs2_xattr_set()
    ocfs2_start_trans()
    ocfs2_xattr_ibody_set()
      down_write(&oi->ip_alloc_sem)

The xattr set path starts the merged transaction before the inode-body
xattr helper acquires ip_alloc_sem, reversing the ip_alloc_sem ->
transaction order used by the allocation and truncate paths.  The
transaction merge in commit 85db90e77806 ("ocfs2/xattr: Merge xattr set
transaction.") introduced this ordering.

Fix it by acquiring ip_alloc_sem once in ocfs2_xattr_set(), before xattr
preparation, allocation reservations and ocfs2_start_trans(), and removing
the per-helper acquisition from ocfs2_xattr_ibody_find(),
ocfs2_xattr_ibody_set() and ocfs2_xattr_create_index_block().  These
helpers now assert via lockdep that the caller holds ip_alloc_sem.

ocfs2_xattr_set_handle(), which only sets initial ACL or security xattrs
on unpublished inodes inside the create transaction, takes ip_alloc_sem
under a dedicated lockdep subclass so that the assertions hold without
creating a transaction -> ip_alloc_sem cycle against the ip_alloc_sem ->
transaction order.  The inode is unpublished, so the acquisition can never
contend.

This keeps the established ip_alloc_sem -> transaction order and makes the
locking unconditional, so lockdep can verify a single plain ordering
instead of conditional acquisitions.

Link: https://lore.kernel.org/20260826112659.246574-1-joseph.qi@linux.alibaba.com
Fixes: 85db90e77806 ("ocfs2/xattr: Merge xattr set transaction.")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: ZhengYuan Huang <gality369@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/xattr.c | 79 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 53 insertions(+), 26 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 921d050c37581..da31b530b96e0 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2697,6 +2697,9 @@ static int ocfs2_xattr_has_space_inline(struct inode *inode,
  *
  * Find extended attribute in inode block and
  * fill search info into struct ocfs2_xattr_search.
+ *
+ * The inline free-space check races with truncate and allocation, so
+ * callers must hold ip_alloc_sem for writing.
  */
 static int ocfs2_xattr_ibody_find(struct inode *inode,
 				  int name_index,
@@ -2708,13 +2711,13 @@ static int ocfs2_xattr_ibody_find(struct inode *inode,
 	int ret;
 	int has_space = 0;
 
+	lockdep_assert_held_write(&oi->ip_alloc_sem);
+
 	if (inode->i_sb->s_blocksize == OCFS2_MIN_BLOCKSIZE)
 		return 0;
 
 	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL)) {
-		down_read(&oi->ip_alloc_sem);
 		has_space = ocfs2_xattr_has_space_inline(inode, di);
-		up_read(&oi->ip_alloc_sem);
 		if (!has_space)
 			return 0;
 	}
@@ -2793,6 +2796,7 @@ static int ocfs2_xattr_ibody_init(struct inode *inode,
  *
  * Set, replace or remove an extended attribute into inode block.
  *
+ * Callers must hold ip_alloc_sem for writing.
  */
 static int ocfs2_xattr_ibody_set(struct inode *inode,
 				 struct ocfs2_xattr_info *xi,
@@ -2803,16 +2807,17 @@ static int ocfs2_xattr_ibody_set(struct inode *inode,
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_xa_loc loc;
 
+	lockdep_assert_held_write(&oi->ip_alloc_sem);
+
 	if (inode->i_sb->s_blocksize == OCFS2_MIN_BLOCKSIZE)
 		return -ENOSPC;
 
-	down_write(&oi->ip_alloc_sem);
 	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL)) {
 		ret = ocfs2_xattr_ibody_init(inode, xs->inode_bh, ctxt);
 		if (ret) {
 			if (ret != -ENOSPC)
 				mlog_errno(ret);
-			goto out;
+			return ret;
 		}
 	}
 
@@ -2822,13 +2827,10 @@ static int ocfs2_xattr_ibody_set(struct inode *inode,
 	if (ret) {
 		if (ret != -ENOSPC)
 			mlog_errno(ret);
-		goto out;
+		return ret;
 	}
 	xs->here = loc.xl_entry;
 
-out:
-	up_write(&oi->ip_alloc_sem);
-
 	return ret;
 }
 
@@ -3486,6 +3488,18 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
 	return ret;
 }
 
+/*
+ * ip_alloc_sem subclass for inodes being initialized before publication.
+ * ocfs2_xattr_set_handle() runs inside the create transaction, so taking
+ * ip_alloc_sem there adds a transaction -> ip_alloc_sem order that would
+ * form a lockdep cycle with the ip_alloc_sem -> transaction order used
+ * elsewhere, if not for this separate subclass.  The inode is unpublished
+ * so the acquisition can never contend.
+ */
+enum {
+	OCFS2_IP_ALLOC_SEM_UNPUBLISHED = 1,
+};
+
 /*
  * This helper is only for setting initial ACL or security xattrs on an inode
  * that is still unpublished, unhashed, and unattached to a dentry.
@@ -3547,6 +3561,13 @@ int ocfs2_xattr_set_handle(handle_t *handle,
 	xis.inode_bh = xbs.inode_bh = di_bh;
 	di = (struct ocfs2_dinode *)di_bh->b_data;
 
+	/*
+	 * The inode is unpublished and cannot contend, but take the
+	 * semaphore anyway so the helpers' lockdep assertions hold.
+	 */
+	down_write_nested(&OCFS2_I(inode)->ip_alloc_sem,
+			  OCFS2_IP_ALLOC_SEM_UNPUBLISHED);
+
 	ret = ocfs2_xattr_ibody_find(inode, name_index, name, &xis);
 	if (ret)
 		goto cleanup;
@@ -3559,6 +3580,7 @@ int ocfs2_xattr_set_handle(handle_t *handle,
 	ret = __ocfs2_xattr_set_handle(inode, di, &xi, &xis, &xbs, &ctxt);
 
 cleanup:
+	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 	brelse(xbs.xattr_bh);
 	ocfs2_xattr_bucket_free(xbs.bucket);
 
@@ -3627,30 +3649,38 @@ int ocfs2_xattr_set(struct inode *inode,
 	di = (struct ocfs2_dinode *)di_bh->b_data;
 
 	down_write(&OCFS2_I(inode)->ip_xattr_sem);
+	/*
+	 * The allocation and truncate paths take ip_alloc_sem before
+	 * starting a transaction, so take it here before xattr
+	 * preparation, allocation reservations and ocfs2_start_trans()
+	 * to keep that order.  The xattr helpers below no longer take
+	 * it themselves.
+	 */
+	down_write(&OCFS2_I(inode)->ip_alloc_sem);
 	/*
 	 * Scan inode and external block to find the same name
 	 * extended attribute and collect search information.
 	 */
 	ret = ocfs2_xattr_ibody_find(inode, name_index, name, &xis);
 	if (ret)
-		goto cleanup;
+		goto out_free_ac;
 	if (xis.not_found) {
 		ret = ocfs2_xattr_block_find(inode, name_index, name, &xbs);
 		if (ret)
-			goto cleanup;
+			goto out_free_ac;
 	}
 
 	if (xis.not_found && xbs.not_found) {
 		ret = -ENODATA;
 		if (flags & XATTR_REPLACE)
-			goto cleanup;
+			goto out_free_ac;
 		ret = 0;
 		if (!value)
-			goto cleanup;
+			goto out_free_ac;
 	} else {
 		ret = -EEXIST;
 		if (flags & XATTR_CREATE)
-			goto cleanup;
+			goto out_free_ac;
 	}
 
 	/* Check whether the value is refcounted and do some preparation. */
@@ -3661,7 +3691,7 @@ int ocfs2_xattr_set(struct inode *inode,
 						   &ref_meta, &ref_credits);
 		if (ret) {
 			mlog_errno(ret);
-			goto cleanup;
+			goto out_free_ac;
 		}
 	}
 
@@ -3672,7 +3702,7 @@ int ocfs2_xattr_set(struct inode *inode,
 		if (ret < 0) {
 			inode_unlock(tl_inode);
 			mlog_errno(ret);
-			goto cleanup;
+			goto out_free_ac;
 		}
 	}
 	inode_unlock(tl_inode);
@@ -3681,7 +3711,7 @@ int ocfs2_xattr_set(struct inode *inode,
 					&xbs, &ctxt, ref_meta, &credits);
 	if (ret) {
 		mlog_errno(ret);
-		goto cleanup;
+		goto out_free_ac;
 	}
 
 	/* we need to update inode's ctime field, so add credit for it. */
@@ -3699,6 +3729,7 @@ int ocfs2_xattr_set(struct inode *inode,
 	ocfs2_commit_trans(osb, ctxt.handle);
 
 out_free_ac:
+	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 	if (ctxt.data_ac)
 		ocfs2_free_alloc_context(ctxt.data_ac);
 	if (ctxt.meta_ac)
@@ -3707,7 +3738,6 @@ int ocfs2_xattr_set(struct inode *inode,
 		ocfs2_schedule_truncate_log_flush(osb, 1);
 	ocfs2_run_deallocs(osb, &ctxt.dealloc);
 
-cleanup:
 	if (ref_tree)
 		ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
 	up_write(&OCFS2_I(inode)->ip_xattr_sem);
@@ -4408,6 +4438,10 @@ static void ocfs2_xattr_update_xattr_search(struct inode *inode,
 	xs->here = xs->header->xh_entries;
 }
 
+/*
+ * Caller must hold ip_alloc_sem for writing, since a new xattr block
+ * is allocated and the xattr block header is rewritten.
+ */
 static int ocfs2_xattr_create_index_block(struct inode *inode,
 					  struct ocfs2_xattr_info *xi,
 					  struct ocfs2_xattr_search *xs,
@@ -4424,19 +4458,14 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 	struct ocfs2_xattr_tree_root *xr;
 	u16 xb_flags = le16_to_cpu(xb->xb_flags);
 
+	lockdep_assert_held_write(&oi->ip_alloc_sem);
+
 	trace_ocfs2_xattr_create_index_block_begin(
 				(unsigned long long)xb_bh->b_blocknr);
 
 	BUG_ON(xb_flags & OCFS2_XATTR_INDEXED);
 	BUG_ON(!xs->bucket);
 
-	/*
-	 * XXX:
-	 * We can use this lock for now, and maybe move to a dedicated mutex
-	 * if performance becomes a problem later.
-	 */
-	down_write(&oi->ip_alloc_sem);
-
 	ret = ocfs2_journal_access_xb(handle, INODE_CACHE(inode), xb_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
@@ -4498,8 +4527,6 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 	ocfs2_journal_dirty(handle, xb_bh);
 
 out:
-	up_write(&oi->ip_alloc_sem);
-
 	return ret;
 }
 
-- 
2.53.0



