Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F7A342CA7;
	Sat, 30 May 2026 17:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163667; cv=none; b=jk/2t1tuMXVReijApRY0SGf/G5cmq7h1ctFLCGIoVWDIjj9N68I8DPGRCv/QbCRzHnKDZSIIMyWv4yZR2aEHZeyUhMCAmh4oOM+DZIGLJSsREMlgz0Kvw9nC+rLju8VSNP/Zl/v1xr7yMC8eeDX6bLWMD0Yz+8MLvYqU3mlEz8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163667; c=relaxed/simple;
	bh=1DwKcCVbyHSG0NglLdtUs0+JalyaG0RTCkn8c5tErjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nb2Y7p5EcI90SwtBwAaBCsyCdwQje2TK9Jg0A0TNJ8P5zv2EqCzhIQ2t291KWsVs0Yp1/Ghx86GxqAEe9OwCYqqS3NTbs6m+tUWNYMN3ddDuyNf96uhdQMvYUVyBVBASJ+Ty1/7SrRzvSWUfcpzv8noMXPsPq1T2pJtiWvQIqZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I3KqYlUA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I3KqYlUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4AB1F00893;
	Sat, 30 May 2026 17:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163661;
	bh=5k69gmqfJQBwAHF0+ftY2YkJQtf3pcEdkROGBB4M+es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I3KqYlUA4qQ86DmjNu+r12XdXuO6DtNB2GbJnJOB1Ag0KDb1UhRazAiqEPzsqQHeL
	 A2reWmUhLLWGSbh6J4lJe+cTyTMsKFUtEL0bNcV5kVypryE68vhGlNXrNeQ1RGMSUH
	 OJ0QhbWjoRDPPtBxooxx30Sm6BOk04oDoA7jFC2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 323/776] spi: topcliff-pch: fix use-after-free on unbind
Date: Sat, 30 May 2026 18:00:37 +0200
Message-ID: <20260530160248.916193890@linuxfoundation.org>
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

commit 9d72732fe70c11424bc90ed466c7ccfa58b42a9a upstream.

Give the driver a chance to flush its queue before releasing the DMA
buffers on driver unbind

Fixes: c37f3c2749b5 ("spi/topcliff_pch: DMA support")
Cc: stable@vger.kernel.org	# 3.1
Cc: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260414134319.978196-9-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-topcliff-pch.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -1427,9 +1427,6 @@ static int pch_spi_pd_remove(struct plat
 	dev_dbg(&plat_dev->dev, "%s:[ch%d] irq=%d\n",
 		__func__, plat_dev->id, board_dat->pdev->irq);
 
-	if (use_dma)
-		pch_free_dma_buf(board_dat, data);
-
 	/* check for any pending messages; no action is taken if the queue
 	 * is still full; but at least we tried.  Unload anyway */
 	count = 500;
@@ -1453,6 +1450,9 @@ static int pch_spi_pd_remove(struct plat
 		free_irq(board_dat->pdev->irq, data);
 	}
 
+	if (use_dma)
+		pch_free_dma_buf(board_dat, data);
+
 	pci_iounmap(board_dat->pdev, data->io_remap_addr);
 	spi_unregister_master(data->master);
 


