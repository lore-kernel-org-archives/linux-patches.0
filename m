Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CD23AB285;
	Sat, 30 May 2026 18:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164923; cv=none; b=Lgp7cpFDvIoTyraF9h1DmPngfVUXWDlEYsGNOVxCBUlj9Y4h2g75DifSBv1poK8dkxWNC2NYC3Nz7LDTFlwY4J1t/GjAKVV9IhXP429Zk1XRX6jKGM1ffv0h3XcJzF5IH+uoBPpe4cpkhG0MWpxpOW29IYlEZZeusaisSqtu8aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164923; c=relaxed/simple;
	bh=BBWXDfno3MBKhbGS4Ll/k+k8iK3Oo7FICGmHGmh7C5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0/C+/QH0GiGDkGAsQ05vrQCtH79tLtpmuTYS+7HBjIeyPstoxlMdvhQCzpF4E/kZNQB3Wu4syErYAd9BWvXLefm0bh6U28kLGtrchXxrQ9w1kaRjlqx7/RhSxEjcoQ/ktSPdVK/WwF84O/1GwvrvGqNP88ouFAhctZHZLinF8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5Hmf5Hj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5Hmf5Hj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870A91F00893;
	Sat, 30 May 2026 18:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164922;
	bh=dc4adUPtYddPC/49VwViYZ2drAo2u+bxO41Aihi4isY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F5Hmf5HjiqZ8g0eqtT2tJsqYCSrUV2I0o8RW1xu7O+OnfjOik0mLdjYQfHqgNU8Ia
	 blGFf0rYC9No8lKRewAGMmw5/fhykI3mtu1MLx56GjIzNw7aUKsC7CSsiyFTsx7aXl
	 mbynMKWJZQZgJ1OeXASMV8Ca/ZnNE+7j8f+7UWaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vignesh R <vigneshr@ti.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 699/776] spi: ti-qspi: fix use-after-free after DMA setup failure
Date: Sat, 30 May 2026 18:06:53 +0200
Message-ID: <20260530160257.895303095@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -873,6 +873,7 @@ static int ti_qspi_probe(struct platform
 		dev_err(qspi->dev,
 			"dma_alloc_coherent failed, using PIO mode\n");
 		dma_release_channel(qspi->rx_chan);
+		qspi->rx_chan = NULL;
 		goto no_dma;
 	}
 	master->dma_rx = qspi->rx_chan;


