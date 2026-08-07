Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E05A4746D7;
	Fri,  7 Aug 2026 15:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116366; cv=none; b=aHLnt+IqGoQTJCqtB0Ohi+7VOvZJoNGTSR0Pl6ps+dXwrwIUPReNRVzGusVTk2lGQHzJLAfr6lBZjdHtH4OH2Hho2cPxjIpohToYabi4wJ+Y3RHfMh71X7rC2lEHcEJUco2knuYl+C6f11vtibRJABy41c91bH3kRd+Y3f+8JE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116366; c=relaxed/simple;
	bh=oLRgAFT4vp2X/v6wiqDgppJMs4sP2xF5Flc5QWOV4Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PirXsPyU7BO96qBoBDIVwIPDEEIG6o25jILvBs+6azYVPHW4IizAfowY/6R7Sl+REvQqMiCpcUSQT8lVf9Yk3GhnaT+6NXZJIy4/BcbXsOA4TAo9hR00hKXiS1sE4vuR1EbuUEkcGgwkunFs3QYCNo54jjh+Fx62PMHrzSvYf7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AbMN+mrN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AbMN+mrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2201F000E9;
	Fri,  7 Aug 2026 15:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116365;
	bh=q9WBP9Q0lE5bhUVgOJg3GcD3UiJ1lUizAX2ibGId+xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AbMN+mrN5R3y+8TfT/jE96QQcemaMtghWkmrxDMCIc0CS8/Um7AOyntJrMnduFtWM
	 gATlEcR4Q66pMN6Vt5PUsn2iguu8LokRfHMRXLEnd+ThQLZpi2eYvCyscmge2bQNxk
	 vrURlOkkYdBLnSkhD7ss9vm4LmQyaFskh4t+sw2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Alencar <455.rodrigo.alencar@gmail.com>,
	Jun Guo <jun.guo@cixtech.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 204/261] spi: spi-cadence: enable SPI_CONTROLLER_MUST_TX
Date: Fri,  7 Aug 2026 16:39:21 +0200
Message-ID: <20260807143419.766646172@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Jun Guo <jun.guo@cixtech.com>

commit f6b625639e39bc384a7bddbf134a698d40258b3b upstream.

During an SPI read operation, even if the xspi->txbuf passed to the
cdns_spi_writerinterface is empty, it is still necessary to call
cdns_spi_write(xspi, CDNS_SPI_TXD, txw); otherwise, the read operation
will fail to obtain data correctly due to a lack of clocks.

Fixes: 4e00135b2dd1 ("spi: spi-cadence: supports transmission with bits_per_word of 16 and 32")
Reported-by: Rodrigo Alencar <455.rodrigo.alencar@gmail.com>
Closes: https://lore.kernel.org/all/lbijvnnwsnddonmm5pveqzap6iibxhl4maneq43x4j6w64dev6@u75qhm5cwiob/
Signed-off-by: Jun Guo <jun.guo@cixtech.com>
Link: https://patch.msgid.link/20260115091924.844179-1-jun.guo@cixtech.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/spi/spi-cadence.c
+++ b/drivers/spi/spi-cadence.c
@@ -722,6 +722,7 @@ static int cdns_spi_probe(struct platfor
 	ctlr->unprepare_transfer_hardware = cdns_unprepare_transfer_hardware;
 	ctlr->mode_bits = SPI_CPOL | SPI_CPHA;
 	ctlr->bits_per_word_mask = SPI_BPW_MASK(8);
+	ctlr->flags = SPI_CONTROLLER_MUST_TX;
 
 	if (of_device_is_compatible(pdev->dev.of_node, "cix,sky1-spi-r1p6"))
 		ctlr->bits_per_word_mask |= SPI_BPW_MASK(16) | SPI_BPW_MASK(32);


