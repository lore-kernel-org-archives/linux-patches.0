Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B062E0412;
	Tue, 11 Nov 2025 01:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825379; cv=none; b=WmWyUMHXtCcHhYUGKce3r5kQRKhfKaUnfZH/Fvl+AlrFWc+yUVQMy9y5PdzW6NwFF1xi1Jf2NQu202AUFOsR+Us+z2Hqgv82XweIwjaCVns6k6Q3RvqdsUsAU6ZvpVj8++U5WBogacLYMEwxhiuAKygD8XCymj3Tqjif21nbI7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825379; c=relaxed/simple;
	bh=519wM4PKG6MoONCdKIiXPLs8sxFX6t3gCRMOZP/edZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FgxI04NP/9NNJ7m7mBGOyuEmiC79R/j7DcAer4O251cfLtMi5quoXGlTYXWakYoK+mN1WkwoGj90fIGJkYGcE1nENdDf8lAusf3779eaBRUeeQEb+hdFSMj3F9KRu1Bmqn+dH2sG/EPydCjnWF80gN9hUSAjZ0U1raKcKwNEkoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YQoIC3/V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YQoIC3/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A59C19422;
	Tue, 11 Nov 2025 01:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825379;
	bh=519wM4PKG6MoONCdKIiXPLs8sxFX6t3gCRMOZP/edZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQoIC3/VgHTZ7Ha1iEUJm646iqZxiuw7uwJI83gNq36/I1X/1UU/tww+s6o/6JF/G
	 LCTIdNi7v85EFlqKDDE8Ea4T4tkhQM6as6R3NdSgkOhNo73bDPQULnKsCkfyGGU2jv
	 3X6QmpYRw29/Ud30HFF+DXsiM7lrN2+OgpWhjhLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammad Heib <mheib@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 777/849] net: ionic: add dma_wmb() before ringing TX doorbell
Date: Tue, 11 Nov 2025 09:45:47 +0900
Message-ID: <20251111004555.214231705@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohammad Heib <mheib@redhat.com>

[ Upstream commit d261f5b09c28850dc63ca1d3018596f829f402d5 ]

The TX path currently writes descriptors and then immediately writes to
the MMIO doorbell register to notify the NIC.  On weakly ordered
architectures, descriptor writes may still be pending in CPU or DMA
write buffers when the doorbell is issued, leading to the device
fetching stale or incomplete descriptors.

Add a dma_wmb() in ionic_txq_post() to ensure all descriptor writes are
visible to the device before the doorbell MMIO write.

Fixes: 0f3154e6bcb3 ("ionic: Add Tx and Rx handling")
Signed-off-by: Mohammad Heib <mheib@redhat.com>
Link: https://patch.msgid.link/20251031155203.203031-1-mheib@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index d10b58ebf6034..2e571d0a0d8a2 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -29,6 +29,10 @@ static void ionic_tx_clean(struct ionic_queue *q,
 
 static inline void ionic_txq_post(struct ionic_queue *q, bool ring_dbell)
 {
+	/* Ensure TX descriptor writes reach memory before NIC reads them.
+	 * Prevents device from fetching stale descriptors.
+	 */
+	dma_wmb();
 	ionic_q_post(q, ring_dbell);
 }
 
-- 
2.51.0



