Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211924;
	b=I97gavYZ95h6Em2HVc2sSpi29A7xUjlNyH98fxqoh6Um3kJSPwiVczELvbjc9Sm/7fzO
	 nHqYxnJWRobvenwH1FshCmbzBnbI6wH6/tMBSCqrU/T7qPx7hXfcqiO+MxDDX0ekBKRXs
	 3j5sVRIlb+Sfy9JaIcEd0M/5ALuIFeMAju9LbQVFEwPXqcQFOotQu6dqRXtEKi2UJx3TA
	 WL1jlYuM3z7Bh6rSuysQ0L+CHm891GexKb5gB0tkb1YyMdFGFYBrbFWADE0gZ+nzPZG39
	 XiN2lb/3amCMEyVsuN9xqAuXDAO4okRtUqd18XNpvw6RX7+/uaK0D6WpwWeItogPWFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211924;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AmmD56WEfKO5zfgzHSTdW2tqtWElaqF//XuTNzFvzro=;
	b=4/rpqSyFK2K50xefr8HFtppGgEQK3r12s514+J9kUmQ+YMw7HfTdav+T0lKyQCbgXSbx
	 DKsZZbYG+FKqdD8Nllp1CSZcKQjSsvRFy38H4+kCTMNN/B1BKOImUs52Mg84c+gersudt
	 1nhkiTj9eHA8YpIANz8F6aaxuqGdIy4UKTPQHrlRup9ykuyM1e48DCLoWH+LJmy8YnBrq
	 yC130PILUasc4qrY6FDkZLfc6C1MRNB4sZ5sGKGpwnVYGtCmoepnub6QBIGfj3hCkCCi/
	 BKRjM/XKEoo2owCDsEVw5s/yzNJm4cv/w8ZI0cTJPZODUvkdstRGivkn8JucotjRJIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xrRNF4B2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0D2606A31A;
	Wed, 28 Oct 2026 18:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xrRNF4B2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078F81F031E1;
	Wed, 28 Oct 2026 18:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211923;
	bh=AmmD56WEfKO5zfgzHSTdW2tqtWElaqF//XuTNzFvzro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xrRNF4B2kWOHyqMVAYheWjIHSCCVwsjyQHWBQ9OiG3rlw0Yp5FdmoagLw8oEGVOuE
	 ElIv4q61K79/a6a0w38zZKzzHYEMwoy1Pi4qi2kX7E6415n5kBjArmz8wzwrpyDYCd
	 ffOEw7xslD3FdwRmBV/M3f1qV0i7cXbqcASm8mY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 547/571] xfs: dont hold buffer locks across sync transaction commit in xfs_sync_sb_buf
Date: Wed, 28 Oct 2026 18:01:34 +0100
Message-ID: <20261028170021.016162231@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yun Zhou <yun.zhou@windriver.com>

[ Upstream commit 41a28c865d1d5843f8cb9e0af17a8f4d9e2961ff ]

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
[ sashal: Omitted realtime superblock handling because xfs_sync_sb_buf() only handles the main superblock. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index e95a6b2ecded6..ad3b7f6e70ee6 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1081,26 +1081,23 @@ xfs_sync_sb_buf(
 	struct xfs_mount	*mp)
 {
 	struct xfs_trans	*tp;
-	struct xfs_buf		*bp;
 	int			error;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
 	if (error)
 		return error;
 
-	bp = xfs_trans_getsb(tp);
 	xfs_log_sb(tp);
-	xfs_trans_bhold(tp, bp);
 	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp);
 	if (error)
-		goto out;
-	/*
-	 * write out the sb buffer to get the changes to disk
-	 */
-	error = xfs_bwrite(bp);
-out:
-	xfs_buf_relse(bp);
+		return error;
+
+	/* Re-acquire and write the sb to disk. */
+	xfs_buf_lock(mp->m_sb_bp);
+	error = xfs_bwrite(mp->m_sb_bp);
+	xfs_buf_unlock(mp->m_sb_bp);
+
 	return error;
 }
 
-- 
2.53.0



