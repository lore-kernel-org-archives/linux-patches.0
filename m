Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17697253F03;
	Wed,  4 Jun 2025 01:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748999236; cv=none; b=dh5uweFKTGYU+NBNWuVplsZzMZbE7EeOUtyPUOOkabfAWcc+YZ7HIJVlPNCmlRmho7i1VnPF0P4SsM+Ine5oZUBx5TwgqkSbPLq2PeX+t2YoN05LoHyuy5ydw1vuA6Nu+tOx8Zq6UQQZDbpTqaMSw4AN1cq9iZ3Zw7rDQRxmASg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748999236; c=relaxed/simple;
	bh=w3FPo9f/e18ejmN1oZx2O8crnFnL6oVnIVlzIPFn+1A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hTr6dc1X2QXc+Cwp/4eTXQoV6jGMqe4j4J/1dxgS4PfwPtZj3JN7fbZiTB82aPzLT9tjIVDo0Tl3/W3qsfvotEFD4wjdT4x1Qd+e56SlBhjg2Ozx24tX3wbs00cE84Jj6eXh3bJ+4dVV7ZbUlh6sGKlF+CBMFz938oD923T9zdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dnpbFdN/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dnpbFdN/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07669C4CEED;
	Wed,  4 Jun 2025 01:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748999236;
	bh=w3FPo9f/e18ejmN1oZx2O8crnFnL6oVnIVlzIPFn+1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dnpbFdN/Bn51GYqNjehKb9FJI/WISZ4V/hNlgFEj6N/uiwvHN6sZ9Ns4IrVsu3seS
	 8jjRa3WyxzBNeN1U5XBODNKbY5JmHZxm87hjC3D0kqFkoOip0LoxtrZJiOSDEh3isP
	 QG3YhTjcmBpIYw12dp6S4ErU8uXAGxT+0NNaWSCG/Qc4ZNbCN8Ik3u4mAxwhA6/nfx
	 E8V0BMJiNfClCU1GZHzWtL7DthsveFVo8C+cD/BV/nqOZC7GR42x3a0vWLmQCehpZe
	 y5A/Cq5wC6LvBttQm/oKzDwc8Lyh/+SN88gXiDiTr2W/V+6wiVMZRj0MmioCFQ5FdU
	 BBiVpwTbPBe1g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Moon Yeounsu <yyyynoom@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	horms@kernel.org,
	tglx@linutronix.de,
	davem@davemloft.net
Subject: [PATCH AUTOSEL 5.4 05/20] net: dlink: add synchronization for stats update
Date: Tue,  3 Jun 2025 21:06:51 -0400
Message-Id: <20250604010706.7395-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604010706.7395-1-sashal@kernel.org>
References: <20250604010706.7395-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.293
Content-Transfer-Encoding: 8bit

From: Moon Yeounsu <yyyynoom@gmail.com>

[ Upstream commit 12889ce926e9a9baf6b83d809ba316af539b89e2 ]

This patch synchronizes code that accesses from both user-space
and IRQ contexts. The `get_stats()` function can be called from both
context.

`dev->stats.tx_errors` and `dev->stats.collisions` are also updated
in the `tx_errors()` function. Therefore, these fields must also be
protected by synchronized.

There is no code that accessses `dev->stats.tx_errors` between the
previous and updated lines, so the updating point can be moved.

