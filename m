Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EE63115BC;
	Mon, 13 Apr 2026 16:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098507; cv=none; b=dsYjRMkDmgIyVv13X+0x7ybHI9X+dyrQBFvGmNpUHmrDk/ji7gX3VL/8iC+rc3uFB2Mg4Pc2rkyjrinOD7nXUsJoymQQfm1nIqRdpyIOMYWxpR410pS6l8mDnS/z04G/LrpKkHu+3cbUPcKL9yN/8rgtvm3nFdjdz9M/fnvXKPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098507; c=relaxed/simple;
	bh=tdafQdRPnwAQUlk6UB+WCnkeLELmp8BPISq0RBp31b8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TB5dJB2yzZRVhJoNNatn2nlobrFvhp5ppDOjANEPUq7PP+T7qDEZJ/sEmkvoDd6UkMAsXUDRyycOOJoLc2aITCj77DT+fm85Djq/S6BvCsjFnJhCIEg48MXCpf6iRzQ1SN3YD4DMMm8nUC4G8zHpjT5eY+dz4MERqoMN4E3z4p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUPXZ6CR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUPXZ6CR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E894FC2BCB0;
	Mon, 13 Apr 2026 16:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098507;
	bh=tdafQdRPnwAQUlk6UB+WCnkeLELmp8BPISq0RBp31b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PUPXZ6CRd7AtVfFz8r2nrUcCE6FXCzdD8gPZxQPJvXb0L49aAM45Gd1ZZhhtH2pkp
	 AdJ2wjV7yDhVOribtVg1/taL6YkC4nQlLXGszp5KRdnpVxc9hqxoBPIf6PtMtmvNcm
	 Tp5qkTk0ZQGO+UZrkE1+GdClI9KmEm0Dk7ZUSqR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Yuto Ohnuki <ytohnuki@amazon.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 552/570] xfs: save ailp before dropping the AIL lock in push callbacks
Date: Mon, 13 Apr 2026 18:01:23 +0200
Message-ID: <20260413155851.137650243@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Yuto Ohnuki <ytohnuki@amazon.com>

[ Upstream commit 394d70b86fae9fe865e7e6d9540b7696f73aa9b6 ]

In xfs_inode_item_push() and xfs_qm_dquot_logitem_push(), the AIL lock
is dropped to perform buffer IO. Once the cluster buffer no longer
protects the log item from reclaim, the log item may be freed by
background reclaim or the dquot shrinker. The subsequent spin_lock()
call dereferences lip->li_ailp, which is a use-after-free.

Fix this by saving the ailp pointer in a local variable while the AIL
lock is held and the log item is guaranteed to be valid.

Reported-by: syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=652af2b3c5569c4ab63c
Fixes: 90c60e164012 ("xfs: xfs_iflush() is no longer necessary")
Cc: stable@vger.kernel.org # v5.9
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_dquot_item.c |    9 +++++++--
 fs/xfs/xfs_inode_item.c |    9 +++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -124,6 +124,7 @@ xfs_qm_dquot_logitem_push(
 {
 	struct xfs_dquot	*dqp = DQUOT_ITEM(lip)->qli_dquot;
 	struct xfs_buf		*bp = lip->li_buf;
+	struct xfs_ail		*ailp = lip->li_ailp;
 	uint			rval = XFS_ITEM_SUCCESS;
 	int			error;
 
@@ -152,7 +153,7 @@ xfs_qm_dquot_logitem_push(
 		goto out_unlock;
 	}
 
-	spin_unlock(&lip->li_ailp->ail_lock);
+	spin_unlock(&ailp->ail_lock);
 
 	error = xfs_qm_dqflush(dqp, &bp);
 	if (!error) {
@@ -162,7 +163,11 @@ xfs_qm_dquot_logitem_push(
 	} else if (error == -EAGAIN)
 		rval = XFS_ITEM_LOCKED;
 
-	spin_lock(&lip->li_ailp->ail_lock);
+	/*
+	 * The buffer no longer protects the log item from reclaim, so
+	 * do not reference lip after this point.
+	 */
+	spin_lock(&ailp->ail_lock);
 out_unlock:
 	xfs_dqunlock(dqp);
 	return rval;
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -540,6 +540,7 @@ xfs_inode_item_push(
 	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 	struct xfs_inode	*ip = iip->ili_inode;
 	struct xfs_buf		*bp = lip->li_buf;
+	struct xfs_ail		*ailp = lip->li_ailp;
 	uint			rval = XFS_ITEM_SUCCESS;
 	int			error;
 
@@ -555,7 +556,7 @@ xfs_inode_item_push(
 	if (!xfs_buf_trylock(bp))
 		return XFS_ITEM_LOCKED;
 
-	spin_unlock(&lip->li_ailp->ail_lock);
+	spin_unlock(&ailp->ail_lock);
 
 	/*
 	 * We need to hold a reference for flushing the cluster buffer as it may
@@ -579,7 +580,11 @@ xfs_inode_item_push(
 		rval = XFS_ITEM_LOCKED;
 	}
 
-	spin_lock(&lip->li_ailp->ail_lock);
+	/*
+	 * The buffer no longer protects the log item from reclaim, so
+	 * do not reference lip after this point.
+	 */
+	spin_lock(&ailp->ail_lock);
 	return rval;
 }
 


