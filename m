Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28EB419E967;
	Tue, 27 May 2025 17:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366475; cv=none; b=HZh9t7OeaCF6KlBmLRKfY4WwogKsfRKCxgmBzNzJIDSe5XLcolkjBCH0S53yFE2GQAJG2ceWQ7r/HJgyPTooRRB+KkFxlI101iZPtV/8Y0OlHd3csjpGbnFvGIzazBeGw5N38sW5pgw0luWpH6NIOezvgRoL5EBlA4SVjQ1izgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366475; c=relaxed/simple;
	bh=EbpKPFnVkEhdrSGFaF/yTs/ZjVN4EVMTpcjynWn+2pE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZK4gd/sU9npYtSLd0xqX5dCkFpmiCnTVGXhZHxMrHoY+ColJDUyrm4YwsdZ7B4+ihSuwoIMh5uq6lGcRjYGQ7Z4ta5orVmtJ9T/7KEI7lftfNe1o73vOhZzNkDKVmlVGFpoDpjv4hB2zP6E4QUQmtiGIsZ3tIWVRvpMFydrqBDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A2ffcnWM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A2ffcnWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C2EC4CEEA;
	Tue, 27 May 2025 17:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366475;
	bh=EbpKPFnVkEhdrSGFaF/yTs/ZjVN4EVMTpcjynWn+2pE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A2ffcnWMBbFsBf/xitF2bKmOi7zzuL/POrHuJHs350Biq/x3tjF9XzOZegXPXHw0c
	 Q0fyi6YEuaHjDNoXKKsw7xPvw7MaCSxKD4isfH6ocr/lqfhWM9HpO+q5DX1Fe1HbGk
	 pxZERIATMRDVQZddCSOPRKR9iOBjSDL1Iw+M3WLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis de Arquer <luis.dearquer@inertim.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 078/783] spi-rockchip: Fix register out of bounds access
Date: Tue, 27 May 2025 18:17:55 +0200
Message-ID: <20250527162516.312700846@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 1bc012fce7cb8..1a6381de6f33d 100644
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



