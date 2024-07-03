Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC8417DA00;
	Wed,  3 Jul 2024 11:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006100; cv=none; b=AmQKFkFhRthhuzNxGWHcHQQuauo3lWPDAe2N9iFt3bh1Hulq802r2y+MTIrGruL5h8mhhb9+HTOdyZc1fp0SzE503TQokhBkkCd1Yh3i2SlqJNmf297nB+0/1EihTmJA9UAJCflU6bOfxQVXkgVqvwpMi8nRoZmqAbpKDZFxwA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006100; c=relaxed/simple;
	bh=P/qE57xplTWF/zlc54+Gq8pw9pUtxzXakf3Cr208N/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0UQ1J3aztgS5sFVn6UlMAnVA1kA+f2S4Wgdag+heDM4YeXCc9IEcNbu6Ja/Ckxa/qRvAMwbRtx9Ms1BWw45Q1fERkMBWVK0SRX4pICXVv2ofbBmpdCGJDlcX5phvFgwfSSgp4KYh4EW2eQ+OAN02m05C0IuQXcyjADNJvGO0NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EMdJAST6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EMdJAST6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632C4C2BD10;
	Wed,  3 Jul 2024 11:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006099;
	bh=P/qE57xplTWF/zlc54+Gq8pw9pUtxzXakf3Cr208N/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EMdJAST6ag+wYCrjhcRSC2C9Maeacd8DkY/+LxQcR2EKXwQuSJY9kVJzUoWs58ygS
	 PwP/bZvjHU8Eavzy8/JIKaQ+F+9iHh2oNQ2CSCCmCi3GRfC9w5lJFeomepyOh4FKOC
	 lWzDY7ieiDrOt6suLQqKQ3RfvbCqrarxQhyYAVWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 300/356] gpio: davinci: Validate the obtained number of IRQs
Date: Wed,  3 Jul 2024 12:40:36 +0200
Message-ID: <20240703102924.463503262@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit 7aa9b96e9a73e4ec1771492d0527bd5fc5ef9164 ]

Value of pdata->gpio_unbanked is taken from Device Tree. In case of broken
DT due to any error this value can be any. Without this value validation
there can be out of chips->irqs array boundaries access in
davinci_gpio_probe().

Validate the obtained nirq value so that it won't exceed the maximum
number of IRQs per bank.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: eb3744a2dd01 ("gpio: davinci: Do not assume continuous IRQ numbering")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Link: https://lore.kernel.org/r/20240618144344.16943-1-amishin@t-argos.ru
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-davinci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index 0214244e9f01f..d691e2ed88a08 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -227,6 +227,11 @@ static int davinci_gpio_probe(struct platform_device *pdev)
 	else
 		nirq = DIV_ROUND_UP(ngpio, 16);
 
+	if (nirq > MAX_INT_PER_BANK) {
+		dev_err(dev, "Too many IRQs!\n");
+		return -EINVAL;
+	}
+
 	chips = devm_kzalloc(dev, sizeof(*chips), GFP_KERNEL);
 	if (!chips)
 		return -ENOMEM;
-- 
2.43.0



