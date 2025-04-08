Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B66267B7F;
	Tue,  8 Apr 2025 11:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110637; cv=none; b=Bs4O7ZjDbB8+32OZ1Ekmqly2pQZc5TfKqear30Avmx4xq63pAMdi7ukOvDrx7JLAsE/OSEMQkaZnoIsNo2IyqJjRtQzTpNH40EAQSfoEvP/LTO2jOC5AXxC/r/N3Cs23dkPpIXvf+i8FIVxOCFC0FQcczU2Ny8Gf+YDImm3s1XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110637; c=relaxed/simple;
	bh=OK2pXLL71IifWfFIzV6tDnUMtE0Oqs9h6/6vJ3UkAKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sv9gJzwjAXdGwZefcc0IL/NQtgyzX0a7P+Tk1y3dVKGtjMYx1e4NUKOmwq7XthAWsb4VTcTP2cAH7htjZmOVHo8SHyGONDn5hLBZg13Sa/RJF5fEBnxDCUioY2n+5B4GtmlIYZSdfYdxyKrziQuEsDwA7nXcLnVBDvKJPS9hhq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRunCzGF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRunCzGF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357EAC4CEE5;
	Tue,  8 Apr 2025 11:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110637;
	bh=OK2pXLL71IifWfFIzV6tDnUMtE0Oqs9h6/6vJ3UkAKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wRunCzGFSTjBABnVUuGn2aP67XZutVWrWQlFwqoV/G1bF2XI8KovqnHPkVAwUPLFY
	 PRW2HxByUnMs+l71sqPdmWZ1GcMXuKjS9rmNhQgNsrKQGImh8nlXwhhJFabGtDIipQ
	 CiwoGJPm6L4VtdOskRliQEFERcaDXLsltInnR1E0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 139/731] arm64: dts: ti: k3-j722s: fix pinctrl settings
Date: Tue,  8 Apr 2025 12:40:36 +0200
Message-ID: <20250408104917.510160538@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit 06daad327d043c23bc1ab4cdb519f589094b9e98 ]

It appears that pinctrl-single is misused on this SoC to control both
the mux and the input and output and bias settings. This results in
non-working pinctrl configurations for GPIOs within the device tree.

This is what happens:
 (1) During startup the pinctrl settings are applied according to the
     device tree. I.e. the pin is configured as output and with
     pull-ups enabled.
 (2) During startup a device driver requests a GPIO.
 (3) pinctrl-single is applying the default GPIO setting according to
     the pinctrl-single,gpio-range property.

This would work as expected if the pinctrl-single is only controlling
the function mux, but it also controls the input/output buffer enable,
the pull-up and pull-down settings etc (pinctrl-single,function-mask
covers the entire pad setting instead of just the mux field).

Remove the pinctrl-single,gpio-range property, so that no settings are
applied during a gpio_request() call.

Fixes: 5e5c50964e2e ("arm64: dts: ti: k3-j722s: Add gpio-ranges properties")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Link: https://lore.kernel.org/r/20250221091447.595199-2-mwalle@kernel.org
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j722s-main.dtsi | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j722s-main.dtsi b/arch/arm64/boot/dts/ti/k3-j722s-main.dtsi
index 3ac2d45a05585..6da7b3a2943c4 100644
--- a/arch/arm64/boot/dts/ti/k3-j722s-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j722s-main.dtsi
@@ -251,21 +251,6 @@
 	ti,interrupt-ranges = <7 71 21>;
 };
 
-&main_pmx0 {
-	pinctrl-single,gpio-range =
-		<&main_pmx0_range 0 32 PIN_GPIO_RANGE_IOPAD>,
-		<&main_pmx0_range 33 38 PIN_GPIO_RANGE_IOPAD>,
-		<&main_pmx0_range 72 17 PIN_GPIO_RANGE_IOPAD>,
-		<&main_pmx0_range 101 25 PIN_GPIO_RANGE_IOPAD>,
-		<&main_pmx0_range 137 5 PIN_GPIO_RANGE_IOPAD>,
-		<&main_pmx0_range 143 3 PIN_GPIO_RANGE_IOPAD>,
-		<&main_pmx0_range 149 2 PIN_GPIO_RANGE_IOPAD>;
-
-	main_pmx0_range: gpio-range {
-		#pinctrl-single,gpio-range-cells = <3>;
-	};
-};
-
 &main_gpio0 {
 	gpio-ranges = <&main_pmx0 0 0 32>, <&main_pmx0 32 33 38>,
 			<&main_pmx0 70 72 17>;
-- 
2.39.5



