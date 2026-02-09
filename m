Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CE31AF0AF;
	Mon,  9 Feb 2026 14:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647672; cv=none; b=RlEAEPSMLn4zN89gardanKpjzsJEKMLocqJZCO5VJlHTb6EGPouGnx6RoTKXk1izhtCLVtt3TJ4o5qh9YYsNG6kBZRYGkPXGKhHQZHK/U0OW4LzCakENrnUWO1MSkGKobc/MQ9pGYAQn1N6Tnh0IllWdHY9cv7nlo39YL0qDPfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647672; c=relaxed/simple;
	bh=to7FSvaBX4amYQGL81IFT+YzNQ+oZL4Cv11e5Y1Zkxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WG0t/AmXC9xCwaOO9lAL/kUjiQk/okyK9K2fZzyg+U53Z0jxhKn3SSnEIBkXSijKx/QjFRBAFlNFAU/B4KkGNNvZfKdecz2i9YPUVTN8fs5+wuz167gGeDgOjLWRiNb3mly1q/Bc/Ep8ch3iMH7TwiXQNUUEgLMF9WIQJNTFpxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+4ma1kd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+4ma1kd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4617C116C6;
	Mon,  9 Feb 2026 14:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647672;
	bh=to7FSvaBX4amYQGL81IFT+YzNQ+oZL4Cv11e5Y1Zkxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z+4ma1kd8kMoG83Mk26yPNiFmenYPdCDGIa7cJiNWUWMWpEOAISzEI8ddfbtIMFBt
	 4BDGZl1KhyfE4+8oN4jmPLQiimigMC/Exg1l/suzORdKetMXKaHQc0G4+gJgWQ3HZ8
	 ms1tIxzjqlPHd9d21QKUnhGC6s3BL+PbhLbE43Sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 170/175] spi: tegra210-quad: Protect curr_xfer check in IRQ handler
Date: Mon,  9 Feb 2026 15:24:03 +0100
Message-ID: <20260209142326.597230493@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index 7fe16ed7e84bd..83def82fe48c1 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1393,6 +1393,11 @@ static irqreturn_t handle_cpu_based_xfer(struct tegra_qspi *tqspi)
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
@@ -1463,6 +1468,11 @@ static irqreturn_t handle_dma_based_xfer(struct tegra_qspi *tqspi)
 	spin_lock_irqsave(&tqspi->lock, flags);
 	t = tqspi->curr_xfer;
 
+	if (!t) {
+		spin_unlock_irqrestore(&tqspi->lock, flags);
+		return IRQ_HANDLED;
+	}
+
 	if (num_errors) {
 		tegra_qspi_dma_unmap_xfer(tqspi, t);
 		tegra_qspi_handle_error(tqspi);
@@ -1501,6 +1511,7 @@ static irqreturn_t handle_dma_based_xfer(struct tegra_qspi *tqspi)
 static irqreturn_t tegra_qspi_isr_thread(int irq, void *context_data)
 {
 	struct tegra_qspi *tqspi = context_data;
+	unsigned long flags;
 	u32 status;
 
 	/*
@@ -1518,7 +1529,9 @@ static irqreturn_t tegra_qspi_isr_thread(int irq, void *context_data)
 	 * If no transfer is in progress, check if this was a real interrupt
 	 * that the timeout handler already processed, or a spurious one.
 	 */
+	spin_lock_irqsave(&tqspi->lock, flags);
 	if (!tqspi->curr_xfer) {
+		spin_unlock_irqrestore(&tqspi->lock, flags);
 		/* Spurious interrupt - transfer not ready */
 		if (!(status & QSPI_RDY))
 			return IRQ_NONE;
@@ -1535,7 +1548,14 @@ static irqreturn_t tegra_qspi_isr_thread(int irq, void *context_data)
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
2.51.0



