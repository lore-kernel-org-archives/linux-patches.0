Received: from mail115-118.sinamail.sina.com.cn (mail115-118.sinamail.sina.com.cn [218.30.115.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83341285CBA
	for <patches@lists.linux.dev>; Tue, 24 Mar 2026 06:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=218.30.115.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774332563; cv=none; b=OcsEchhofgVL5CBmZO6yxOmj7VUuaF2I/T1sMcVh+aQXvFHd2imiKGhbuQzR9HhrfdQhQLg6VnsFqzK468FWEFhNbPe3TtYT1pfM3tPOYA48XdJYuIPSv/n7gyRFS8tDBxvmFfEoa2ErV+Ksn5HIKtEA1qZukQAh3DCHkU7jsxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774332563; c=relaxed/simple;
	bh=NHlIIQJlyhTjT8FAs/JqW6E3uA9plhEOOXkdFAwdfe4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=I6A4Z7kR6kain3DM2Oa6KolmxGKn3ZTsalC0K+ezL6KbNJw6rledlrWm8SGN7i4fXI7l2dv50kRizjlmQom4Xpjh2QEURgLDErM+EUbCDHzMoRjL82ks+7meEPF+C1m+m1bwzw2bD7hFwFomZBuw+cFFIWLpPe5N+9zuxnwwSO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.cn; spf=pass smtp.mailfrom=sina.cn; dkim=pass (1024-bit key) header.d=sina.cn header.i=@sina.cn header.b=BEGP32Qx; arc=none smtp.client-ip=218.30.115.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.cn header.i=@sina.cn header.b="BEGP32Qx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.cn; s=201208; t=1774332561;
	bh=qgnBCkgus4C3JeV2aFGnoI4lXC+JO8798ruCRc8QCFk=;
	h=From:Subject:Date:Message-Id;
	b=BEGP32QxW07m84ye/mfHjTnvmZ02q+op86KBAD129EXww1hipB1d7IT6zcnGRJhOC
	 Dm5hO1X/a7ZM6AvSWRaqTZoAP27qREa7/n6L0YuN9/+9rGz6njfsq4BB1YAOGaUMcY
	 1oY/epRyW6DuoosCirGFsTSmUekY0S8lPvXrh/t0=
X-SMAIL-HELO: NTT-kernel-dev
Received: from unknown (HELO NTT-kernel-dev)([60.247.85.88])
	by sina.cn (10.185.250.24) with ESMTP
	id 69C22A6000002D58; Tue, 24 Mar 2026 14:08:39 +0800 (CST)
X-Sender: jianqkang@sina.cn
X-Auth-ID: jianqkang@sina.cn
Authentication-Results: sina.cn;
	 spf=none smtp.mailfrom=jianqkang@sina.cn;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=jianqkang@sina.cn
X-SMAIL-MID: 25143110748017
X-SMAIL-UIID: FD7F7D2A21814E41830FC47941554F61-20260324-140839-1
From: Jianqiang kang <jianqkang@sina.cn>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	leitao@debian.org
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	thierry.reding@gmail.com,
	jonathanh@nvidia.com,
	skomatineni@nvidia.com,
	ldewangan@nvidia.com,
	treding@nvidia.com,
	broonie@kernel.org,
	va@nvidia.com,
	linux-tegra@vger.kernel.org,
	linux-spi@vger.kernel.org
Subject: [PATCH 6.12.y] spi: tegra210-quad: Protect curr_xfer check in IRQ handler
Date: Tue, 24 Mar 2026 14:08:32 +0800
Message-Id: <20260324060832.724228-1-jianqkang@sina.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Breno Leitao <leitao@debian.org>

[ Upstream commit edf9088b6e1d6d88982db7eb5e736a0e4fbcc09e ]

Now that all other accesses to curr_xfer are done under the lock,
protect the curr_xfer NULL check in tegra_qspi_isr_thread() with the
spinlock. Without this protection, the following race can occur:

  CPU0 (ISR thread)              CPU1 (timeout path)
  ----------------               -------------------
  if (!tqspi->curr_xfer)
    // sees non-NULL
                                 spin_lock()
                                 tqspi->curr_xfer = NULL
                                 spin_unlock()
  handle_*_xfer()
    spin_lock()
    t = tqspi->curr_xfer  // NULL!
    ... t->len ...        // NULL dereference!

With this patch, all curr_xfer accesses are now properly synchronized.

Although all accesses to curr_xfer are done under the lock, in
tegra_qspi_isr_thread() it checks for NULL, releases the lock and
reacquires it later in handle_cpu_based_xfer()/handle_dma_based_xfer().
There is a potential for an update in between, which could cause a NULL
pointer dereference.

To handle this, add a NULL check inside the handlers after acquiring
the lock. This ensures that if the timeout path has already cleared
curr_xfer, the handler will safely return without dereferencing the
NULL pointer.

Fixes: b4e002d8a7ce ("spi: tegra210-quad: Fix timeout handling")
Signed-off-by: Breno Leitao <leitao@debian.org>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260126-tegra_xfer-v2-6-6d2115e4f387@debian.org
Signed-off-by: Mark Brown <broonie@kernel.org>
[ Minor conflict resolved. ]
Signed-off-by: Jianqiang kang <jianqkang@sina.cn>
---
 drivers/spi/spi-tegra210-quad.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index edc9d400728a..14dd98b92bd9 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1351,6 +1351,11 @@ static irqreturn_t handle_cpu_based_xfer(struct tegra_qspi *tqspi)
 	spin_lock_irqsave(&tqspi->lock, flags);
 	t = tqspi->curr_xfer;
 
+	if (!t) {
+		spin_unlock_irqrestore(&tqspi->lock, flags);
+		return IRQ_HANDLED;
+	}
+
 	if (tqspi->tx_status ||  tqspi->rx_status) {
 		tegra_qspi_handle_error(tqspi);
 		complete(&tqspi->xfer_completion);
@@ -1419,6 +1424,11 @@ static irqreturn_t handle_dma_based_xfer(struct tegra_qspi *tqspi)
 	spin_lock_irqsave(&tqspi->lock, flags);
 	t = tqspi->curr_xfer;
 
+	if (!t) {
+		spin_unlock_irqrestore(&tqspi->lock, flags);
+		return IRQ_HANDLED;
+	}
+
 	if (err) {
 		tegra_qspi_dma_unmap_xfer(tqspi, t);
 		tegra_qspi_handle_error(tqspi);
@@ -1457,6 +1467,7 @@ static irqreturn_t handle_dma_based_xfer(struct tegra_qspi *tqspi)
 static irqreturn_t tegra_qspi_isr_thread(int irq, void *context_data)
 {
 	struct tegra_qspi *tqspi = context_data;
+	unsigned long flags;
 	u32 status;
 
 	/*
@@ -1474,7 +1485,9 @@ static irqreturn_t tegra_qspi_isr_thread(int irq, void *context_data)
 	 * If no transfer is in progress, check if this was a real interrupt
 	 * that the timeout handler already processed, or a spurious one.
 	 */
+	spin_lock_irqsave(&tqspi->lock, flags);
 	if (!tqspi->curr_xfer) {
+		spin_unlock_irqrestore(&tqspi->lock, flags);
 		/* Spurious interrupt - transfer not ready */
 		if (!(status & QSPI_RDY))
 			return IRQ_NONE;
@@ -1491,7 +1504,14 @@ static irqreturn_t tegra_qspi_isr_thread(int irq, void *context_data)
 		tqspi->rx_status = tqspi->status_reg & (QSPI_RX_FIFO_OVF | QSPI_RX_FIFO_UNF);
 
 	tegra_qspi_mask_clear_irq(tqspi);
+	spin_unlock_irqrestore(&tqspi->lock, flags);
 
+	/*
+	 * Lock is released here but handlers safely re-check curr_xfer under
+	 * lock before dereferencing.
+	 * DMA handler also needs to sleep in wait_for_completion_*(), which
+	 * cannot be done while holding spinlock.
+	 */
 	if (!tqspi->is_curr_dma_xfer)
 		return handle_cpu_based_xfer(tqspi);
 
-- 
2.34.1

