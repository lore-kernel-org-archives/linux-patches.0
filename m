Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2930C183CA3;
	Sun,  1 Sep 2024 16:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209160; cv=none; b=BBsSbjCjzHoQ1dtYXTOYwWy8iFC4MXwRXtczYLp+FgR/7G3Ay9wxcubOhjvZ6Sr7HTXiisZID3l+mCR7b2FNSKc3rxqTKR2Gy3c7nfwDfmmuem90Kuzd7saqcB4qS/RJGnHtoXKVTqDdpQjcX0MHzMvQigwirTQBOKg4llLycmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209160; c=relaxed/simple;
	bh=g7+q6+s/hGnhraDFDtxaoSlKIaLsQT8lv4PeP2+c3aA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSJka/VOeF8kE9xzF5yMDwyJVP6rcVhNqq3A7fzmgjEFHObHhf9Fi/m5hQaQF/HO1xgNxOVORGFhjV72eeQ1w1Urat1GNcMO+Zyt8ixhUPt/0HUPgMzOIvGJtr+8s+RzGkJasgEhv/2qDLJnAbCKUwELjPkH1pxskKDNjrAPgBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xTXQz/kG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xTXQz/kG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88DDAC4CEC3;
	Sun,  1 Sep 2024 16:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209160;
	bh=g7+q6+s/hGnhraDFDtxaoSlKIaLsQT8lv4PeP2+c3aA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xTXQz/kGpo7mBZu0bjvKNUh8vguWYHk942rl/bkC3izgvz9cCTb2bE74VogpEI3XP
	 BYkO6paV9XwJ8WrHDuvNuXMN0j//q20WT3/igG5Uhd4MdpkFVVu2q+TGN1r+I0GwX2
	 9EnVQY5G5WzDlaveBlOGm1+x7UWrVG3nmGKIHWYg=
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
Subject: [PATCH 6.1 05/71] pinctrl: rockchip: correct RK3328 iomux width flag for GPIO2-B pins
Date: Sun,  1 Sep 2024 18:17:10 +0200
Message-ID: <20240901160802.089288744@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3803,7 +3803,7 @@ static struct rockchip_pin_bank rk3328_p
 	PIN_BANK_IOMUX_FLAGS(0, 32, "gpio0", 0, 0, 0, 0),
 	PIN_BANK_IOMUX_FLAGS(1, 32, "gpio1", 0, 0, 0, 0),
 	PIN_BANK_IOMUX_FLAGS(2, 32, "gpio2", 0,
-			     0,
+			     IOMUX_WIDTH_2BIT,
 			     IOMUX_WIDTH_3BIT,
 			     0),
 	PIN_BANK_IOMUX_FLAGS(3, 32, "gpio3",


