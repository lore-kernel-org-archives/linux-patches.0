Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6396AAC
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C587C433C8;
	Sun, 17 Sep 2023 20:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982287;
	bh=SOuD8+8HltxNpybI94VBXJD4zGYas+uldGbmjUUeAOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kZA3uROpkl8q0ABrRfCDKiE5lQia2gthju2wYdjsUAItGDWuQGlICsd5Sf483KHhP
	 x5B2ARyuTEHzW4+QcA/EcYepHorRehpQVcb04jmBvkj1HNR34XZFYB17D4Cme7Q+WO
	 /C7bxdCXiDwNO3SLcL0laGIkz6gUhkheDI02ieJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 206/511] pinctrl: mcp23s08: check return value of devm_kasprintf()
Date: Sun, 17 Sep 2023 21:10:33 +0200
Message-ID: <20230917191118.797600155@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit f941714a7c7698eadb59bc27d34d6d6f38982705 ]

devm_kasprintf() returns a pointer to dynamically allocated memory.
Pointer could be NULL in case allocation fails. Check pointer validity.
Identified with coccinelle (kmerr.cocci script).

Fixes: 0f04a81784fe ("pinctrl: mcp23s08: Split to three parts: core, I²C, SPI")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230621100409.1608395-1-claudiu.beznea@microchip.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-mcp23s08_spi.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-mcp23s08_spi.c b/drivers/pinctrl/pinctrl-mcp23s08_spi.c
index 9ae10318f6f35..ea059b9c5542e 100644
--- a/drivers/pinctrl/pinctrl-mcp23s08_spi.c
+++ b/drivers/pinctrl/pinctrl-mcp23s08_spi.c
@@ -91,18 +91,28 @@ static int mcp23s08_spi_regmap_init(struct mcp23s08 *mcp, struct device *dev,
 		mcp->reg_shift = 0;
 		mcp->chip.ngpio = 8;
 		mcp->chip.label = devm_kasprintf(dev, GFP_KERNEL, "mcp23s08.%d", addr);
+		if (!mcp->chip.label)
+			return -ENOMEM;
 
 		config = &mcp23x08_regmap;
 		name = devm_kasprintf(dev, GFP_KERNEL, "%d", addr);
+		if (!name)
+			return -ENOMEM;
+
 		break;
 
 	case MCP_TYPE_S17:
 		mcp->reg_shift = 1;
 		mcp->chip.ngpio = 16;
 		mcp->chip.label = devm_kasprintf(dev, GFP_KERNEL, "mcp23s17.%d", addr);
+		if (!mcp->chip.label)
+			return -ENOMEM;
 
 		config = &mcp23x17_regmap;
 		name = devm_kasprintf(dev, GFP_KERNEL, "%d", addr);
+		if (!name)
+			return -ENOMEM;
+
 		break;
 
 	case MCP_TYPE_S18:
-- 
2.40.1



