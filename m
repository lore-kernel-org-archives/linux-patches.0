Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96663AFAE2;
	Wed, 30 Sep 2026 18:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794436; cv=none; b=WaKThw5OIcrofPM24ptRrwfwA3OZ+ZkhUNiJgBSr81qX+cQ4KUlUwC3MclEpPBO6RwUZcbzPsjbyW4wUxewDB2EK1tuh5TYNM1N9t1PAPn/Qj9Cmf+ikKALo6rdNSge1/UiI6eLQjsYInbjiHqpYNkiLzP4jAIT2aC/JnN9aybg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794436; c=relaxed/simple;
	bh=muoCskfLp9ss6bB6a04Va6caOKP9zOsYMQxwWSUxEj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZM22GHwoAMWwfqhaOvjTIAocQuHxCSuAR5ODIZWjM0Gg1j7EjznhJZps0GliDrkoMyLsUIiGTIzytTZZYFibEBLtZYTZ5npDeBRc/HgMFBfuiybtbaIi4GfLdXxIfWbvPdzopqo3t4THULkx2L9sSUQb1yOxO8Ik6e3eMcBF95A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNR0THeu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNR0THeu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110991F000FF;
	Wed, 30 Sep 2026 18:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794435;
	bh=Wz5Twg1lvrrPP1zlx/L1y9ppyVMVzyvPPCp91EUks8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TNR0THeuuYhOCO6b+1os1oA0Eug6aa85A+ohRacHqSdVDC9RbzdHTF9Xj9qoDfZyd
	 QuU9bnc2jigUtZ2DAIwUAvuefne+5XJ9ub5Qiivgr0KOttyGGKjkiXAamhrjcrPFx+
	 zN9mtS145LoI3NY3evdYXj4SYzmYTMXX+triDqFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Michal Simek <michal.simek@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0210/1193] spi: xilinx: let transfers timeout in case of no IRQ
Date: Wed, 30 Sep 2026 17:14:54 +0200
Message-ID: <20260930152438.870404830@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 36362bee7fff8..aa24d1b9dc93d 100644
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



