Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A10F1C006A;
	Tue,  2 Jul 2024 17:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940606; cv=none; b=BR/CYhH9hysfcYJpwTU2l6eGSOwj/iNNEulH78e+CJLCuWZ39uQNww5JCLRGqhmRkF3gsoJVLeMY/F0jPTka/m3Vntt7s+r6RjRBpLREvGRvS5QYo/t9QRko1IMovFQtHA/9o7IEO1h8i8lAeujKc0nqGKDqJPdV8YMJliyQ0Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940606; c=relaxed/simple;
	bh=4du2s4hoeO8pCtbLL5Nvv/p1+GwyTEx8C0Qk+Y5U8tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pa2mpB3dTGtTXNImM3C0CKEXBSzR/uUi3llqeuOdZUBvfDUDK1p1HxUODxeSmEpnPnM4PsKgvTYcDwSgsMoskUw/vtc1kX+p26FNHf0RZw1e9Wr1Y45fPlDGIK/pY8F/AXGDlUlnUykGMHq27VNl4HMFyfEl2Wrnejix0sVQfoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w9NUCS/9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w9NUCS/9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFF7C4AF0F;
	Tue,  2 Jul 2024 17:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940606;
	bh=4du2s4hoeO8pCtbLL5Nvv/p1+GwyTEx8C0Qk+Y5U8tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w9NUCS/9qXfeJHTqguclZ+wm/9Qw6ltp+MA2PtdGud2twmq686cXhJ0rw97HKbo4F
	 /A780fnACQdbkXh1eE/aeCfhte2RCLEjHsgVDIAlCtGSY9yt+0kvOo3qaeTrv8dtnk
	 hkwbba2V1OFw+hH4CECdQLMS56MT+Oly37AkldGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 205/222] arm64: dts: rockchip: Fix SD NAND and eMMC init on rk3308-rock-pi-s
Date: Tue,  2 Jul 2024 19:04:03 +0200
Message-ID: <20240702170251.822255565@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit 1fb98c855ccd7bc7f50c7a9626fbb8440454760b ]

Radxa ROCK Pi S have optional onboard SD NAND on board revision v1.1,
v1.2 and v1.3, revision v1.5 changed to use optional onboard eMMC.

The optional SD NAND typically fails to initialize:

  mmc_host mmc0: Bus speed (slot 0) = 400000Hz (slot req 400000Hz, actual 400000HZ div = 0)
  mmc0: error -110 whilst initialising SD card
  mmc_host mmc0: Bus speed (slot 0) = 300000Hz (slot req 300000Hz, actual 300000HZ div = 0)
  mmc0: error -110 whilst initialising SD card
  mmc_host mmc0: Bus speed (slot 0) = 200000Hz (slot req 200000Hz, actual 200000HZ div = 0)
  mmc0: error -110 whilst initialising SD card
  mmc_host mmc0: Bus speed (slot 0) = 100000Hz (slot req 100000Hz, actual 100000HZ div = 0)
  mmc0: error -110 whilst initialising SD card

Add pinctrl and cap-sd-highspeed to fix SD NAND initialization. Also
drop bus-width and mmc-hs200-1_8v to fix eMMC initialization on the new
v1.5 board revision, only 3v3 signal voltage is used.

Fixes: 2e04c25b1320 ("arm64: dts: rockchip: add ROCK Pi S DTS support")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Link: https://lore.kernel.org/r/20240521211029.1236094-4-jonas@kwiboo.se
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts b/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
index b47fe02c33fbd..84f4b4a44644c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
@@ -126,10 +126,12 @@
 };
 
 &emmc {
-	bus-width = <4>;
 	cap-mmc-highspeed;
-	mmc-hs200-1_8v;
+	cap-sd-highspeed;
+	no-sdio;
 	non-removable;
+	pinctrl-names = "default";
+	pinctrl-0 = <&emmc_bus8 &emmc_clk &emmc_cmd>;
 	vmmc-supply = <&vcc_io>;
 	status = "okay";
 };
-- 
2.43.0



