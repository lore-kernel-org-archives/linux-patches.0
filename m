Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C183221552;
	Thu, 13 Feb 2025 14:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457573; cv=none; b=M70OdY9r7pVLFKx3EDiM5vCWVIVWQxdI1IsmNOe8cOZ68HMp2cvB4A4m5gnuTZXDbz5Wfe63o95xQ9M9J8go3e9eU9NLoQJ6Wvn9eZjcuOvSbwycwHVSR8tlyvrvp2ryFaOK4jYYmQOG2Zf6nGplyujqwjCtCN7xiDBx5hMnTGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457573; c=relaxed/simple;
	bh=FZFHzuOtO1Z/wvgGNt14Mxr1UlIOcyHIgqGpIEE9kWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQQ/gOMSFW8XjpIGuMsV9NJllgqs1YhVzcrxYbB7fB/xuknOG4rNmQfsKV+q7ez93ds5+znF/Ynu+2JIafKmOlnWs5Dcbm+l07EmWkn4e6Ei/xDn+R5CRkeRQtAZcioBkyoaNDv7zx6XkVSh+r/FhUREyQsQ5F34C1V9GWs0LlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lV6csunR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lV6csunR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E04FC4CEE2;
	Thu, 13 Feb 2025 14:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457572;
	bh=FZFHzuOtO1Z/wvgGNt14Mxr1UlIOcyHIgqGpIEE9kWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lV6csunRgS/JnYWlRsDoNI6/dFvl3DBw7mbGPtRA+BT/tb2zlTiJrX6z7YEC6yTH0
	 qqy9cDnuiGvEOGDdO7+JELBXLJUZYYefa8fxBES9nU6tv88Nvln6kL+ElS9cGUYUab
	 CEeUAHPjDEwMFme2Kbsr7KyoRUL44Xkcx1YQXhRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Jakob Unterwurzacher <jakob.unterwurzacher@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.12 150/422] arm64: dts: rockchip: increase gmac rx_delay on rk3399-puma
Date: Thu, 13 Feb 2025 15:24:59 +0100
Message-ID: <20250213142442.337513901@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -181,7 +181,7 @@
 	snps,reset-active-low;
 	snps,reset-delays-us = <0 10000 50000>;
 	tx_delay = <0x10>;
-	rx_delay = <0x10>;
+	rx_delay = <0x23>;
 	status = "okay";
 };
 


