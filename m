Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33161150980;
	Mon, 16 Sep 2024 12:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488000; cv=none; b=Pn4hc07FhTFIPq9k/oOy8KoRGtTVs1uS6GEcuvl1+FFY41jAKavjeKiJ0onPiS2rWK16BrLNi8flnhzb/YC+KLn4QImRkgJgwVGUTXLO1yhRhxa7yNuagxXCDZ3C5P6J7i8Z1aHr2q68YP9GkIM3jfR/wf4VK++DUM8VhoD4654=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488000; c=relaxed/simple;
	bh=Wc+mDW0lCtXPEsNdbjOSgy+tYe4VFRdEwXmCzgTCYs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWRoJvovTraf2jfj3v9Xnbii4L1jbHlO4Kk8WfdR6QdZWcbgHgLpJrX1xPntbFZhwnMZDTbylw3W4cyX8fsi8+yMoxIgu5cl8yRFMF0liH7dby5XSJ3YiphKfxl3cdClAPGXv585Xqe7wdqtWf1ArJX8CyTL+b4v7E6YNCsRDEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hW1+gzZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hW1+gzZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ABC8C4CEC4;
	Mon, 16 Sep 2024 11:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488000;
	bh=Wc+mDW0lCtXPEsNdbjOSgy+tYe4VFRdEwXmCzgTCYs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hW1+gzZhjAn5Z8RPUdi7zMlw5i/zEul4Ebisl1hoauBQpKS0GHuxxLn+a8ZzSIuyd
	 hUwzwS6wP3MM3qYSAl1Gagknq4GoI5SJJzR9tW0v/hc0v74AGEibvkinYZobjxa4b2
	 a0McuCbrgzIjmHmSBzt73+K7YAx/SXbFffoE4u+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.1 24/63] arm64: dts: rockchip: fix eMMC/SPI corruption when audio has been used on RK3399 Puma
Date: Mon, 16 Sep 2024 13:44:03 +0200
Message-ID: <20240916114221.922071592@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
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
@@ -374,6 +374,7 @@
 
 &i2s0 {
 	pinctrl-0 = <&i2s0_2ch_bus>;
+	pinctrl-1 = <&i2s0_2ch_bus_bclk_off>;
 	rockchip,playback-channels = <2>;
 	rockchip,capture-channels = <2>;
 	status = "okay";
@@ -382,8 +383,8 @@
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
@@ -391,6 +392,14 @@
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


