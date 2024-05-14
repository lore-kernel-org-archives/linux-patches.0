Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B4B13A256;
	Tue, 14 May 2024 11:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684662; cv=none; b=bRZNaIL+UtFCku2fi/Bk3pas4dL68PGfMdzUeqybahYbP1djdHTPhbl5mdmQQg900b2MlHs9ec5Oh3Fv9/dYouHjs6x8hyVTE0TuCIj2pIqisyhI102y3llzzkw0SMLFbBaRa9007Aj6NfXZRsCXJ5K1AKzP0Wf5me/17SMFMQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684662; c=relaxed/simple;
	bh=HGml4OBI/BbGmWcRU1RpSAXxYDyKCkfyetwDAlT7rIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xmy5wWUxxUAVMJS4yieI/NtGiSdGJ24IatHHiLm01nEyCAsWQJKbvT83/PsWXCNH1XyqdHMrNH3DybFzIPAzcovrsYZv6Vi1DwYAeZgeZFExpOQm57Qq6W9GL19fS8y1a7vRH6RpyX1Gb0jSRee16kEi3F+x/SeIoPSwMTo5t0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dw2C09kr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dw2C09kr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93587C2BD10;
	Tue, 14 May 2024 11:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684662;
	bh=HGml4OBI/BbGmWcRU1RpSAXxYDyKCkfyetwDAlT7rIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dw2C09krt30b2cB3cLlCPE11Z0NEQtbWUiu4Qs4svdavhDhpthfTd8Mj4EOdOHJ3x
	 k3JIyinR27CfwHEbLUDzCqFz1XWWkKep/YitpVLKoOENJ1SUPyEafHQGEJIYIgaUjM
	 s1b8YNmbk5wp0vSTnb3QriAZei78KtQfR3kimLUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"John B. Wyatt IV" <jwyatt@redhat.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/301] cxgb4: Properly lock TX queue for the selftest.
Date: Tue, 14 May 2024 12:15:43 +0200
Message-ID: <20240514101034.969002948@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 98dd78551d89a..fff1ce835bc0d 100644
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



