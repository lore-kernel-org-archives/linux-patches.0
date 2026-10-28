Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217111;
	b=bcaM/YjaGcc6gHxIS7wh0Gz0eFdqaSciuYhqludEeywN/enqwxXnfCC/rXtUoTi2FG0p
	 wtjjPG4E0vEsNy6LV+HH3W78EyWG0+fBi8/lZqqI/RsVBwY5G5xaNaEym+4fDjb186SRy
	 X7aAUWJuYK39Iphhp6VURnEAzwpD7rKbGOMH6M49BS07boiFcgON1U3VnShC6IXbCjpfh
	 uXwVIQmck6+az/pKiADi2I8nl0I90jp4KzsfmXvrK7X2blND2U9OUx71hgmkUAfUxKeGi
	 rMyicGjOUuD0QZb/2MbK3v243/6v6sw3V0SKFBbMzUaPzvij9sRa2ZUpJqGb3R3yOqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217111;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zWsblQ9LipAsLKXaXPUyB5qpFHNha/xBhJfi6xfHOT8=;
	b=PCmxQZ1TekN4oenYxih9+Ou27dNemREBEelubn7p0/QNZphVkIosr2bCucu5onMA87FR
	 Cjw9bSOCP4SDukHSrRWYWd0DAtmxXp89gGTZzNIKO/Ipve27ekgXW9DSOX61hUFlLLY2V
	 TtU/nepGHNfBRpObbOo/ZdcKWYjDr8yP52N5ZWajvPZIb7Qoqhz3+3uZpgvpZ/AxqSPoo
	 jWkGBtvGqIg9tYMvzPoxsKKZNEltnnczIEGYsGjL3SAqay66ryVZETQ3wQyLIEQL93cUg
	 Jbb9rBFnr7v753S0De0X0Px6GmTdGzegQ6SAQb0rBG35+ontjq6DBtrzN2yd33Rkpbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kzCc2raL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318C9606A322;
	Wed, 28 Oct 2026 19:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kzCc2raL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8479F1F01825;
	Wed, 28 Oct 2026 19:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217111;
	bh=zWsblQ9LipAsLKXaXPUyB5qpFHNha/xBhJfi6xfHOT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kzCc2raL0Ee5Nv1tN7U/pJKEYdv6rBFNNwzXIAgRKr81qjjY0WU2p8ja/Iq2TKDkY
	 MF4wJFEjyIIR/RpssAN8paSZvBxpYibCXZAnm6BHMsn3GTHckyG1Zas/z8DbefzreE
	 T6vrxMwKKhoIyOo9RuzprobGrYufpUvaUVqD2lck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1793/1887] xfs: dont hold buffer locks across sync transaction commit in xfs_sync_sb_buf
Date: Wed, 28 Oct 2026 18:04:49 +0100
Message-ID: <20261028170540.248793849@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: omitted realtime superblock changes because the target code lacks that support ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index b5f081993cd4f..6c5c2b40056d8 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1148,26 +1148,23 @@ xfs_sync_sb_buf(
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



