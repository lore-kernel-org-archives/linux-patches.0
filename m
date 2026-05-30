Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2BE3AA182;
	Sat, 30 May 2026 17:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162265; cv=none; b=QQwUkTiZ5fQfe0pxN0f1PvmIpSILELZK/vtcrziM3gJI9TfbX3HsUoxQA8MA2MS3dWnYz2Vk3ZLY/E2pc1dA3ULZrXUrDqKAuxH4Ue62wBwc74KLln08PETL+QY2V/whXpdp2DbnSxrIL5B2HPEP1mDCjyjCkszqhtE01cY5Rzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162265; c=relaxed/simple;
	bh=g43dq6gd9GH/JJhiS6rZshDnZ74e+nKWtJi6YYx4nyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hv4lHW5GKA23QZKQCXuHOFgk3CR4FgkA9TWHUL8re1Dm8qLiDqMoBbQmuSVyNzmkzPnaqKJuJpEaa5t9kZMPbTwIKdlAIaqn2fggnZLimT36UmuH4+H37F5b6gDpsnj0bi0TcKFA15a9e8bJjnXtmk4dE//ryURrKPspi6w2HC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6wlFaTj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6wlFaTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B4C1F00893;
	Sat, 30 May 2026 17:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162262;
	bh=yQDlyMZ9eZgCwQ0tIX+p4ZMBw+DzHrPDJlIFtkhXQzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T6wlFaTjIAHRW9dImC2EbDFi9Zs69fs0mHNWvUWoKinXU+dwQOza6/VBLS9WVkA7H
	 ELN1RiE5B+0XPB3JkIIPbLvYsnArsb2CrCLof9mIFCHrNA7MM7rPxvQB2ldJ+/CT7G
	 E77A0tfWOKUn09eCUTMqFp0u+m8cTnEszjo86tG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vignesh R <vigneshr@ti.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 870/969] spi: ti-qspi: fix use-after-free after DMA setup failure
Date: Sat, 30 May 2026 18:06:34 +0200
Message-ID: <20260530160324.707413108@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
@@ -875,6 +875,7 @@ static int ti_qspi_probe(struct platform
 		dev_err(qspi->dev,
 			"dma_alloc_coherent failed, using PIO mode\n");
 		dma_release_channel(qspi->rx_chan);
+		qspi->rx_chan = NULL;
 		goto no_dma;
 	}
 	master->dma_rx = qspi->rx_chan;


