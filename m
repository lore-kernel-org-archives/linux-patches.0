Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DE1515964;
	Wed, 30 Sep 2026 16:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784514; cv=none; b=uWfniYHkml1QIpvt7v+/1+hIWE4BUE5m0GbP5/fCgtVVUAjbASJB2MrTM/4GMufjSi1wbVh+yxZkHkftdHYi7XsVcXRR1HIiL+K+noR37rqS1dh7btNwxVZXHa/TUL8GwH1DEfmIEEQLiZwHNoWTsXaX8VTdLMuFLotEFl7LOPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784514; c=relaxed/simple;
	bh=FLIdyASqSyfsXGApo8v0freNVo4Q7V0aJy8C4FlmVKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PjXMxvZDMTA9/2mPRRKzzIDmdrD5Lz/KXra7dz13FFgGd2NYyBkYqwcALyGukb8V7HBViFlH04LT1PSeIVNOMIOlMCmdKVMU+colbiyA0piY5pMy8dT31quGCL1Lcze9nUmb3uEn12HAeUWywQkczdxy63saO6Dkw/FkXwvgZss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jocl/7mE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jocl/7mE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29CCF1F00898;
	Wed, 30 Sep 2026 16:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784507;
	bh=2PIM4m29OuI34ZFeR+4bnJWav5kYW6E7dqb/xHwlPJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jocl/7mENOsJelUK0/BUqYqiPN2ACE5tBeNtAw1Pu6ZavVAju4yMAcOtf222Lf93L
	 lVsMg6pVroEjW7n+cOtDgKixoz9Z60XSR4LIqxTQ0Dz6o+wskIaH7pXGwHkFW6CvJq
	 tbfp6mYvePKJbh5h754w7vJL6FnwYPqHZ9DF6pfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Michal Simek <michal.simek@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 181/982] spi: xilinx: let transfers timeout in case of no IRQ
Date: Wed, 30 Sep 2026 17:15:17 +0200
Message-ID: <20260930152420.702319191@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index 6551628998926..0c8360d7f39bc 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -283,7 +283,11 @@ static int xilinx_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 
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



