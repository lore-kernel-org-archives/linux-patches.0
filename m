Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F4D313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301048; cv=none; b=HNhjNBcsyvJ73wSGzNBx4PvpOISINhLMt+od0Sxv2F+Ly5tcbRhZp+H/LyVUqgG2KZFc30xIUTbP0T7PYbdVGUdJkR8TL55NwcGVfJiA2llvdd0sxTJQTA8nqnCvRJu89fR1IP+/Cy075OrFMPW1qHkoYNQKnS6dlm7ecwgIv60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301048; c=relaxed/simple;
	bh=PydTwEqeCbZg9HU66Qfhd+8E0cz2J+FcRHJw4mffmPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eVUvItIrTZ1rJCYaqde23YYzTf5cVespNwMZPTfD83KQavcqEMF3BsG7ezfvxnKER7UmzKYQLk+HTwYJrDG0+Ns30My6AZ/qs6R/SJkG+ha0FHDb+G+dvNKrvytFRRCk52Y0BK60eCxvFlAVqQJEx77TVee3fpfr5G99ZaIMfAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e/Mw6eQ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e/Mw6eQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C53C19425;
	Sat, 28 Feb 2026 17:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301047;
	bh=PydTwEqeCbZg9HU66Qfhd+8E0cz2J+FcRHJw4mffmPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/Mw6eQ/aOXQP7uW+vFpop3Ikm4zAow1s7BwJ2pjvo74ISFfckoyQ0kMOpULF306k
	 QRgoqmfYtuFvgj+VXUhie+Q3lRR8OU2eT674xYD7JUBwZXm0namSFHztJLJd8E0AKn
	 gy5AC1Asp67OMPJEpU8EM3KDMLUn75Ei+/av8Y9At+r85F7vFMgu7XIC1ws4yRdISb
	 dX/36MvDWtofEQ7zM88Ni+oX2cfAanwrcM4b6Jgf1a9ADdREMAFAkZm3f2BNG6xExU
	 O6XmbSj5lZduf0uQyZqolUoEjEc30khARI7H5PaHlhlHpBqBg3ke8foH09e8H2noaE
	 /VhOMrXGC1/nQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Billy Tsai <billy_tsai@aspeedtech.com>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 187/752] gpio: aspeed-sgpio: Change the macro to support deferred probe
Date: Sat, 28 Feb 2026 12:38:18 -0500
Message-ID: <20260228174750.1542406-187-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Billy Tsai <billy_tsai@aspeedtech.com>

[ Upstream commit e18533b023ec7a33488bcf33140ce69bbba2894f ]

Use module_platform_driver() to replace module_platform_driver_probe().
The former utilizes platform_driver_register(), which allows the driver to
defer probing when it doesn't acquire the necessary resources due to probe
order. In contrast, the latter uses __platform_driver_probe(), which
includes the comment "Note that this is incompatible with deferred
probing." Since our SGPIO driver requires access to the clock resource, the
former is more suitable.

Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Link: https://lore.kernel.org/r/20260123-upstream_sgpio-v2-1-69cfd1631400@aspeedtech.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-aspeed-sgpio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-aspeed-sgpio.c b/drivers/gpio/gpio-aspeed-sgpio.c
index 7622f9e9f54af..318cd0e397416 100644
--- a/drivers/gpio/gpio-aspeed-sgpio.c
+++ b/drivers/gpio/gpio-aspeed-sgpio.c
@@ -516,7 +516,7 @@ static const struct of_device_id aspeed_sgpio_of_table[] = {
 
 MODULE_DEVICE_TABLE(of, aspeed_sgpio_of_table);
 
-static int __init aspeed_sgpio_probe(struct platform_device *pdev)
+static int aspeed_sgpio_probe(struct platform_device *pdev)
 {
 	u32 nr_gpios, sgpio_freq, sgpio_clk_div, gpio_cnt_regval, pin_mask;
 	const struct aspeed_sgpio_pdata *pdata;
@@ -611,11 +611,12 @@ static int __init aspeed_sgpio_probe(struct platform_device *pdev)
 }
 
 static struct platform_driver aspeed_sgpio_driver = {
+	.probe = aspeed_sgpio_probe,
 	.driver = {
 		.name = KBUILD_MODNAME,
 		.of_match_table = aspeed_sgpio_of_table,
 	},
 };
 
-module_platform_driver_probe(aspeed_sgpio_driver, aspeed_sgpio_probe);
+module_platform_driver(aspeed_sgpio_driver);
 MODULE_DESCRIPTION("Aspeed Serial GPIO Driver");
-- 
2.51.0

