Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D136F079;
	Mon, 29 Jan 2024 17:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548465; cv=none; b=Wqu3e7EVvr6sgu0LLwkmm+lGpKT7NckuiUbnM0F5jbKJAM5aZhlikrvo0P5kCRaKaohbVpwyf6CK2qP6zHE5x36Qtp5d7sUJUWQqQSXibQN2gcQGpERF513s8J+0mA3kKqWrCjF/1JF0rIlLKS+a8Se+2nq1GYsuQ+2SXU2L0WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548465; c=relaxed/simple;
	bh=1ksb4uBJOWgVSJIYyTb0JRtWWC4Jwo6zaiwLkPxxBKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kcaVO//7qvA3hITLeqEZs1ItpKbP+hKSIO0Oh2jBUYwrTbls55op9Kc936cwm8c0eSLXAmwIHUE2a+u5dDRJ3yoyi+bb2ClNaUqUbRp+gJoBdq2IbNePdlzxluQIC8rXzSzCe6x2ypLKniV2PPWONOoKPNHkvebqZR++RZR08Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wrgAWadC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wrgAWadC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6FBC433C7;
	Mon, 29 Jan 2024 17:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548465;
	bh=1ksb4uBJOWgVSJIYyTb0JRtWWC4Jwo6zaiwLkPxxBKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wrgAWadCBuQkbv3OQZFbjrnmbhCwi5QRd7VvOoqlg9/i38LzcOsydMxaFmOwr9MnS
	 V1cxuyzbUnJhUTszeaVXqVHxYnYaByJb8Y7jnLX3mP8C7KwlPTyzTfcc8Z7NQIhYUn
	 ifl+4ZTvN3/q3biLlpPS3e5xJibejIPqMShalBkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Edwards <CFSworks@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.6 079/331] arm64: dts: rockchip: Fix rk3588 USB power-domain clocks
Date: Mon, 29 Jan 2024 09:02:23 -0800
Message-ID: <20240129170017.236310334@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Edwards <cfsworks@gmail.com>

commit 44de8996ed5a10f08f2fe947182da6535edcfae5 upstream.

The QoS blocks saved/restored when toggling the PD_USB power domain are
clocked by ACLK_USB. Attempting to access these memory regions without
that clock running will result in an indefinite CPU stall.

The PD_USB node wasn't specifying this clock dependency, resulting in
hangs when trying to toggle the power domain (either on or off), unless
we get "lucky" and have ACLK_USB running for another reason at the time.
This "luck" can result from the bootloader leaving USB powered/clocked,
and if no built-in driver wants USB, Linux will disable the unused
PD+CLK on boot when {pd,clk}_ignore_unused aren't given. This can also
be unlucky because the two cleanup tasks run in parallel and race: if
the CLK is disabled first, the PD deactivation stalls the boot. In any
case, the PD cannot then be reenabled (if e.g. the driver loads later)
once the clock has been stopped.

Fix this by specifying a dependency on ACLK_USB, instead of only
ACLK_USB_ROOT. The child-parent relationship means the former implies
the latter anyway.

Fixes: c9211fa2602b8 ("arm64: dts: rockchip: Add base DT for rk3588 SoC")
Cc: stable@vger.kernel.org
Signed-off-by: Sam Edwards <CFSworks@gmail.com>
Link: https://lore.kernel.org/r/20231216021019.1543811-1-CFSworks@gmail.com
[changed to only include the missing clock, not dropping the root-clocks]
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3588s.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/rockchip/rk3588s.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588s.dtsi
@@ -890,6 +890,7 @@
 				reg = <RK3588_PD_USB>;
 				clocks = <&cru PCLK_PHP_ROOT>,
 					 <&cru ACLK_USB_ROOT>,
+					 <&cru ACLK_USB>,
 					 <&cru HCLK_USB_ROOT>,
 					 <&cru HCLK_HOST0>,
 					 <&cru HCLK_HOST_ARB0>,


