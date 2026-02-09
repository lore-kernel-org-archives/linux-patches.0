Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD5E22301;
	Mon,  9 Feb 2026 14:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648295; cv=none; b=L3yNcLjlSXUGcjMkP7YIp0B/xA5bsiUlcJcMwUWOX4gYCj73SNZ/ddGsleQon1avvI7k5e7Uvo2X2T+9rtgVJ+CEphOesKRzc10l6q+dTEG5msnUploIMOnKLZr7WP+Vk/daG2w6wj3qpafxQUJ81DtJzWxs6ZA2huTlS+W5IuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648295; c=relaxed/simple;
	bh=jfAFQcpx38XfaG2uxWfhq41+eTXbrAl8bPwt/kgxgrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kf13BZAe9XpMAvZhzxW6HqVH0IGfG0Cd4q3sSFc08rUT5LjCsqpPJe4I4Zo6X9Z1Lwxxg47xH3qsWMB7Y3JBvUuBeoqc9la0Mq7MVXlwPngWMJXce8wNDyCv9uev+x58wMDSwANfVXtlW+kgyjPnsXKtPaNImeXLfn9y6DKLFP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LpWb5mNg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LpWb5mNg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EECC19422;
	Mon,  9 Feb 2026 14:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648295;
	bh=jfAFQcpx38XfaG2uxWfhq41+eTXbrAl8bPwt/kgxgrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LpWb5mNgen3OoakMSPHSk1rnf8rMYq7iBvo99JIRLf5tNRjrpBiWZ7kRsCH1W/60b
	 tyRnP+dEDKqNhY2aER6rvS6vhMS6JwYb+5z7lNEiZlGYs8luHTcU7z1VDsYdLRDPXG
	 FppovZfFXLYcDPDx9zrZZZL0KHbesIfdGse78sLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Thierry Reding <treding@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 64/69] spi: tegra210-quad: Move curr_xfer read inside spinlock
Date: Mon,  9 Feb 2026 15:24:32 +0100
Message-ID: <20260209142304.228535887@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit ef13ba357656451d6371940d8414e3e271df97e3 ]

Move the assignment of the transfer pointer from curr_xfer inside the
spinlock critical section in both handle_cpu_based_xfer() and
handle_dma_based_xfer().

Previously, curr_xfer was read before acquiring the lock, creating a
window where the timeout path could clear curr_xfer between reading it
and using it. By moving the read inside the lock, the handlers are
guaranteed to see a consistent value that cannot be modified by the
timeout path.

Fixes: 921fc1838fb0 ("spi: tegra210-quad: Add support for Tegra210 QSPI controller")
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Thierry Reding <treding@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://patch.msgid.link/20260126-tegra_xfer-v2-2-6d2115e4f387@debian.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index 024e1468eee8d..c0cc5bd7e6d2f 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1325,10 +1325,11 @@ static int tegra_qspi_transfer_one_message(struct spi_master *master,
 
 static irqreturn_t handle_cpu_based_xfer(struct tegra_qspi *tqspi)
 {
-	struct spi_transfer *t = tqspi->curr_xfer;
+	struct spi_transfer *t;
 	unsigned long flags;
 
 	spin_lock_irqsave(&tqspi->lock, flags);
+	t = tqspi->curr_xfer;
 
 	if (tqspi->tx_status ||  tqspi->rx_status) {
 		tegra_qspi_handle_error(tqspi);
@@ -1359,7 +1360,7 @@ static irqreturn_t handle_cpu_based_xfer(struct tegra_qspi *tqspi)
 
 static irqreturn_t handle_dma_based_xfer(struct tegra_qspi *tqspi)
 {
-	struct spi_transfer *t = tqspi->curr_xfer;
+	struct spi_transfer *t;
 	unsigned int total_fifo_words;
 	unsigned long flags;
 	long wait_status;
@@ -1396,6 +1397,7 @@ static irqreturn_t handle_dma_based_xfer(struct tegra_qspi *tqspi)
 	}
 
 	spin_lock_irqsave(&tqspi->lock, flags);
+	t = tqspi->curr_xfer;
 
 	if (err) {
 		tegra_qspi_dma_unmap_xfer(tqspi, t);
-- 
2.51.0



