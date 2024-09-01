Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782FA3BB59;
	Sun,  1 Sep 2024 17:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210501; cv=none; b=JgiJqvAjB9La4vRYI30+4GffT1ztwLATvFTr8/Sz82+Ecl65Rpc90iHsV+SD3EebW0FQL6zJVwHTqT+oCzbfq8MA1u/W4H5TZu9e9ZvdrACMMP9dW+DvbAqPrCouWNlZvvWsVXQrR7sxbb4OpOSfPLNXbMuhzMv01k/heL4P+Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210501; c=relaxed/simple;
	bh=Fuaa3yKALtg2CHJh91rs2oS2IcUylI/3QGahoFGGk44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkC5UBmzXnnPBnJyc5Q0QJ+utOFMAMYh2r/HGhAiMfumrthBHeA49XuDke1Hfm87WvzB7CazDyY0tBRiqm/238irMa4SBt8bZD5+ToVHGQXsfJkdo7Au+m2JdkR7FYCEaHr9vAkfRWvs3QBiJzKqook1GPLExqU/qbEaUOPO8J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zoDl8rTu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zoDl8rTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96218C4CEC3;
	Sun,  1 Sep 2024 17:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210501;
	bh=Fuaa3yKALtg2CHJh91rs2oS2IcUylI/3QGahoFGGk44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zoDl8rTubsIRwQDSTnkCd/dazz9MrN1RDnPzZK6RIXLqMoQU8IXr8A0ve/LkEfq5s
	 pnbzxNyKyLoYTAJN3J+bnyVnSfT6GJ+Wx2UeyoHVIJZX4/e4pj9cmAepXC/r7g3jH2
	 0huriiQ/OVCNEM/r9F1QRK8sVvhA9CSCFyF1MwHg=
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
Subject: [PATCH 5.15 177/215] pinctrl: rockchip: correct RK3328 iomux width flag for GPIO2-B pins
Date: Sun,  1 Sep 2024 18:18:09 +0200
Message-ID: <20240901160830.053466994@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3218,7 +3218,7 @@ static struct rockchip_pin_bank rk3328_p
 	PIN_BANK_IOMUX_FLAGS(0, 32, "gpio0", 0, 0, 0, 0),
 	PIN_BANK_IOMUX_FLAGS(1, 32, "gpio1", 0, 0, 0, 0),
 	PIN_BANK_IOMUX_FLAGS(2, 32, "gpio2", 0,
-			     0,
+			     IOMUX_WIDTH_2BIT,
 			     IOMUX_WIDTH_3BIT,
 			     0),
 	PIN_BANK_IOMUX_FLAGS(3, 32, "gpio3",


