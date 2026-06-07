Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E71296BCC;
	Sun,  7 Jun 2026 10:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829633; cv=none; b=mzXgBq9ThqjHkR2bozh8LqfXUzT1AA5cL+Ni2BYgOGZ+mYzz67IYD7QXgx4xXbTua0vK93ILwQx+mGSbIVFpflUjT8cLljHb41cQMO83G3wbJHwfh0o9NcvjQt6Z20tiRj+EvI3rC1fErlRswIIPSfFn36QxY7D90XR4d7n9VOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829633; c=relaxed/simple;
	bh=wATruwFd+qB/wrEa+ZhmancLQShTdR2zsDu062AETrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJnqudS6SVcbhMAoGYA2fVlD6q1r3hcaBF+eRFyQTf1BexMgfqOj7d1zbCNTgN8yiH2uKLtWkdlBac+oVRfk1Zp6KUmF24SUZl01ENAOnkLIJgvYRXP/HgX+gZ5BKkWygEYqUUA5C+h9egz2bH707iSOPOqSqrIyfQNZnqcr+XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RodX1/Vy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RodX1/Vy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B9F1F00893;
	Sun,  7 Jun 2026 10:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829632;
	bh=1sKpwoqZ89qUumMjO3f+3naQ+N+uXQEj3tt2YS/l9H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RodX1/Vy/swhc1bWBCQNPN336C4WJieV1WOTwO4wUEAycod4g/pXLL2+mNh/9gBwh
	 H8W9z45+Z1PGkh/4lUO044/PIZzunig4/qVd6jKNoArPf6uN86XFJoT/wPhiBurRAB
	 cR1qiU+DLbIxnaQJ7P7l3OY3Ic8nFl/kf/Mfm5uI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 7.0 301/332] serial: fsl_lpuart: fix rx buffer and DMA map leaks in start_rx_dma
Date: Sun,  7 Jun 2026 12:01:10 +0200
Message-ID: <20260607095739.115051182@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


