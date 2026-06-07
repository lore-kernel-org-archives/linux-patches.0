Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2AF4204E;
	Sun,  7 Jun 2026 10:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829629; cv=none; b=L8CZtPwhRiXA+Lao9PNo2ZzCMyvHxMsmqsiSuNDARkHUWIkih45CS6G8iF/n3r2N0TI16g0HgsQqZGCkgoKKDfKk8MvluzoZLjWFporm4DACJVQ0vZpClI1wAcj/xBLas+Yx5hwbYy8RHvbmP715ZVl6jwUxwne3Jo381d9KSYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829629; c=relaxed/simple;
	bh=6G8oJIqHFO4PuVpUerMPLtD65S04+LklHMdoTEpdqdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwqiXJ+z2EoF4QUQYgSTHBHQYAU4g2A8tx9VAtifmCiJHuamcdAm9WUgXh4Qp3EMENpNcuJytvA4lR8rndI1ZvXPLFRzcrDJkw6Tz7+McWQZ7P5j2eaZJriavuOC27FrV98JYi98eRjWkeGdR8L1DFYJM+IB+uP9Ul6VHXpcKhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V8KzW955; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V8KzW955"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222E41F00893;
	Sun,  7 Jun 2026 10:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829628;
	bh=M/jM9OguR2Xwsr0ufC951yJpCcZW0006LNIFEyxzHmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V8KzW955leULVTBlJTA8atXS8i4Bl6ONtpQG8G3P44vG78HRbn1QM6h5XgHshRQEa
	 bGTQM9hX4wwxS+OpTfGtHkhAhPEztMeYQ9STRFG1X6exZDDnbe4U/rTtpBpv9zQjQE
	 unVM+dymq3Y3isDntvnVYJ0VYQjM+AoTT37hoU2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.18 266/315] serial: fsl_lpuart: fix rx buffer and DMA map leaks in start_rx_dma
Date: Sun,  7 Jun 2026 12:00:53 +0200
Message-ID: <20260607095737.342060621@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Shitalkumar Gandhi <shital.gandhi45@gmail.com>

commit 9a9254c4a2a3ca2b3da16d173f3b0dd01f397ff6 upstream.

lpuart_start_rx_dma() allocates sport->rx_ring.buf with kzalloc() and
then maps a scatterlist via dma_map_sg().  On three subsequent error
paths the function returns directly without releasing those resources:

  - when dma_map_sg() returns 0 (-EINVAL):
      ring->buf is leaked.
  - when dmaengine_slave_config() fails:
      ring->buf and the DMA mapping are leaked.
  - when dmaengine_prep_dma_cyclic() returns NULL:
      ring->buf and the DMA mapping are leaked.

The sole cleanup path, lpuart_dma_rx_free(), is only reached when
lpuart_dma_rx_use is set, and the caller lpuart_rx_dma_startup() clears
that flag on failure of lpuart_start_rx_dma().  So these resources are
permanently leaked on every failure in this function.  Repeated port
open/close or termios changes under error conditions will slowly consume
memory and leave stale streaming DMA mappings behind.

Fix it by introducing two error labels that unmap the scatterlist and
free the ring buffer as appropriate.  While here, replace the misleading
-EFAULT (bad userspace pointer) returned when dmaengine_prep_dma_cyclic()
fails with the more accurate -ENOMEM, matching how other dmaengine users
in the tree treat this failure.

No functional change on the success path.

Fixes: 5887ad43ee02 ("tty: serial: fsl_lpuart: Use cyclic DMA for Rx")
Cc: stable <stable@kernel.org>
Signed-off-by: Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260420135903.2062024-1-shitalkumar.gandhi@cambiumnetworks.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/fsl_lpuart.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1379,7 +1379,8 @@ static inline int lpuart_start_rx_dma(st
 
 	if (!nent) {
 		dev_err(sport->port.dev, "DMA Rx mapping error\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_free_buf;
 	}
 
 	dma_rx_sconfig.src_addr = lpuart_dma_datareg_addr(sport);
@@ -1391,7 +1392,7 @@ static inline int lpuart_start_rx_dma(st
 	if (ret < 0) {
 		dev_err(sport->port.dev,
 				"DMA Rx slave config failed, err = %d\n", ret);
-		return ret;
+		goto err_unmap_sg;
 	}
 
 	sport->dma_rx_desc = dmaengine_prep_dma_cyclic(chan,
@@ -1402,7 +1403,8 @@ static inline int lpuart_start_rx_dma(st
 				 DMA_PREP_INTERRUPT);
 	if (!sport->dma_rx_desc) {
 		dev_err(sport->port.dev, "Cannot prepare cyclic DMA\n");
-		return -EFAULT;
+		ret = -ENOMEM;
+		goto err_unmap_sg;
 	}
 
 	sport->dma_rx_desc->callback = lpuart_dma_rx_complete;
@@ -1426,6 +1428,13 @@ static inline int lpuart_start_rx_dma(st
 	}
 
 	return 0;
+
+err_unmap_sg:
+	dma_unmap_sg(chan->device->dev, &sport->rx_sgl, 1, DMA_FROM_DEVICE);
+err_free_buf:
+	kfree(ring->buf);
+	ring->buf = NULL;
+	return ret;
 }
 
 static void lpuart_dma_rx_free(struct uart_port *port)


