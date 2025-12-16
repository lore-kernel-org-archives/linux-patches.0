Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C2F35FF4D;
	Tue, 16 Dec 2025 12:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887347; cv=none; b=KhnDU54sokCXX2xGhLMVMA0KwLD+3u7SpAjomMhOyYx4pH5IH1MSDVWCuXNW76RENe6CF+wBfqjKt4rLODL8d9kaM3VSxOQ9JHRhtNBbo5a8zIqZoxHJAKuQe/DZih6QrYtBI0+pzvWYtvfsNE+x8doUGcdoNHbDUm0M9IVg2RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887347; c=relaxed/simple;
	bh=XE179lnjuQRl7oeXJw0VraoCH473v2owFc9WfaG6uRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0uKBapwYGaQMfQ/vorDaKijL6ulAwMfGf1q9MMUejnWxDexGWfD2AyeNAk29bf0vCEfr8rjBgWNvVjWF9Obu1wgedn+19E3PPev1lMuQETKn63lmJnGURZtDTWiOLM/E8HAFw5ztdi/SDig1xlfrmRsZjmnfC4FPGhRYvfHt/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNPzIq5b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNPzIq5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719B4C4CEF1;
	Tue, 16 Dec 2025 12:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887346;
	bh=XE179lnjuQRl7oeXJw0VraoCH473v2owFc9WfaG6uRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VNPzIq5bOYpNFaKUQx9SwTX6osP265HM4qDXB0wqD0KurYFDPpfbZ0rIn6QHYuZIC
	 0h2+LjHKxql+d8n5BHSu5OttG8DmY7EpW2M0OJIbGi0DYOIScYLsC7RiuqbQKOdgDL
	 7wdFgk3r/VuVLnOmIMN6Iv1BXaWMCjtRNczq9a+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thierry Reding <treding@nvidia.com>,
	Vishwaroop A <va@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 201/614] spi: tegra210-quad: Fix timeout handling
Date: Tue, 16 Dec 2025 12:09:28 +0100
Message-ID: <20251216111408.661364329@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Vishwaroop A <va@nvidia.com>

[ Upstream commit b4e002d8a7cee3b1d70efad0e222567f92a73000 ]

When the CPU that the QSPI interrupt handler runs on (typically CPU 0)
is excessively busy, it can lead to rare cases of the IRQ thread not
running before the transfer timeout is reached.

While handling the timeouts, any pending transfers are cleaned up and
the message that they correspond to is marked as failed, which leaves
the curr_xfer field pointing at stale memory.

To avoid this, clear curr_xfer to NULL upon timeout and check for this
condition when the IRQ thread is finally run.

While at it, also make sure to clear interrupts on failure so that new
interrupts can be run.

A better, more involved, fix would move the interrupt clearing into a
hard IRQ handler. Ideally we would also want to signal that the IRQ
thread no longer needs to be run after the timeout is hit to avoid the
extra check for a valid transfer.

Fixes: 921fc1838fb0 ("spi: tegra210-quad: Add support for Tegra210 QSPI controller")
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Vishwaroop A <va@nvidia.com>
Link: https://patch.msgid.link/20251028155703.4151791-2-va@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index 3be7499db21ec..d9ca3d7b082f2 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1024,8 +1024,10 @@ static void tegra_qspi_handle_error(struct tegra_qspi *tqspi)
 	dev_err(tqspi->dev, "error in transfer, fifo status 0x%08x\n", tqspi->status_reg);
 	tegra_qspi_dump_regs(tqspi);
 	tegra_qspi_flush_fifos(tqspi, true);
-	if (device_reset(tqspi->dev) < 0)
+	if (device_reset(tqspi->dev) < 0) {
 		dev_warn_once(tqspi->dev, "device reset failed\n");
+		tegra_qspi_mask_clear_irq(tqspi);
+	}
 }
 
 static void tegra_qspi_transfer_end(struct spi_device *spi)
@@ -1176,9 +1178,11 @@ static int tegra_qspi_combined_seq_xfer(struct tegra_qspi *tqspi,
 				}
 
 				/* Reset controller if timeout happens */
-				if (device_reset(tqspi->dev) < 0)
+				if (device_reset(tqspi->dev) < 0) {
 					dev_warn_once(tqspi->dev,
 						      "device reset failed\n");
+					tegra_qspi_mask_clear_irq(tqspi);
+				}
 				ret = -EIO;
 				goto exit;
 			}
@@ -1200,11 +1204,13 @@ static int tegra_qspi_combined_seq_xfer(struct tegra_qspi *tqspi,
 			tegra_qspi_transfer_end(spi);
 			spi_transfer_delay_exec(xfer);
 		}
+		tqspi->curr_xfer = NULL;
 		transfer_phase++;
 	}
 	ret = 0;
 
 exit:
+	tqspi->curr_xfer = NULL;
 	msg->status = ret;
 
 	return ret;
@@ -1290,6 +1296,8 @@ static int tegra_qspi_non_combined_seq_xfer(struct tegra_qspi *tqspi,
 		msg->actual_length += xfer->len + dummy_bytes;
 
 complete_xfer:
+		tqspi->curr_xfer = NULL;
+
 		if (ret < 0) {
 			tegra_qspi_transfer_end(spi);
 			spi_transfer_delay_exec(xfer);
@@ -1395,6 +1403,7 @@ static irqreturn_t handle_cpu_based_xfer(struct tegra_qspi *tqspi)
 	tegra_qspi_calculate_curr_xfer_param(tqspi, t);
 	tegra_qspi_start_cpu_based_transfer(tqspi, t);
 exit:
+	tqspi->curr_xfer = NULL;
 	spin_unlock_irqrestore(&tqspi->lock, flags);
 	return IRQ_HANDLED;
 }
@@ -1480,6 +1489,15 @@ static irqreturn_t tegra_qspi_isr_thread(int irq, void *context_data)
 {
 	struct tegra_qspi *tqspi = context_data;
 
+	/*
+	 * Occasionally the IRQ thread takes a long time to wake up (usually
+	 * when the CPU that it's running on is excessively busy) and we have
+	 * already reached the timeout before and cleaned up the timed out
+	 * transfer. Avoid any processing in that case and bail out early.
+	 */
+	if (!tqspi->curr_xfer)
+		return IRQ_NONE;
+
 	tqspi->status_reg = tegra_qspi_readl(tqspi, QSPI_FIFO_STATUS);
 
 	if (tqspi->cur_direction & DATA_DIR_TX)
-- 
2.51.0



