Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AFD1C07C2;
	Tue, 15 Oct 2024 12:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997017; cv=none; b=e+1hGcpAxZpAaoS8XgaAk0/hUoaOzw4rN9lgJ9J/OU6SgsDNJgdHNhDKxmhFqJVpUnWzWZRE8jOCom/yASq9IaJUDWvsF5k1IRfeiXGpD6nRacYGwLq5hVD3Fnv1H9qund2HPRHLHt9cISQvAITAGq+uznRJDcmFMgFr74P1pBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997017; c=relaxed/simple;
	bh=BBwwlLPGKuQQf8nB3I8AAhGE0VmZqfux/W4Vy50RigQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tL0fO19iZn3XZv0EVO7ZtP3RyrahhTGA5fl9vmPlDMw1272m5WWti5irAVXckdcwWdudhqpPsp/0gPodxXJMMOtQzf0I4AFsIwqBfav78LG8ORWuxkZRxbs58+WbAe4iBQAlJREm0DgZcPRl7eK1oxjbL4ygFYFHBcvoPHTzlAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eGX6fYEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eGX6fYEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18DE1C4CEC6;
	Tue, 15 Oct 2024 12:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997017;
	bh=BBwwlLPGKuQQf8nB3I8AAhGE0VmZqfux/W4Vy50RigQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGX6fYEj+bY/xtqRgN1kU0y8Gct1bBKkywi9JbihH/jfF2KE7OL7X/vAEbfqLAUWa
	 85XvHbax133Hso1GDKMhDpaL3pSdOmAwIjYaW0Uw0urz6ioqFKAvawEJWQDeFdHAjB
	 3Mz6jXoeL6IHtiF84oAmPpx3OJJZaXZsWewKlJRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Blocher <thomas.blocher@ek-dev.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/518] pinctrl: at91: make it work with current gpiolib
Date: Tue, 15 Oct 2024 14:38:56 +0200
Message-ID: <20241015123918.244232267@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

From: Thomas Blocher <thomas.blocher@ek-dev.de>

[ Upstream commit 752f387faaae0ae2e84d3f496922524785e77d60 ]

pinctrl-at91 currently does not support the gpio-groups devicetree
property and has no pin-range.
Because of this at91 gpios stopped working since patch
commit 2ab73c6d8323fa1e ("gpio: Support GPIO controllers without pin-ranges")
This was discussed in the patches
commit fc328a7d1fcce263 ("gpio: Revert regression in sysfs-gpio (gpiolib.c)")
commit 56e337f2cf132632 ("Revert "gpio: Revert regression in sysfs-gpio (gpiolib.c)"")

As a workaround manually set pin-range via gpiochip_add_pin_range() until
a) pinctrl-at91 is reworked to support devicetree gpio-groups
b) another solution as mentioned in
commit 56e337f2cf132632 ("Revert "gpio: Revert regression in sysfs-gpio (gpiolib.c)"")
is found

Signed-off-by: Thomas Blocher <thomas.blocher@ek-dev.de>
Link: https://lore.kernel.org/5b992862-355d-f0de-cd3d-ff99e67a4ff1@ek-dev.de
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-at91.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 52ecd47c18e2d..bb9348f14b1ba 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1401,8 +1401,11 @@ static int at91_pinctrl_probe(struct platform_device *pdev)
 
 	/* We will handle a range of GPIO pins */
 	for (i = 0; i < gpio_banks; i++)
-		if (gpio_chips[i])
+		if (gpio_chips[i]) {
 			pinctrl_add_gpio_range(info->pctl, &gpio_chips[i]->range);
+			gpiochip_add_pin_range(&gpio_chips[i]->chip, dev_name(info->pctl->dev), 0,
+				gpio_chips[i]->range.pin_base, gpio_chips[i]->range.npins);
+		}
 
 	dev_info(&pdev->dev, "initialized AT91 pinctrl driver\n");
 
-- 
2.43.0



