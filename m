Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5E48F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5592BC433EF;
	Mon, 13 Feb 2023 14:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300093;
	bh=/PwGSRY3IcB3MSYNVAlgh0iJwFR2W2CgmonWJwyZfXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LIePmb2H1IMsnZ2Z8gPskYxcldLPPQlLdr6IpJXs7RjQCKgMYmFjshr1e9omf8hkp
	 rsSK8Gyq2MjnFm03XRM9jijf8fFJDmBeFhpIoYUZxHVDXA32oAGQTCgE12+mOV5ypW
	 SlpYF5KMJfbLp42h7osKX8ydEfShYFgNWT8+Rydk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaud Ferraris <arnaud.ferraris@collabora.com>,
	Caleb Connolly <kc@postmarketos.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/114] arm64: dts: rockchip: fix input enable pinconf on rk3399
Date: Mon, 13 Feb 2023 15:48:16 +0100
Message-Id: <20230213144745.390833115@linuxfoundation.org>
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

From: Arnaud Ferraris <arnaud.ferraris@collabora.com>

[ Upstream commit 6f515b663d49a14fb63f8c5d0a2a4ae53d44790a ]

When the input enable pinconf was introduced, a default drive-strength
value of 2 was set for the pull up/down configs. However, this parameter
is unneeded when configuring the pin as input, and having a single
hardcoded value here is actually harmful: GPIOs on the RK3399 have
various same drive-strength capabilities depending on the bank and port
they belong to.

As an example, trying to configure the GPIO4_PD3 pin as an input with
pull-up enabled fails with the following output:

  [   10.706542] rockchip-pinctrl pinctrl: unsupported driver strength 2
  [   10.713661] rockchip-pinctrl pinctrl: pin_config_set op failed for pin 155

(acceptable drive-strength values for this pin being 3, 6, 9 and 12)

Let's drop the drive-strength property from all input pinconfs in order
to solve this issue.

Fixes: ec48c3e82ca3 ("arm64: dts: rockchip: add an input enable pinconf to rk3399")
Signed-off-by: Arnaud Ferraris <arnaud.ferraris@collabora.com>
Reviewed-by: Caleb Connolly <kc@postmarketos.org>
Link: https://lore.kernel.org/r/20221215101947.254896-1-arnaud.ferraris@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index 92c2207e686ce..59858f2dc8b9f 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -2221,13 +2221,11 @@
 		pcfg_input_pull_up: pcfg-input-pull-up {
 			input-enable;
 			bias-pull-up;
-			drive-strength = <2>;
 		};
 
 		pcfg_input_pull_down: pcfg-input-pull-down {
 			input-enable;
 			bias-pull-down;
-			drive-strength = <2>;
 		};
 
 		clock {
-- 
2.39.0



