Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827201;
	b=rCv7+ataJaq9xDti4qVJA76OAH+Kbx2Yn3/YZj/Esxz9rZ6g6L/YjvNNlLs7b2o0u1mJ
	 8717gFW+JARN/KJoSG0vlFnLxjrvp4hkVvjWlYJxLAnkFSAlxtkFHyNKFsflMw+EOltet
	 5924aJqdG+pFhUxrun2OJT7fVM+qg10aZWsjvEcT54m/YcuaYD50QuZbrXq6qcDFqwB+4
	 GM+7NyFe+X2noVSHANgO+xHpT9hW8Ulrgb+fjPV4D94vHZ2sVBlWmtL2GJSnRwoFMaSik
	 lpM8iWxA6qHSDQtRXWg4KxIahvXED0q71KOv5FmsAOwdYhhCui3K0T/ERZZ9qUfMuRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827201;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IroGTun+mc0K7vzq7B5C4EZPRT4iKUU8fBAyoa648ho=;
	b=ndspy94Y01FR6eQKW9XG//MR+4vqFfzwZtrl7StAcEgIN4rR/KJ4XPazWdHzR7VouMUO
	 D3TmGb3uj7FLUcB6YQ57uKSuVDjhnKmHfTfH4zEqnogqNdhiXJ6VxUoc7VwU1ivqZ+YCX
	 wNKCNVd11/f9t40PviJeyZXNd2ay3ZzGPmN93NZHCbiLSltlGvp+CP9dw1V27HNm1cVcp
	 Eg7q97v4E80pgorrbRgmjwuzjelLovamlW9M7FoZC1XIgkQ+2HkoQkynZD0wat5tync2t
	 Zqgwv+bDsbyswmeIZwomR1Cb3e0gO8cyQ8mBe0Z6IA/B+6tkpRdnoPjovIgzVpyzDIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EywIIGbZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5BF606A843;
	Wed,  4 Nov 2026 21:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EywIIGbZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5C41F00A16;
	Wed,  4 Nov 2026 21:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827201;
	bh=IroGTun+mc0K7vzq7B5C4EZPRT4iKUU8fBAyoa648ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EywIIGbZFt+GKGJLo+rwvyvhqy0SszD57u+VuDANooGWirH8fzBL18L4qRrXDPgI/
	 whtJ6jpifIuk7+jb9BQT9mXRimA0AJKKRg5CORV778AE9VGHwtzxx9lZoZ8vX28Bik
	 4xCiERwj1UZk17DDqR/4QSFixinLqCyp6P7VWB6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.3 254/547] spi: spi-pci1xxxx: quiesce DMA engines on transfer timeout
Date: Wed,  4 Nov 2026 16:07:18 -0500
Message-ID: <20261104211045.395102292@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weibin Liu <liuwb@xiaopeng.com>

commit 0b591332a2bdc13d3f9163793131fe3651d1556a upstream.

If a DMA-mapped transfer times out waiting for DMA_TERM and neither DMA
abort interrupt arrived, pci1xxxx_spi_transfer_with_dma() returns
through the error label while both DMA engines are still enabled, the
done/abort interrupt status is still armed and the transfer state
(p->xfer, p->tx_sgl, p->rx_sgl) is still registered.

The ISRs keep firing afterwards: they reprogram the DMA engines from
p->tx_sgl / p->rx_sgl and signal completion through p->xfer and
p->spi_xfer_done, all of which the SPI core is free to unmap or reuse
once transfer_one() has returned, which is a use-after-free. A late
done interrupt can also start the next transfer queued behind the
failed one.

Stop both DMA engines, drain the pending done/abort interrupt status
and synchronize the DMA IRQs before dropping the in-progress state and
the transfer pointers, and re-enable the engines afterwards so that
subsequent transfers keep working. The engines are only turned back on
once both were confirmed to have stopped: re-enabling an engine that
failed to stop would cancel the pending stop request and let it keep
running into buffers the SPI core is about to unmap or free, which is
exactly the window this patch closes. An engine that failed to stop is
left disabled, as the abort paths already do.

The DMA interrupt status and mask registers are shared between the two
SPI instances, so the cleanup drains only this instance's done/abort
status bits instead of masking the interrupt lines, which would also
suppress the peer instance's completion interrupts.

Also make the DMA ISRs ignore interrupts while no transfer is in
progress so that a stray MSI after the cleanup can no longer act on
the cleared state.

No PCI1XXXX hardware was available for testing and QEMU has no model
of this PCIe part, so the timeout path was exercised with a userspace
replica of the timeout branch and the DMA ISRs, with the register and
interrupt accesses mocked: on the unfixed code both a wedged engine
that clears after the timeout and a late done interrupt touch the
freed transfer state, while with this fix applied neither does and an
engine that failed to stop is left disabled.  The module was also
loaded and unloaded in a QEMU x86_64 guest running a kernel with this
fix applied.

Fixes: 9538edeb72c9 ("spi: mchp-pci1xxxx: DMA support for copying data to and from SPI Buf")
Cc: stable@vger.kernel.org # 6.8+
Signed-off-by: Weibin Liu <liuwb@xiaopeng.com>
Link: https://patch.msgid.link/20261016020036.1333548-1-liuwb@xiaopeng.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-pci1xxxx.c |   71 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

