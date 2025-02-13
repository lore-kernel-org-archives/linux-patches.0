Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008C6221723;
	Thu, 13 Feb 2025 14:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458543; cv=none; b=dkoewL7CBINy9z2OCob0w7g87tT44CJakt3VxMEMgXNqc8hfmCpwz93H2oct8oRqr2MWBZvjIbAg2j6PC299ptv6hzUWxIV6HnVIWW8IdbXpFbOmo6eGbJTf+kWZcKjhNIhaW0WcclFcTQRaSRqYyEf24/O1JeDbCc02iWhrdTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458543; c=relaxed/simple;
	bh=0ojGQl+pSpCD/V2aYjG9IiJdvebcAP060xpKegYHbTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kws+Ptt5dzCnPd0zLUrL316c67JPCeV8Rw0TdIHijc7QkTVj3WmKdBLcOBGkQWuzfE0d032RHhxHdU/bIqfxkkAj/KiR/3OVYKPQcvp1BSZPJzG38Z/slEEUw1/RFfOOt7GBlKP+STFf0wbDUfuk4RaP5Nky9lQ0Gv2k9mOADeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dl6u9azm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dl6u9azm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E036C4CED1;
	Thu, 13 Feb 2025 14:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458542;
	bh=0ojGQl+pSpCD/V2aYjG9IiJdvebcAP060xpKegYHbTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dl6u9azm2WVwnIVeWiCvR6gyQsL+TdB61awWR9lk5j7s5MRpb5YMeYbAsHCF+0tYK
	 4rFild5PcJRvr7rMzpecvWOhrcwv71eclcS0Etcd6Cegq1TCa0mrVIW4IDlm69LWLf
	 quC806mJ3rltxw2YT0u7YvpEaBIzZg8DsH0JHSKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.12 401/422] xfs: clean up log item accesses in xfs_qm_dqflush{,_done}
Date: Thu, 13 Feb 2025 15:29:10 +0100
Message-ID: <20250213142452.023491209@linuxfoundation.org>
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

commit ec88b41b932d5731291dcc0d0d63ea13ab8e07d5 upstream

Clean up these functions a little bit before we move on to the real
modifications, and make the variable naming consistent for dquot log items.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_dquot.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)


--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1136,8 +1136,9 @@ static void
 xfs_qm_dqflush_done(
 	struct xfs_log_item	*lip)
 {
-	struct xfs_dq_logitem	*qip = (struct xfs_dq_logitem *)lip;
-	struct xfs_dquot	*dqp = qip->qli_dquot;
+	struct xfs_dq_logitem	*qlip =
+			container_of(lip, struct xfs_dq_logitem, qli_item);
+	struct xfs_dquot	*dqp = qlip->qli_dquot;
 	struct xfs_ail		*ailp = lip->li_ailp;
 	xfs_lsn_t		tail_lsn;
 
@@ -1150,12 +1151,12 @@ xfs_qm_dqflush_done(
 	 * holding the lock before removing the dquot from the AIL.
 	 */
 	if (test_bit(XFS_LI_IN_AIL, &lip->li_flags) &&
-	    ((lip->li_lsn == qip->qli_flush_lsn) ||
+	    ((lip->li_lsn == qlip->qli_flush_lsn) ||
 	     test_bit(XFS_LI_FAILED, &lip->li_flags))) {
 
 		spin_lock(&ailp->ail_lock);
 		xfs_clear_li_failed(lip);
-		if (lip->li_lsn == qip->qli_flush_lsn) {
+		if (lip->li_lsn == qlip->qli_flush_lsn) {
 			/* xfs_ail_update_finish() drops the AIL lock */
 			tail_lsn = xfs_ail_delete_one(ailp, lip);
 			xfs_ail_update_finish(ailp, tail_lsn);
@@ -1313,7 +1314,7 @@ xfs_qm_dqflush(
 	dqp->q_flags &= ~XFS_DQFLAG_DIRTY;
 
 	xfs_trans_ail_copy_lsn(mp->m_ail, &dqp->q_logitem.qli_flush_lsn,
-					&dqp->q_logitem.qli_item.li_lsn);
+			&lip->li_lsn);
 
 	/*
 	 * copy the lsn into the on-disk dquot now while we have the in memory
@@ -1325,7 +1326,7 @@ xfs_qm_dqflush(
 	 * of a dquot without an up-to-date CRC getting to disk.
 	 */
 	if (xfs_has_crc(mp)) {
-		dqblk->dd_lsn = cpu_to_be64(dqp->q_logitem.qli_item.li_lsn);
+		dqblk->dd_lsn = cpu_to_be64(lip->li_lsn);
 		xfs_update_cksum((char *)dqblk, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
 	}
@@ -1335,7 +1336,7 @@ xfs_qm_dqflush(
 	 * the AIL and release the flush lock once the dquot is synced to disk.
 	 */
 	bp->b_flags |= _XBF_DQUOTS;
-	list_add_tail(&dqp->q_logitem.qli_item.li_bio_list, &bp->b_li_list);
+	list_add_tail(&lip->li_bio_list, &bp->b_li_list);
 
 	/*
 	 * If the buffer is pinned then push on the log so we won't


