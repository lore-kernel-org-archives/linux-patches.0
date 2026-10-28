Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207833;
	b=PBfcExJ+ppt76ZWrQ1eePTKldo8T+gaeR/uoXvyQswEc0iI/+vUdb55/pJqhjOgoJJz+
	 g5nrFEBjFMhIYMvsu7ZYaaHgQ8kuPnRDq3JNTrgy/C+blsJo719DF2P9o6Dkj8v0cT3uj
	 Fy7mpOeHnpMhOSom6tOdsXWWBOm3CzHHo9dDTuQAUHJhJ+TlKqdZUkJhkb3ye7Nt7Qsgu
	 7WYVXIU8vDrjwQi1FpETCENcD1zIlRHZ4ypOnxA/Fm3j+GDnLXTKg7sK/71tz+6+wGPhY
	 kaVaUoH4OjEQ/hejGmaNgL1TsOESa0Qu1e/3cXYXBPa2tNsC36Q0z4Shlm3pSdASfhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EN/+P7CVEskAeau5sPk1NhOsTFlA2uQJERXThHsUii8=;
	b=wZ0tjbcY6cUcYIOjDFx0jwIDfSgJgo5GFF4dDah3us7lvfzoAupIYaSm8bk6QrEmOZd4
	 73w4zGOY4KXLnSBc2aWdUI9aVwEzayg3sDu/vL/KYiq/2GRQb0xbY+KW//+UFqnJWV8QU
	 StqoTnSdoGn3O0/a5DPjcHGq9CjLNfAHNmpU7lCVIFxMOzFj+lpNF92Sy+qK4G278nrfS
	 Yww7LWkwFvre825/8Nu3/q6ObFZstxIt5YpVWYAXpQQCfwzxaRUqx5YeqBH4Fizq5zO+s
	 V7JwndGWKeuWKPJ7WE7mY8ttPbPrkHNFS+EpONO0eDJ/Io7EWECUTNp7ujHj0zC966A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lOkiAtrS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA82F606A325;
	Wed, 28 Oct 2026 17:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lOkiAtrS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB761F031E2;
	Wed, 28 Oct 2026 17:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207832;
	bh=EN/+P7CVEskAeau5sPk1NhOsTFlA2uQJERXThHsUii8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lOkiAtrSxaJ1v9gDN8KPzZT/c1ToI3SaXNsepfDxPY31EuudWHhy1q5wjbJFYhkO8
	 rsTpVS9Sr+j3WDkorosHyXm278KixagjfJ65bflu1BatJlyn0Hmk0w7iw7niFTyN6r
	 Nj0kM4xgU75YcCzibvEu4BX4N9e/CE3zgeiq1tCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 155/247] xfs: dont hold buffer locks across sync transaction commit in xfs_sync_sb_buf
Date: Wed, 28 Oct 2026 17:59:18 +0100
Message-ID: <20261028165951.083217592@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Omitted realtime-superblock changes because the corresponding support is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index eb46712e27d9f..de10b1adbf8a5 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1186,26 +1186,23 @@ xfs_sync_sb_buf(
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



