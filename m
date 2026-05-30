Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A0E344DB9;
	Sat, 30 May 2026 17:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162919; cv=none; b=CKmfQqmJM1eKmb/wVQvuYsKgaFPdkCZ0eVubTeVANo5QV/lVstuXIctZFskwOq99RkewKM7xZNZmEFZoCSvZJjBjLYVDzwtbcG79o4EvNdjdVY06HbtE2hyKhrZLuS1S1uNafR+OL5qGuEVR3ZTVQJsjrHedfRISc8Zev0/61Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162919; c=relaxed/simple;
	bh=GKC1fRcx+uyciryTwZivVjT0DntpB7znw2fsXqgy7F8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0KBcvZxn0Oku/+6veH5ySux+qk0EeX+txjgB+xwtrJ756SISw/Z8s7GOIxt2iVF54eWNDpke4ZGApIPELeyI+qQQiwkpoL2krWSzCSuWLQ+p86pcgIYLbJH4E5jTtI1odOvdRqbklPkB8P+hICC9vXM6DXzuoRsdu0RiS18Nu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OF4Mqe/9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OF4Mqe/9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F91C1F00893;
	Sat, 30 May 2026 17:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162918;
	bh=1yf4VnxMTF+wZdboUtVHKLKglx5ZelTGQMHqgGZfRz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OF4Mqe/9gnRYO1Dyk0ietci4+a65W2OeFa9erahdyUuxUKsflQrhR32T4H63F2xzB
	 E7SVDb2pyum76biJYv9fM3jDzMXnj/3YMdDGpiJ0TU0m2X38aDvDOf80tiiDO0xv2g
	 Y4gpLwaMaFJBE7JrENh0rSboShMJg00lH94Zgn+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
	Martin Kepplinger <martin.kepplinger@puri.sm>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/776] arm64: dts: imx8mq-librem5: Set the DVS voltages lower
Date: Sat, 30 May 2026 17:56:55 +0200
Message-ID: <20260530160242.953415553@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>

[ Upstream commit c24a9b698fb02cd0723fa8375abab07f94b97b10 ]

They're still in the operating range according to i.MX 8M Quad
datasheet. There's some headroom added over minimal values to
account for voltage drop.

Operational ranges (min - typ - max [selected]):
 - VDD_SOC (BUCK1): 0.81 - 0.9 - 0.99 [0.88]
 - VDD_ARM (BUCK2): 0.81 - 0.9 - 1.05 [0.84] (1000MHz)
                    0.90 - 1.0 - 1.05 [0.93] (1500MHz)
 - VDD_GPU (BUCK3): 0.81 - 0.9 - 1.05 [0.85] (800MHz)
                    0.90 - 1.0 - 1.05 [ -- ] (1000MHz)
 - VDD_VPU (BUCK4): 0.81 - 0.9 - 1.05 [ -- ] (550/500/588MHz)
                    0.90 - 1.0 - 1.05 [0.93] (660/600/800MHz)

Idle power consumption doesn't appear to be influenced much,
but a simple load test (`cat /dev/urandom | pigz - > /dev/null`
combined with running Animatch) seems to show about 0.3W of
difference.

Care is advised, as there may be differences between each
units in how low can they be undervolted - in my experience,
reaching that point usually makes the phone fail to boot.
In my case, it appears that my Birch phone can go down the most.

This is a somewhat conservative set of values that I've seen
working well on all my devices; I haven't tried very hard to
optimize it, so more experiments are welcome.

Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: 511f76bf1dce ("arm64: dts: imx8mq-librem5: Bump BUCK1 suspend voltage up to 0.85V")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mq-librem5-r3.dts |    2 -
 arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi   |   22 ++++++++++++++------
 2 files changed, 17 insertions(+), 7 deletions(-)

--- a/arch/arm64/boot/dts/freescale/imx8mq-librem5-r3.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mq-librem5-r3.dts
@@ -12,7 +12,7 @@
 
 &a53_opp_table {
 	opp-1000000000 {
-		opp-microvolt = <1000000>;
+		opp-microvolt = <950000>;
 	};
 };
 
--- a/arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi
@@ -704,8 +704,8 @@
 				regulator-max-microvolt = <1300000>;
 				regulator-boot-on;
 				regulator-ramp-delay = <1250>;
-				rohm,dvs-run-voltage = <900000>;
-				rohm,dvs-idle-voltage = <850000>;
+				rohm,dvs-run-voltage = <880000>;
+				rohm,dvs-idle-voltage = <820000>;
 				rohm,dvs-suspend-voltage = <800000>;
 				regulator-always-on;
 			};
@@ -716,8 +716,8 @@
 				regulator-max-microvolt = <1300000>;
 				regulator-boot-on;
 				regulator-ramp-delay = <1250>;
-				rohm,dvs-run-voltage = <1000000>;
-				rohm,dvs-idle-voltage = <900000>;
+				rohm,dvs-run-voltage = <950000>;
+				rohm,dvs-idle-voltage = <850000>;
 				regulator-always-on;
 			};
 
@@ -726,14 +726,14 @@
 				regulator-min-microvolt = <700000>;
 				regulator-max-microvolt = <1300000>;
 				regulator-boot-on;
-				rohm,dvs-run-voltage = <900000>;
+				rohm,dvs-run-voltage = <850000>;
 			};
 
 			buck4_reg: BUCK4 {
 				regulator-name = "buck4";
 				regulator-min-microvolt = <700000>;
 				regulator-max-microvolt = <1300000>;
-				rohm,dvs-run-voltage = <1000000>;
+				rohm,dvs-run-voltage = <930000>;
 			};
 
 			buck5_reg: BUCK5 {
@@ -1214,3 +1214,13 @@
 	fsl,ext-reset-output;
 	status = "okay";
 };
+
+&a53_opp_table {
+	opp-1000000000 {
+		opp-microvolt = <850000>;
+	};
+
+	opp-1500000000 {
+		opp-microvolt = <950000>;
+	};
+};


