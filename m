Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DF31D63EF;
	Tue, 27 May 2025 16:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364497; cv=none; b=maVigqobvzPaaQHg25Z4lan44dD9cJqrv72weJF7FmENukMY9QPt9HCIsJ0vTzr5BvTFR1JFHlMbYug9HXjVLOLK7ofxd98GaeZE6S4mAEBmuRXxoPGBMx8GuDsJN1tI+MV+/vbNsBEUKPPDFg0Rz2ukdJN5LJI3++8uHUO4U5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364497; c=relaxed/simple;
	bh=o472906vaSjMuibz+puAQvwqYHWO9Foq4RM7x56WDu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=is+igKakJt4dj4qllrrlv4P/CVmU/dVr1MTJBc2QdCK/JZr5aPAMDcu6jdR5ojI6aA6jf2EXamPNY1GhhOG8D+3BKWlCS7dKQOapbsaQdibbxy2b0q26+FwXEOWW8tWMjRFfTJ0NPIEPsYmJLfmfD27cIfRo4YGaIBkpoNeWwz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FsK8p2e1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FsK8p2e1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9A5C4CEE9;
	Tue, 27 May 2025 16:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364497;
	bh=o472906vaSjMuibz+puAQvwqYHWO9Foq4RM7x56WDu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FsK8p2e1vyGCZAUtgTqglSK63Yr5tweju0YmlppO5OjGIYIB+vHRtSuIP7PQ3APCq
	 5QeACz8WkoZR9nvxbKys6oeMlwaAJqzKQen/lCJq5ljPJuNo9fzFt0QODE95ay+Vmt
	 mCXthxeePLH+2n0Mc2w3xxxnhMn0PP9bFD7lqZK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis de Arquer <luis.dearquer@inertim.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/626] spi-rockchip: Fix register out of bounds access
Date: Tue, 27 May 2025 18:19:27 +0200
Message-ID: <20250527162448.053475665@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Luis de Arquer <luis.dearquer@inertim.com>

[ Upstream commit 7a874e8b54ea21094f7fd2d428b164394c6cb316 ]

Do not write native chip select stuff for GPIO chip selects.
GPIOs can be numbered much higher than native CS.
Also, it makes no sense.

Signed-off-by: Luis de Arquer <luis.dearquer@inertim.com>
Link: https://patch.msgid.link/365ccddfba110549202b3520f4401a6a936e82a8.camel@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rockchip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index 40a64a598a749..5008489d6fac8 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -547,7 +547,7 @@ static int rockchip_spi_config(struct rockchip_spi *rs,
 	cr0 |= (spi->mode & 0x3U) << CR0_SCPH_OFFSET;
 	if (spi->mode & SPI_LSB_FIRST)
 		cr0 |= CR0_FBM_LSB << CR0_FBM_OFFSET;
-	if (spi->mode & SPI_CS_HIGH)
+	if ((spi->mode & SPI_CS_HIGH) && !(spi_get_csgpiod(spi, 0)))
 		cr0 |= BIT(spi_get_chipselect(spi, 0)) << CR0_SOI_OFFSET;
 
 	if (xfer->rx_buf && xfer->tx_buf)
-- 
2.39.5



