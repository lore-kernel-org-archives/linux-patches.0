Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B14DDBC;
	Wed,  4 Jun 2025 00:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998588; cv=none; b=FenQwme6nNDPgxG6QWSP4Kp85D7Z34auOOjvIbBLwsaIxYT0gREc0Rrxb7upoPQfYMHD7XM84PCCy0GHmj2Au7y3lpN30rL42S+zUNh7Xfevx4u2b07OYyh5ugrJJOy7Yg4rTZofKIhO6zjxk6LhDZZ03z61MvaVJ1AYDffb0IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998588; c=relaxed/simple;
	bh=qyDiYDBdihp2YcchsjfqcEWHlAXGjVYhSo5yE/WnWJk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ErR9A9hypRKGLC3a4HqKSV5oUdXjn+6wHS9nrMixwxtCM7MFo7bTgNvJuUMkrGUsoqqXoIv2gRTxPSVHvKK0leShfOjv4Flti9HdQxTK1R9w3bMzYoXhQUsCGZ/UadTPChFWUuGlZ1OmR00czI6oBacIoDE0FpadBHC5vNJGTVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PmQumRij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PmQumRij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402C7C4CEED;
	Wed,  4 Jun 2025 00:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998588;
	bh=qyDiYDBdihp2YcchsjfqcEWHlAXGjVYhSo5yE/WnWJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PmQumRij9hUzteu5Fq1n+VZ6uAx8CB1USiUq+3m9vEZ5fX28ZwrFfTvKM1y/0Uj6k
	 XrNdTVaEfW87SxtaI/G6TiOwRlfXOuocIsZaeU7GVrGr79LiF9w2iF/XvwknNH29R2
	 54J0mt5ekG9mEMPMqoDdrvikrNU8VFwBmROpPt8Ra4UhK0q6YLMZgubY4Wf1/CaNH6
	 RxWrq/YCgNjqSd3hHWP3FYow5KIAAe8x7dVZi6qyiiHU49HjIPnDaT+bRf66V1XlnC
	 ylFPA00wOQIOazOgLIm7wvXJR+lOWOh565q695ZdlKGXJOJ1N6AoJygMk6GjcvjyEd
	 CFe2pKnGvItxg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Moon Yeounsu <yyyynoom@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	horms@kernel.org,
	mingo@kernel.org,
	davem@davemloft.net,
	tglx@linutronix.de
Subject: [PATCH AUTOSEL 6.14 026/108] net: dlink: add synchronization for stats update
Date: Tue,  3 Jun 2025 20:54:09 -0400
Message-Id: <20250604005531.4178547-26-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005531.4178547-1-sashal@kernel.org>
References: <20250604005531.4178547-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
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
index 6bf8a7aeef908..787218d60c6b1 100644
--- a/drivers/net/ethernet/dlink/dl2k.c
+++ b/drivers/net/ethernet/dlink/dl2k.c
@@ -146,6 +146,8 @@ rio_probe1 (struct pci_dev *pdev, const struct pci_device_id *ent)
 	np->ioaddr = ioaddr;
 	np->chip_id = chip_idx;
 	np->pdev = pdev;
+
+	spin_lock_init(&np->stats_lock);
 	spin_lock_init (&np->tx_lock);
 	spin_lock_init (&np->rx_lock);
 
@@ -865,7 +867,6 @@ tx_error (struct net_device *dev, int tx_status)
 	frame_id = (tx_status & 0xffff0000);
 	printk (KERN_ERR "%s: Transmit error, TxStatus %4.4x, FrameId %d.\n",
 		dev->name, tx_status, frame_id);
-	dev->stats.tx_errors++;
 	/* Ttransmit Underrun */
 	if (tx_status & 0x10) {
 		dev->stats.tx_fifo_errors++;
@@ -902,9 +903,15 @@ tx_error (struct net_device *dev, int tx_status)
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
@@ -1073,7 +1080,9 @@ get_stats (struct net_device *dev)
 	int i;
 #endif
 	unsigned int stat_reg;
+	unsigned long flags;
 
+	spin_lock_irqsave(&np->stats_lock, flags);
 	/* All statistics registers need to be acknowledged,
 	   else statistic overflow could cause problems */
 
@@ -1123,6 +1132,9 @@ get_stats (struct net_device *dev)
 	dr16(TCPCheckSumErrors);
 	dr16(UDPCheckSumErrors);
 	dr16(IPCheckSumErrors);
+
+	spin_unlock_irqrestore(&np->stats_lock, flags);
+
 	return &dev->stats;
 }
 
diff --git a/drivers/net/ethernet/dlink/dl2k.h b/drivers/net/ethernet/dlink/dl2k.h
index 0e33e2eaae960..56aff2f0bdbfa 100644
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

