Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC35227EA4;
	Mon,  2 Jun 2025 14:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873160; cv=none; b=Als/CXfJGX1tRvhesvcOQCYBCC3pCDqAfNYNRt3XWbGePaFimh780AvRIyMjcPV+sv/5kpaVq3QcevgdXu56hzvQzd2wmJGzDSFALlX4dAkhFPYyfmwurn1krsanu00rm6CAbm3WT6FS6+iOv9a/sVrLzgrD/MLnD7gQK6rfzz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873160; c=relaxed/simple;
	bh=JZzROz2SBIkkx8jPcidysB095MSeIjwXZAYmmgX5Qlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mkUFciIOqEr/vIciduGCdNjMi9QAik/KeZRSGEGJgfVCjoItKvmQ3GHJl8G0VOhX57MuJLPdbeVF3Todqphd/WeXdHIp6SS58ylrXl3mo3LQmkrk582L6dOFB5nJVwPXuIGirAw2QJ1m6hIhyprNRTnPop18w8a7rVi9u51kGI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nx326gC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nx326gC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3313C4CEEE;
	Mon,  2 Jun 2025 14:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873160;
	bh=JZzROz2SBIkkx8jPcidysB095MSeIjwXZAYmmgX5Qlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nx326gC81nKHMhO+46fBEMMgYeAO4gIfKKCWLYhqpI3/73T5DVKEinDyNHgPQ7tWZ
	 QP+TUqhTNh966W1Gxl65S9MqqhtKyRPl194J2ffJ3weoxKQhbw6AvU8fTM05pySEP3
	 ZLZNPVWeBI0vsYdcVmKfale8ZUaAU+UcDNNfKDdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis de Arquer <luis.dearquer@inertim.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/444] spi-rockchip: Fix register out of bounds access
Date: Mon,  2 Jun 2025 15:42:01 +0200
Message-ID: <20250602134343.238825713@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1f374cf4d6f65..1615f935c8f03 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -542,7 +542,7 @@ static int rockchip_spi_config(struct rockchip_spi *rs,
 	cr0 |= (spi->mode & 0x3U) << CR0_SCPH_OFFSET;
 	if (spi->mode & SPI_LSB_FIRST)
 		cr0 |= CR0_FBM_LSB << CR0_FBM_OFFSET;
-	if (spi->mode & SPI_CS_HIGH)
+	if ((spi->mode & SPI_CS_HIGH) && !(spi_get_csgpiod(spi, 0)))
 		cr0 |= BIT(spi_get_chipselect(spi, 0)) << CR0_SOI_OFFSET;
 
 	if (xfer->rx_buf && xfer->tx_buf)
-- 
2.39.5



