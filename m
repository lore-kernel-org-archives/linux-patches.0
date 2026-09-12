Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B470343893;
	Sat, 12 Sep 2026 14:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224085; cv=none; b=iuRUBXwg061XTcRwhMVATqerY/f4uTTrWjnXgYxLKXoLERqq5+0I2W/FfVzoiGApQAR2yS75wEZW/KlBi+U1NQsKNCw1gjwupcmjJhOMbHl8kEAU8YnszT/KIk3uiwpEPeDP0SlQhfydeRN5mHmsKOtbLrFqj0lLYO5SD3aMfPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224085; c=relaxed/simple;
	bh=WAGQEqIPl8a4Z9R4pMy+/MkUqTmd2VgeI/iwKEm5bzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcTs0VtVQ0EgAiuQxr4NdUU6qKyl5Aobod7QThQbPMEMiUcWHm6Pe3LZsCUKNMW7ickr+jKMQWAFsMdlE1LcRt/UqWIsKZb0oV4JvhqhTd2vx4nVApRaHgI4nzR1cJ0tx1KAylbHE4YjKOd52XFBSGySy4GutJTg8hhMP3cXhJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xzs7YjHQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xzs7YjHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09B91F000FF;
	Sat, 12 Sep 2026 14:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224083;
	bh=9Daz7u7K3Z7SMN/EgAgP8TwT8xa9Yhx/XEdMTBemTrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xzs7YjHQw5t2+S+jnXkSuJuxMm4RD9gIOrFnTqRbJ8A8hAjYVmeqEHV2ON8cWslc9
	 NSpv7lSXrRcItGmwA+wt/OAw5NW7KGo2gc35+xoSc76TgmqNHdjDttFqdJbc4//Vw9
	 64ywuESmvhGAtQNGrJ5AEbyhWMCNl3ymiBFR15SQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Curutchet <bastien.curutchet@bootlin.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0922/1424] spi: davinci: Unset POWERDOWN bit when releasing resources
Date: Sat, 12 Sep 2026 08:55:54 +0200
Message-ID: <20260912065627.972057277@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bastien Curutchet <bastien.curutchet@bootlin.com>

[ Upstream commit 1762dc01fc78ef5f19693e9317eae7491c6c7e1b ]

On the OMAPL138, the SPI reference clock is provided by the Power and
Sleep Controller (PSC). The PSC's datasheet says that 'some peripherals
have special programming requirements and additional recommended steps
you must take before you can invoke the PSC module state transition'. I
didn't find more details in documentation but it appears that PSC needs
the SPI to clear the POWERDOWN bit before disabling the clock. Indeed,
when this bit is set, the PSC gets stuck in transitions from enable to
disable state.

Clear the POWERDOWN bit when releasing driver's resources

Signed-off-by: Bastien Curutchet <bastien.curutchet@bootlin.com>
Link: https://patch.msgid.link/20240624071745.17409-1-bastien.curutchet@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: ea408a05dc8f ("spi: davinci: switch to managed controller allocation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-davinci.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/spi/spi-davinci.c b/drivers/spi/spi-davinci.c
index 5688be245c68a..80c5c26f8d961 100644
--- a/drivers/spi/spi-davinci.c
+++ b/drivers/spi/spi-davinci.c
@@ -984,6 +984,9 @@ static int davinci_spi_probe(struct platform_device *pdev)
 	return ret;
 
 free_dma:
+	/* This bit needs to be cleared to disable dpsi->clk */
+	clear_io_bits(dspi->base + SPIGCR1, SPIGCR1_POWERDOWN_MASK);
+
 	if (dspi->dma_rx) {
 		dma_release_channel(dspi->dma_rx);
 		dma_release_channel(dspi->dma_tx);
@@ -1013,6 +1016,9 @@ static void davinci_spi_remove(struct platform_device *pdev)
 
 	spi_bitbang_stop(&dspi->bitbang);
 
+	/* This bit needs to be cleared to disable dpsi->clk */
+	clear_io_bits(dspi->base + SPIGCR1, SPIGCR1_POWERDOWN_MASK);
+
 	if (dspi->dma_rx) {
 		dma_release_channel(dspi->dma_rx);
 		dma_release_channel(dspi->dma_tx);
-- 
2.53.0



