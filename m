Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFE914AD15;
	Tue, 20 Feb 2024 21:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463354; cv=none; b=UHKUniwDKQgVTjBDHNDA3iHSpalmbKxYfHm6pPVHNu5ofKOMDpl5w+rbsTOZ0A7lEwPLOuWFJIYKhoo3ivioAQI3XrVAczuH7F20v+WbO82xiqqpVDERqA1b83XBW+wUZCKW9I1mfB371NUwqF/WSchUrF32K9YltyW0I9dpJdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463354; c=relaxed/simple;
	bh=w1YfufTYl/goKmLuNc3Hk5C9Voa3uW9Dy2fyB9w2pUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rY1jzu8Zz72KbHt1FewKQLf1++OixXPSDw1SnhRrQDUVTrs8B0VBcYFplQZ9XPBZlHgWiQ759a5SaIVs5djeGZ3R+s5iFvOSNpFC/UZVy6zSYBkVnpfcHYdEj/H9pRdrKCyu61BoX5TrV+b3z04GJAUioWbGpWPzzdYLNA9QZ68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=em6pL02y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="em6pL02y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7F6C433F1;
	Tue, 20 Feb 2024 21:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463354;
	bh=w1YfufTYl/goKmLuNc3Hk5C9Voa3uW9Dy2fyB9w2pUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=em6pL02y2ijv5FYIkILPOEdR8TS9c/YeKe6TtempIQoYckc+ajcxhhZt+39N/cYyO
	 qtWsh8dgsWqwDhjdXFYGwOHM2f81oFDGl8nYjKVIzsnqSBCje4z7ywzdX+KKJJRPvm
	 17Tqlfna5HQYHghNAMOVwtbDSw7wQqnOp8su3nts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Clark Wang <xiaoning.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/331] spi: imx: fix the burst length at DMA mode and CPU mode
Date: Tue, 20 Feb 2024 21:52:14 +0100
Message-ID: <20240220205638.162394355@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Carlos Song <carlos.song@nxp.com>

[ Upstream commit c712c05e46c8ce550842951e9e2606e24dbf0475 ]

For DMA mode, the bus width of the DMA is equal to the size of data
word, so burst length should be configured as bits per word.

For CPU mode, because of the spi transfer len is in byte, so calculate
the total number of words according to spi transfer len and bits per
word, burst length should be configured as total data bits.

Signed-off-by: Carlos Song <carlos.song@nxp.com>
Reviewed-by: Clark Wang <xiaoning.wang@nxp.com>
Fixes: e9b220aeacf1 ("spi: spi-imx: correctly configure burst length when using dma")
Fixes: 5f66db08cbd3 ("spi: imx: Take in account bits per word instead of assuming 8-bits")
Link: https://lore.kernel.org/r/20240204091912.36488-1-carlos.song@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-imx.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 272bc871a848..e2d3e3ec1378 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -2,6 +2,7 @@
 // Copyright 2004-2007 Freescale Semiconductor, Inc. All Rights Reserved.
 // Copyright (C) 2008 Juergen Beisert
 
+#include <linux/bits.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
 #include <linux/delay.h>
@@ -660,15 +661,15 @@ static int mx51_ecspi_prepare_transfer(struct spi_imx_data *spi_imx,
 			<< MX51_ECSPI_CTRL_BL_OFFSET;
 	else {
 		if (spi_imx->usedma) {
-			ctrl |= (spi_imx->bits_per_word *
-				spi_imx_bytes_per_word(spi_imx->bits_per_word) - 1)
+			ctrl |= (spi_imx->bits_per_word - 1)
 				<< MX51_ECSPI_CTRL_BL_OFFSET;
 		} else {
 			if (spi_imx->count >= MX51_ECSPI_CTRL_MAX_BURST)
-				ctrl |= (MX51_ECSPI_CTRL_MAX_BURST - 1)
+				ctrl |= (MX51_ECSPI_CTRL_MAX_BURST * BITS_PER_BYTE - 1)
 						<< MX51_ECSPI_CTRL_BL_OFFSET;
 			else
-				ctrl |= (spi_imx->count * spi_imx->bits_per_word - 1)
+				ctrl |= spi_imx->count / DIV_ROUND_UP(spi_imx->bits_per_word,
+						BITS_PER_BYTE) * spi_imx->bits_per_word
 						<< MX51_ECSPI_CTRL_BL_OFFSET;
 		}
 	}
-- 
2.43.0



