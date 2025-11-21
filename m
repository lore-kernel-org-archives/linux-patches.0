Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8DE346A0E;
	Fri, 21 Nov 2025 13:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732814; cv=none; b=kcY2mz634web2E69pBBddSOzELPo9PbILKbuag5Tdwc8jfxDKzMbzp52fey2hjLLugAa0b76t6jDznTzqzl/R3Vc9sks2O5s0KxRaiT9m4Vrtu/cBCBvMIJnGU1e4roQRWBLrpnIVOtPxWRZthKeNjA1rVd1tykvYo8Zk0BK+mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732814; c=relaxed/simple;
	bh=9BRKknYp/+4hA6Kvzud4XdmnnB5o3OBWddJK8yPbD7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vo32qvellH4eEtwyP56yB8VfaV0MUHwmZSEjbCr/5kQqkv09Rl0RNaCBxXzU9pDmdJyxOxz1ZG2/gIRo2RKqUnzJvRlI8j3JCiETzrRS+8tkXtcLMwKfV5jzoer5jBEBefXbbMjQXhWV85k0uAeLXdbeT1/86DHuNGrzVw7UXnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUvQG5U4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUvQG5U4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81459C4CEF1;
	Fri, 21 Nov 2025 13:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732813;
	bh=9BRKknYp/+4hA6Kvzud4XdmnnB5o3OBWddJK8yPbD7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tUvQG5U4JKrw6gbN/EA5R48yNHtEU2zu8AJLyKGO3omuUMAt39AhpGZa+CamwSKZa
	 nQXtlemwF7fx4Oyk9COYi8AnvW6+SyxQf5KxK5LggrUD8AGbeVAeMUDDDrPwzyzKXd
	 SZ57vuC7+4GO2mfxEnw10vPGgok/pymSaP8YiZKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c4f3462d8b2ad7977bea@syzkaller.appspotmail.com,
	Shaurya Rane <ssrane_b23@ee.vjti.ac.in>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 253/529] jfs: fix uninitialized waitqueue in transaction manager
Date: Fri, 21 Nov 2025 14:09:12 +0100
Message-ID: <20251121130240.021598827@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dccc8b3f10459..42fb833ef2834 100644
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



