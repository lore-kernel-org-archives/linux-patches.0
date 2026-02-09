Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D294137AA8A;
	Mon,  9 Feb 2026 14:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648301; cv=none; b=sq66FsQPMqUGPLaEZMepRaSUGxO0CmhnFrgOqqXJm4KeFaXUOBbXaIxnaNoeyxXpYQl6z1eTMmZ2YAu1mDMOj34RbDvklXSIt8dNaGdFWY0PQVBnWWcNUOF4fZRqn+CCl2eAhojni/+jQpBNm7jl5CY9b8Xgen6o1byUGmxTGcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648301; c=relaxed/simple;
	bh=demjFFJYLBABCcZb/G45LLfBH6zZUfHSqof0znAs0ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPDzVjnEHlsCMYlbQXqqd294eEO4Xtvv1KWuaFWLz1r15WLzetKTUosJpT0LkzxDw8kn0KTrUNw0lc/IOADN3wzSTe43BFr5KrAgqyt1hssEZTs5b5PU5Ab3CFwcQ8aj3udhxo9ejii/hRY/z9FZzs/0MC+RTkmloa1b1kuKhuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KmhWdXhh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KmhWdXhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5738CC116C6;
	Mon,  9 Feb 2026 14:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648301;
	bh=demjFFJYLBABCcZb/G45LLfBH6zZUfHSqof0znAs0ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KmhWdXhhErtfX6MLeXPrvHYrMU4Czp9ksNZ1L87imzotDWlr0OVi/7Mzq0Tws2xli
	 uxTcVpWfG037ZKeqS7prur9HAfzTf0Xff4wi00Fo5TbMq+Fo10dLU7I75f6u4tHHnh
	 k1OdOxGSk8hcEbhKQ7gxp8lTdTWZHHLHAKPfGQaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 65/69] spi: tegra210-quad: Protect curr_xfer assignment in tegra_qspi_setup_transfer_one
Date: Mon,  9 Feb 2026 15:24:33 +0100
Message-ID: <20260209142304.264326474@linuxfoundation.org>
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
index c0cc5bd7e6d2f..d3d3e698bffa1 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -813,6 +813,7 @@ static u32 tegra_qspi_setup_transfer_one(struct spi_device *spi, struct spi_tran
 	u32 command1, command2, speed = t->speed_hz;
 	u8 bits_per_word = t->bits_per_word;
 	u32 tx_tap = 0, rx_tap = 0;
+	unsigned long flags;
 	int req_mode;
 
 	if (!has_acpi_companion(tqspi->dev) && speed != tqspi->cur_speed) {
@@ -820,10 +821,12 @@ static u32 tegra_qspi_setup_transfer_one(struct spi_device *spi, struct spi_tran
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



