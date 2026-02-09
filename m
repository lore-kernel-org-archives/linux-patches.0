Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4F51AF0AF;
	Mon,  9 Feb 2026 14:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647694; cv=none; b=fHwcwK9OkpdFOVvxzXf7r7F3Z41lIdqk7mSF+L9BrYxI9oDlak1QiPSKOgrUf+HK8TX/A9P0mzxAjkgETJYYBTfacOAMINb3MTf2wCZ7KoahRChk7w4JeDCC0R0PWVaB+05gRfMd5C837MjLEdD0L6OEls25I2ZfNMIVDgJ/ors=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647694; c=relaxed/simple;
	bh=nN19ngKrNGuFupiqP8FepNs0HGA1iOwTRUfgsKMnuH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AEg5CxDJe/Utn52e8+07n2H1rRMCsxCc58Jbr3U7QVhZVVVIcWwsa3UX95DCyRYJT3OhMX1VnqYh56yev+Pa7IHpXwFTwHC7R7GbrweaTYTJ8PkvB/97+trdoN9+dteNgT9LpjVvO9NyoCAcU5kGvyqhy6P4omz9uheY4FUYTQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ls3BwKfl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ls3BwKfl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8D4C116C6;
	Mon,  9 Feb 2026 14:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647694;
	bh=nN19ngKrNGuFupiqP8FepNs0HGA1iOwTRUfgsKMnuH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ls3BwKflrq5iSy8eulsv3WVTmXvSXdvcI3I75/uWX1xpwIHth1wNCaickI7Fj1iJt
	 ExCDyUNzhrEhlHPz11kRMsez9svx7s8++SV9pzXJPz0DNShfLYIWj2ROhhunPnhGhZ
	 EVMbdk8a8MQAoVvLH3i6OhcX1Pgta5Syp5rdk7L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 162/175] gpio: loongson-64bit: Fix incorrect NULL check after devm_kcalloc()
Date: Mon,  9 Feb 2026 15:23:55 +0100
Message-ID: <20260209142326.317475202@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit e34f77b09080c86c929153e2a72da26b4f8947ff ]

Fix incorrect NULL check in loongson_gpio_init_irqchip().
The function checks chip->parent instead of chip->irq.parents.

Fixes: 03c146cb6cd1 ("gpio: loongson-64bit: Add support for Loongson-2K0300 SoC")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Link: https://patch.msgid.link/20260205072649.3271158-1-nichen@iscas.ac.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-loongson-64bit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-loongson-64bit.c b/drivers/gpio/gpio-loongson-64bit.c
index 82d4c3aa4d2fc..d5573fb0616ce 100644
--- a/drivers/gpio/gpio-loongson-64bit.c
+++ b/drivers/gpio/gpio-loongson-64bit.c
@@ -263,7 +263,7 @@ static int loongson_gpio_init_irqchip(struct platform_device *pdev,
 	chip->irq.num_parents = data->intr_num;
 	chip->irq.parents = devm_kcalloc(&pdev->dev, data->intr_num,
 					 sizeof(*chip->irq.parents), GFP_KERNEL);
-	if (!chip->parent)
+	if (!chip->irq.parents)
 		return -ENOMEM;
 
 	for (i = 0; i < data->intr_num; i++) {
-- 
2.51.0



