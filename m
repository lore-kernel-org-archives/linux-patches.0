Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEDF46C4BB;
	Tue, 21 Jul 2026 15:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649495; cv=none; b=dwwM9PLbsMdXAkPBEVCqW4xSjI8eAUzx6+nJRiINh216L1W8Fa7EtZRODvT0dy+hAm9HX6oTgnkb/Ic/UsCoKlanqt2h7nJYxYffoCBAriOBeyzKrrUD6qsVLUcvXNjF8QkVEfyWztrUOlp0f090+SZ9JNfkXUOPmmPea8X7UJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649495; c=relaxed/simple;
	bh=zJxnNfHLiiIIQpZS4ICttpnjwMJX8b5tjJtTu3dI7MM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjeZceHfgtDV1u6KLNfUPUMBQienMbl56izDGlhy03A8i4qLhcgGIujuT+ikLsgGXZ+k5VdjPYVAOeKwoD9pci++VL/lp3HBey8oFm52WB959ZSsn/ALnSzrICcslynv1byJW9Wei5fw8hvVa8yFOZ/iqDZ7m50vHmIqPzjZfiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hm0CAr/7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hm0CAr/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545FF1F000E9;
	Tue, 21 Jul 2026 15:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649492;
	bh=6T+XJSISRHlu+O0txJbj72hN+K3So8ED17VFHVoywQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hm0CAr/7MiGxw39yzsDMh1Bj31TDiNQRRNNDqPrg70S0x1utfZNqujD5ZSghOrFga
	 zwYxfk4NGT6YW71t53WQ/5u5bX7ikG9rCRnsH6rI9X6DPXShslxrHNtSTnzJGqjEvk
	 ctlC/7kYUUZ5SOUyyOSyoKAo4VHaRVrlyLXAeMJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0555/2077] spi: ep93xx: fix double-free of zeropage on DMA setup failure
Date: Tue, 21 Jul 2026 17:03:48 +0200
Message-ID: <20260721152605.900928210@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 7886054b06f762f62054957a8f6de0f14e6b7541 ]

If DMA setup fails after allocating the zeropage, the error path frees
the page but leaves espi->zeropage dangling. A subsequent call to
ep93xx_spi_release_dma() sees the non-NULL pointer and frees the page
again.

Clear the pointer after freeing in the error path of
ep93xx_spi_setup_dma().

Fixes: 626a96db1169 ("spi/ep93xx: add DMA support")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260529-ep93xx-v1-1-9185070ca1fc@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-ep93xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index f716c9607be4af..4cab0d97a68afc 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -600,6 +600,7 @@ static int ep93xx_spi_setup_dma(struct device *dev, struct ep93xx_spi *espi)
 	espi->dma_rx = NULL;
 fail_free_page:
 	free_page((unsigned long)espi->zeropage);
+	espi->zeropage = NULL;
 
 	return ret;
 }
-- 
2.53.0



