Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E2733CEA8;
	Thu, 17 Sep 2026 18:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668098; cv=none; b=gcZ/EO9AtaoHrcC+K+qCAVDJhcZK0b5uTazAQqzIAPQ2mm5Wavvs6y5KPWxoXKVqx1ETUSGMu0QNGjM33+NNH3CkxyNHd63TtgcqUGelEkcYZu7fNyOAfhsNEtP/AvndvWN+PQou0vF5kzxKDbi5hSaWWZE33o0g3HzQSSogsjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668098; c=relaxed/simple;
	bh=ptsQIgs2HExpmLqoioV1h7+7fpiyd55D5Xu6TSUyxvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBMlc6qlBwOR7hIsE5z0q+8kEB9XoSw9n0ld77nWQVyGh88UBbO7k43aTqFMHCj6VPwctS9/O2PaPW7Kp+vSuJVjuSlwSwwMrD/p0zMyKNvIux/H+DqJl1m5JSFWpYHq0Ojy9EXInCQFSBJRei/nBgkkN1UnT7RMIoGhIrI+2vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zdroMM3M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zdroMM3M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872131F000FF;
	Thu, 17 Sep 2026 18:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668096;
	bh=ChGnZXN62aU8w8i+jjrteBDteqSCELqmWYwV9wL3xLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zdroMM3M3ZjJcdDTF6+a4Aq0WtQzJKsi5vD8EdWyJ0Us1rgKJp2HUTjWs6Sw6q8FN
	 7kxXb7CIYvJ0zNRbFbcAo9qhyENcnwxsTC8T4Z5RTJi55MOrjEM59JbYk+cyhaLHEZ
	 3fGk/3iYvPCycRYf3W1H4DMFyiT6OgRlAMO2nWSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Michal Simek <michal.simek@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0285/1102] spi: xilinx: let transfers timeout in case of no IRQ
Date: Thu, 17 Sep 2026 16:03:48 +0100
Message-ID: <20260917151546.768709706@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vadim Fedorenko <vadim.fedorenko@linux.dev>

[ Upstream commit 0f95264f49ace739d411fd9149e2b3545d741d06 ]

In case of failed HW the driver may not see an interrupt and will stuck
in waiting forever. We can avoid such situation by timing out of
transfers if the interrupt is not seen in a reasonable time.

This problem can be found on unload of ptp_ocp driver for TimeCard which
uses Xilinx SPI AXI and SPI-NOR flash memory. During tear-down process
spi-nor drivers send soft reset command which is not triggering an
interrupt stalling the unload process completely.

Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Acked-by: Michal Simek <michal.simek@amd.com>
Link: https://patch.msgid.link/20260610222843.782337-1-vadim.fedorenko@linux.dev
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-xilinx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index 9eef5688dff22..8f394c3ab1ae1 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -284,7 +284,11 @@ static int xilinx_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 
 		if (use_irq) {
 			xspi->write_fn(cr, xspi->regs + XSPI_CR_OFFSET);
-			wait_for_completion(&xspi->done);
+			if (!wait_for_completion_timeout(&xspi->done, secs_to_jiffies(1))) {
+				dev_err(&spi->dev, "SPI transfer timed out\n");
+				xspi_init_hw(xspi);
+				return -ETIMEDOUT;
+			}
 			/* A transmit has just completed. Process received data
 			 * and check for more data to transmit. Always inhibit
 			 * the transmitter while the Isr refills the transmit
-- 
2.53.0



