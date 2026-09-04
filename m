Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B46D41687B;
	Fri,  4 Sep 2026 05:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499472; cv=none; b=tZ5UHnxnD2r/w4W8x7tkZn7JX366Bq7Ah709QTaTTYLZM6vQHXn2ZuLm6PhsIb+HTNh0RJae3upX4+/jxwAUNHgd87wI76Y9jAS8xLg3Z4a5oabmMfinSTXuqK5eN8pjBiDltz9ULIcGEG23tOYxV99uUOeLILJRWhc7LU5bb+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499472; c=relaxed/simple;
	bh=IKmzcu3MmRR8qDaGtJPnQkWowe+pT6vfqQXLmota610=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NtJbdrwjjE0nUPpRJx7C6AHMcsLjt5MeryjJA1teGPbhv6EWRG0i8ScsPJ9Y2vFXrQKEl1z4B/+brQXWyk2/WYU5Bk6QpNu3leU+J26SCXRf2uzHTJdfraLkPYi6pkvZeyIQRjbQ2V8v27Y/ucYcp9b38PIGzFYpO5lLdnf4Ob8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sr1LuDzv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sr1LuDzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DEF1F00A3D;
	Fri,  4 Sep 2026 05:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499471;
	bh=vEpXfNKfLi37guebjSxgx926DdsAx+T5TfXL0Rb78tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sr1LuDzvArk3li9arEaA06Waf59APFmpUa3zTwOmPXnd1rj7H1TUAZVChlF8Ri9Eq
	 uFaAZZ1FOG0NntX2SnkZaMWsik1cG5SJTNYPrRp5MAdD1UgGHsRgZ6+6Z5dF5vcMzf
	 I5j6PzdsSd4wIOfHOfNG3Y8R0iaE/V8pG363jw8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@nabladev.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 7.2 429/713] arm64: dts: rockchip: Fix rk3399-roc-pc-plus analog audio
Date: Fri,  4 Sep 2026 06:56:37 +0200
Message-ID: <20260904045813.444588972@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -136,6 +136,18 @@
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


