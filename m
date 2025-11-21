Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FAA4343215;
	Fri, 21 Nov 2025 13:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733457; cv=none; b=kZLBKLrzlAGehEpAv+Ym5nrZKBioYQKtO9bSLMBSa8w+ZiZtCEO2WdIUzw5kYc28G9HXoLtFEk139dFaCqSG2AdHUWuMFvI1Y30QaQ309kWFMtqaw9547TLezNAm4/VrZRklWP0waBw4npmsu58bYmAdZYb9wtpsQIBedNBSSV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733457; c=relaxed/simple;
	bh=GDKLNLnGcvvZVGXwsGuK3WnOmrijuXPNGZKLNBcU6kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tg7Ief9ABTvRJO0JudPQUVEtRP7ryi6Gxru8weTbraiI/9wwFdiQBoGq+0f3smQl/YVet3GhXNlsCF10jqbMewvQZZROKDLaI9qfhCNi2UvrFyxVs+exNV43ywYP/6I9zfTlx0BFwAxLMlx+QEgt3boXmI63ZQxes3S/eVJATEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MvDGb1Wt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MvDGb1Wt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22153C4CEF1;
	Fri, 21 Nov 2025 13:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733457;
	bh=GDKLNLnGcvvZVGXwsGuK3WnOmrijuXPNGZKLNBcU6kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MvDGb1WtjODXc47qtTgSPvwe62PZqKW2OPsKJGj6Jex8VdIACBeUb8Zc1qlLxCB96
	 Nj58aaAiTwlqLfqfojK6je1VpcMU24mD7GIhAHq2PZk4ZD1pBE2Dtw68t7u8TcHGBp
	 h3JISeOIdnn1Su/MCO6niLra/FmEZDIq1zHbAP8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	Anand Moon <linux.amoon@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 457/529] arm64: dts: rockchip: Set correct pinctrl for I2S1 8ch TX on odroid-m1
Date: Fri, 21 Nov 2025 14:12:36 +0100
Message-ID: <20251121130247.271460725@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Anand Moon <linux.amoon@gmail.com>

[ Upstream commit d425aef66e62221fa6bb0ccb94296df29e4cc107 ]

Enable proper pin multiplexing for the I2S1 8-channel transmit interface by
adding the default pinctrl configuration which esures correct signal routing
and avoids pinmux conflicts during audio playback.

Changes fix the error
[  116.856643] [    T782] rockchip-pinctrl pinctrl: pin gpio1-10 already requested by affinity_hint; cannot claim for fe410000.i2s
[  116.857567] [    T782] rockchip-pinctrl pinctrl: error -EINVAL: pin-42 (fe410000.i2s)
[  116.857618] [    T782] rockchip-pinctrl pinctrl: error -EINVAL: could not request pin 42 (gpio1-10) from group i2s1m0-sdi1 on device rockchip-pinctrl
[  116.857659] [    T782] rockchip-i2s-tdm fe410000.i2s: Error applying setting, reverse things back

I2S1 on the M1 to the codec in the RK809 only uses the SCLK, LRCK, SDI0
and SDO0 signals, so limit the claimed pins to those.

With this change audio output works as expected:

$ aplay -l
**** List of PLAYBACK Hardware Devices ****
card 0: HDMI [HDMI], device 0: fe400000.i2s-i2s-hifi i2s-hifi-0 [fe400000.i2s-i2s-hifi i2s-hifi-0]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 1: RK817 [Analog RK817], device 0: fe410000.i2s-rk817-hifi rk817-hifi-0 [fe410000.i2s-rk817-hifi rk817-hifi-0]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

Fixes: 78f858447cb7 ("arm64: dts: rockchip: Add analog audio on ODROID-M1")
Cc: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Anand Moon <linux.amoon@gmail.com>
[adapted the commit message a bit]
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-odroid-m1.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-odroid-m1.dts b/arch/arm64/boot/dts/rockchip/rk3568-odroid-m1.dts
index 6a02db4f073f2..a5426b82552ed 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-odroid-m1.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-odroid-m1.dts
@@ -482,6 +482,8 @@
 };
 
 &i2s1_8ch {
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2s1m0_sclktx &i2s1m0_lrcktx &i2s1m0_sdi0 &i2s1m0_sdo0>;
 	rockchip,trcm-sync-tx-only;
 	status = "okay";
 };
-- 
2.51.0



