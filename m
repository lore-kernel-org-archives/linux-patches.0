Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBABF27732;
	Thu, 16 Jul 2026 14:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211714; cv=none; b=bFLU0bfNzdOCtdwrwOxXbVA2Oa6tFu0cUFgrtH2j7Db08Oowh0pYfzDeWnCj8xTMpOvxnDRHPzCDaO+DIsVM4EnQmIJ4jYFH1SYrEh8h8SOc4hWiYb126Dutmv7P7A8prnYgHevQbt6dqX9kNYM/CdDtmQIuDrva02orlR8KwSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211714; c=relaxed/simple;
	bh=6n2pnyll2+MN81k3XS7A/CxUAoxToIowlK0HqKwv2Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h8eYLnMXuVpUnem34gLNruzhjouQxCEc98rdpBE3uzHHmghyoXEJGs/MWjhU5uf6gryMkkYe7yJwYVQ5nF5EughYBQ89PhPYXtHjnQuBTiysQXCkDPaJ/1Y9P7z8OHsIIDr8uZ1VVrOUaSrlewrLJJ1TIfFrgJ2LEzYSEPOc/m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b8ezztf5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b8ezztf5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E00E1F00A3A;
	Thu, 16 Jul 2026 14:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211713;
	bh=lL73ez9ezlX9YET7wYXJvDFwmNTUP0ZJJ1qtGg3L/CQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b8ezztf5sAloPlp6epSVZL2AOxLsvA91XAY21c7WH4jmvZToSvGb6DjRp3+X9ErU5
	 vwI3kxPogYSauBIPawRobnBudNEHU0c5SbLGjEzhnoqHXpmWMXGllnfoA6uD05GEDb
	 JAqQKfZPPtQMs/G2bojdvmz4IeqsCXxtgXMSWRSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Scardovi <scardracs@disroot.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Heiko Stuebner <heiko.stuebner@cherry.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/349] gpio: rockchip: teardown bugs and resource leaks
Date: Thu, 16 Jul 2026 15:29:03 +0200
Message-ID: <20260716133033.500486001@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Scardovi <scardracs@disroot.org>

[ Upstream commit 9500077678230e36d22bf16d2b9539c13e59a801 ]

Address several teardown issues and resource leaks in the driver's remove
path and error handling:

1. Debounce clock reference leak: The debounce clock (bank->db_clk) is
   obtained using of_clk_get() which increments the clock's reference
   count, but clk_put() is never called. Register a devm action to
   cleanly release it on unbind. Note that of_clk_get(..., 1) remains
   necessary over devm_clk_get() because the DT binding does not define
   clock-names, precluding name-based lookup.

2. Unregistered chained IRQ handler: The chained IRQ handler is not
   disconnected in remove(). If a stray interrupt fires after the driver
   is removed, the kernel attempts to execute a stale handler, leading
   to a panic. Fix this by clearing the handler in remove().

3. IRQ domain leak: The linear IRQ domain and its generic chips are
   allocated manually during probe but never removed. Remove the IRQ
   domain during driver teardown to free the associated generic chips
   and mappings.

Fixes: 936ee2675eee ("gpio/rockchip: add driver for rockchip gpio")
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Marco Scardovi <scardracs@disroot.org>
Link: https://patch.msgid.link/20260526171050.12785-3-scardracs@disroot.org
[Bartosz: don't emit an error message on devres allocation failure]
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Heiko Stuebner <heiko.stuebner@cherry.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-rockchip.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-rockchip.c b/drivers/gpio/gpio-rockchip.c
index 16c1ec3a5d0e79..0a93c74933f08b 100644
--- a/drivers/gpio/gpio-rockchip.c
+++ b/drivers/gpio/gpio-rockchip.c
@@ -629,10 +629,17 @@ static int rockchip_gpiolib_register(struct rockchip_pin_bank *bank)
 	return ret;
 }
 
+static void rockchip_clk_put(void *data)
+{
+	struct clk *clk = data;
+
+	clk_put(clk);
+}
+
 static int rockchip_get_bank_data(struct rockchip_pin_bank *bank)
 {
 	struct resource res;
-	int id = 0;
+	int id = 0, ret;
 
 	if (of_address_to_resource(bank->of_node, 0, &res)) {
 		dev_err(bank->dev, "cannot find IO resource for bank\n");
@@ -663,6 +670,11 @@ static int rockchip_get_bank_data(struct rockchip_pin_bank *bank)
 			dev_err(bank->dev, "cannot find debounce clk\n");
 			return -EINVAL;
 		}
+
+		ret = devm_add_action_or_reset(bank->dev, rockchip_clk_put,
+					       bank->db_clk);
+		if (ret)
+			return ret;
 		break;
 	case GPIO_TYPE_V1:
 		bank->gpio_regs = &gpio_regs_v1;
@@ -779,6 +791,9 @@ static void rockchip_gpio_remove(struct platform_device *pdev)
 {
 	struct rockchip_pin_bank *bank = platform_get_drvdata(pdev);
 
+	irq_set_chained_handler_and_data(bank->irq, NULL, NULL);
+	if (bank->domain)
+		irq_domain_remove(bank->domain);
 	gpiochip_remove(&bank->gpio_chip);
 }
 
-- 
2.53.0



