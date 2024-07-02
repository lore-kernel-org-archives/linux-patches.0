Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1ADC1BD005;
	Tue,  2 Jul 2024 17:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941642; cv=none; b=oERvl8vU1kZhULUZWehFfgg2BGVFq97vZPeWYJRDx9ocE6cOOv3xR4TabbrO4xUDEKU2kt/XKmDnDPD8GAupQkKifN+2Mhh/nJsUVA0a56L4l3ZL2CFiBc5gCxE3LrF9q1bJGFGprhm27nip/Td/h0E/M2Z+Ipw004I3m8LEhmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941642; c=relaxed/simple;
	bh=cFEPzgMykpKq6xhTQpEHypfwVpyJH7tdwKoClFtn4Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nlj4txbvjKl6nX8YVxeQfk9cErHFD8L1hV4HYnbFP76kh4lxBQugYjA7tEt0EpaezZlwmGa3gv+RTxmFeVNmOgSsV75Zg/GkEepbf9Lq9qu0FiYUK/ZuKMw+xlAQQD6698bm89HkG1H4UWkCH7853IAFnU+V5wXG9cIN2k9pKtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jNxJq28m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jNxJq28m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F47C116B1;
	Tue,  2 Jul 2024 17:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941641;
	bh=cFEPzgMykpKq6xhTQpEHypfwVpyJH7tdwKoClFtn4Tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jNxJq28mbP3MaZyV/YFnOZfua3eR1BEIXho6gF7TeK+Snn71CtCwale65kakQK/WW
	 q9loNLBDfq1ayA4gHRl7UdOoq0hnXRwWqL4d3AAnIgU7JwkPnBTSkh84sHJ3knHnoU
	 d17rY8jP1DGp1vYTx8OozJIbWUiN6obmKojq5Ml0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 124/128] arm64: dts: rockchip: Fix SD NAND and eMMC init on rk3308-rock-pi-s
Date: Tue,  2 Jul 2024 19:05:25 +0200
Message-ID: <20240702170230.910106581@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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
index a71f249ed384e..e9d5d55f0a8ae 100644
--- a/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
@@ -127,10 +127,12 @@
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



