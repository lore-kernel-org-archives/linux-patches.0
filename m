Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0816C307AC4;
	Sat, 25 Oct 2025 16:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409167; cv=none; b=vCWVPCO1L/Ulpb2v3N4koHWU8F2cGA98l0vSTL1efqruAjSzEoGsmOeMK+fawLuR1iwOMoEDPXE0LfdGmCHL4yofHuP4hitpKSlydJVgHu8+Iwy5oXgHDI1VBntBEnU0PvmCsqyHBxgrBQbN8WKNJKnkFJRIGFR49j1rmx1HuV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409167; c=relaxed/simple;
	bh=AbpB0gL1tgUYZeJubeGkbYNli+tZXVzNp/3ticMHYC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mUQp/+Xq3YQchc8UM3YTpC3ZwGbTPV6mdwEfnl8I8J/VQ1uEH9BR9yV1d+ZhEH/qtg4HyRcaLo2/SJMRTU6+m5cHT6+CT3MO4pU/Wc05JS0m5j/BbkpE94AdZTuwaD7AdYaHzhDEDNGD/0tvPrNgV8kcMNckmFNi/dsNKtAhG/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XFQwp6Sd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XFQwp6Sd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36CBC4CEF5;
	Sat, 25 Oct 2025 16:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409166;
	bh=AbpB0gL1tgUYZeJubeGkbYNli+tZXVzNp/3ticMHYC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XFQwp6SdVE14tJK/vqM0/78cuUrVDlaBguvxfhSGr6nVpviXpr0bNEx4HGHehjXxW
	 UODr/fpmywsX9DtYXDwo2LuULPPrKPazm29LOi7zw1Mv/tt7wubLBcfcwaliyaPpLO
	 YPD9IVQuJLrfhLQlI9BnNz7G/N0pkCvoOcdvZuiGFmB+hkFsrxK0VoWHq6VMjl+Y6p
	 LjUCTanqJWJKimjNrVWe1DpE+Fah05ZKaT3g9jto9+NzWI7+2H/tb9ma7NJebQsVWH
	 W7hxv9+JPy8YxqUi5gY7QUmDpQCXbQhcr3Ec917wssAbq0uMpR557r7eZlBDin0odG
	 G+C7lCCGfejEA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>,
	syzbot+c4f3462d8b2ad7977bea@syzkaller.appspotmail.com,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	shaggy@kernel.org,
	alexander.deucher@amd.com,
	alexandre.f.demers@gmail.com,
	jfs-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 6.17-5.4] jfs: fix uninitialized waitqueue in transaction manager
Date: Sat, 25 Oct 2025 11:57:38 -0400
Message-ID: <20251025160905.3857885-227-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES
- `txInit()` previously skipped index 0 when priming the `tblock` wait
  queues, so `TxBlock[0].waitor` stayed uninitialized
  (`fs/jfs/jfs_txnmgr.c:270-284` before the patch). When the filesystem
  is mounted read-only, `txBegin()` legitimately returns `tid == 0`
  (`fs/jfs/jfs_txnmgr.c:348-354`), yet every caller still executes
  `txEnd(tid)`. `txEnd()` immediately calls `TXN_WAKEUP(&tblk->waitor)`
  on that reserved entry (`fs/jfs/jfs_txnmgr.c:500-506`), which trips
  lockdep (“trying to register non-static key”) and can panic the
  system, exactly as reported by syzbot.
- The fix ensures both `waitor` and `gcwait` are initialized for all
  `tblock`s, including the reserved slot 0, by running a dedicated loop
  from 0..nTxBlock-1 before wiring up the freelist
  (`fs/jfs/jfs_txnmgr.c:275-283`). No other behaviour changes occur: the
  freelist population for indices ≥1 remains identical, and slot 0 is
  still excluded from allocation.
- The bug was introduced when `txBegin()` started returning 0 for read-
  only mounts (commit 95e2b352c03b0a86, already in 6.6+ stable). Thus
  every supported stable tree that contains that change is susceptible
  to an immediate kernel crash whenever `txEnd(0)` executes—triggerable
  by routine metadata operations on a read-only JFS volume.
- The patch is tiny, localized to initialization, and carries negligible
  regression risk: initializing a waitqueue head twice is safe, and no
  concurrent activity exists during `txInit()`. There are no
  prerequisite dependencies.
- Because this resolves a real, user-visible crash introduced in
  currently-supported stable releases and does so with a minimal, well-
  scoped change, it squarely meets the stable backport criteria.

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

