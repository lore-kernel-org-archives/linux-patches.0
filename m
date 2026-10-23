Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774883;
	b=P2taNWD/SzL0nqGDUlZzlFMpjYQWeQE1vjM0NM3SQuJz1lXY3/9S06e8tGvc8QTmTIgC
	 5mxYYtn0xCQdVfk/5/HSigFKsU73I1aY5EZFlHYmXeHY6iuuppMj6DJEp6daFaCgDy8iL
	 L8ZUBh0JBEZG3uN6Jq0iRxQcyytp4Q58ypLUZzNmFn6HaT03iL26Qw24DBAGk5DFFVwpt
	 QAB5c80TzEKMXKSKc/QEqCo2iX/Z4aO/Ma8KaknoH5CraYSkCR7NKO/VB3gm5LeRJz0fT
	 t5JmQOgiQGYgyMFu+pfHiqZ2D16Shqb24+PouYtp3TNOLAMjxLur4bo/eCRy1mxNmzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774883;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eziICgBkSMlsO3AKHbuEnn/EuhV59NqNNyCAC4NB5OQ=;
	b=mom6cS9MadiTSi9AG20QHFKPTsXkrnbpgqod+NYSKrS0sJWF7ofnYUscjpDb6vZXz33H
	 NXvX7uozzdQRrEuWjAeY3U6iMmp02hSsLHgldy8VOpaf3VqeigUdn+EvROgVXlW7m3KG1
	 nsUPSBh2kptV3urrd87+MHYBFBhR+HTRcVrvnff859k82GJhE1YeFvD1/rzMufOqEW2NI
	 bCJoCvc970rqDuzKqV4si3ozkvPXJ+ntbvQo7tBPg+RMVBEStfm0oKpRwKYpvJpWjhD8Y
	 dxdp31BKLcnLeJDVQuEZYurdfdUYDvws9MmL8HkLGvcEVJImQUqo1qZIv4Ip59Ev/DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dr9wL2p9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA16606A32C;
	Fri, 23 Oct 2026 17:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dr9wL2p9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8119B1F01828;
	Fri, 23 Oct 2026 17:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774883;
	bh=eziICgBkSMlsO3AKHbuEnn/EuhV59NqNNyCAC4NB5OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dr9wL2p9ehTnZYNgxVGZ+NkME1gTNIoLThExTcM+PWzdhbC+vASKWd4MVScPgfVlT
	 RAJMuLS91VmZW7n70qCbadNaJLIZMZQYqYtpOYBkhDio/AhN3Tm1eqSmBd7m3wCezr
	 bs7c09etqi3Tg81HSMpB4D8zhTXKy/M6ARvtfvXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 190/242] xfs: dont hold buffer locks across sync transaction commit in xfs_sync_sb_buf
Date: Fri, 23 Oct 2026 18:40:32 +0200
Message-ID: <20261023163718.285594219@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yun Zhou <yun.zhou@windriver.com>

commit 41a28c865d1d5843f8cb9e0af17a8f4d9e2961ff upstream.

xfs_sync_sb_buf() holds sb/rtsb buffer locks across a synchronous
xfs_trans_commit(), which flushes the CIL push workqueue internally.
If shutdown occurs during the CIL push, xfs_buf_item_unpin() needs to
lock these buffers to fail them, causing a deadlock:

  setlabel:          holds buf lock -> flush_workqueue(xfs-cil)
  CIL push worker:   xfs_buf_item_unpin -> xfs_buf_lock(same buf)

Remove the xfs_trans_bhold() calls so that commit releases the buffer
locks normally.  After the sync commit, re-acquire the buffers via
mp->m_sb_bp / mp->m_rtsb_bp for the on-disk writeback.

Fixes: f7664b31975b ("xfs: implement online get/set fs label")
Reported-by: syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=837bcd54843dd6262f2f
Cc: stable@vger.kernel.org
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_rtgroup.h |    6 +++++-
 fs/xfs/libxfs/xfs_sb.c      |   37 +++++++++++++++++--------------------
 2 files changed, 22 insertions(+), 21 deletions(-)

--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -359,7 +359,11 @@ static inline int xfs_initialize_rtgroup
 # define xfs_rtgroup_unlock(rtg, gf)		((void)0)
 # define xfs_rtgroup_trans_join(tp, rtg, gf)	((void)0)
 # define xfs_update_rtsb(bp, sb_bp)	((void)0)
-# define xfs_log_rtsb(tp, sb_bp)	(NULL)
+static inline struct xfs_buf *xfs_log_rtsb(struct xfs_trans *tp,
+		const struct xfs_buf *sb_bp)
+{
+	return NULL;
+}
 # define xfs_rtgroup_get_geometry(rtg, rgeo)	(-EOPNOTSUPP)
 #endif /* CONFIG_XFS_RT */
 
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1470,36 +1470,33 @@ xfs_sync_sb_buf(
 	bool			update_rtsb)
 {
 	struct xfs_trans	*tp;
-	struct xfs_buf		*bp;
-	struct xfs_buf		*rtsb_bp = NULL;
 	int			error;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
 	if (error)
 		return error;
 
-	bp = xfs_trans_getsb(tp);
 	xfs_log_sb(tp);
-	xfs_trans_bhold(tp, bp);
-	if (update_rtsb) {
-		rtsb_bp = xfs_log_rtsb(tp, bp);
-		if (rtsb_bp)
-			xfs_trans_bhold(tp, rtsb_bp);
-	}
+	if (update_rtsb)
+		xfs_log_rtsb(tp, xfs_trans_getsb(tp));
 	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp);
 	if (error)
-		goto out;
-	/*
-	 * write out the sb buffer to get the changes to disk
-	 */
-	error = xfs_bwrite(bp);
-	if (!error && rtsb_bp)
-		error = xfs_bwrite(rtsb_bp);
-out:
-	if (rtsb_bp)
-		xfs_buf_relse(rtsb_bp);
-	xfs_buf_relse(bp);
+		return error;
+
+	/* Re-acquire and write the sb and rtsb to disk. */
+	xfs_buf_lock(mp->m_sb_bp);
+	error = xfs_bwrite(mp->m_sb_bp);
+	xfs_buf_unlock(mp->m_sb_bp);
+	if (error)
+		return error;
+
+	if (update_rtsb && mp->m_rtsb_bp) {
+		xfs_buf_lock(mp->m_rtsb_bp);
+		error = xfs_bwrite(mp->m_rtsb_bp);
+		xfs_buf_unlock(mp->m_rtsb_bp);
+	}
+
 	return error;
 }
 


