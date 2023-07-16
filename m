Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD078F75
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:15:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B848C433C8;
	Sun, 16 Jul 2023 20:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538520;
	bh=dskl49KNdcROIMUASvDn5WXYgXotbxB2GMpnCHk+xCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OuIOCu+dDuGVPCwOmU0WczxCQhW1NiUtqV8APsC7FLkh5FwWk7aePJnkcJ21IrtmY
	 LNX/uCo+NgCEaDLoXaNFp4KSFvLlLW/KvIv4C/mBc+nSkJgV+aGRSSWmgOm8/RYgXE
	 6AFoF8+FmPztQ2rxaQi4S+2Sa7a6yR4Ie3I9eNd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 480/800] pinctrl: at91-pio4: check return value of devm_kasprintf()
Date: Sun, 16 Jul 2023 21:45:33 +0200
Message-ID: <20230716195000.227331604@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit f6fd5d4ff8ca0b24cee1af4130bcb1fa96b61aa0 ]

devm_kasprintf() returns a pointer to dynamically allocated memory.
Pointer could be NULL in case allocation fails. Check pointer validity.
Identified with coccinelle (kmerr.cocci script).

Fixes: 776180848b57 ("pinctrl: introduce driver for Atmel PIO4 controller")
Depends-on: 1c4e5c470a56 ("pinctrl: at91: use devm_kasprintf() to avoid potential leaks")
Depends-on: 5a8f9cf269e8 ("pinctrl: at91-pio4: use proper format specifier for unsigned int")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230615105333.585304-4-claudiu.beznea@microchip.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-at91-pio4.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-at91-pio4.c b/drivers/pinctrl/pinctrl-at91-pio4.c
index 2fe40acb6a3e5..98c2122817264 100644
--- a/drivers/pinctrl/pinctrl-at91-pio4.c
+++ b/drivers/pinctrl/pinctrl-at91-pio4.c
@@ -1146,6 +1146,8 @@ static int atmel_pinctrl_probe(struct platform_device *pdev)
 		/* Pin naming convention: P(bank_name)(bank_pin_number). */
 		pin_desc[i].name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "P%c%u",
 						  bank + 'A', line);
+		if (!pin_desc[i].name)
+			return -ENOMEM;
 
 		group->name = group_names[i] = pin_desc[i].name;
 		group->pin = pin_desc[i].number;
-- 
2.39.2



