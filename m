Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883FE2BE7C6;
	Thu, 15 Jan 2026 17:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496419; cv=none; b=TNxhebjTmYU3h2+Y5H8D3IF66KruBils2kRrroGMB7txqwRLd9Tx1OOxsaNXkFQjkE+Em7NoLRQcRaXQFrpom9ZVbvO20Wr6VhMLDdI+WahDK9bvl6v08aR+lfIFGWCepSTff0j/wIzUevE/WtPofmtUAIjIq9a33hkb0THLivg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496419; c=relaxed/simple;
	bh=UIBdPndzv5+0MabyG6GJ7aqZHrnlIFJZGCM4bI97Lmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXxGEQQ/cYfTY4XFM18I8yTKhmZK4zTvFN/kH/lKwTB/qQ4lKjTjB95dgM7BoTeScv/tRnDc8i3peTfDO85bd+UbapPBO9EvdV01vPwz9Vne88yh1VPydgRx7JjTFD3py0ywkyde20OAhDetkD8iiAKOgdv4BLS845xM7AhDGLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uTg6wUx8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uTg6wUx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18CDCC116D0;
	Thu, 15 Jan 2026 17:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496419;
	bh=UIBdPndzv5+0MabyG6GJ7aqZHrnlIFJZGCM4bI97Lmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uTg6wUx880qiAphkkS5Wdhk17IHpixgj/YqAnkxN5qJUyRLnzhcddw8KJyQE2i00d
	 i19Jtd52fFCb5Tp190rswC0FL9KD/E8o3Gt8hbNJOt+LFfVbFf+edUhAKl7LuP2m4W
	 gYL5Jhv8CZlj517wtsH6/PDLyC/IcB74PnwaCtKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Litwin <mateusz.litwin@nokia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 181/181] spi: cadence-quadspi: Prevent lost complete() call during indirect read
Date: Thu, 15 Jan 2026 17:48:38 +0100
Message-ID: <20260115164208.847590764@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Mateusz Litwin <mateusz.litwin@nokia.com>

[ Upstream commit d67396c9d697041b385d70ff2fd59cb07ae167e8 ]

A race condition exists between the read loop and IRQ `complete()` call.
An interrupt could call the complete() between the inner loop and
reinit_completion(), potentially losing the completion event and causing
an unnecessary timeout. Moving reinit_completion() before the loop
prevents this. A premature signal will only result in a spurious wakeup
and another wait cycle, which is preferable to waiting for a timeout.

Signed-off-by: Mateusz Litwin <mateusz.litwin@nokia.com>
Link: https://patch.msgid.link/20251218-cqspi_indirect_read_improve-v2-1-396079972f2a@nokia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index 3231bdaf9bd06..1cca9d87fbde4 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -769,6 +769,7 @@ static int cqspi_indirect_read_execute(struct cqspi_flash_pdata *f_pdata,
 	readl(reg_base + CQSPI_REG_INDIRECTRD); /* Flush posted write. */
 
 	while (remaining > 0) {
+		ret = 0;
 		if (use_irq &&
 		    !wait_for_completion_timeout(&cqspi->transfer_complete,
 						 msecs_to_jiffies(CQSPI_READ_TIMEOUT_MS)))
@@ -781,6 +782,14 @@ static int cqspi_indirect_read_execute(struct cqspi_flash_pdata *f_pdata,
 		if (cqspi->slow_sram)
 			writel(0x0, reg_base + CQSPI_REG_IRQMASK);
 
+		/*
+		 * Prevent lost interrupt and race condition by reinitializing early.
+		 * A spurious wakeup and another wait cycle can occur here,
+		 * which is preferable to waiting until timeout if interrupt is lost.
+		 */
+		if (use_irq)
+			reinit_completion(&cqspi->transfer_complete);
+
 		bytes_to_read = cqspi_get_rd_sram_level(cqspi);
 
 		if (ret && bytes_to_read == 0) {
@@ -813,7 +822,6 @@ static int cqspi_indirect_read_execute(struct cqspi_flash_pdata *f_pdata,
 		}
 
 		if (use_irq && remaining > 0) {
-			reinit_completion(&cqspi->transfer_complete);
 			if (cqspi->slow_sram)
 				writel(CQSPI_REG_IRQ_WATERMARK, reg_base + CQSPI_REG_IRQMASK);
 		}
-- 
2.51.0



