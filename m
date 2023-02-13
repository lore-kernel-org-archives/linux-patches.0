Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FBDA8F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE64C433D2;
	Mon, 13 Feb 2023 14:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300129;
	bh=Cf+kS6qyabJJ1AWRmVjZ3oKIWUBHw+19t3mRXgokVys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NYlI3fj6wZowshporidqglSXN9oxP9B1vOAdh6mhBqaW97dZShUdYbUzCn9clV9gL
	 a8Iw6uwUbpi9p07tQjETDWproZBc7zy3Qq1UdaBgzkkx7Z3fiI/G1tkUsDb6m4LwAL
	 AMG8KqTyTyzhG6eDXUDaWwVgrtIZ+WGaUgUPUsEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Stanley <joel@jms.id.au>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/114] pinctrl: aspeed: Revert "Force to disable the functions signal"
Date: Mon, 13 Feb 2023 15:48:30 +0100
Message-Id: <20230213144746.075131018@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit 606d4ef4922662ded34aa7218288c3043ce0a41a ]

This reverts commit cf517fef601b9dde151f0afc27164d13bf1fd907.

The commit cf517fef601b ("pinctrl: aspeed: Force to disable the
function's signal") exposed a problem with fetching the regmap for
reading the GFX register.

The Romulus machine the device tree contains a gpio hog for GPIO S7.
With the patch applied:

  Muxing pin 151 for GPIO
  Disabling signal VPOB9 for VPO
  aspeed-g5-pinctrl 1e6e2080.pinctrl: Failed to acquire regmap for IP block 1
  aspeed-g5-pinctrl 1e6e2080.pinctrl: request() failed for pin 151

The code path is aspeed-gpio -> pinmux-g5 -> regmap -> clk, and the
of_clock code returns an error as it doesn't have a valid struct clk_hw
pointer. The regmap call happens because pinmux wants to check the GFX
node (IP block 1) to query bits there.

For reference, before the offending patch:

  Muxing pin 151 for GPIO
  Disabling signal VPOB9 for VPO
  Want SCU8C[0x00000080]=0x1, got 0x0 from 0x00000000
  Disabling signal VPOB9 for VPOOFF1
  Want SCU8C[0x00000080]=0x1, got 0x0 from 0x00000000
  Disabling signal VPOB9 for VPOOFF2
  Want SCU8C[0x00000080]=0x1, got 0x0 from 0x00000000
  Enabling signal GPIOS7 for GPIOS7
  Muxed pin 151 as GPIOS7
  gpio-943 (seq_cont): hogged as output/low

We can't skip the clock check to allow pinmux to proceed, because the
write to disable VPOB9 will try to set a bit in the GFX register space
which will not stick when the IP is in reset. However, we do not want to
enable the IP just so pinmux can do a disable-enable dance for the pin.

For now, revert the offending patch while a correct solution is found.

Fixes: cf517fef601b ("pinctrl: aspeed: Force to disable the function's signal")
Link: https://github.com/openbmc/linux/issues/218
Signed-off-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20230130220845.917985-1-joel@jms.id.au
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/aspeed/pinctrl-aspeed.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/aspeed/pinctrl-aspeed.c b/drivers/pinctrl/aspeed/pinctrl-aspeed.c
index f93d6959cee94..5a12fc7cf91fb 100644
--- a/drivers/pinctrl/aspeed/pinctrl-aspeed.c
+++ b/drivers/pinctrl/aspeed/pinctrl-aspeed.c
@@ -92,10 +92,19 @@ static int aspeed_sig_expr_enable(struct aspeed_pinmux_data *ctx,
 static int aspeed_sig_expr_disable(struct aspeed_pinmux_data *ctx,
 				   const struct aspeed_sig_expr *expr)
 {
+	int ret;
+
 	pr_debug("Disabling signal %s for %s\n", expr->signal,
 		 expr->function);
 
-	return aspeed_sig_expr_set(ctx, expr, false);
+	ret = aspeed_sig_expr_eval(ctx, expr, true);
+	if (ret < 0)
+		return ret;
+
+	if (ret)
+		return aspeed_sig_expr_set(ctx, expr, false);
+
+	return 0;
 }
 
 /**
-- 
2.39.0



