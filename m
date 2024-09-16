Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F5E158557;
	Mon, 16 Sep 2024 12:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488248; cv=none; b=BG+c4ILPIUzaLt2lu+RNr0yVfDZ5wqrzUn/7X6uS8C4NoqPWHolKRyu9xocxJFGaRIizz6p5/Ew4EvCe6S5nSS2zQkYvQYwVimixNS5m/+M8AGP7Ro/qMKkxLdubgVkp3y8pQyZ6ynhQ4jQ6LizeFugKhnDM1S7SJC74hOe3Ph4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488248; c=relaxed/simple;
	bh=VkQCTv8nSabD+AqxwWDMvY8nwQy0cDKTPiaMzqdgOoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AEKst+aUPp+5DUuBG0LG8+N80Qsp7SW4L6DrhyoELXYvXLRJ6+rE81HH8my38MfTNcaDWKO4Kpok0119wZK+V5gRM06/r6Y2y2TSQ9Q7zlGKnbb8Wd2+BDg4CVkjev1ZFn1tst3jcrFl7mse1ox2yNJKKdxB0C9H3aAtTxVsvkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yM6WesDc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yM6WesDc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2C3C4CEC4;
	Mon, 16 Sep 2024 12:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488247;
	bh=VkQCTv8nSabD+AqxwWDMvY8nwQy0cDKTPiaMzqdgOoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yM6WesDcaEXe4uMR1RtgyusLrRhaV19otE1qwNgD9i+TwV7mCHJaAMWenFi75Gv9s
	 ro5YyuY69EGLE78NsXtIE5c84+bmGWtp7wZv6x281DU9FoBbzwCcMaN3d0WMZUmSdk
	 F46rrBkzuGGx9C4hMY5udidnMQ4E8+YHI9Xjdfac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.10 047/121] arm64: dts: rockchip: fix eMMC/SPI corruption when audio has been used on RK3399 Puma
Date: Mon, 16 Sep 2024 13:43:41 +0200
Message-ID: <20240916114230.678424144@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Schulz <quentin.schulz@cherry.de>

commit bb94a157b37ec23f53906a279320f6ed64300eba upstream.

In commit 91419ae0420f ("arm64: dts: rockchip: use BCLK to GPIO switch
on rk3399"), an additional pinctrl state was added whose default pinmux
is for 8ch i2s0. However, Puma only has 2ch i2s0. It's been overriding
the pinctrl-0 property but the second property override was missed in
the aforementioned commit.

On Puma, a hardware slider called "BIOS Disable/Normal Boot" can disable
eMMC and SPI to force booting from SD card. Another software-controlled
GPIO is then configured to override this behavior to make eMMC and SPI
available without human intervention. This is currently done in U-Boot
and it was enough until the aforementioned commit.

Indeed, because of this additional not-yet-overridden property, this
software-controlled GPIO is now muxed in a state that does not override
this hardware slider anymore, rendering SPI and eMMC flashes unusable.

Let's override the property with the 2ch pinmux to fix this.

Fixes: 91419ae0420f ("arm64: dts: rockchip: use BCLK to GPIO switch on rk3399")
Cc: stable@vger.kernel.org
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Link: https://lore.kernel.org/r/20240731-puma-emmc-6-v1-1-4e28eadf32d0@cherry.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
@@ -409,6 +409,7 @@
 
 &i2s0 {
 	pinctrl-0 = <&i2s0_2ch_bus>;
+	pinctrl-1 = <&i2s0_2ch_bus_bclk_off>;
 	rockchip,playback-channels = <2>;
 	rockchip,capture-channels = <2>;
 	status = "okay";
@@ -417,8 +418,8 @@
 /*
  * As Q7 does not specify neither a global nor a RX clock for I2S these
  * signals are not used. Furthermore I2S0_LRCK_RX is used as GPIO.
- * Therefore we have to redefine the i2s0_2ch_bus definition to prevent
- * conflicts.
+ * Therefore we have to redefine the i2s0_2ch_bus and i2s0_2ch_bus_bclk_off
+ * definitions to prevent conflicts.
  */
 &i2s0_2ch_bus {
 	rockchip,pins =
@@ -426,6 +427,14 @@
 		<3 RK_PD2 1 &pcfg_pull_none>,
 		<3 RK_PD3 1 &pcfg_pull_none>,
 		<3 RK_PD7 1 &pcfg_pull_none>;
+};
+
+&i2s0_2ch_bus_bclk_off {
+	rockchip,pins =
+		<3 RK_PD0 RK_FUNC_GPIO &pcfg_pull_none>,
+		<3 RK_PD2 1 &pcfg_pull_none>,
+		<3 RK_PD3 1 &pcfg_pull_none>,
+		<3 RK_PD7 1 &pcfg_pull_none>;
 };
 
 &io_domains {