Signed-off-by: Moon Yeounsu <yyyynoom@gmail.com>
Link: https://patch.msgid.link/20250515075333.48290-1-yyyynoom@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees for the
following reasons: **1. Critical Data Race Fix**: The commit addresses a
real data race condition where `dev->stats.tx_errors` and
`dev->stats.collisions` can be accessed concurrently from user-space
(`get_stats()` function) and IRQ context (`tx_error()` function). This
is a genuine bug that can cause statistics corruption. **2. User-Visible
Impact**: The race condition affects network statistics that are exposed
to userspace through standard interfaces like `/proc/net/dev` and
ethtool. Corrupted statistics can mislead network monitoring tools and
system administrators. **3. Low Risk, High Value Fix**: The changes are
minimal and follow established kernel synchronization patterns: - Adds a
single `spinlock_t stats_lock` field to the driver's private structure -
Protects critical sections with
`spin_lock_irqsave()`/`spin_unlock_irqrestore()` in `get_stats()` -
Protects IRQ-context updates in `tx_error()` with the same spinlock - No
functional logic changes, only synchronization additions **4. Self-
Contained Changes**: The fix is entirely within the dl2k driver
(`drivers/net/ethernet/dlink/dl2k.c` and `dl2k.h`), making it safe to
backport without affecting other subsystems. **5. Precedent from Similar
Commits**: This closely mirrors "Similar Commit #5" (net: stmmac:
protect updates of 64-bit statistics counters) which was marked as
"Backport Status: YES" for addressing the same type of statistics
synchronization issue. **6. Follows Stable Tree Criteria**: - Fixes an
important bug affecting users - Changes are small and contained -
Minimal risk of regression - No new features or architectural changes
The fix prevents potential data corruption in network statistics, which
is exactly the type of bug that stable kernels should address to
maintain system reliability and data integrity.

 drivers/net/ethernet/dlink/dl2k.c | 14 +++++++++++++-
 drivers/net/ethernet/dlink/dl2k.h |  2 ++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/dlink/dl2k.c b/drivers/net/ethernet/dlink/dl2k.c
index 55e720d2ea0c7..77388a66b1d8f 100644
--- a/drivers/net/ethernet/dlink/dl2k.c
+++ b/drivers/net/ethernet/dlink/dl2k.c
@@ -155,6 +155,8 @@ rio_probe1 (struct pci_dev *pdev, const struct pci_device_id *ent)
 	np->ioaddr = ioaddr;
 	np->chip_id = chip_idx;
 	np->pdev = pdev;
+
+	spin_lock_init(&np->stats_lock);
 	spin_lock_init (&np->tx_lock);
 	spin_lock_init (&np->rx_lock);
 
@@ -875,7 +877,6 @@ tx_error (struct net_device *dev, int tx_status)
 	frame_id = (tx_status & 0xffff0000);
 	printk (KERN_ERR "%s: Transmit error, TxStatus %4.4x, FrameId %d.\n",
 		dev->name, tx_status, frame_id);
-	dev->stats.tx_errors++;
 	/* Ttransmit Underrun */
 	if (tx_status & 0x10) {
 		dev->stats.tx_fifo_errors++;
@@ -912,9 +913,15 @@ tx_error (struct net_device *dev, int tx_status)
 		rio_set_led_mode(dev);
 		/* Let TxStartThresh stay default value */
 	}
+
+	spin_lock(&np->stats_lock);
 	/* Maximum Collisions */
 	if (tx_status & 0x08)
 		dev->stats.collisions++;
+
+	dev->stats.tx_errors++;
+	spin_unlock(&np->stats_lock);
+
 	/* Restart the Tx */
 	dw32(MACCtrl, dr16(MACCtrl) | TxEnable);
 }
@@ -1084,7 +1091,9 @@ get_stats (struct net_device *dev)
 	int i;
 #endif
 	unsigned int stat_reg;
+	unsigned long flags;
 
+	spin_lock_irqsave(&np->stats_lock, flags);
 	/* All statistics registers need to be acknowledged,
 	   else statistic overflow could cause problems */
 
@@ -1134,6 +1143,9 @@ get_stats (struct net_device *dev)
 	dr16(TCPCheckSumErrors);
 	dr16(UDPCheckSumErrors);
 	dr16(IPCheckSumErrors);
+
+	spin_unlock_irqrestore(&np->stats_lock, flags);
+
 	return &dev->stats;
 }
 
diff --git a/drivers/net/ethernet/dlink/dl2k.h b/drivers/net/ethernet/dlink/dl2k.h
index 195dc6cfd8955..c24823e909ef9 100644
--- a/drivers/net/ethernet/dlink/dl2k.h
+++ b/drivers/net/ethernet/dlink/dl2k.h
@@ -372,6 +372,8 @@ struct netdev_private {
 	struct pci_dev *pdev;
 	void __iomem *ioaddr;
 	void __iomem *eeprom_addr;
+	// To ensure synchronization when stats are updated.
+	spinlock_t stats_lock;
 	spinlock_t tx_lock;
 	spinlock_t rx_lock;
 	unsigned int rx_buf_sz;		/* Based on MTU+slack. */
-- 
2.39.5

