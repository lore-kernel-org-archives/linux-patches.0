Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3490309DCF;
	Tue, 31 Mar 2026 17:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976838; cv=none; b=TKQhpUz9p35s2KfAY1dBR5j+0vcYqdZi2573lvB4mqhXnmu6PVUyhIoyBtWjUsH85meuLJOqGdSO3kb4P66HjOqG5j+o0z8XGVbodZ1LnpwZ34Isa8JB1vXdMjldAcCp1rQXSglMBHnRIWsKUGbv832wxSvlS5W25iOGwn/8w3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976838; c=relaxed/simple;
	bh=oG4nJUNXk8nqLTUVt7dBn9voQMIdvDdT8QWoD/q3D6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYatUQiNr47dR6Kcp23Bv6PZiuvh8uItDUQs9P9B+cHT0DyRWrqi/3g98OsYsY1NCSk+Hd5ZR380Z63WrFparOuAqINPqo+kzOkPfWRbKmxHfYplTxEzV+3g7ZOJDw3SpUBeDi9g/9XbH31m2bmzVDGtZ4e0i+niGHjFv8+JL0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fkrvxUSg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fkrvxUSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49563C19423;
	Tue, 31 Mar 2026 17:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976838;
	bh=oG4nJUNXk8nqLTUVt7dBn9voQMIdvDdT8QWoD/q3D6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fkrvxUSgzlcS2WUFWfmWeJUT0cadq1QiNMKhf8gHbKMCajgYMg4ybKMRRxz0XIP8+
	 S7zBFdNjRJ58FNm7NKSHFHckJl12KW3GregZumY5Fj2HvQbhr4e4eSQzMdtHUQxt4O
	 S15Cz6eGeYKF7yTHtlPW4xA+OpaUKaEIcHvdrgkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Yuto Ohnuki <ytohnuki@amazon.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 248/309] xfs: save ailp before dropping the AIL lock in push callbacks
Date: Tue, 31 Mar 2026 18:22:31 +0200
Message-ID: <20260331161802.699830233@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -749,6 +749,7 @@ xfs_inode_item_push(
 	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 	struct xfs_inode	*ip = iip->ili_inode;
 	struct xfs_buf		*bp = lip->li_buf;
+	struct xfs_ail		*ailp = lip->li_ailp;
 	uint			rval = XFS_ITEM_SUCCESS;
 	int			error;
 
@@ -774,7 +775,7 @@ xfs_inode_item_push(
 	if (!xfs_buf_trylock(bp))
 		return XFS_ITEM_LOCKED;
 
-	spin_unlock(&lip->li_ailp->ail_lock);
+	spin_unlock(&ailp->ail_lock);
 
 	/*
 	 * We need to hold a reference for flushing the cluster buffer as it may
@@ -798,7 +799,11 @@ xfs_inode_item_push(
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
 


