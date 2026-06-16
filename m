Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB2A3D45D0;
	Tue, 16 Jun 2026 18:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633187; cv=none; b=kvMj6tsUuZQIs2C1zbAngUUb62xwaR3VWWlSiQrAYVb+3xM23ZpzetDzuQ/JDtJ9qR2A7NSHphZJbiAnHo/Rj3y70jiYhoOnBdvJxHd7djHwVWIjwxzT1OyHTaJGXRyrF8yUZkpj4Lw+Vau4DgC+X/nBxwuEzvrgy+tQHuF2xK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633187; c=relaxed/simple;
	bh=iNzxiOy6nnn82X08Q91Q/J0eXEcTGdc/kwXatjKiads=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+KSA1CX4+uZyRLkMT/nME32RkfNv2viFoDUqxg1/bvQT8g8fiVHZJE6Sguxd7OfI4bIVDIpdQZi3REWofznCXjy+Ys9p23YEh4VbhpQ8AKAycQFq+Xkv58O4nwpEF3Vr8sS90W6BkXHUKY1dM/x81hSgM7nwgkL7ivb2ZDLYN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tezS9KXW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tezS9KXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32581F000E9;
	Tue, 16 Jun 2026 18:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633186;
	bh=Emz4QOHuUjuSejMLInnFeEWTr3EZ0Q9cdYyj9DYF78M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tezS9KXWyDgNg+MV2KGWY1Jbem8BqVX6j8kUzBsqf1Zc2+wdYDcQ4UDCTlM/J6a5w
	 sdyZo5w8GNhGoF8DKQRMDOIqLadonC1DH9TmaNQB7KAgzjm01ZIwOupOFuTtpD9rmu
	 EAogjIXILj1Y+Vod6DbK2w7F+cbB0Nwfdvpn97Yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Scardovi <scardracs@disroot.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/411] gpio: rockchip: convert bank->clk to devm_clk_get_enabled()
Date: Tue, 16 Jun 2026 20:24:31 +0530
Message-ID: <20260616145102.094673612@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Scardovi <scardracs@disroot.org>

[ Upstream commit 3e46c18d5d87f063a93ae0fe7662fbf6660459d5 ]

The bank->clk was previously obtained via of_clk_get() and manually
prepared/enabled. However, it was missing a corresponding clk_put() in
both the error paths and the remove function, leading to a reference leak.

Convert the allocation to devm_clk_get_enabled(), which also properly
propagates failures from clk_prepare_enable() that were previously ignored.

The GPIO bank device uses the same OF node as the previous of_clk_get()
call, so devm_clk_get_enabled(dev, NULL) correctly resolves the same
clock provider entry.

Fix the reference leak and simplify the code by removing the manual
clk_disable_unprepare() calls in the probe error paths and in the
remove function.

Fixes: 936ee2675eee ("gpio/rockchip: add driver for rockchip gpio")
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Marco Scardovi <scardracs@disroot.org>
Link: https://patch.msgid.link/20260526171050.12785-2-scardracs@disroot.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-rockchip.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-rockchip.c b/drivers/gpio/gpio-rockchip.c
index d331745da1a3a8..df2eefc1554a01 100644
--- a/drivers/gpio/gpio-rockchip.c
+++ b/drivers/gpio/gpio-rockchip.c
@@ -649,11 +649,10 @@ static int rockchip_get_bank_data(struct rockchip_pin_bank *bank)
 	if (!bank->irq)
 		return -EINVAL;
 
-	bank->clk = of_clk_get(bank->of_node, 0);
+	bank->clk = devm_clk_get_enabled(bank->dev, NULL);
 	if (IS_ERR(bank->clk))
 		return PTR_ERR(bank->clk);
 
-	clk_prepare_enable(bank->clk);
 	id = readl(bank->reg_base + gpio_regs_v2.version_id);
 
 	/* If not gpio v2, that is default to v1. */
@@ -663,7 +662,6 @@ static int rockchip_get_bank_data(struct rockchip_pin_bank *bank)
 		bank->db_clk = of_clk_get(bank->of_node, 1);
 		if (IS_ERR(bank->db_clk)) {
 			dev_err(bank->dev, "cannot find debounce clk\n");
-			clk_disable_unprepare(bank->clk);
 			return -EINVAL;
 		}
 	} else {
@@ -737,7 +735,6 @@ static int rockchip_gpio_probe(struct platform_device *pdev)
 
 	ret = rockchip_gpiolib_register(bank);
 	if (ret) {
-		clk_disable_unprepare(bank->clk);
 		mutex_unlock(&bank->deferred_lock);
 		return ret;
 	}
@@ -773,7 +770,6 @@ static int rockchip_gpio_remove(struct platform_device *pdev)
 {
 	struct rockchip_pin_bank *bank = platform_get_drvdata(pdev);
 
-	clk_disable_unprepare(bank->clk);
 	gpiochip_remove(&bank->gpio_chip);
 
 	return 0;
-- 
2.53.0



