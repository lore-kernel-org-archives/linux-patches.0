Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4C31FF7B9;
	Thu, 13 Feb 2025 14:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458519; cv=none; b=sTQOuvjYmFMt9pf6MCkBFGiMP+HvlGbgyNK+eFcLBLH3KG2ozy1BeFDHJByWEZyaOFopZ8jmFLFU480geo9TrpxO23FZhx+4+JdIKv5q6YaHPfMl64QRLMl6lPIfklpNLbeqfXfqSG5ewvTSxqPo9aRcBU3N866d2A5s3vcR+i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458519; c=relaxed/simple;
	bh=RocZ2MVJ9AAs3xJR+E3vucAs1WbF1RNSyjLgC6QIGWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZsLP5SESINtsUPKZMjhBrlm5IrQ2XGi7RH5s7+Iml8loNgwGlbGWMj3poJfc0oJQ4Or3JgjNyfemmeernn2M/WlexKs3vSaUdFEcUEYuJ1K/Bc4v77yRx5TspE6JE3NBxYih1ZPVF5VhG4NYv3oO+108qDELqKwLGN+As8JmiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zv3nfIQu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zv3nfIQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DAB9C4CEE8;
	Thu, 13 Feb 2025 14:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458519;
	bh=RocZ2MVJ9AAs3xJR+E3vucAs1WbF1RNSyjLgC6QIGWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zv3nfIQuEV1Xt8LgInagY8mQZM811ZCJA8TdgXB5IrRtckOhtOHOWeYS/kUdx54j/
	 wAkqlueICrpRcSkB/DbQ3YjdUUEbYqgJfgyU9FfobVb4KLCPXAllCEEIttpddCKsma
	 6aQYvM9q/bcDi42oxSc4Au45QqeT4FAqfF1cCquY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3126ab3db03db42e7a31@syzkaller.appspotmail.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.12 404/422] xfs: release the dquot buf outside of qli_lock
Date: Thu, 13 Feb 2025 15:29:13 +0100
Message-ID: <20250213142452.143422942@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Darrick J. Wong <djwong@kernel.org>

commit 1aacd3fac248902ea1f7607f2d12b93929a4833b upstream

Lai Yi reported a lockdep complaint about circular locking:

 Chain exists of:
   &lp->qli_lock --> &bch->bc_lock --> &l->lock

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&l->lock);
                                lock(&bch->bc_lock);
                                lock(&l->lock);
   lock(&lp->qli_lock);

I /think/ the problem here is that xfs_dquot_attach_buf during
quotacheck will release the buffer while it's holding the qli_lock.
Because this is a cached buffer, xfs_buf_rele_cached takes b_lock before
decrementing b_hold.  Other threads have taught lockdep that a locking
dependency chain is bp->b_lock -> bch->bc_lock -> l(ru)->lock; and that
another chain is l(ru)->lock -> lp->qli_lock.  Hence we do not want to
take b_lock while holding qli_lock.

Reported-by: syzbot+3126ab3db03db42e7a31@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org> # v6.13-rc3
Fixes: ca378189fdfa89 ("xfs: convert quotacheck to attach dquot buffers")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_dquot.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)


--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1308,7 +1308,8 @@ out_abort:
 
 /*
  * Attach a dquot buffer to this dquot to avoid allocating a buffer during a
- * dqflush, since dqflush can be called from reclaim context.
+ * dqflush, since dqflush can be called from reclaim context.  Caller must hold
+ * the dqlock.
  */
 int
 xfs_dquot_attach_buf(
@@ -1329,13 +1330,16 @@ xfs_dquot_attach_buf(
 			return error;
 
 		/*
-		 * Attach the dquot to the buffer so that the AIL does not have
-		 * to read the dquot buffer to push this item.
+		 * Hold the dquot buffer so that we retain our ref to it after
+		 * detaching it from the transaction, then give that ref to the
+		 * dquot log item so that the AIL does not have to read the
+		 * dquot buffer to push this item.
 		 */
 		xfs_buf_hold(bp);
+		xfs_trans_brelse(tp, bp);
+
 		spin_lock(&qlip->qli_lock);
 		lip->li_buf = bp;
-		xfs_trans_brelse(tp, bp);
 	}
 	qlip->qli_dirty = true;
 	spin_unlock(&qlip->qli_lock);


