Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274C13EF0A2;
	Tue, 31 Mar 2026 16:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976112; cv=none; b=XopSzjdZZtbwTDSw5gfOZdtfM/VpOQQxLZMOUNlkZTh9sOBEQcqFcbR9KyOQ8a6j0jxQKZUrvnpVTqXbwCDPDJ2cL5vf0Zg98UzPlpQx+XzcoPsFSqoGdNv0uSNP1l1ZvduNsC0Vd37vNoJnWyjT11Gl+mlfy/Ds/ofh3UBiNWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976112; c=relaxed/simple;
	bh=3NRthCewJKKblBe4KGW9LjTRN+YiAP/EpbypjP+I6Ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dP9jJB4CrdwuCRIKrWrz24yp1QyLrsentO1p9arq3Gu2dUbKvgigRstUmV6afb12GuAfCzGLnzYicEjXeSx16WqX2ZjmOjGJ0IffgfFC2a7RFPN1W0DlTPdiEEvlQ/DMzRrjGqBovYCIXRoylC4Xsxg9ozxwKumAn6x6TqdzovU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QnNtt2wH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QnNtt2wH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FE8C19423;
	Tue, 31 Mar 2026 16:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976112;
	bh=3NRthCewJKKblBe4KGW9LjTRN+YiAP/EpbypjP+I6Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QnNtt2wHWuw8Y5W/TstuRF0gb2JNq283Nd0kCZMk/yfPeDGVSt10I89McvSUw+g7I
	 X//m53SldUgBlSLsxg968GMiX4DYqteEvMtx5MXbb1jhYG86WDNpQZoCYchLYove7d
	 Vksm+C4naDKArryvZaksWFDZpCilRFd/pKQCTdj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Yuto Ohnuki <ytohnuki@amazon.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 178/244] xfs: save ailp before dropping the AIL lock in push callbacks
Date: Tue, 31 Mar 2026 18:22:08 +0200
Message-ID: <20260331161748.329656498@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Yuto Ohnuki <ytohnuki@amazon.com>

commit 394d70b86fae9fe865e7e6d9540b7696f73aa9b6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_dquot_item.c |    9 +++++++--
 fs/xfs/xfs_inode_item.c |    9 +++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -126,6 +126,7 @@ xfs_qm_dquot_logitem_push(
 	struct xfs_dq_logitem	*qlip = DQUOT_ITEM(lip);
 	struct xfs_dquot	*dqp = qlip->qli_dquot;
 	struct xfs_buf		*bp;
+	struct xfs_ail		*ailp = lip->li_ailp;
 	uint			rval = XFS_ITEM_SUCCESS;
 	int			error;
 
@@ -154,7 +155,7 @@ xfs_qm_dquot_logitem_push(
 		goto out_unlock;
 	}
 
-	spin_unlock(&lip->li_ailp->ail_lock);
+	spin_unlock(&ailp->ail_lock);
 
 	error = xfs_dquot_use_attached_buf(dqp, &bp);
 	if (error == -EAGAIN) {
@@ -173,9 +174,13 @@ xfs_qm_dquot_logitem_push(
 			rval = XFS_ITEM_FLUSHING;
 	}
 	xfs_buf_relse(bp);
+	/*
+	 * The buffer no longer protects the log item from reclaim, so
+	 * do not reference lip after this point.
+	 */
 
 out_relock_ail:
-	spin_lock(&lip->li_ailp->ail_lock);
+	spin_lock(&ailp->ail_lock);
 out_unlock:
 	xfs_dqunlock(dqp);
 	return rval;
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -726,6 +726,7 @@ xfs_inode_item_push(
 	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 	struct xfs_inode	*ip = iip->ili_inode;
 	struct xfs_buf		*bp = lip->li_buf;
+	struct xfs_ail		*ailp = lip->li_ailp;
 	uint			rval = XFS_ITEM_SUCCESS;
 	int			error;
 
@@ -748,7 +749,7 @@ xfs_inode_item_push(
 	if (!xfs_buf_trylock(bp))
 		return XFS_ITEM_LOCKED;
 
-	spin_unlock(&lip->li_ailp->ail_lock);
+	spin_unlock(&ailp->ail_lock);
 
 	/*
 	 * We need to hold a reference for flushing the cluster buffer as it may
@@ -772,7 +773,11 @@ xfs_inode_item_push(
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
 


