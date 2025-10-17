Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6EC337111;
	Fri, 17 Oct 2025 14:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713108; cv=none; b=udqKdBJbY9XGokno7dz7iIHkPiq+lNjIPX/E0uz00vPRKn5r5f1mh9eUAQ/SM+KFzIceUsJSv3NN37fWgNtIv3QHVvSmfJMc6P7oPPen69xsBh71/ZaMUfp/HNWGtGcevDvImGQSyMa7SHjjoeSVJ3dRX3Ku91Rvt5dl+tyd23w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713108; c=relaxed/simple;
	bh=HB0TSy8LxflJAEJkGM0PVMn6nFOOhHEKjkoERsq9oH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5EES9bPspiKZAli8Wp9IYF9ml+ZMLeMeBnPylwL3vB0n/3kQfdkrH58CwWYFbUodtlZgHr/+2lWPxMXitKzwFK3ft0q84ANFXqoh9FucOhTSZcE8tVXoyINbrIm816pBx0EwriCPhsfgvAELwqymQ2WkDfowBWUw2KxcH9sai8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTFsCHAF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTFsCHAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D9AC4CEE7;
	Fri, 17 Oct 2025 14:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713108;
	bh=HB0TSy8LxflJAEJkGM0PVMn6nFOOhHEKjkoERsq9oH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pTFsCHAFTlmMLgVgx0QUrvScnC/a4LbzGznkV7lK4cd76zqI6xA59GaUp/Y8K62aQ
	 7qjdWG8cuTDMMVQx/gLUOLibECW3HjwRR1Or9RQGnJjMrDGkLxk5VUdG9n51JHspgx
	 D09IPKWy3BbhdS5WtkuXOe0Z+cSSEIhv3xLsEd6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/168] gpio: wcd934x: mark the GPIO controller as sleeping
Date: Fri, 17 Oct 2025 16:52:08 +0200
Message-ID: <20251017145130.824029910@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit b5f8aa8d4bde0cf3e4595af5a536da337e5f1c78 ]

The slimbus regmap passed to the GPIO driver down from MFD does not use
fast_io. This means a mutex is used for locking and thus this GPIO chip
must not be used in atomic context. Change the can_sleep switch in
struct gpio_chip to true.

Fixes: 59c324683400 ("gpio: wcd934x: Add support to wcd934x gpio controller")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-wcd934x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-wcd934x.c b/drivers/gpio/gpio-wcd934x.c
index cbbbd105a5a7b..26d70ac90933c 100644
--- a/drivers/gpio/gpio-wcd934x.c
+++ b/drivers/gpio/gpio-wcd934x.c
@@ -101,7 +101,7 @@ static int wcd_gpio_probe(struct platform_device *pdev)
 	chip->base = -1;
 	chip->ngpio = WCD934X_NPINS;
 	chip->label = dev_name(dev);
-	chip->can_sleep = false;
+	chip->can_sleep = true;
 
 	return devm_gpiochip_add_data(dev, chip, data);
 }
-- 
2.51.0



