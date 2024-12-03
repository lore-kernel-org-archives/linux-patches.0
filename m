Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A251F8AFF;
	Tue,  3 Dec 2024 15:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240475; cv=none; b=uui2L6ROX1QjisFx8XPGIf6MjA/kJuYqYmFpqJVJ3d52x4RJhW2eZLynDzOHI+L/lKXrlOujBTjErh0KAE8m77UIil3qvRBqgz4L9Rb9PbGYakuJHsyMB6P1xPgBLcUS2HGIlZ/UFb/GPcVuioY25RRcC8hCwEvEZ5afv+poQIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240475; c=relaxed/simple;
	bh=twepPB1QblaXbe4yUjs6IG+Iq36S7ZH6bZOFZEK5Gbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMs0cPTwsQyg/5BjYKmuF0v39MjLnzTiDd+9rclN43JCkSOXYdPzCymDoQS41UYRCOhM1+zj09k9NMrhGuThthIxs/4Y5MPBzYBXY4yML96qN79+dVEvG2QKxQEvQEicJ4TbQxogdNARoKh9GRaiWC2OFsFdl35kM400wMoB/Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UA3LKQwM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UA3LKQwM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9CFC4CECF;
	Tue,  3 Dec 2024 15:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240474;
	bh=twepPB1QblaXbe4yUjs6IG+Iq36S7ZH6bZOFZEK5Gbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UA3LKQwMM8vEngBEycS6/JkD+29irQQVo1geG34ifjA7WSJ76MvgdgUc2L7AICcrn
	 weKEK8eV2eKBBu6Ho3UKHP2M3ZoWxFaR/bkrlMe2BqHziw35tJcbUzipPh3BN8ycMV
	 OhUAf3IwEYuNEFgLPeTJaQMsJU6D+O6wOyCJ4+Iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aniket Limaye <a-limaye@ti.com>,
	Jared McArthur <j-mcarthur@ti.com>,
	Vaishnav Achath <vaishnav.a@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 147/826] arm64: dts: ti: k3-j7200: Fix register map for main domain pmx
Date: Tue,  3 Dec 2024 15:37:54 +0100
Message-ID: <20241203144749.480732590@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jared McArthur <j-mcarthur@ti.com>

[ Upstream commit b7af8b4acb3e08c710cd48f098ce8cd07cf43a1e ]

Commit 0d0a0b441346 ("arm64: dts: ti: k3-j7200: fix main pinmux
range") split the main_pmx0 into two nodes: main_pmx0 and main_pmx1
due to a non-addressable region, but incorrectly represented the
ranges. As a result, the memory map for the pinctrl is incorrect. Fix
this by introducing the correct ranges.

The ranges are taken from the J7200 TRM [1] (Table 5-695. CTRL_MMR0
Registers).

Padconfig starting addresses and ranges:
-  0 to 66: 0x11c000, 0x10c
-       68: 0x11c110, 0x004
- 71 to 73: 0x11c11c, 0x00c
- 89 to 90: 0x11c164, 0x008

The datasheet [2] doesn't contain PADCONFIG63 (Table 6-106. Pin
Multiplexing), but the pin is necessary for enabling the MMC1 CLKLP
pad loopback and should be included in the pinmux register map.

Due to the change in pinmux node addresses, change the pinmux node for
the USB0_DRVVBUS pin to main_pmx2. The offset has not changed since the
new main_pmx2 node has the same base address and range as the original
main_pmx1 node. All other pinmuxing done within J7200 dts or dtso files
only uses main_pmx0 which has not changed.

[1] https://www.ti.com/lit/pdf/spruiu1
[2] https://www.ti.com/lit/gpn/dra821u

Fixes: 0d0a0b441346 ("arm64: dts: ti: k3-j7200: fix main pinmux range")
Signed-off-by: Aniket Limaye <a-limaye@ti.com>
Signed-off-by: Jared McArthur <j-mcarthur@ti.com>
Reviewed-by: Vaishnav Achath <vaishnav.a@ti.com>
Link: https://lore.kernel.org/r/20240926102533.398139-1-a-limaye@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/ti/k3-j7200-common-proc-board.dts     |  2 +-
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi     | 22 +++++++++++++++++--
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts b/arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts
index 6593c5da82c06..df39f2b1ff6ba 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts
+++ b/arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts
@@ -254,7 +254,7 @@ J721E_IOPAD(0x38, PIN_OUTPUT, 0) /* (Y21) MCAN3_TX */
 	};
 };
 
-&main_pmx1 {
+&main_pmx2 {
 	main_usbss0_pins_default: main-usbss0-default-pins {
 		pinctrl-single,pins = <
 			J721E_IOPAD(0x04, PIN_OUTPUT, 0) /* (T4) USB0_DRVVBUS */
diff --git a/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi b/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
index 9386bf3ef9f68..41adfa64418d0 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
@@ -426,10 +426,28 @@ main_pmx0: pinctrl@11c000 {
 		pinctrl-single,function-mask = <0xffffffff>;
 	};
 
-	main_pmx1: pinctrl@11c11c {
+	main_pmx1: pinctrl@11c110 {
 		compatible = "ti,j7200-padconf", "pinctrl-single";
 		/* Proxy 0 addressing */
-		reg = <0x00 0x11c11c 0x00 0xc>;
+		reg = <0x00 0x11c110 0x00 0x004>;
+		#pinctrl-cells = <1>;
+		pinctrl-single,register-width = <32>;
+		pinctrl-single,function-mask = <0xffffffff>;
+	};
+
+	main_pmx2: pinctrl@11c11c {
+		compatible = "ti,j7200-padconf", "pinctrl-single";
+		/* Proxy 0 addressing */
+		reg = <0x00 0x11c11c 0x00 0x00c>;
+		#pinctrl-cells = <1>;
+		pinctrl-single,register-width = <32>;
+		pinctrl-single,function-mask = <0xffffffff>;
+	};
+
+	main_pmx3: pinctrl@11c164 {
+		compatible = "ti,j7200-padconf", "pinctrl-single";
+		/* Proxy 0 addressing */
+		reg = <0x00 0x11c164 0x00 0x008>;
 		#pinctrl-cells = <1>;
 		pinctrl-single,register-width = <32>;
 		pinctrl-single,function-mask = <0xffffffff>;
-- 
2.43.0



