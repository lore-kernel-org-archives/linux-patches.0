Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E252F37;
	Tue,  8 Jul 2025 16:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993296; cv=none; b=OMhKTH5liSHzEZOWXPh4GVifvmMz3Lcq6D7PiPVFJ40ujHER/CqsoOiDeehWBn78pz+zvztpR8fVlStG8jqY1YmOBc4IIvhoBxDxTiE7EkHUHhzQK+xyFyaLFIrYtlXF4JDmGOIFNBjLhsMFUSNSKESvOjzuFSlAQkUC083ViVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993296; c=relaxed/simple;
	bh=O6dOEoEvuNjW0kIm/1feDwMhy80ZXV3fJyig6Dt7/9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bh6Be8dXdicABAd1Gv68UlJJ/asLOt1YrSB1MbsGgs/aLXEmUgSEGHRxnnNMJ0ksPUj9Udb25xNDpSlvb/8ufrNBFU65f4JkwCMRATLD/4A/2KHjf0cKiWdR386fqLMfzFPmqv5SR+LrO0qqwVOrEur+psQT5aQaIUYrF2YYvyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=snQual+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="snQual+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5D0C4CEED;
	Tue,  8 Jul 2025 16:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993296;
	bh=O6dOEoEvuNjW0kIm/1feDwMhy80ZXV3fJyig6Dt7/9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=snQual+YIjfS1k48j30fxN7ujB7CRb2/t4b4GIAHCLwCwg06UAgZEV5Yf1tmWxWh/
	 uapKsV1n+zV/Y/495E+SRR09ecWKu9j9HTC7Jwn/iERHq8JFSz33zwzvb22cqSfxBB
	 OC7+qe9v51l3K4F5S6tlHAnK3iasi6roP1dmMeb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.15 025/178] regulator: gpio: Fix the out-of-bounds access to drvdata::gpiods
Date: Tue,  8 Jul 2025 18:21:02 +0200
Message-ID: <20250708162237.205884546@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <mani@kernel.org>

commit c9764fd88bc744592b0604ccb6b6fc1a5f76b4e3 upstream.

drvdata::gpiods is supposed to hold an array of 'gpio_desc' pointers. But
the memory is allocated for only one pointer. This will lead to
out-of-bounds access later in the code if 'config::ngpios' is > 1. So
fix the code to allocate enough memory to hold 'config::ngpios' of GPIO
descriptors.

While at it, also move the check for memory allocation failure to be below
the allocation to make it more readable.

Cc: stable@vger.kernel.org # 5.0
Fixes: d6cd33ad7102 ("regulator: gpio: Convert to use descriptors")
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20250703103549.16558-1-mani@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/gpio-regulator.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -260,8 +260,10 @@ static int gpio_regulator_probe(struct p
 		return -ENOMEM;
 	}
 
-	drvdata->gpiods = devm_kzalloc(dev, sizeof(struct gpio_desc *),
-				       GFP_KERNEL);
+	drvdata->gpiods = devm_kcalloc(dev, config->ngpios,
+				       sizeof(struct gpio_desc *), GFP_KERNEL);
+	if (!drvdata->gpiods)
+		return -ENOMEM;
 
 	if (config->input_supply) {
 		drvdata->desc.supply_name = devm_kstrdup(&pdev->dev,
@@ -274,8 +276,6 @@ static int gpio_regulator_probe(struct p
 		}
 	}
 
-	if (!drvdata->gpiods)
-		return -ENOMEM;
 	for (i = 0; i < config->ngpios; i++) {
 		drvdata->gpiods[i] = devm_gpiod_get_index(dev,
 							  NULL,


