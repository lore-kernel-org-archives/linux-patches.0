Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7751519AA;
	Wed,  5 Feb 2025 14:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764347; cv=none; b=M1lD6C7cmGbGmHxwQS5EXgFxqLXzpcZJjO691SFBpJKsrYDObvSH/W8AaklhnY45bJZt2xmp+6jEhFzdgnSh6z1oOnqT7ed0yQOpSt8al3hiVELy2z4ObuM9KkKaU4Gd+tftim8/oYuqKg3rWn5o4qHIO3s6BEJtbTraafT5Ibw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764347; c=relaxed/simple;
	bh=4MfPcgXTTLytakOe74T573WkcoZRE7/ptajrrWaMIwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nksLMYExIChs7vgU+KXoKOJBawBGePK/ZBNuo9Gyxh6lu1LzGOcKlbTODtANtJFYeP+gSN9FGy+nai6CIMx4FoLGkddPeHnODDc1zf0KtQ/hY0ZhgTMYgVJmiZG9xChewwBRiYtyJ8PN7xQaXvgSfujCDxVDR3VNRg5GbjUTFSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iBt6QTj7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iBt6QTj7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D3AC4CED1;
	Wed,  5 Feb 2025 14:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764347;
	bh=4MfPcgXTTLytakOe74T573WkcoZRE7/ptajrrWaMIwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iBt6QTj77wC4Dm+XLYUnrbUKRhiF8O1cjZBpEFrT8Bej+mNzDuCN1eTSF/jMe2RgP
	 ATTZ2Unm9DmOCZvsETkrBS7C7seLZFGitPFhF8E/jS1WqULDsTd8RMJERUxf6j1ktS
	 kvDkOkTdduPxSWgYttA2H1xTgA7Ukvnqpo9QWrZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 115/590] gpio: pca953x: log an error when failing to get the reset GPIO
Date: Wed,  5 Feb 2025 14:37:50 +0100
Message-ID: <20250205134459.657837485@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

[ Upstream commit 7cef813a91c468253c80633891393478b9f2c966 ]

When the dirver fails getting this GPIO, it fails silently. Log an error
message to make debugging a lot easier by just reading dmesg.

Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Fixes: 054ccdef8b28 ("gpio: pca953x: Add optional reset gpio control")
Link: https://lore.kernel.org/r/20241219-pca953x-log-no-reset-gpio-v1-1-9aa7bcc45ead@bootlin.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 3f2d33ee20cca..e49802f26e07f 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -1088,7 +1088,8 @@ static int pca953x_probe(struct i2c_client *client)
 		 */
 		reset_gpio = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_LOW);
 		if (IS_ERR(reset_gpio))
-			return PTR_ERR(reset_gpio);
+			return dev_err_probe(dev, PTR_ERR(reset_gpio),
+					     "Failed to get reset gpio\n");
 	}
 
 	chip->client = client;
-- 
2.39.5



