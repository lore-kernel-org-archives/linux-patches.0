Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F151E492;
	Tue,  8 Jul 2025 17:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994216; cv=none; b=I3LgKa0TD+Nt9GXgA3/O3bEk2HR7PHNUIOAOBEGRYaqEeNfZvEOd4ZHxc1KE1C3iEMQoVyBGP+sqovfEnZWbnQ+9klf8Yv2N77/pTFsKQ1bBrFkcNOh288SIQ95O813HOLY4UaURedbUIWJhv7xSwayKg9+4rqkDts1VPMluYKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994216; c=relaxed/simple;
	bh=H0zmU7rQ9uw8AsfWWUN6DJfoczRG1eT9zqWrHU1UA/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omGaKa+Onn1g7VH+2+9yN3L0jcyB0cmRpZwceMe4XQjwCA2GbAOWJ/JnAgOPwrZ+eLThHH+SuZ21MXkerSDEHo9G5TMz4yU0+y2EB/7UlySMs6f1mU92/dQj62p6dHfO/8w51xK+zU1i+M0zDBt8VLqhcxfTYuEVeY1D7IBW29c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=edALqzIm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="edALqzIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC15C4CEED;
	Tue,  8 Jul 2025 17:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994215;
	bh=H0zmU7rQ9uw8AsfWWUN6DJfoczRG1eT9zqWrHU1UA/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=edALqzImUwyXEqsYexVbupKgCyWlXKs1uW4qiDZpLZA6b1pZJSQ1aBVHD7xFYi4qQ
	 4UbNdQzSoBVVlX5CDSA50cYM20KBboN5edBfDibx5B/yfoR1rgc/3Ho1ASIgaOCdp7
	 MlnXDYX4H9cP+N+i3zmA7YuAX5dHKFSoIAOUNk70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/160] regulator: gpio: Fix the out-of-bounds access to drvdata::gpiods
Date: Tue,  8 Jul 2025 18:22:56 +0200
Message-ID: <20250708162235.220634643@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <mani@kernel.org>

[ Upstream commit c9764fd88bc744592b0604ccb6b6fc1a5f76b4e3 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/gpio-regulator.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 95e61a2f43f5d..b34671eb49b52 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -260,8 +260,10 @@ static int gpio_regulator_probe(struct platform_device *pdev)
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
@@ -274,8 +276,6 @@ static int gpio_regulator_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (!drvdata->gpiods)
-		return -ENOMEM;
 	for (i = 0; i < config->ngpios; i++) {
 		drvdata->gpiods[i] = devm_gpiod_get_index(dev,
 							  NULL,
-- 
2.39.5



