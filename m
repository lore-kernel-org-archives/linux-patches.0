Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20252DA757;
	Tue, 11 Nov 2025 01:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824120; cv=none; b=dB9ajDuDmtxR1f2D4ichk+T9ABTrZ7EqeED8CCaEsVasKaxYikRDH++k7jFDd87Dt9p5p4SPxHNz2CxcsKag4KFsoL3owkYz/gMVop6so6qVV9gh3U2ipvF4F3SDr+DeAxsiag3TWU/wW/I7QpWXYRcWs3ZwqqIl3WzIcaZx/QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824120; c=relaxed/simple;
	bh=QSuCtokbByleE4sD52qVbO9iShJ9EETOcNQAEIkV8Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JT+AouvddQFg/eF373s8ntQGdZHgH0cGBV4vM6jM+d3YV7y0dt5HHudV/f8EDS1IWzkVoSXJ5zDZNNI9mbC+PoxFwXx7BJLTfAnvfMc1N1n965OJliEkOd+FcyWs6ZOQpkmaqtcOxnKSrwSKt9xrpsuF/Kwp09mmrm4OIoB5UmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hKhgDr7v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hKhgDr7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E19C113D0;
	Tue, 11 Nov 2025 01:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824120;
	bh=QSuCtokbByleE4sD52qVbO9iShJ9EETOcNQAEIkV8Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hKhgDr7vGGfX1oZFKIU4pmC10tp+J+OPrAnzzqv9CUdF0bQCk7B0uc0BgyqW0e6+a
	 SZsdRHoN8gklNRx7zGEs54MnEU3QuuWSXCXjJlCdimd97QGY0o9D4t6qQO3DnnuV4F
	 L5VWCN/6oCG01lM88UHWOccDR7tpmreV44Lb0ehU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c4f3462d8b2ad7977bea@syzkaller.appspotmail.com,
	Shaurya Rane <ssrane_b23@ee.vjti.ac.in>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 391/565] jfs: fix uninitialized waitqueue in transaction manager
Date: Tue, 11 Nov 2025 09:44:07 +0900
Message-ID: <20251111004535.668292559@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>

[ Upstream commit 300b072df72694ea330c4c673c035253e07827b8 ]

The transaction manager initialization in txInit() was not properly
initializing TxBlock[0].waitor waitqueue, causing a crash when
txEnd(0) is called on read-only filesystems.

When a filesystem is mounted read-only, txBegin() returns tid=0 to
indicate no transaction. However, txEnd(0) still gets called and
tries to access TxBlock[0].waitor via tid_to_tblock(0), but this
waitqueue was never initialized because the initialization loop
started at index 1 instead of 0.

This causes a 'non-static key' lockdep warning and system crash:
  INFO: trying to register non-static key in txEnd

Fix by ensuring all transaction blocks including TxBlock[0] have
their waitqueues properly initialized during txInit().

Reported-by: syzbot+c4f3462d8b2ad7977bea@syzkaller.appspotmail.com

Signed-off-by: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_txnmgr.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
index be17e3c43582f..7840a03e5bcb7 100644
--- a/fs/jfs/jfs_txnmgr.c
+++ b/fs/jfs/jfs_txnmgr.c
@@ -272,14 +272,15 @@ int txInit(void)
 	if (TxBlock == NULL)
 		return -ENOMEM;
 
-	for (k = 1; k < nTxBlock - 1; k++) {
-		TxBlock[k].next = k + 1;
+	for (k = 0; k < nTxBlock; k++) {
 		init_waitqueue_head(&TxBlock[k].gcwait);
 		init_waitqueue_head(&TxBlock[k].waitor);
 	}
+
+	for (k = 1; k < nTxBlock - 1; k++) {
+		TxBlock[k].next = k + 1;
+	}
 	TxBlock[k].next = 0;
-	init_waitqueue_head(&TxBlock[k].gcwait);
-	init_waitqueue_head(&TxBlock[k].waitor);
 
 	TxAnchor.freetid = 1;
 	init_waitqueue_head(&TxAnchor.freewait);
-- 
2.51.0



