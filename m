Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B734248176;
	Mon, 23 Jun 2025 13:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685147; cv=none; b=GjklZ1VTllhRZgLUu6YT1wKh9q9Rg0soceeYx43ArVJJLKPrlsNewG6xIcgfBE+qjAs/k820nezgzOjjtmr4CS+seEAetSNAZ52iHyZSMfYB3Hy8g3oZXROakM4+SDvecGNW7M6SPDl5luLVauleTedO/gDM/c7y1XxQHAz/I0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685147; c=relaxed/simple;
	bh=PY8TMAlqlYjKOfv28Xy1TJlcKztfrwtG8MvcqXdKtLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPvq9aaRVvSXI0SwaStibZRH5alwT6zq1dKHidfGlH9prYPrPbtDs6kLgVRJeH94bRXj1OawSqen6XNhseG4PrNztbk3tlD1fGKxWuI93WJywy5vqqy3hsFFSuUbKx5D+XlQGz+ZANy5wG4wMqbAIU132JNruWLiV2aHwOR9hLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jlF3dUeF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jlF3dUeF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15CCC4CEEA;
	Mon, 23 Jun 2025 13:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685147;
	bh=PY8TMAlqlYjKOfv28Xy1TJlcKztfrwtG8MvcqXdKtLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jlF3dUeFgeFXHezr6uxlFNcGvyVSpVK33KEe5j97DPwTd9ibsTebHlhI0oHPBNAR+
	 GRvf+rkZ2MXTW2nAV1//w0T2UAQCwmSwhrxv7Xo8ACLo43Wi3TM9um88Dhg+wc+9BV
	 Cb7Np7pQQwpW1c9DhusFFjXMWO7jrz8DUnlAW/qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 209/592] power: supply: gpio-charger: Fix wakeup source leaks on device unbind
Date: Mon, 23 Jun 2025 15:02:47 +0200
Message-ID: <20250623130705.259472579@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 51212ce95354c5b51e8c3054bf80eeeed80003b6 ]

Device can be unbound, so driver must also release memory for the wakeup
source.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250406202730.55096-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/gpio-charger.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/gpio-charger.c b/drivers/power/supply/gpio-charger.c
index 1dfd5b0cb30d8..1b2da9b5fb654 100644
--- a/drivers/power/supply/gpio-charger.c
+++ b/drivers/power/supply/gpio-charger.c
@@ -366,7 +366,9 @@ static int gpio_charger_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, gpio_charger);
 
-	device_init_wakeup(dev, 1);
+	ret = devm_device_init_wakeup(dev);
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to init wakeup\n");
 
 	return 0;
 }
-- 
2.39.5



