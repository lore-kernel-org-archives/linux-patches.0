Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EEA421220;
	Mon, 17 Aug 2026 15:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980565; cv=none; b=DZsPyHy4bGlS5g+tH0rWPk7ZEbNhN2DmJAz0CcWbR6031Kiw7AowmbHg8cIRJ4lZeB8sLTsCN+8MW5/chevUGXYhI6gqEIsMiWKMH5PIqaJQamcia2aRC3ue92sGV7jzKretXs5cgi45nbpsC+mF3TlOR6GtPVz/14QnlrC0d9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980565; c=relaxed/simple;
	bh=r43UqAmh4UWafSUhX0WIbNKkrd/Q8lVD7Qgt3+BKozI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2D8d4zlDfHFY3nFbe3/wwBwtC9bO5GNRiN0D0nZbGaO+ZIJPD3zNf83q0G5zjWwmZzitL88sbeZUQnSEUYJDVoezsQWmBEcfPx/yjUof+hd8kOkRnfcesQgz+76s5K4OxX39O+LHRh12xe3S0FTmV20pksXuNew+NGvSZkm66g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PV+IUpVP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PV+IUpVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE931F000E9;
	Mon, 17 Aug 2026 15:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980564;
	bh=GsHdtbYzFzQfzWY/hNxBlEwC0GOT4MMkGpSZP6sSErQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PV+IUpVPSEkrgp0wZrqmCCpqfgGY/e0OauyGP6c1nEHVK82CNdTbOQjBYaKD+aYAc
	 spSbdTyrWJi2RIgLV+7nATerSC5rs0AzFF2jaOeutUYHSdtHFv/nYUpc3Fwby/yQEz
	 X/5fVBPmrJhrOYYJMq/B1y/f4wl3z+datjJM+i4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Cunhao Lu <1579567540@qq.com>
Subject: [PATCH 6.1 569/609] serial: 8250_dma: Clear stale RX state on shutdown
Date: Mon, 17 Aug 2026 15:34:25 +0200
Message-ID: <20260817132602.760771663@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Cunhao Lu <1579567540@qq.com>

commit e2fe6a0efecbef00e3ecc2db64dd5afa8c212b41 upstream.

serial8250_release_dma() terminates RX DMA and releases the channel, but
leaves rx_running set.  If the port is closed while an RX transfer is
active, the stale state remains while rxchan is NULL until the channel is
requested again on the next open.

The DesignWare BUSY workaround added by commit a7b9ce39fbe4
("serial: 8250_dw: Ensure BUSY is deasserted") calls
serial8250_rx_dma_flush() from the LCR write path during startup.  This
happens before serial8250_request_dma() obtains a new RX channel.  On
reopen, the stale rx_running state therefore makes the flush path pass a
NULL channel to dmaengine_pause(), causing a kernel Oops.

Clear rx_running after terminating RX DMA, matching the TX cleanup.  Also
make the flush helper return if the DMA object or RX channel is not
available so startup and teardown paths cannot pass a NULL channel to the
DMAengine API.

Fixes: 0fcb7901f9d6 ("tty: serial: 8250_dma: keep own book keeping about RX transfers")
Cc: stable <stable@kernel.org>
Signed-off-by: Cunhao Lu <1579567540@qq.com>
Link: https://patch.msgid.link/tencent_9EE2945F4C933B4D810C73C2D7485E000F06@qq.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_dma.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -195,11 +195,12 @@ void serial8250_rx_dma_flush(struct uart
 {
 	struct uart_8250_dma *dma = p->dma;
 
-	if (dma->rx_running) {
-		dmaengine_pause(dma->rxchan);
-		__dma_rx_complete(p);
-		dmaengine_terminate_async(dma->rxchan);
-	}
+	if (!dma || !dma->rxchan || !dma->rx_running)
+		return;
+
+	dmaengine_pause(dma->rxchan);
+	__dma_rx_complete(p);
+	dmaengine_terminate_async(dma->rxchan);
 }
 EXPORT_SYMBOL_GPL(serial8250_rx_dma_flush);
 
@@ -308,6 +309,7 @@ void serial8250_release_dma(struct uart_
 
 	/* Release RX resources */
 	dmaengine_terminate_sync(dma->rxchan);
+	dma->rx_running = 0;
 	dma_free_coherent(dma->rxchan->device->dev, dma->rx_size, dma->rx_buf,
 			  dma->rx_addr);
 	dma_release_channel(dma->rxchan);


