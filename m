Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209520;
	b=hMVinHaM1d7yLH9cCBJx/DT2MqXlxrgfUHohPfiNf7gdF7GOYvNPGHak8maFMgaYvWAy
	 aM5Nmktk+Dc2StbanhnuEnM3cc/c/m4/FdY0JyWHlTgFnEWNm7ES+1hBR1nNxuXweOqZ7
	 gbzY7ishUSVpImhNVDl0rwrYAyE+72WaxdImRmF4QLJE5jLo1PIsmIzK/Jqx7Aaygv+eS
	 dTLDAuZaV9m/GkWk4pdmhh9WWUmOe6jqDkjPC4wdPTaETL5HhDJZUbgceCyAZTjN0RveF
	 bba3FlrKQZpp4MUKEzQoGOuMZ7phVecUBTMjCbu1P3EjyuLZr4rbMZHGi0FDa3FtRKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209520;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/L5R//FilBfFIgZ544pCk8ezQEIC7lJYDSNtCXjakjM=;
	b=zkJadkVwZk1O+nnZOlGUvYUCuBdZeRoz7ngfrOH/R55dmtuaj2wFC4qN3VFqxZ6WqWq1
	 ealU13wELGVwnM0uywm92bYCdvKHus6Qu7B4qNH9w1i4OB7jXQY8hGE2wn8XsKzGrx+Xt
	 0JNRCSA69f2fVnzcUn4uw4uo6bBYsoDxuG0D8dwYtsexzNauYAuhKVE2m9aT+XmHoxxLb
	 6++q7IoyYHmMtjZDna7mgghGGXDPsAbsZyyFJrRNjHfcBRElfOxACZjVqmTLu5xUNMu5D
	 dv0KkMfFvhBMMs+GsuGR6r888OkDCAjhTYsBiNtQOdM9S3VJ0yqGz9yT0osnD1Ee7fA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kS7kh5yf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676E6606A31E;
	Wed, 28 Oct 2026 17:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kS7kh5yf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B829E1F01825;
	Wed, 28 Oct 2026 17:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209520;
	bh=/L5R//FilBfFIgZ544pCk8ezQEIC7lJYDSNtCXjakjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kS7kh5yfIC8ipRwOZeZdch4tSK2Ic04ziWhIPUda+HF4+iEmMApmTQIvi3LNv1OcQ
	 RBNmCRMal6+yqwefhAaQIqbm+T86MJlNF8SLlcQcoWTADQ+t+UrZeevjQkdeu1X30w
	 tneWTLPMVsc6oHYVM3qwJmotfzn8UE+KZ2WpUwx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 499/516] xfs: dont hold buffer locks across sync transaction commit in xfs_sync_sb_buf
Date: Wed, 28 Oct 2026 18:00:51 +0100
Message-ID: <20261028170015.299538686@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Omitted realtime superblock changes because xfs_sync_sb_buf() lacks realtime superblock support. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 40b31fa6687b7..2cc8da99a42e4 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1151,26 +1151,23 @@ xfs_sync_sb_buf(
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



