Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9150E183CA4;
	Sun,  1 Sep 2024 16:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207963; cv=none; b=gsbi8H/zGiWr2ae1vkQ5kI3ZpriHwjRPypUJipHZ20vtr6JXg9aJYEfaPYEq3h84x8c6WjZ229NxF9Kdc+CyfopKKDR1WxIgHna7vJz9A2UvCufd0RN+6xIbzocyn2LqZrFfAj88Cn94OYldXfQDpxw6M5HLmFcRwxhsrxUPgYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207963; c=relaxed/simple;
	bh=lQQy1IJFj3S0K/2qIn0Re+XEQF9vZnX0aiPNE6EgDKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dk6mW6EZDAg4hdPOvRYV1GqZ7ydBDqLRpevr3oChCxHdxeXnuU5QBDua7jinwLf0RKcYh0RO9jQppNwCHaooO5S2DKpcEsqgCZonfjatApu2H4IcxcsQZU5tnT7yjTJtRVAWgmuvKyC3FtqJuLzDdOrrzpW533Fr9IDHqRa7y6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLETJTbU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLETJTbU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F54C4CEC3;
	Sun,  1 Sep 2024 16:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207963;
	bh=lQQy1IJFj3S0K/2qIn0Re+XEQF9vZnX0aiPNE6EgDKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XLETJTbUP/gvgpNi1J9eS9Zhl6Xle2bUPSKfmIFPFsdRKuJNWiTS9pOHWaQefOfDC
	 DT7YIXeDcj7VAflRUq85ch/uA9E2vevAkfZmhet7p+DMWN5k/GvRulFAxLOC83JKek
	 9G/aHpDFsoBuDM+gs6JQTt13GaT7JZxezImkTEaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Kojedzinszky <richard@kojedz.in>,
	Huang-Huang Bao <i@eh5.me>,
	Heiko Stuebner <heiko@sntech.de>,
	Daniel Golle <daniel@makrotopia.org>,
	Trevor Woerner <twoerner@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.6 06/93] pinctrl: rockchip: correct RK3328 iomux width flag for GPIO2-B pins
Date: Sun,  1 Sep 2024 18:15:53 +0200
Message-ID: <20240901160807.596122419@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huang-Huang Bao <i@eh5.me>

commit 128f71fe014fc91efa1407ce549f94a9a9f1072c upstream.

The base iomux offsets for each GPIO pin line are accumulatively
calculated based off iomux width flag in rockchip_pinctrl_get_soc_data.
If the iomux width flag is one of IOMUX_WIDTH_4BIT, IOMUX_WIDTH_3BIT or
IOMUX_WIDTH_2BIT, the base offset for next pin line would increase by 8
bytes, otherwise it would increase by 4 bytes.

Despite most of GPIO2-B iomux have 2-bit data width, which can be fit
into 4 bytes space with write mask, it actually take 8 bytes width for
whole GPIO2-B line.

Commit e8448a6c817c ("pinctrl: rockchip: fix pinmux bits for RK3328
GPIO2-B pins") wrongly set iomux width flag to 0, causing all base
iomux offset for line after GPIO2-B to be calculated wrong. Fix the
iomux width flag to IOMUX_WIDTH_2BIT so the offset after GPIO2-B is
correctly increased by 8, matching the actual width of GPIO2-B iomux.

Fixes: e8448a6c817c ("pinctrl: rockchip: fix pinmux bits for RK3328 GPIO2-B pins")
Cc: stable@vger.kernel.org
Reported-by: Richard Kojedzinszky <richard@kojedz.in>
Closes: https://lore.kernel.org/linux-rockchip/4f29b743202397d60edfb3c725537415@kojedz.in/
Tested-by: Richard Kojedzinszky <richard@kojedz.in>
Signed-off-by: Huang-Huang Bao <i@eh5.me>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Tested-by: Daniel Golle <daniel@makrotopia.org>
Tested-by: Trevor Woerner <twoerner@gmail.com>
Link: https://lore.kernel.org/20240709105428.1176375-1-i@eh5.me
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-rockchip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -3802,7 +3802,7 @@ static struct rockchip_pin_bank rk3328_p
 	PIN_BANK_IOMUX_FLAGS(0, 32, "gpio0", 0, 0, 0, 0),
 	PIN_BANK_IOMUX_FLAGS(1, 32, "gpio1", 0, 0, 0, 0),
 	PIN_BANK_IOMUX_FLAGS(2, 32, "gpio2", 0,
-			     0,
+			     IOMUX_WIDTH_2BIT,
 			     IOMUX_WIDTH_3BIT,
 			     0),
 	PIN_BANK_IOMUX_FLAGS(3, 32, "gpio3",


