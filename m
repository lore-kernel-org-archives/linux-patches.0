Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047070;
	b=TPSFJD18LHK7cWeCSQTdvg+87+e/dO16qgdGs4w/QnyJxEqD/nX4/aTIWTXW8Iav0XKX
	 FKH19A7otDwyYV2tGcchbaSwZVR+u4y/arJzbx6z7FCZ1lazaN245jBtdESZKGlC5UPRQ
	 A9Xj7yMoIYsgTi/L3QSoFLU+4KX6YYvjsUlcSMC+VczOSMF5mBirHs7V3qt1c+IlrgjP/
	 aBQ3sqEOd0i24CUzyoXvunosc+nGxWmBKBmyy/x7Mqpr1qUCQkFtc76l/oH6Y8mj+Edx6
	 nQA8IdT6DCYDdxPUF2ff2kdmkcFwDrbByIlbUhdrZ+w13TYEH7m1XsjL4t6a2jTmaMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047070;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Kpmia1o7GjxBNqYbFt3V02QAnp75gQ68wHeK1Muc/hU=;
	b=hwHayjHoMrRrq+h7cYkkPpMqwfNmJCyVQIgOOTRK/8TSJJhaBWcTCQNvPpwBjNgx74Pc
	 KEL3NQK2L8QLqfS+9sxForBSepjBcXQZNdlg0IoN6bFW3+ulfRCopr/tp5RdO6WXrV/B1
	 eu+g3IZIaQABXE98PlyxoF+hyVFdnLmNrPyGUAPyM29iJ9Xrla0ZRKfCLp5gecyTPyFGC
	 H7neoWQLbMje6855f+APSYEotGcEgIVOAsUBQ43hzJjK9braNvL2duSDHzWWWmi4gauf/
	 WdMrSGbjOmBGP/6SEjlxKcO2JuOzICGJotmgsEqTW+aJNyDsFTxv8x2d6K+pPAKY9yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GJCZmQRA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE797606A31C;
	Thu, 19 Nov 2026 00:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GJCZmQRA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119281F000C4;
	Thu, 19 Nov 2026 00:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047070;
	bh=Kpmia1o7GjxBNqYbFt3V02QAnp75gQ68wHeK1Muc/hU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GJCZmQRA+Z3AnCxfZZVVRffIlu9M1aD1na1n5EXEOM9aw2mNBkpFOuvo9FWQkSmjf
	 fJcq14ALzcPFUFSuzDrTGaQkVJYfbscopSUVUNL9+xVW7Mf7JZPmLthhNcfKk7lutr
	 k8sRd9snXcPo5hjaxPknHyV3khMEL0N+a7398oQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Lagerwall <ross.lagerwall@citrix.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger@xenproject.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1505/2857] xen-blkfront: Fix IO race during unplug
Date: Wed, 18 Nov 2026 15:42:19 +0100
Message-ID: <20261118150255.522012432@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ross Lagerwall <ross.lagerwall@citrix.com>

[ Upstream commit 61b6d1df1d6234c38a6ea7e4f58e7da035ef6ab4 ]

During unplug, blkfront stops the hw queues and marks the disk as dead,
then later during removal calls del_gendisk(). However, IO issued after
the hw queues are stopped but before the call to del_gendisk() will be
queued but never handled. This causes del_gendisk() to hang forever
waiting for the queue refcount to drop to zero.

This can be reproduced by issuing IO during an artificial delay after
stopping the hw queues.

Fix this by simply not stopping the hw queues directly. Marking the disk
as dead already freezes the queue which prevents new requests being
added and it synchronously runs the hw queues to clear anything pending.
If the hw queues are stopped when calling blk_mark_disk_dead(), running
the hw queues is a no-op and can leave queued requests unprocessed.

Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Acked-by: Roger Pau Monné <roger@xenproject.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20261006163411.2583538-1-ross.lagerwall@citrix.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/xen-blkfront.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 7ad03bcd9f274..207a2ec844849 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -2131,10 +2131,8 @@ static void blkfront_closing(struct blkfront_info *info)
 		return;
 
 	/* No more blkif_request(). */
-	if (info->rq && info->gd) {
-		blk_mq_stop_hw_queues(info->rq);
+	if (info->gd)
 		blk_mark_disk_dead(info->gd);
-	}
 
 	for_each_rinfo(info, rinfo, i) {
 		/* No more gnttab callback work. */
-- 
2.53.0



