Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD642F2D;
	Tue, 27 Feb 2024 13:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041280; cv=none; b=MrPJ/w5HEnm/5sI9L71CIQhSYnn9GEUd8RDLbVIOZNp1HraJ8p+CG1kH/Z5UV0HDtiiUkl2+xG2/1KGjx0cVKhmOvjNtja2/QGlfYz9NQ4sp0MbIFbaFQ0zluhokIHVRTP8WHWeRlENNttIlxZh/lnyykKaN6BAqtttfgpTAyHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041280; c=relaxed/simple;
	bh=aUP86XcTpfJ6eDEuJ2nzHTWkkJwyQdxw34v0wYb8LsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t19yiLjPrlPrwCuBTiw0+p71DB3/lMOEzR+86Mb0WYK45idm+4nNGKDH0gVKbVGxQ3OdwNGHisrgrhjBHct3II1GscQHyTzIvp0Ye8pwNBlAocktTcb5rwVcBtZYN7ss6+TRSW39wFVEp9KoSFtFV9iJeLwJ2uAUAjmzTlGaHj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FJayG2Dd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FJayG2Dd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE7DC433F1;
	Tue, 27 Feb 2024 13:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041280;
	bh=aUP86XcTpfJ6eDEuJ2nzHTWkkJwyQdxw34v0wYb8LsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FJayG2DdOiDe0jgDfdG8jMbm4ZRwettwVTG+wt4qVKaI5Jy9BPl2ASTOt/xHIpw5J
	 pQt8Ro6jiJyp3l/I4mTjzhpyMZIa8OBwwNUAmJKBMWm8h82PYJta/pk/LMBqk6IEeQ
	 4vOyClMUuwejgaDvWAPpfWPr8OtrC8dcUY4/U1vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Emil Renner Berthing <emil.renner.berthing@canonical.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 284/334] gpiolib: Handle no pin_ranges in gpiochip_generic_config()
Date: Tue, 27 Feb 2024 14:22:22 +0100
Message-ID: <20240227131640.158883113@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Renner Berthing <emil.renner.berthing@canonical.com>

[ Upstream commit ae366ba8576da0135d7d3db2dfa6304f3338d0c2 ]

Similar to gpiochip_generic_request() and gpiochip_generic_free() the
gpiochip_generic_config() function needs to handle the case where there
are no pinctrl pins mapped to the GPIOs, usually through the gpio-ranges
device tree property.

Commit f34fd6ee1be8 ("gpio: dwapb: Use generic request, free and
set_config") set the .set_config callback to gpiochip_generic_config()
in the dwapb GPIO driver so the GPIO API can set pinctrl configuration
for the corresponding pins. Most boards using the dwapb driver do not
set the gpio-ranges device tree property though, and in this case
gpiochip_generic_config() would return -EPROPE_DEFER rather than the
previous -ENOTSUPP return value. This in turn makes
gpio_set_config_with_argument_optional() fail and propagate the error to
any driver requesting GPIOs.

Fixes: 2956b5d94a76 ("pinctrl / gpio: Introduce .set_config() callback for GPIO chips")
Reported-by: Jisheng Zhang <jszhang@kernel.org>
Closes: https://lore.kernel.org/linux-gpio/ZdC_g3U4l0CJIWzh@xhacker/
Tested-by: Jisheng Zhang <jszhang@kernel.org>
Signed-off-by: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 95d2a7b2ea3e2..15de124d5b402 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2043,6 +2043,11 @@ EXPORT_SYMBOL_GPL(gpiochip_generic_free);
 int gpiochip_generic_config(struct gpio_chip *gc, unsigned int offset,
 			    unsigned long config)
 {
+#ifdef CONFIG_PINCTRL
+	if (list_empty(&gc->gpiodev->pin_ranges))
+		return -ENOTSUPP;
+#endif
+
 	return pinctrl_gpio_set_config(gc, offset, config);
 }
 EXPORT_SYMBOL_GPL(gpiochip_generic_config);
-- 
2.43.0



