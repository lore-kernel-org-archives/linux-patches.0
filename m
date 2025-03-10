Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA20D17CA12;
	Mon, 10 Mar 2025 17:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629331; cv=none; b=pisS6YvEd3lVcObP6SAdKHARsfoY2E5ijH5GhOiNIXCF0rmd2KXqrYmeVHBoVlWQPb9qPARKGldwZrNmH6Q2233qJgX9+FQWOlITXWI2iHugmAxygv/lStFz3p5BbEPSkiX8IWPSbysJow8F/y/C1bJVpP4LF0NMx8jsORlvC+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629331; c=relaxed/simple;
	bh=fJv05JWhop8exE10tG9POllbC6B1XMgvRvLCR4fTSJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AiqllVLh7cQqsif5fXEGm5UtpEiUhw8LI2Z/i3A8uQHLmG3Kl4m+wFV+jIWnQ+UIhT+Q/FYkIsRF3VuFh0VGQrLGfKj9mAW3eLPrKrUv6XXEhYm+L66hvo0PSZofNaL3DT2nS41IRCzipEU6mQveiShsw7XSQBHS/nLdKBAMYuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mIh47sGQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mIh47sGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A66C4CEED;
	Mon, 10 Mar 2025 17:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629330;
	bh=fJv05JWhop8exE10tG9POllbC6B1XMgvRvLCR4fTSJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mIh47sGQVt8eq9QWrDo/i0KpYts6xKL20TeguEx1CiXqjiUZYR9CxCmUsZCLEY24t
	 kMzVOsGA6g/GqAZQYfkI7RiMK+g/LxwhvjpQx5kg/fweN/06ivU4WQoV7fD8SNy+v9
	 H+BjHfWh2TzkqbmsgISVbudmdGW0DFusD2zSP9rQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Jakob Unterwurzacher <jakob.unterwurzacher@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.15 258/620] arm64: dts: rockchip: increase gmac rx_delay on rk3399-puma
Date: Mon, 10 Mar 2025 18:01:44 +0100
Message-ID: <20250310170555.811026514@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakob Unterwurzacher <jakobunt@gmail.com>

commit 9d241b06802c6c2176ae7aa4f9f17f8a577ed337 upstream.

During mass manufacturing, we noticed the mmc_rx_crc_error counter,
as reported by "ethtool -S eth0 | grep mmc_rx_crc_error", to increase
above zero during nuttcp speedtests. Most of the time, this did not
affect the achieved speed, but it prompted this investigation.

Cycling through the rx_delay range on six boards (see table below) of
various ages shows that there is a large good region from 0x12 to 0x35
where we see zero crc errors on all tested boards.

The old rx_delay value (0x10) seems to have always been on the edge for
the KSZ9031RNX that is usually placed on Puma.

Choose "rx_delay = 0x23" to put us smack in the middle of the good
region. This works fine as well with the KSZ9131RNX PHY that was used
for a small number of boards during the COVID chip shortages.

	Board S/N        PHY        rx_delay good region
	---------        ---        --------------------
	Puma TT0069903   KSZ9031RNX 0x11 0x35
	Puma TT0157733   KSZ9031RNX 0x11 0x35
	Puma TT0681551   KSZ9031RNX 0x12 0x37
	Puma TT0681156   KSZ9031RNX 0x10 0x38
	Puma 17496030079 KSZ9031RNX 0x10 0x37 (Puma v1.2 from 2017)
	Puma TT0681720   KSZ9131RNX 0x02 0x39 (alternative PHY used in very few boards)

	Intersection of good regions = 0x12 0x35
	Middle of good region = 0x23

Fixes: 2c66fc34e945 ("arm64: dts: rockchip: add RK3399-Q7 (Puma) SoM")
Cc: stable@vger.kernel.org
Reviewed-by: Quentin Schulz <quentin.schulz@cherry.de>
Tested-by: Quentin Schulz <quentin.schulz@cherry.de> # Puma v2.1 and v2.3 with KSZ9031
Signed-off-by: Jakob Unterwurzacher <jakob.unterwurzacher@cherry.de>
Link: https://lore.kernel.org/r/20241213-puma_rx_delay-v4-1-8e8e11cc6ed7@cherry.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
@@ -136,7 +136,7 @@
 	snps,reset-active-low;
 	snps,reset-delays-us = <0 10000 50000>;
 	tx_delay = <0x10>;
-	rx_delay = <0x10>;
+	rx_delay = <0x23>;
 	status = "okay";
 };
 


