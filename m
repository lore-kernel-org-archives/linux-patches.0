Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF99933262B;
	Mon, 20 Apr 2026 15:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700335; cv=none; b=RZ/Smf73xRu23QjY3Jmyac8YG4EpczxLXSM4zjcydlD5IHIVIlZNnFoxQ88r0tPRPeCpcYF9usNtnPlfpAt0DqyvweUNjEc5TsQXHYS0YlrYLj4rpl1jHSV8NlM9UO/PPB8FnTEyiANQCTr3e653ybEcDyfECqs2sDseSQg/AD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700335; c=relaxed/simple;
	bh=q/IdcCtYa0CHGURVPLGStW0v1ARcX2JlnURWG8Wr9LQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hpFyedsZ+VALWFmR48JpV2a95R5fdnUMK0hseDR2ggP/0fzhethSnHlknqXU3mMq+f7CVJ3dr86V63BHlLjGlj31Bh+RgX+33Vx86loxzRKjClWOQuRAmRZKesqunKFMTGZkDNcW/Iu/rQh2JpsJ3sI+8xAFUgCSNvEwhSsp6yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iiNDIzdq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iiNDIzdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466DAC19425;
	Mon, 20 Apr 2026 15:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700335;
	bh=q/IdcCtYa0CHGURVPLGStW0v1ARcX2JlnURWG8Wr9LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iiNDIzdq9A4EfAcjMn1Fd6t66ny84u6QLLtDzvKtMUQzllm8cv4V6D7mVTzghisvj
	 pqnF1Z8NRAe/XGgyeWaj5U+X0mygqN2Hhy4xU4sGYLm3MEJW/Ql+YMFIvHwjilUEPw
	 i8qhbsh/iNL3IPJxcQOb6S8BHnWy1oZXhAA4fPGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 132/220] gpio: tegra: fix irq_release_resources calling enable instead of disable
Date: Mon, 20 Apr 2026 17:41:13 +0200
Message-ID: <20260420153938.780582740@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>

[ Upstream commit 1561d96f5f55c1bca9ff047ace5813f4f244eea6 ]

tegra_gpio_irq_release_resources() erroneously calls tegra_gpio_enable()
instead of tegra_gpio_disable(). When IRQ resources are released, the
GPIO configuration bit (CNF) should be cleared to deconfigure the pin as
a GPIO. Leaving it enabled wastes power and can cause unexpected behavior
if the pin is later reused for an alternate function via pinctrl.

Fixes: 66fecef5bde0 ("gpio: tegra: Convert to gpio_irq_chip")
Signed-off-by: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Link: https://patch.msgid.link/20260407210247.1737938-1-samasth.norway.ananda@oracle.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-tegra.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index 15a5762a82c25..b14052fe64ac6 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -595,7 +595,7 @@ static void tegra_gpio_irq_release_resources(struct irq_data *d)
 	struct tegra_gpio_info *tgi = gpiochip_get_data(chip);
 
 	gpiochip_relres_irq(chip, d->hwirq);
-	tegra_gpio_enable(tgi, d->hwirq);
+	tegra_gpio_disable(tgi, d->hwirq);
 }
 
 static void tegra_gpio_irq_print_chip(struct irq_data *d, struct seq_file *s)
-- 
2.53.0



