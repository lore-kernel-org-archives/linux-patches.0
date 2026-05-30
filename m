Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A8F2F8EB5;
	Sat, 30 May 2026 16:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159341; cv=none; b=fTvGIb8GerpyB5NxXwy1MYz0Jm9YZ1U1JnZ7Fxgx2WVkmiU2GbsYAw4uu8UXOo2teyHP/LbaFWX6evbCjCe8ocbtIHyFikEP3CfoWR2q6R6ZwLG++VI6jDD60CgzoYfE2CI5qButaOiLL8J3UuZeM4mkDPzBIoFYLm7frwtiKFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159341; c=relaxed/simple;
	bh=Zusm+AcPc5LaaopnxZJUgEbU1x8O38af8u7BuY44qTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yh1guNB9K4lJhM5wzukVdBQv76PSVv5psEGcXHV9Bscq8KCt8C3sz6r8gg2ZMJr2OqtdhAFU2rzDbWAU1uSnqBGg1O9tLzT3CFN+wectGWrQsyOWX2+zJY5THhHe1R0qM4P0kWipXUk5Dm0UtS9dKtBVCp22XwnB6YA1WTY6+Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lvRHalHA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lvRHalHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1411F00893;
	Sat, 30 May 2026 16:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159339;
	bh=dR+q+c9mzWKzrWD5nRcyh3E24D3+gFAA6f6MUtOIyI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lvRHalHAT3VVUhzQJckj/FLzFKHLtCJtIG6lknNzMcZb3+BhsStCRpHiBUckuwjEI
	 Sk4hODFYQkmFL+Yn2CfwogVUMaS6i4tx2ZMSxuPkQCLcHfyIvaV/KkwmyHD9+fuwVX
	 tmT4CC092+CEEdoWmKNUXJgu5cdt2ia1khYqu5IU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
	Martin Kepplinger <martin.kepplinger@puri.sm>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 117/969] arm64: dts: imx8mq-librem5: Set the DVS voltages lower
Date: Sat, 30 May 2026 17:54:01 +0200
Message-ID: <20260530160303.541760471@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7,7 +7,7 @@
 
 &a53_opp_table {
 	opp-1000000000 {
-		opp-microvolt = <1000000>;
+		opp-microvolt = <950000>;
 	};
 };
 
--- a/arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi
@@ -819,8 +819,8 @@
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
@@ -831,8 +831,8 @@
 				regulator-max-microvolt = <1300000>;
 				regulator-boot-on;
 				regulator-ramp-delay = <1250>;
-				rohm,dvs-run-voltage = <1000000>;
-				rohm,dvs-idle-voltage = <900000>;
+				rohm,dvs-run-voltage = <950000>;
+				rohm,dvs-idle-voltage = <850000>;
 				regulator-always-on;
 			};
 
@@ -841,14 +841,14 @@
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
@@ -1379,3 +1379,13 @@
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


