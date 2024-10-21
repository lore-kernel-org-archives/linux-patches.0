Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC8F1F427B;
	Mon, 21 Oct 2024 10:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507460; cv=none; b=BgBD6SwquIuR5iEqf8wSXnEcQTWfU3IFHApLJ9lSK+Kqrm5XUnJNR+qw69EMEvOjirpQHd94ZFDwXWffEsS07SdoP4xzxLQyaEFkO2S+WgYxTLyh8lCpDvSaPKm0axaUKh0mut5OG/YGGvuFrnz93vK8JKJyMvIVmqmBafzH91s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507460; c=relaxed/simple;
	bh=hZFqZQPabrfFsZTLWxHCR8YflLaZdtYnTk2/OsBunis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ktgQkq/rWuIJUFEwriUAlNI4/TgQWEO/Uwr7+zv/vdKFuF3Ro28bG8IE8y935D6C+RVkrzqU32q7SCicXdHPqmwWxF8XIMcbPqH7BxShaP+qBl2nvGPixbEXH229wArn5OIOEhhU5q61didLfoZZPiemukX1BThDes8hsAd+YC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hS+E6VeM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hS+E6VeM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1178C4CEC7;
	Mon, 21 Oct 2024 10:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507460;
	bh=hZFqZQPabrfFsZTLWxHCR8YflLaZdtYnTk2/OsBunis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hS+E6VeMkhYVcZzthsrH6qPzhzyf+RXTBg+cVINflPlSdfwCmgvG95SxXoo4hrhDR
	 iL+q5vIoRG/HzC+N18MRT8cAdRkmo4teyzAn+y7bvEHMnPK9n5GJZ6dz+i8hnZXZLn
	 6s9H8H4e6UMF6BGrMkSFiw8mIj7sQQMpmHXiiN9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.1 84/91] pinctrl: apple: check devm_kasprintf() returned value
Date: Mon, 21 Oct 2024 12:25:38 +0200
Message-ID: <20241021102253.091217788@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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

From: Ma Ke <make24@iscas.ac.cn>

commit 665a58fe663ac7a9ea618dc0b29881649324b116 upstream.

devm_kasprintf() can return a NULL pointer on failure but this returned
value is not checked. Fix this lack and check the returned value.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: a0f160ffcb83 ("pinctrl: add pinctrl/GPIO driver for Apple SoCs")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Reviewed-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/20240905020917.356534-1-make24@iscas.ac.cn
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-apple-gpio.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/pinctrl/pinctrl-apple-gpio.c
+++ b/drivers/pinctrl/pinctrl-apple-gpio.c
@@ -471,6 +471,9 @@ static int apple_gpio_pinctrl_probe(stru
 	for (i = 0; i < npins; i++) {
 		pins[i].number = i;
 		pins[i].name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "PIN%u", i);
+		if (!pins[i].name)
+			return -ENOMEM;
+
 		pins[i].drv_data = pctl;
 		pin_names[i] = pins[i].name;
 		pin_nums[i] = i;


