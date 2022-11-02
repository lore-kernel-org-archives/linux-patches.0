Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1E37E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:47:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24461C433C1;
	Wed,  2 Nov 2022 02:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357234;
	bh=hf/2atxo370edgHm3wo67uB4OMbaDIQlNsv9U2J2My0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h2VKJdSuQzSdc5r5W5/CGtLCfpExkqRi0rox8p9XUBIxQF/uzeVi4eOh3Wj1C6Z9p
	 7vXDwUrzp7SBorav1JB+Y7bJQzqqzq5JN7WsKfAXAHcaVCr/XVgW1vNCK7B5Ps+xC0
	 LmqTyu5ZZe+NO55FTyPjzerTMItOsNmfC9GoOuVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robert.marko@sartura.hr>,
	luka.perkov@sartura.hr,
	Linus Walleij <linus.walleij@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 136/240] spi: qup: support using GPIO as chip select line
Date: Wed,  2 Nov 2022 03:31:51 +0100
Message-Id: <20221102022114.455716106@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Robert Marko <robert.marko@sartura.hr>

[ Upstream commit b40af6183b685b0cf7870987b858de0d48db9ea0 ]

Most of the device with QUP SPI adapter are actually using GPIO-s for
chip select.

However, this stopped working after ("spi: Retire legacy GPIO handling")
as it introduced a check on ->use_gpio_descriptors flag and since spi-qup
driver does not set the flag it meant that all of boards using GPIO-s and
with QUP adapter SPI devices stopped working.

So, to enable using GPIO-s again set ->use_gpio_descriptors to true and
populate ->max_native_cs.

Fixes: f48dc6b96649 ("spi: Retire legacy GPIO handling")
Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Cc: luka.perkov@sartura.hr
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20221006194819.1536932-1-robert.marko@sartura.hr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-qup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-qup.c b/drivers/spi/spi-qup.c
index 7d89510dc3f0..678dc51ef017 100644
--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -1057,6 +1057,8 @@ static int spi_qup_probe(struct platform_device *pdev)
 	else
 		master->num_chipselect = num_cs;
 
+	master->use_gpio_descriptors = true;
+	master->max_native_cs = SPI_NUM_CHIPSELECTS;
 	master->bus_num = pdev->id;
 	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH | SPI_LOOP;
 	master->bits_per_word_mask = SPI_BPW_RANGE_MASK(4, 32);
-- 
2.35.1



