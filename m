Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DD72DB7BB;
	Fri,  7 Aug 2026 15:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115620; cv=none; b=R2FaCMZ14+YSIqcFXf78pfa7+zGhLQtsGZ5E8NyeRJp6IOi97OWza7jNW+V3YSFYRg2ah8pQ0xk1mPCD0TJeYxqVduSUe1ORiFbp3wo/H8Xdwamu4wpOE6PoTE7cM/4d+BHEHj/YQhQDCkz5jDBwfEfTawEzuZJYz/L9lGscJjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115620; c=relaxed/simple;
	bh=wlGlHi9GkUd/Q5eMdDBwPLOlALmSo9MBGYOsXcfDb6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJvJVKcPxXKMBm4MDwnBURUO666vV5j50/EwishAFUK5UkJdHFrfJErs0SY/sOGWwZ2u+Pv/hnp6hyZ2Ud9ObS1mlSCDegPVdHfDTo+XOtQKkxI1hKHkmBileh17c+h3bK+q2cBBYjnDfR/gxqqCVw+kPvMMYCkzV6Toai3kmVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LdGKWHql; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LdGKWHql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2301F00A3A;
	Fri,  7 Aug 2026 15:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115619;
	bh=V/nWBBYDSmwEBBH+O8ETRXjK4S51Joz0WGmTVUqC3qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LdGKWHqlmrzSLhXRplWLuPu+It8+ouLMdnvzyidfSWgi3OmJXkeES7T+5TNhGFD/4
	 hPcKgYDtEvMZkW9bX0bmuDdx/76hfWLUHdlcqD+jX0faOxl/FRSHEwo+XCZnK5yoZt
	 bm8sbq+AT1MPX4BGxk93WNeTMZHjoOgaMXoy2Tu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Alencar <455.rodrigo.alencar@gmail.com>,
	Jun Guo <jun.guo@cixtech.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 341/396] spi: spi-cadence: enable SPI_CONTROLLER_MUST_TX
Date: Fri,  7 Aug 2026 16:38:21 +0200
Message-ID: <20260807143431.640905078@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -735,6 +735,7 @@ static int cdns_spi_probe(struct platfor
 	ctlr->unprepare_transfer_hardware = cdns_unprepare_transfer_hardware;
 	ctlr->mode_bits = SPI_CPOL | SPI_CPHA;
 	ctlr->bits_per_word_mask = SPI_BPW_MASK(8);
+	ctlr->flags = SPI_CONTROLLER_MUST_TX;
 
 	if (of_device_is_compatible(pdev->dev.of_node, "cix,sky1-spi-r1p6"))
 		ctlr->bits_per_word_mask |= SPI_BPW_MASK(16) | SPI_BPW_MASK(32);


