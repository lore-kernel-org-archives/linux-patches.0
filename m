Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3034A4D1795;
	Thu, 17 Sep 2026 17:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664607; cv=none; b=avoGdivCwU/epx6+OUgWiDpNaCp0P3H6csjCJMDEZLD3VbZUHNxdVBU5g4BY+uLFMeOKvvw18x+kECrdvCrMf3uLPGorPYbmYJdoLXN3zvxMjLCac1EUJJtBwbXi0RDu3+2G6YIcPE+QHtjozwDdEqxCx0poqHZH9Hpzm9h9d0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664607; c=relaxed/simple;
	bh=gmw7t5HRFprBGeuBoifAf9GDnZWawF25wdifqtRpep4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2Y3ctcgUrRIZswoX/z/3hz5kc6kSMzQI7xoXvSPvD7YOIsn7g9Ec1w+azNjdiPsXPQJDBR/drTDG91ckUvVe+LOIzizytiEoGjJeiJGOtXcJcUSi70ZO1OTrPq+72B4GzN3pSL5pGC6XiBTyrKe1y8HGfWRMySbLsMdV2HhSTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0uBY5cuG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0uBY5cuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F471F000FF;
	Thu, 17 Sep 2026 17:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664606;
	bh=lTCTgb6qS1nvV825WPd4AhLZ1kEnIoeeumwqMshUQiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0uBY5cuGl4H3DTmT0L7CLBoBWxxhDEdWtdqRYAuW/x4fef0Q4W0Ld1njCKhffG02r
	 h+zczyifeFwasulF6GLlWQsTRBow7Wh8zwB+aSizavuugLNLJoHWVu4YFd373Gxffs
	 l7JjOTn4zzefGE6DaY+QtUO6iJCUC8HWTpg0LN4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Michal Simek <michal.simek@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0391/1250] spi: xilinx: let transfers timeout in case of no IRQ
Date: Thu, 17 Sep 2026 16:03:06 +0100
Message-ID: <20260917151602.634130499@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 8085571913c8b..dac6c695f0727 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -285,7 +285,11 @@ static int xilinx_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 
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



