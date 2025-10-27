Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A974C246BB7;
	Mon, 27 Oct 2025 18:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591252; cv=none; b=WmHatrgUx7BBpu9jMUksjD9v6M8ebQMBeAdjpYWS3VfxRGFEcr6/wpvbhj6dDrUMzt2esaWbwmnmvMRychRftG9PKMNUv3pKLN1IhSCE8Co5KD17qFIhxw2Xh78onyUwsOPGMLPGYz5cnMWelM0B+Yu+pMpF5ZPx8gEooY3KXKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591252; c=relaxed/simple;
	bh=qDhBSHD+8GfOjzxYNE9MOafgv9TQZ83kJPkrAXsbDJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0JzBfLsk9At1bpGPfaJRDDW6y843fRCzTSZ4p9c74xL5LYcBoa/AdeBaC8BroU8repq3CofzEmtSrJUXjFGZg9k80O5aCgKgrNQqn+p15nIHUeKULeysCJfKcDVo5GAD/ZdCW7q5npIwDcpg2asr9bcBG1xnei/1U7ULEUw+8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JnGVxWbT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JnGVxWbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359EFC4CEF1;
	Mon, 27 Oct 2025 18:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591252;
	bh=qDhBSHD+8GfOjzxYNE9MOafgv9TQZ83kJPkrAXsbDJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JnGVxWbT2wNjHcb6QFdrwqjaz/dx9oF5VHYc8Ge3a9jI9Iw/muMJ4uGRV8vStVchc
	 vBprDwz4/BrRMp+MhsvnsqqfEKouwTFu3pGIYycAtgWH/10Q9rC2Yapph/WEZPex8r
	 aKVRC2qdUApDJTOcwW1zWtM8v70JQPP4++TQ1mwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 126/332] gpio: wcd934x: mark the GPIO controller as sleeping
Date: Mon, 27 Oct 2025 19:32:59 +0100
Message-ID: <20251027183527.938731851@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



