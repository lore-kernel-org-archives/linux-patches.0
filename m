Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE4D2EAE5;
	Wed,  4 Jun 2025 01:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748999143; cv=none; b=d3MXLcEG8Vh+pvfBwmvgWk0gzOxjFVE/vYP/w5KTxXr4OiTDtXrvZ+SIKLKg8I13kfOV1DDIs7b7jJSE4BqBZ9hHOFuSotCAzw6hh6AXfYnt2fcH7MHsA0gYpRddePkETksbyojFKZuyfOOPG+k+vby+YsT+wW5+qhgtoGxl2qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748999143; c=relaxed/simple;
	bh=O3W+qVgEW7YL7/MvyT+U9y89YihNvI+xmbgzHmluf7U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=frEXUHE/Wvqv1jsPlWoVuR+90BuexLhrnS8MXndWtgBrvJYEmHUHTjgyRpiB2Iq9xh9SwkGGetkmy0BjHX+S0/anozupH1umrH+cAThTJU/K0srkyU2Wr6tXSl5sT2Oj8QnYQJpqjIWJm4l+lrr6eZLIRpUod3X4OM5oQuxeLKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=olGP1ZHx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="olGP1ZHx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D241C4CEED;
	Wed,  4 Jun 2025 01:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748999142;
	bh=O3W+qVgEW7YL7/MvyT+U9y89YihNvI+xmbgzHmluf7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=olGP1ZHxmGWEZ/599feehfV0mOk74DdWHHB457OBPANGHe9uQoREesKWUOU8Ilq4y
	 WFevW5AzIF9g+c9Gne+osdsjlDH7qTPuZvnzl/4VrbsdjWhss3j4UapOdN/NMZoTil
	 bJBE+mKqsyctmw0uqX0aM4YJFlxpi1wYtVfh7bH2QLrSuNVFs0l0Sy/cAWTlYUSGxJ
	 yddg2ajuopVIan/YMWEcxe3FtuegTpEjRP+aDmqAGBtgyhGumHMHlUrQvGWVBfH86K
	 rwkpLZubi8Z64B3RCcTNB4+F3/w8+m82P59XIl/tJKnbfe04NP5rLsXSAu9mJWlLxr
	 8q4Qqreuuok+g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Moon Yeounsu <yyyynoom@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	horms@kernel.org,
	mingo@kernel.org,
	tglx@linutronix.de,
	davem@davemloft.net
Subject: [PATCH AUTOSEL 5.15 09/33] net: dlink: add synchronization for stats update
Date: Tue,  3 Jun 2025 21:05:00 -0400
Message-Id: <20250604010524.6091-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604010524.6091-1-sashal@kernel.org>
References: <20250604010524.6091-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.184
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
index af0b6fa296e56..09a275eb44487 100644
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
 
@@ -869,7 +871,6 @@ tx_error (struct net_device *dev, int tx_status)
 	frame_id = (tx_status & 0xffff0000);
 	printk (KERN_ERR "%s: Transmit error, TxStatus %4.4x, FrameId %d.\n",
 		dev->name, tx_status, frame_id);
-	dev->stats.tx_errors++;
 	/* Ttransmit Underrun */
 	if (tx_status & 0x10) {
 		dev->stats.tx_fifo_errors++;
@@ -906,9 +907,15 @@ tx_error (struct net_device *dev, int tx_status)
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
@@ -1077,7 +1084,9 @@ get_stats (struct net_device *dev)
 	int i;
 #endif
 	unsigned int stat_reg;
+	unsigned long flags;
 
+	spin_lock_irqsave(&np->stats_lock, flags);
 	/* All statistics registers need to be acknowledged,
 	   else statistic overflow could cause problems */
 
@@ -1127,6 +1136,9 @@ get_stats (struct net_device *dev)
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

