Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2581F756A;
	Tue,  3 Dec 2024 15:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238082; cv=none; b=U0m/b/si+5E2iRDvvly5QMHSGTlg2jI6EOXfrzEMd3/ptj2v2GtGDESMHF1J6nWsT5tK7XByGIDnP/pBLxxtUrhTOUxDa4qsT/1GpgGThyRtD1/UxrR25yrijiHGNRbX+XMo5kQap+m0KPCJ3M12opUQsr6LaP/qi+EjE6Vg+5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238082; c=relaxed/simple;
	bh=TsNEIb71hasoJ8qLTfy4rYiUBZf2SSh4R5P1IzM+MY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p1s1ynaYF8kTn08zKYPPfWE52/7wRvvvLe1Lr5TAr59BWd4wP4J3riRw80lxnxjmZM1C/PbQGgkkUKTP5jm5DB3xA78csSUIWgyMWq16e3mtCzT2Pq6JRIi3ROveeiqTGIxgY6EfxZCWTFIBrF/4f2595nvR1mBmxfnSJW7NDFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjhXy65Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjhXy65Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B8BC4CECF;
	Tue,  3 Dec 2024 15:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238082;
	bh=TsNEIb71hasoJ8qLTfy4rYiUBZf2SSh4R5P1IzM+MY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjhXy65YAhhP0kMJcCgsslugyWy1VSSOF7RVnbqkDuUz5E+hcazmQiBeLABdG7JvU
	 BKl/D3C5KgRP+8wgiiGr7L83pgaWRtg+xEoFMJj1Q9gcaslKmZ12931xj1Fn6Hlngn
	 wFH60GHI1IyaWAtbgVSS9xORKwKxwVs7Kl081648=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 155/817] mmc: mmc_spi: drop buggy snprintf()
Date: Tue,  3 Dec 2024 15:35:27 +0100
Message-ID: <20241203144001.776463799@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index c9caa1ece7ef9..5a19d3e949134 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -222,10 +222,6 @@ static int mmc_spi_response_get(struct mmc_spi_host *host,
 	u8 	leftover = 0;
 	unsigned short rotator;
 	int 	i;
-	char	tag[32];
-
-	snprintf(tag, sizeof(tag), "  ... CMD%d response SPI_%s",
-		cmd->opcode, maptype(cmd));
 
 	/* Except for data block reads, the whole response will already
 	 * be stored in the scratch buffer.  It's somewhere after the
@@ -378,8 +374,9 @@ static int mmc_spi_response_get(struct mmc_spi_host *host,
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



