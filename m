Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925E01AF0AF;
	Mon,  9 Feb 2026 14:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647710; cv=none; b=TUKckvTzP0yNJ0c2Z/yFrUjLldcI4bWs1YEbGZ3L/g/0k1Z0pXpBjIfFdNbiT8fEBlNW1sEC1166mZKSHP1UmeAcRLkq1hkVQwm+ylwkPq9syPiqyWBxH9BNN/osVr4RxiSqUOV1QBMJomqH6HzMZ5AvNRKXy93YGqntooMJn88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647710; c=relaxed/simple;
	bh=TcUd91dBSCoQdJEE/pZqncBUWyB4TOPxQfqUCdyOY+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9n6pVjz2RyEF5YffiN8qnnzM3vhXWwObSqAOVR1FwcHTQCjpnrkjva147rpg6wh9bTy6uviGaZOqbmAcwe5tC7VzRuegjhEVNhoh/uwiDptoMTOijIMpqkTRi4ncUPoQw67SbOgr2fulx+idKnCPUc5qxxK9nFGWlcQJe0quR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JF1OlZz5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JF1OlZz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BCCC116C6;
	Mon,  9 Feb 2026 14:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647710;
	bh=TcUd91dBSCoQdJEE/pZqncBUWyB4TOPxQfqUCdyOY+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JF1OlZz5byrv9UV7JCw4mWG3vF8dAAMWtGRjtM/KNxH1rPK9ZbGwHtTKsOlCMhrMy
	 558Sv2+/xoc9GZ8DTCT+pmQ3k+2C1IYNBV2ZwfnGa7VLLMIUmJtncA1SUF+IxAMEQE
	 qmrvLfkFZvOfQR7uxm39BQamIAIHGVADlqkAqork=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 167/175] spi: tegra210-quad: Protect curr_xfer assignment in tegra_qspi_setup_transfer_one
Date: Mon,  9 Feb 2026 15:24:00 +0100
Message-ID: <20260209142326.492661036@linuxfoundation.org>
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

[ Upstream commit f5a4d7f5e32ba163cff893493ec1cbb0fd2fb0d5 ]

When the timeout handler processes a completed transfer and signals
completion, the transfer thread can immediately set up the next transfer
and assign curr_xfer to point to it.

If a delayed ISR from the previous transfer then runs, it checks if
(!tqspi->curr_xfer) (currently without the lock also -- to be fixed
soon) to detect stale interrupts, but this check passes because
curr_xfer now points to the new transfer. The ISR then incorrectly
processes the new transfer's context.

Protect the curr_xfer assignment with the spinlock to ensure the ISR
either sees NULL (and bails out) or sees the new value only after the
assignment is complete.

Fixes: 921fc1838fb0 ("spi: tegra210-quad: Add support for Tegra210 QSPI controller")
Signed-off-by: Breno Leitao <leitao@debian.org>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260126-tegra_xfer-v2-3-6d2115e4f387@debian.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index a599bad02b4d3..6d89a9309d85e 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -839,6 +839,7 @@ static u32 tegra_qspi_setup_transfer_one(struct spi_device *spi, struct spi_tran
 	u32 command1, command2, speed = t->speed_hz;
 	u8 bits_per_word = t->bits_per_word;
 	u32 tx_tap = 0, rx_tap = 0;
+	unsigned long flags;
 	int req_mode;
 
 	if (!has_acpi_companion(tqspi->dev) && speed != tqspi->cur_speed) {
@@ -846,10 +847,12 @@ static u32 tegra_qspi_setup_transfer_one(struct spi_device *spi, struct spi_tran
 		tqspi->cur_speed = speed;
 	}
 
+	spin_lock_irqsave(&tqspi->lock, flags);
 	tqspi->cur_pos = 0;
 	tqspi->cur_rx_pos = 0;
 	tqspi->cur_tx_pos = 0;
 	tqspi->curr_xfer = t;
+	spin_unlock_irqrestore(&tqspi->lock, flags);
 
 	if (is_first_of_msg) {
 		tegra_qspi_mask_clear_irq(tqspi);
-- 
2.51.0



