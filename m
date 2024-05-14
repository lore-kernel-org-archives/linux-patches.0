Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4904584D26;
	Tue, 14 May 2024 11:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686258; cv=none; b=nOu3lMmr0z5Eq7cimnRAseaxQiyPZHq01I+fCfGKRgMCPG+z0HQ8zdQ//V1mpfyDKUqdcHUkwxyOgqYhMfQFgP2UbuDx2oeUyGxLgpJ/3j4Wtw3ULIyEpGpKiGaEs3C7/4OFbdw+kB+HKqmhouEiFx9efV0oeM2lgpmpDOXsyOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686258; c=relaxed/simple;
	bh=I9GivZ4WChiVYpakNbbb1yBnQ/hoyiQ0NMwOTmP5KTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amRztkqXU8VKBWgnR9jYJe3UP/RmK06dgcayEq7oizgE7t9UBNW0+V9L0T/nYcX4nOggG2zdcwuWEcziS/KIYLO4EwFzfzPkh7t86ExjBXWFQ7cs6CHVG4BKHZZ/gU9aNL483d+GPYa56arV6cTdeeBIxrsiKMbviRzKyMJQ8bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AgvJfTsD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AgvJfTsD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4ABC2BD10;
	Tue, 14 May 2024 11:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686258;
	bh=I9GivZ4WChiVYpakNbbb1yBnQ/hoyiQ0NMwOTmP5KTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AgvJfTsDfjz4wUN/2s1twwggc1fJLqJQh1pCaQCrjniyDgPAqFq/RJwd1kXJpLHT9
	 2UGj10IgkIHE6feOsSfvVWbV0fympdbCjXhS241sODHxU0zc8xW+Q+CtWGN5nK9ecF
	 aowqnqZx/tjq6nsbakIUTFyHM41FArRWv4Bc440o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"John B. Wyatt IV" <jwyatt@redhat.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/236] cxgb4: Properly lock TX queue for the selftest.
Date: Tue, 14 May 2024 12:17:16 +0200
Message-ID: <20240514101023.180585883@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 9067eccdd7849dd120d5495dbd5a686fa6ed2c1a ]

The selftest for the driver sends a dummy packet and checks if the
packet will be received properly as it should be. The regular TX path
and the selftest can use the same network queue so locking is required
and was missing in the selftest path. This was addressed in the commit
cited below.
Unfortunately locking the TX queue requires BH to be disabled which is
not the case in selftest path which is invoked in process context.
Lockdep should be complaining about this.

Use __netif_tx_lock_bh() for TX queue locking.

Fixes: c650e04898072 ("cxgb4: Fix race between loopback and normal Tx path")
Reported-by: "John B. Wyatt IV" <jwyatt@redhat.com>
Closes: https://lore.kernel.org/all/Zic0ot5aGgR-V4Ks@thinkpad2021/
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://lore.kernel.org/r/20240429091147.YWAaal4v@linutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 46809e2d94ee0..4809d9eae6ca5 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -2684,12 +2684,12 @@ int cxgb4_selftest_lb_pkt(struct net_device *netdev)
 	lb->loopback = 1;
 
 	q = &adap->sge.ethtxq[pi->first_qset];
-	__netif_tx_lock(q->txq, smp_processor_id());
+	__netif_tx_lock_bh(q->txq);
 
 	reclaim_completed_tx(adap, &q->q, -1, true);
 	credits = txq_avail(&q->q) - ndesc;
 	if (unlikely(credits < 0)) {
-		__netif_tx_unlock(q->txq);
+		__netif_tx_unlock_bh(q->txq);
 		return -ENOMEM;
 	}
 
@@ -2724,7 +2724,7 @@ int cxgb4_selftest_lb_pkt(struct net_device *netdev)
 	init_completion(&lb->completion);
 	txq_advance(&q->q, ndesc);
 	cxgb4_ring_tx_db(adap, &q->q, ndesc);
-	__netif_tx_unlock(q->txq);
+	__netif_tx_unlock_bh(q->txq);
 
 	/* wait for the pkt to return */
 	ret = wait_for_completion_timeout(&lb->completion, 10 * HZ);
-- 
2.43.0



