Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DBE16DEAC;
	Wed,  3 Jul 2024 11:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005037; cv=none; b=oUYgMnLgchJr/qKxcMTgEUaX+W7fpS5GgsQhmqeEelnCtJtPq1xnexckbCB6B/oMoTJUDlIvN8Wr2DuC/MBW0ljPjABT/18E5ge4MoK2jSYsRD7BAot1ojm9jvHjmcYtV2spwMIjzeNAP6FfejCicmsQq0ji18F+Xy0v+sAtlt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005037; c=relaxed/simple;
	bh=uPjGE1XqOZB523C3woCWSNXAjaZ9rnA1TqZtXUf+wnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tIEEH7k9YPSDBO1ubUNyMNh9y5aouCR5TtTY6uMQ7uBGEFH/dSOv3j0JiNuomdDvG04oaJJEwxoOvii6+jh1jDoAPopUCyt4ydlp0dECWOpDC5RkGGReWHd843bZYCqVczY/3bpgkCzo6q8jsWMz0Ztj0knWQn8MFBVIEyqC/Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hhwSmfFf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hhwSmfFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D348C32781;
	Wed,  3 Jul 2024 11:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005036;
	bh=uPjGE1XqOZB523C3woCWSNXAjaZ9rnA1TqZtXUf+wnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hhwSmfFfXu/XzBcbKNyKOD9YcT++rCJanyYLYYATwuDQOVZQZCyiDMAmdxIGnrFhN
	 wIa416Cjga6h7JMbj/IfmXaT9u/NVJ365Tkb9QfnjUXJa0g60IUGK0ZXVuVASu0rAr
	 OE4Lrt9d7CrEMm6323ESjgfaRzNrbgt72UX6WGCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 240/290] gpio: davinci: Validate the obtained number of IRQs
Date: Wed,  3 Jul 2024 12:40:21 +0200
Message-ID: <20240703102913.216014443@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 80597e90de9c6..33623bcfc886c 100644
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



