Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A762157E65;
	Mon, 29 Jan 2024 17:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548065; cv=none; b=sgnl7fIjSdiQYfL+XsvF3J6XrirrxjJ05S7S4YiJs4yA7GJmhskgiEqZtlxvk4Yt5rtunhAcyr5nZV9Lhcwm6lRxmlGfLZl9VzM/lBHn0g6elVbgyaSGeiWMR7DN9AnOOdF6uQTJN3tRSVpTBMy9/7XqNdijE4rUkf6DKWfVZD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548065; c=relaxed/simple;
	bh=3nyMNTR00buw7+lJNctZmpna7oUVqpzY5koH/xedN7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5+BvNozquQG16tvS7YMPzzVZruk9zzGTywEswWdcyYSu5OhJXlOW6jS2YNN44h2ulCcNYJIrTHbVY8ZmEzVtM9hwOP6PBGA+PVMgAxvspQNsVJvdoQDgnE46/wX6+ZgsXxEptufWEzlNFwQc+RFJcDrLIOH543E9nruoag4Y40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OqZaZz+A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OqZaZz+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8FEFC433F1;
	Mon, 29 Jan 2024 17:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548065;
	bh=3nyMNTR00buw7+lJNctZmpna7oUVqpzY5koH/xedN7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OqZaZz+AloxugogBsXbD9FoJFsC98xvcWTJDzHCB9DTUkyyz5SDWv9SLRTh3kEkTF
	 TpC0WuuCRkubSXiuJQz6lhAK6Utx7W7VfXxoTVl+xWZdfZE0swN/rIBivuCW6T7dkw
	 eMx+6Xzl2HGTlYCFwKqa7yXlX/s36xrAhFa3ZH2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Edwards <CFSworks@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.7 072/346] arm64: dts: rockchip: Fix rk3588 USB power-domain clocks
Date: Mon, 29 Jan 2024 09:01:43 -0800
Message-ID: <20240129170018.503325988@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -916,6 +916,7 @@
 				reg = <RK3588_PD_USB>;
 				clocks = <&cru PCLK_PHP_ROOT>,
 					 <&cru ACLK_USB_ROOT>,
+					 <&cru ACLK_USB>,
 					 <&cru HCLK_USB_ROOT>,
 					 <&cru HCLK_HOST0>,
 					 <&cru HCLK_HOST_ARB0>,