--- a/drivers/spi/spi-pci1xxxx.c
+++ b/drivers/spi/spi-pci1xxxx.c
@@ -542,6 +542,8 @@ static int pci1xxxx_spi_transfer_with_dm
 	struct pci1xxxx_spi_internal *p = spi_controller_get_devdata(spi_ctlr);
 	struct pci1xxxx_spi *par = p->parent;
 	dma_addr_t tx_dma_addr = 0;
+	unsigned long flags;
+	bool engines_stopped;
 	int ret = 0;
 	u32 regval;
 
@@ -618,12 +620,72 @@ static int pci1xxxx_spi_transfer_with_dm
 			p->dma_aborted_wr = false;
 			ret = -ECANCELED;
 		}
+
+		/*
+		 * A timed out transfer leaves the DMA engines running and
+		 * the done/abort interrupt status armed with p->xfer,
+		 * p->tx_sgl and p->rx_sgl still registered.  Stop the
+		 * engines, drain the pending status and synchronize the
+		 * IRQs before dropping the transfer state, otherwise a
+		 * late interrupt makes the ISRs reprogram the engines
+		 * from or signal completion through memory which the SPI
+		 * core is about to unmap or free.
+		 */
+		writel(SPI_DMA_ENGINE_DIS,
+		       par->dma_offset_bar + SPI_DMA_GLOBAL_WR_ENGINE_EN);
+		writel(SPI_DMA_ENGINE_DIS,
+		       par->dma_offset_bar + SPI_DMA_GLOBAL_RD_ENGINE_EN);
+		engines_stopped =
+			!(readl_poll_timeout(par->dma_offset_bar +
+					     SPI_DMA_GLOBAL_WR_ENGINE_EN,
+					     regval, regval == 0x0, 0,
+					     USEC_PER_MSEC) ||
+			  readl_poll_timeout(par->dma_offset_bar +
+					     SPI_DMA_GLOBAL_RD_ENGINE_EN,
+					     regval, regval == 0x0, 0,
+					     USEC_PER_MSEC));
+		if (!engines_stopped)
+			dev_warn(&par->dev->dev,
+				 "SPI DMA engines failed to stop\n");
+
+		spin_lock_irqsave(&par->dma_wr_reg_lock, flags);
+		writel((SPI_DMA_DONE_INT_MASK(p->hw_inst) |
+			SPI_DMA_ABORT_INT_MASK(p->hw_inst)),
+		       par->dma_offset_bar + SPI_DMA_INTR_WR_CLR);
+		spin_unlock_irqrestore(&par->dma_wr_reg_lock, flags);
+		spin_lock_irqsave(&par->dma_rd_reg_lock, flags);
+		writel((SPI_DMA_DONE_INT_MASK(p->hw_inst) |
+			SPI_DMA_ABORT_INT_MASK(p->hw_inst)),
+		       par->dma_offset_bar + SPI_DMA_INTR_RD_CLR);
+		spin_unlock_irqrestore(&par->dma_rd_reg_lock, flags);
+
+		p->spi_xfer_in_progress = false;
+		synchronize_irq(p->irq[1]);
+		synchronize_irq(p->irq[2]);
+
+		/*
+		 * Turn the engines back on only once both are confirmed
+		 * to have stopped: re-enabling an engine that failed to
+		 * stop would cancel the pending stop request and let it
+		 * run into buffers the SPI core is about to unmap or
+		 * free.  An engine that failed to stop is left disabled,
+		 * as the abort paths already do.
+		 */
+		if (engines_stopped) {
+			writel(SPI_DMA_ENGINE_EN,
+			       par->dma_offset_bar + SPI_DMA_GLOBAL_WR_ENGINE_EN);
+			writel(SPI_DMA_ENGINE_EN,
+			       par->dma_offset_bar + SPI_DMA_GLOBAL_RD_ENGINE_EN);
+		}
 		goto error;
 	}
 	ret = 0;
 
 error:
 	p->spi_xfer_in_progress = false;
+	p->xfer = NULL;
+	p->tx_sgl = NULL;
+	p->rx_sgl = NULL;
 
 	return ret;
 }
@@ -695,6 +757,9 @@ static irqreturn_t pci1xxxx_spi_isr_dma_
 	unsigned long flags;
 	u32 regval;
 
+	if (!p->spi_xfer_in_progress)
+		return IRQ_NONE;
+
 	/* Clear the DMA RD INT and start spi xfer*/
 	regval = readl(p->parent->dma_offset_bar + SPI_DMA_INTR_RD_STS);
 	if (regval) {
@@ -723,6 +788,9 @@ static irqreturn_t pci1xxxx_spi_isr_dma_
 	unsigned long flags;
 	u32 regval;
 
+	if (!p->spi_xfer_in_progress)
+		return IRQ_NONE;
+
 	/* Clear the DMA WR INT */
 	regval = readl(p->parent->dma_offset_bar + SPI_DMA_INTR_WR_STS);
 	if (regval) {
@@ -755,6 +823,9 @@ static irqreturn_t pci1xxxx_spi_isr_dma(
 	irqreturn_t spi_int_fired = IRQ_NONE;
 	u32 regval;
 
+	if (!p->spi_xfer_in_progress)
+		return IRQ_NONE;
+
 	/* Clear the SPI GO_BIT Interrupt */
 	regval = readl(p->parent->reg_base + SPI_MST_EVENT_REG_OFFSET(p->hw_inst));
 	if (regval & SPI_INTR) {


