Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7562750E6;
	Mon,  9 Feb 2026 14:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648970; cv=none; b=gZBHYLjJ8tpilfVg55Rt8nj1eomGDhI+fOyPiczUbt9o80evj6lyv7aubvgiaMdAN08MZLPnNMQjMNkmXuG1x9paFQvu84d5kQ0qXODzqNrRn1ecHj3zBJZ6Axtqvoq440Ud0ncp+irs3+8SScB7Dr5DmcAl0+kHEn55EEJPaPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648970; c=relaxed/simple;
	bh=ljqOpB06Zq+DqbUsLp65BMcgXJ/xwL0aaA9My5Gd934=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s70vwCKnW6f4jhsyRVy6H+KZGNLhSbGkN19x0g0Vx8463nB2m+Hq9hCe5gFkZG/6vSXiSH6tt5T6HqzLMuMaphbu5kAOwxZ4cdELTV8OCK+Cp9bkAiBqlarKr62dgN3IXVSjCYMg26qm40rUdmRrVAN/MKT6+wmw84bBDShNWOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c39jMZTM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c39jMZTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE51DC116C6;
	Mon,  9 Feb 2026 14:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648970;
	bh=ljqOpB06Zq+DqbUsLp65BMcgXJ/xwL0aaA9My5Gd934=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c39jMZTMoyYQo1+6fMpVKzYyfE0qq4/1reKgpBeqTPX9/BIf93sQiE0q2s3ARV5l+
	 X8I0OiWJM8Jtnx1k8w+6tOJqrPJSCpSkua6P+0SZFWG1hKTBUaz8G8x+N0edsGLJHb
	 At2FnWDbbiNWkuwM1+h+3Oqz+79QWtaGZJI5Ay0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Thierry Reding <treding@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 70/75] spi: tegra210-quad: Move curr_xfer read inside spinlock
Date: Mon,  9 Feb 2026 15:25:07 +0100
Message-ID: <20260209142304.374413346@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
References: <20260209142301.830618238@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b8fabeb403bad..18bd11150a5c6 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1310,10 +1310,11 @@ static int tegra_qspi_transfer_one_message(struct spi_master *master,
 
 static irqreturn_t handle_cpu_based_xfer(struct tegra_qspi *tqspi)
 {
-	struct spi_transfer *t = tqspi->curr_xfer;
+	struct spi_transfer *t;
 	unsigned long flags;
 
 	spin_lock_irqsave(&tqspi->lock, flags);
+	t = tqspi->curr_xfer;
 
 	if (tqspi->tx_status ||  tqspi->rx_status) {
 		tegra_qspi_handle_error(tqspi);
@@ -1344,7 +1345,7 @@ static irqreturn_t handle_cpu_based_xfer(struct tegra_qspi *tqspi)
 
 static irqreturn_t handle_dma_based_xfer(struct tegra_qspi *tqspi)
 {
-	struct spi_transfer *t = tqspi->curr_xfer;
+	struct spi_transfer *t;
 	unsigned int total_fifo_words;
 	unsigned long flags;
 	long wait_status;
@@ -1381,6 +1382,7 @@ static irqreturn_t handle_dma_based_xfer(struct tegra_qspi *tqspi)
 	}
 
 	spin_lock_irqsave(&tqspi->lock, flags);
+	t = tqspi->curr_xfer;
 
 	if (err) {
 		tegra_qspi_dma_unmap_xfer(tqspi, t);
-- 
2.51.0



