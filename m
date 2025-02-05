Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D461A76DA;
	Wed,  5 Feb 2025 15:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768650; cv=none; b=VGr3mW/xHhCIYal25eBdK/1AlkDF0qjKQlccStxqpq8ADYeZWUBdwcBGIDz9UE0ogsS9xX9sjpXLIB0MG4OYZ8oY3v/kIxtOnIictFiGFA0G+fD9iZvosoVq6fOKIXOfX5W7ZI4PlPoZiH4Ote0I7ijCNGY1okq2WnwVCmFDIg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768650; c=relaxed/simple;
	bh=EXZebBHKXSOZBcxkwUy6zD1Eel/VzqwZSW+B0I2R/Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMiGmw0XTcPKz1AjxiL1vmnMPCkBNwlU9ogh3+m/o118SOQRCJ2dtaasJmg9pgXui4fuONq1IDebKUu6FyicIyec4lfYYo4iffMebS8pVPvVHqjoBEnfq1rbAuElwEL65nb4AEQlqT8WWFGt1w5we6kIGUB4+do58/1tsy6ZcBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YDdGlW+3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YDdGlW+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D073C4CED1;
	Wed,  5 Feb 2025 15:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768650;
	bh=EXZebBHKXSOZBcxkwUy6zD1Eel/VzqwZSW+B0I2R/Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YDdGlW+3vI353xkTMQDfLCZ4o2zWXOdRapiYmcSUPyI89CZ7vTXNbmcFaMsKKhBQi
	 5g8qoJ7pKusX/KEQ+c5UBhu3CzfBqt2+tyELmpioF3wEAVtmoKdEPZEaa350L3VGTw
	 Eo6vetjr+AxB0UsN+z1WTjxuKELIloAqRCv0BVPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3126ab3db03db42e7a31@syzkaller.appspotmail.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.13 586/623] xfs: release the dquot buf outside of qli_lock
Date: Wed,  5 Feb 2025 14:45:28 +0100
Message-ID: <20250205134518.641469163@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 1aacd3fac248902ea1f7607f2d12b93929a4833b upstream.

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
Tested-by: syzbot+3126ab3db03db42e7a31@syzkaller.appspotmail.com
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_dquot.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1316,7 +1316,8 @@ out_abort:
 
 /*
  * Attach a dquot buffer to this dquot to avoid allocating a buffer during a
- * dqflush, since dqflush can be called from reclaim context.
+ * dqflush, since dqflush can be called from reclaim context.  Caller must hold
+ * the dqlock.
  */
 int
 xfs_dquot_attach_buf(
@@ -1337,13 +1338,16 @@ xfs_dquot_attach_buf(
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


