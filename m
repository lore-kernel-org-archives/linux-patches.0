Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92361BE858;
	Tue,  2 Jul 2024 17:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941410; cv=none; b=SACT3rOlT3rZ9r3vxQSRCp6X6VmvL247aCpvRBDrtfbIeeOr5+2vJ+uuBeFYKgJ5Aum0Vh8Kqdcpa+F57ihBpu2w2Z0iGJDRiUWO2MZiP2n3JTIeMJSFZk/Jm7IhE5vAv6mE2rJmXqaG48QOH66Aqk2BXM3kSaTQHvf8iQK/W54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941410; c=relaxed/simple;
	bh=O/Nv8Y+V0YE6Rntv1ksEvGGpA6QRQTZdyJqRzw/hv1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RPfahGDf2la0H6HisKD9R7JE2tYcSFCiq6zELYiGpgfSfVWR6dzMw2BQwApHwk+TtnLaNIwBh4CXtTarJGfFaZvYvW2aVz8ZP55oiOukOrCRDJoB67452w1JXTteZzGu1HT9T4ivXxRvEr0EvAc9aFdPnPZAa+UifOwmxfhqM3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZ2tLpUG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZ2tLpUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C523C116B1;
	Tue,  2 Jul 2024 17:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941410;
	bh=O/Nv8Y+V0YE6Rntv1ksEvGGpA6QRQTZdyJqRzw/hv1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vZ2tLpUGAE7ymFXX0JVXgSPj4U5iWQRjzGxeafTB2LhTr4eT37c7htxgAYR1Ocetr
	 uyfmBv3Y6XyAzisuxk4Es+Uwb/NxGj23qoC+XLua3Ezdgc2YNy8AwlFcDaEWkiHpvO
	 Ahh4pP1vnyrLV+D4mnUuNvJmqDy8Kh0XeUpOUIMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/128] gpio: davinci: Validate the obtained number of IRQs
Date: Tue,  2 Jul 2024 19:04:16 +0200
Message-ID: <20240702170228.313047804@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 69f3d864f69d3..206829165fc58 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -230,6 +230,11 @@ static int davinci_gpio_probe(struct platform_device *pdev)
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



