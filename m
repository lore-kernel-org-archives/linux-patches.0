Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976E43446C5;
	Thu, 28 May 2026 20:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000623; cv=none; b=oa5gpvKidiYBB8wcXDv2bUEkFxI6UMgcDA0mXSzHQy/GCrU7wnsbXf/pwUOwdM7uDiymHjkeAyXcytG9p9F2MyybxFLr7dWQlgzsUxwhHofifsPeLCD8QXNS7TbeN6G6X9ilLHInI2WY++2AnncNAGLNO/lxsTPaKcUo/BoJa+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000623; c=relaxed/simple;
	bh=TY9KqlTbRTXKecteZRRg8EF+qPcHoX7QT1ypa7qTqmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJmB+BxbpfChU3Cg7/TMHnzBPSaJqdMYlezyl/cg+2bpjYcVUQU8BcjgtaTI361EMiYTH+GAmQDoQlNgKUgMxPRmyKrvT3MT9C1rAfeiEx4vBRmwd8R7+kEvSlxjWvJXfACOLgVGo9jjbUWcG+YoYjZ0a9T/sX4clqNHTcdi5Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XgrUoYEc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XgrUoYEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3841F000E9;
	Thu, 28 May 2026 20:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000622;
	bh=RM1WxqLXT5Q2cWbAqNX40t5C6x2Y+0CifyiBxO5Rhmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XgrUoYEci1mzgmLSqGbUfslf5upnquRZ4MWG1ZeOIccdC7AO40fK1fBZyjdfiHyhi
	 rmgtKa2s9ohv0Y7vXyJOTYc79A5oGu8naJROmiOfPL+1AD7/aX/tCYXLskjAVHXY0j
	 Tpv2JPqK4BNo84+79+C2K/tTIr0fLxamncFc+OrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vignesh R <vigneshr@ti.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 110/272] spi: ti-qspi: fix use-after-free after DMA setup failure
Date: Thu, 28 May 2026 21:48:04 +0200
Message-ID: <20260528194632.457291150@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit ea6ec3343e05f7937a53eb6d7617b3abdb4abc19 upstream.

The driver falls back to PIO mode if DMA setup fails during probe.

Make sure to clear the DMA channel pointer also if buffer allocation
fails to avoid passing a pointer to the released channel to the DMA
engine (or trying to free the channel a second time on late probe errors
or driver unbind).

This issue was flagged by Sashiko when reviewing a devres allocation
conversion patch.

Fixes: c687c46e9e45 ("spi: spi-ti-qspi: Use bounce buffer if read buffer is not DMA'ble")
Link: https://sashiko.dev/#/patchset/20260505072909.618363-1-johan%40kernel.org?part=17
Cc: stable@vger.kernel.org	# 4.12
Cc: Vignesh R <vigneshr@ti.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260512074809.915084-1-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-ti-qspi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/spi/spi-ti-qspi.c
+++ b/drivers/spi/spi-ti-qspi.c
@@ -874,6 +874,7 @@ static int ti_qspi_probe(struct platform
 		dev_err(qspi->dev,
 			"dma_alloc_coherent failed, using PIO mode\n");
 		dma_release_channel(qspi->rx_chan);
+		qspi->rx_chan = NULL;
 		goto no_dma;
 	}
 	host->dma_rx = qspi->rx_chan;


