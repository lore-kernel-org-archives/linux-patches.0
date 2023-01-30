Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E0728EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:58:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA64C433D2;
	Mon, 30 Jan 2023 13:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087132;
	bh=tkpPod23MZrQlfWaoJQ7LVtRRjAyUGjIFigyL+Sj2Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pFHaRd1+h3GCX3L2suMiJVEFaxLDvW+DaakOdKh42GyNkkUuVRa8sRSr4XTjRxzTO
	 bbJxwj3Q0iNo77gCYnI5BBvXzgsTjtvqpsOSvbfx6YIj3jfVjXp00PMRKHbzFpddaQ
	 /7s7EA5U9vKEeR0mC/o3cOPut5ZJBlmZaaH11iVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Jianqun Xu <jay.xu@rock-chips.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/313] pinctrl: rockchip: fix reading pull type on rk3568
Date: Mon, 30 Jan 2023 14:48:32 +0100
Message-Id: <20230130134340.230131146@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit 31b62a98de42cf65d76e4dcfb571af067d27d83a ]

When reading pinconf-pins from debugfs it fails to get the configured pull
type on RK3568, "unsupported pinctrl type" error messages is also reported.

Fix this by adding support for RK3568 in rockchip_get_pull, including a
reverse of the pull-up value swap applied in rockchip_set_pull so that
pull-up is correctly reported in pinconf-pins.
Also update the workaround comment to reflect affected pins, GPIO0_D3-D6.

Fixes: c0dadc0e47a8 ("pinctrl: rockchip: add support for rk3568")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Jianqun Xu <jay.xu@rock-chips.com>
Link: https://lore.kernel.org/r/20230110172955.1258840-1-jonas@kwiboo.se
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-rockchip.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index da974ff2d75d..c3b9313e5be1 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -2436,10 +2436,19 @@ static int rockchip_get_pull(struct rockchip_pin_bank *bank, int pin_num)
 	case RK3308:
 	case RK3368:
 	case RK3399:
+	case RK3568:
 	case RK3588:
 		pull_type = bank->pull_type[pin_num / 8];
 		data >>= bit;
 		data &= (1 << RK3188_PULL_BITS_PER_PIN) - 1;
+		/*
+		 * In the TRM, pull-up being 1 for everything except the GPIO0_D3-D6,
+		 * where that pull up value becomes 3.
+		 */
+		if (ctrl->type == RK3568 && bank->bank_num == 0 && pin_num >= 27 && pin_num <= 30) {
+			if (data == 3)
+				data = 1;
+		}
 
 		return rockchip_pull_list[pull_type][data];
 	default:
@@ -2497,7 +2506,7 @@ static int rockchip_set_pull(struct rockchip_pin_bank *bank,
 			}
 		}
 		/*
-		 * In the TRM, pull-up being 1 for everything except the GPIO0_D0-D6,
+		 * In the TRM, pull-up being 1 for everything except the GPIO0_D3-D6,
 		 * where that pull up value becomes 3.
 		 */
 		if (ctrl->type == RK3568 && bank->bank_num == 0 && pin_num >= 27 && pin_num <= 30) {
-- 
2.39.0



