Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CD3477982;
	Tue, 16 Jun 2026 17:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632363; cv=none; b=LH2ze7MG1RGzc381DTr8WezmIgyETpOye4GaZKVGb/uaOYHyrT5QSEPphpx0zr0IYqrAWDuoRoKIOSHAYSnZNZQg/01WTmGSkhO469VbzY5I8h1tqesgBmh+RSYw+qIKsJghs4/CSV6yi9Woh0igVbIUjeoiMui723Kk5H7mGaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632363; c=relaxed/simple;
	bh=7PaqhLDNaRYmpccsyuYoWUMXZk6GT/54dT/kLuiDHmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dStEHm8C3UI03dUdtbuJnH2IPfRlZyDyn8dvftQzPkNZRmoMz7Ep7Mz5H4eqouZfqMnlxSQNEITAs6CyKKbyi+xaRtknNShmSrkmDK21PvumkVTt7+S5oQkGMHIx4BzZDQmVPRlmOb7t55EplTxoBAXTpTC7V6IOG+7Rckwro40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tdFqcioO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tdFqcioO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7437D1F000E9;
	Tue, 16 Jun 2026 17:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632361;
	bh=EIlPBomE672/J6GvBhBaqNERshy4rhMA9kaKP/Q/lQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tdFqcioOFQUdC8UHKQn3k+0pS3S69CieDMK/N7zRn1DPNKhrnx6fFKXDpLFB49FkD
	 BCYr5BtgOI7Zc2ZjbcdKUeTVPOa/BLTAWrt78KyC/ZNIYZVN6U6yn5oFIj8+1RGSto
	 p8ZkgupYisf99WYTENGOCh+alSn0AHvpbLrlF71E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adithya K V <adithya.kv@samsung.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 396/522] spi: s3c64xx: fix NULL-deref on driver unbind
Date: Tue, 16 Jun 2026 20:29:03 +0530
Message-ID: <20260616145144.501165284@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

[ Upstream commit 45daacbead8a009844bd5dba6cfa731332184d17 ]

A change moving DMA channel allocation from probe() back to
s3c64xx_spi_prepare_transfer() failed to remove the corresponding
deallocation from remove().

Drop the bogus DMA channel release from remove() to avoid triggering a
NULL-pointer dereference on driver unbind.

This issue was flagged by Sashiko when reviewing a controller
deregistration fix.

Fixes: f52b03c70744 ("spi: s3c64xx: requests spi-dma channel only during data transfer")
Cc: stable@vger.kernel.org	# 6.0
Cc: Adithya K V <adithya.kv@samsung.com>
Link: https://sashiko.dev/#/patchset/20260410081757.503099-1-johan%40kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410094925.518343-1-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-s3c64xx.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -1274,11 +1274,6 @@ static int s3c64xx_spi_remove(struct pla
 
 	writel(0, sdd->regs + S3C64XX_SPI_INT_EN);
 
-	if (!is_polling(sdd)) {
-		dma_release_channel(sdd->rx_dma.ch);
-		dma_release_channel(sdd->tx_dma.ch);
-	}
-
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);


