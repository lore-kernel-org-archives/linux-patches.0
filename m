Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285F32D73A6;
	Sat, 17 Oct 2026 17:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257021; cv=none; b=gN6cA7qPTJz/+sA40Pom3pJyq+U4DW/h036BPwOQY4ypfipaWr68KBS+2ih/VaAkycwQZ1hLx2YhoAH05MhGVyWEo4DoPpEo9PR+Ut0tgiZuU0Ziic6o8UD3RiZ+N+lxfmyBpy4uawuR62fzcepYawo3P68bG0N55ytq48j79SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257021; c=relaxed/simple;
	bh=kvNuhjPRTUyXDkK6idn0sGVOIkh4Q61Vc0gMVPXW27o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ah6SMnDT3ufgOMEPgi5POLL+gJr5ypugebFvOez2CuaqAL4tdDSi2bYY1nFNQKyoRenMOU1OhyeIgyWTSlxZNf8p7ZQrc4SNtQ9JYaRdovnCY6/6k44vdFeUllcNTeLYSYAASY/lxktsWZmNpdW31Xp+vmxEQcqSZy3kds6zGAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zWOZBLnL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zWOZBLnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746B71F000C4;
	Sat, 17 Oct 2026 17:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257020;
	bh=Vsx/9bdILrMx9IuuoH1iAuIwMPkBebifR70glRHJyOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zWOZBLnLLLOQNfNDoAPHfWH0KIef/Wbp2tM6K8TYJJjtAh/LqKZsEjox+Wer7s3Ax
	 USkX8b92YwQhqRHfZfTw9dHPytlanydyPyMCM6zWdsYPOrSfy8tNIJCql2pD/cIFhD
	 jJEOtSndVNaaMhTQNOcz1XQhQLN9lsBsbuogYyUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Scardovi <scardracs@disroot.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0425/1674] gpio: rockchip: teardown bugs and resource leaks
Date: Sat, 17 Oct 2026 17:44:57 +0200
Message-ID: <20261017160442.037247852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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

[ Backport to 6.6.y: For 6.6.y, send with 1c1e0fc88d6e (CVE-2026-53226)
  so generic chips are explicitly removed before irq_domain_remove().
  6.1.y lacks irq_domain_remove_generic_chips(), so it needs a
  separately reviewed older generic-chip teardown backport. ]

Fixes: 936ee2675eee ("gpio/rockchip: add driver for rockchip gpio")
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Marco Scardovi <scardracs@disroot.org>
Link: https://patch.msgid.link/20260526171050.12785-3-scardracs@disroot.org
[Bartosz: don't emit an error message on devres allocation failure]
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-rockchip.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-rockchip.c b/drivers/gpio/gpio-rockchip.c
index ff9a4b8611d7f..e0e4f3ed5fdd4 100644
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
@@ -662,6 +669,11 @@ static int rockchip_get_bank_data(struct rockchip_pin_bank *bank)
 			dev_err(bank->dev, "cannot find debounce clk\n");
 			return -EINVAL;
 		}
+
+		ret = devm_add_action_or_reset(bank->dev, rockchip_clk_put,
+					       bank->db_clk);
+		if (ret)
+			return ret;
 	} else {
 		bank->gpio_regs = &gpio_regs_v1;
 		bank->gpio_type = GPIO_TYPE_V1;
@@ -773,6 +785,9 @@ static int rockchip_gpio_remove(struct platform_device *pdev)
 {
 	struct rockchip_pin_bank *bank = platform_get_drvdata(pdev);
 
+	irq_set_chained_handler_and_data(bank->irq, NULL, NULL);
+	if (bank->domain)
+		irq_domain_remove(bank->domain);
 	gpiochip_remove(&bank->gpio_chip);
 
 	return 0;
-- 
2.53.0



