Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617C9522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F10C433C7;
	Sun,  9 Jul 2023 11:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902364;
	bh=QR7icJWg8kFVed04lTN7wMSBBqjWqg4mSdPgC278FkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=asGXxsghR4L5EkNMFyPgIoohVQAiNMcMRmwzTHUZORh507S8+UJO9FGIOwKfpaDIH
	 4rWlpUe9biBYW94wVGd7JECWdXlJuU+xcyZrJJatPTfX6CgqxF5vyqkwh+vXTG2305
	 Y7aVizFYlwFYAtwrj9M/JgHum+imUaAk6PjP6zqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Ryan Wanner <ryan.wanner@microchip.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 350/431] pinctrl: at91: fix a couple NULL vs IS_ERR() checks
Date: Sun,  9 Jul 2023 13:14:58 +0200
Message-ID: <20230709111459.372507955@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 35216718c9ac2aef934ea9cd229572d4996807b2 ]

The devm_kasprintf_strarray() function doesn't return NULL on error,
it returns error pointers.  Update the checks accordingly.

Fixes: f494c1913cbb ("pinctrl: at91: use devm_kasprintf() to avoid potential leaks (part 2)")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Ryan Wanner <ryan.wanner@microchip.com>
Link: https://lore.kernel.org/r/5697980e-f687-47a7-9db8-2af34ae464bd@kili.mountain
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-at91.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index e3664aafccef9..9184d457edf8d 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1399,8 +1399,8 @@ static int at91_pinctrl_probe(struct platform_device *pdev)
 		char **names;
 
 		names = devm_kasprintf_strarray(dev, "pio", MAX_NB_GPIO_PER_BANK);
-		if (!names)
-			return -ENOMEM;
+		if (IS_ERR(names))
+			return PTR_ERR(names);
 
 		for (j = 0; j < MAX_NB_GPIO_PER_BANK; j++, k++) {
 			char *name = names[j];
@@ -1860,8 +1860,8 @@ static int at91_gpio_probe(struct platform_device *pdev)
 	}
 
 	names = devm_kasprintf_strarray(dev, "pio", chip->ngpio);
-	if (!names)
-		return -ENOMEM;
+	if (IS_ERR(names))
+		return PTR_ERR(names);
 
 	for (i = 0; i < chip->ngpio; i++)
 		strreplace(names[i], '-', alias_idx + 'A');
-- 
2.39.2



