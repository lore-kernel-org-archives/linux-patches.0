Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6614F218;
	Thu, 12 Dec 2024 17:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023797; cv=none; b=LY/5TbQWMCCGDvb45Dgtsp4kmaVIjy8o4RxiqDa+jruKLH5Dtu6T90dTNgMUjArv+LvTvQrXML4oobeVRzEHZcOQ4uBj5K57Vxidv2WlmabnBA62Ydev8P1NK07jEak0hGIV4FMnhFTlPaXb/BwMIwhXIV07X9kHJHdmjPdnrjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023797; c=relaxed/simple;
	bh=1ZxN9CcJhGMg1MGE2YOElUZHT7HQ7LJl8YDhsA/jy8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BsiBUTdDuKULyKQdS8EsbYLrIBE1C43NbpX9CVkZG34m2s5H5/4AwaqDpo/2K4wQvChO9vs0Z9ejVkrJUSORDKCVqvsbWsWJ963pDOVeX8CcWFIBUNfxZwdhp4LZAvpA8Ybk/dfh1udDZG8q6St7LBEyWMAP3poH7t9TPq0NAS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k1a1Bq6i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k1a1Bq6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C99C4CECE;
	Thu, 12 Dec 2024 17:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023797;
	bh=1ZxN9CcJhGMg1MGE2YOElUZHT7HQ7LJl8YDhsA/jy8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k1a1Bq6iv4Hgv7UM6A3zhfnFDOPhRU5BB8/yt0oIDJNilwAMvrAKmgK/8GNOIA9vm
	 SKsjEiXnZctP85RGy738lMH3PcFTwIKsU81J0CrBxNMF4I11mrUusNS2a4lvmlPaq6
	 0WsYs+oWSk8Gz99h/mclCOODAWPkAr8uB7+dXJEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/459] mmc: mmc_spi: drop buggy snprintf()
Date: Thu, 12 Dec 2024 15:57:02 +0100
Message-ID: <20241212144256.838493267@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 328bda09cc91b3d93bc64f4a4dadc44313dd8140 ]

GCC 13 complains about the truncated output of snprintf():

drivers/mmc/host/mmc_spi.c: In function ‘mmc_spi_response_get’:
drivers/mmc/host/mmc_spi.c:227:64: error: ‘snprintf’ output may be truncated before the last format character [-Werror=format-truncation=]
  227 |         snprintf(tag, sizeof(tag), "  ... CMD%d response SPI_%s",
      |                                                                ^
drivers/mmc/host/mmc_spi.c:227:9: note: ‘snprintf’ output between 26 and 43 bytes into a destination of size 32
  227 |         snprintf(tag, sizeof(tag), "  ... CMD%d response SPI_%s",
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  228 |                 cmd->opcode, maptype(cmd));

Drop it and fold the string it generates into the only place where it's
emitted - the dev_dbg() call at the end of the function.

Fixes: 15a0580ced08 ("mmc_spi host driver")
Suggested-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://lore.kernel.org/r/20241008160134.69934-1-brgl@bgdev.pl
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mmc_spi.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index a1fb5d0e9553a..d85e5f7f5011d 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -230,10 +230,6 @@ static int mmc_spi_response_get(struct mmc_spi_host *host,
 	u8 	leftover = 0;
 	unsigned short rotator;
 	int 	i;
-	char	tag[32];
-
-	snprintf(tag, sizeof(tag), "  ... CMD%d response SPI_%s",
-		cmd->opcode, maptype(cmd));
 
 	/* Except for data block reads, the whole response will already
 	 * be stored in the scratch buffer.  It's somewhere after the
@@ -386,8 +382,9 @@ static int mmc_spi_response_get(struct mmc_spi_host *host,
 	}
 
 	if (value < 0)
-		dev_dbg(&host->spi->dev, "%s: resp %04x %08x\n",
-			tag, cmd->resp[0], cmd->resp[1]);
+		dev_dbg(&host->spi->dev,
+			"  ... CMD%d response SPI_%s: resp %04x %08x\n",
+			cmd->opcode, maptype(cmd), cmd->resp[0], cmd->resp[1]);
 
 	/* disable chipselect on errors and some success cases */
 	if (value >= 0 && cs_on)
-- 
2.43.0



