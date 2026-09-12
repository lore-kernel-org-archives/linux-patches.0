Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8606147ECDE;
	Sat, 12 Sep 2026 13:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220608; cv=none; b=mYMXyxCkM69x7lpuESyAjwXFWjVFcGqcPVLUZGxP+QyEVQ4owMdSJQf94S6hTlmrx5GN5VS2tAM6t8A3CfUaMi3HkI2+PbLYPyeiFtkaD2KOoHBJsKDpMlN9qSbHvMwcuEnGWB9Als6bI5bmzMMhPHMGGsZ2ZoaDu2nTLftCV7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220608; c=relaxed/simple;
	bh=4FQo9J00hv5sdAdHTkaHRiUTG1A23COw0IkHN6cDnP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6BV34L8jbqBnTFZzbXfua4KCBvmIJMR2kiJ8OdirBoZ8wYdwSxIXWBxqNm4Dghp3AFkJtm9CMpr8CK7fpeKyimzjA5GgiqLBYBVgpdWXgjug7V0HobnXdBNQAxWFZf4LEwPSQl4qCn1zBopmryUlciSMkktMW165GXfO5XVuH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0apBAlwp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0apBAlwp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6851F00898;
	Sat, 12 Sep 2026 13:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220607;
	bh=15D/XsCrHA48tAGw2nfNKn4zCSn4MvUvorch4UX4zQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0apBAlwpkIhcrTdPt3YiHfROZe7WNf8Pmx0dbxabRY7HwX+9b/v63EUWOIeKltkHP
	 LSSt+7tjMcAiULTTzYup1LrSBoZRjC88dpdwWEq46wToTSUB2gcPAp/CkAGBGL+ZOW
	 mhdiGJ1JIjuu/RGjjhF10hWMN3gJ0kENCeTjiTA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@nabladev.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.6 0169/1424] arm64: dts: rockchip: Fix rk3399-roc-pc-plus analog audio
Date: Sat, 12 Sep 2026 08:43:21 +0200
Message-ID: <20260912065611.077062959@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Fabio Estevam <festevam@nabladev.com>

commit 4f7259ebe1eba4778768a4f5a0bbbe439d10f3f3 upstream.

The ES8388 sound card on the rk3399-roc-pc-plus fails to probe because
i2s1 cannot claim its MCLK pin:

pinctrl: pin gpio4-0 already requested by ff880000.i2s; cannot claim for ff890000.i2s
pinctrl: error -EINVAL: pin-128 (ff890000.i2s)
pinctrl: error -EINVAL: could not request pin 128 (gpio4-0) from group i2s-8ch-mclk-pin
on device rockchip-pinctrl

GPIO4_A0 is routed as SCLK_I2S_8CH_OUT and is used by i2s1 as the
external MCLK for the ES8388 codec. The board dts already removes
GPIO4_A0 from the i2s0_8ch_bus pin group, but i2s0 still claims the
same pin through its bclk_off state.

Since the i2s driver requests both states, this blocks i2s1 pinctrl
setup and leaves the simple-audio-card deferred with a parse error.

Override i2s0_8ch_bus_bclk_off as well, matching the existing
i2s0_8ch_bus override, so GPIO4_A0 is left for i2s1/ES8388 audio.

Cc: stable@vger.kernel.org
Fixes: 6d9a7bd6a13c ("arm64: dts: rockchip: add support for Firefly ROC-RK3399-PC-PLUS")
Signed-off-by: Fabio Estevam <festevam@nabladev.com>
Link: https://patch.msgid.link/20260717010736.578419-1-festevam@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-roc-pc-plus.dts |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/arch/arm64/boot/dts/rockchip/rk3399-roc-pc-plus.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-roc-pc-plus.dts
@@ -133,6 +133,18 @@
 		<3 RK_PD7 1 &pcfg_pull_none>;
 };
 
+&i2s0_8ch_bus_bclk_off {
+	rockchip,pins =
+		<3 RK_PD0 RK_FUNC_GPIO &pcfg_pull_none>,
+		<3 RK_PD1 1 &pcfg_pull_none>,
+		<3 RK_PD2 1 &pcfg_pull_none>,
+		<3 RK_PD3 1 &pcfg_pull_none>,
+		<3 RK_PD4 1 &pcfg_pull_none>,
+		<3 RK_PD5 1 &pcfg_pull_none>,
+		<3 RK_PD6 1 &pcfg_pull_none>,
+		<3 RK_PD7 1 &pcfg_pull_none>;
+};
+
 &i2s1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2s_8ch_mclk_pin>, <&i2s1_2ch_bus>;


