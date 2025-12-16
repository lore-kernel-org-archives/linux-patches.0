Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C899336D4F2;
	Tue, 16 Dec 2025 12:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887489; cv=none; b=Zzze8bHot/47OMX27JDLG3zGOGKAnBK2Jj2jh5uCHivtsgHgaZRUZ1TIw/geOTWSlXcsr+/552x7scpSOjkcQRJ+UtByFHocrh5em6+Y+ueSRIS9ot2ZJfAbNDJioQL4EfBcCbaarcZ7J8CRIk/A3C80mc9zpximdHhlEE2P6Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887489; c=relaxed/simple;
	bh=rXxEmLhuirInjVztVIAqucjlOkuGfpNPoXQdwfWyxJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+b+4YdfX8SOAJGEzAEsOLIQWyNLpu9bvujEzokg59wfsSjxRhBBJLa7QsPyyOufnmIPXgm4fukUvAVbq7GRH6uQvA1/kNK1anIzhKxUG7c3gmBGVPNj0Cc+mnyxusIE1YlkOsssIJL+HrWGElyi7KEfEgfA2/EuDGO8dONNDOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uoz+2vv1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uoz+2vv1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E123C4CEF1;
	Tue, 16 Dec 2025 12:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887489;
	bh=rXxEmLhuirInjVztVIAqucjlOkuGfpNPoXQdwfWyxJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uoz+2vv1+xayz64gzzr4k7zvP7DShXxHVHr03y04kkjNo55jJ97aL9k/P5EvJZsTC
	 Qvtm9fGr+KMrEe/aAnVChAu+skk+P38WdTGU6FZbWDOomwnMwD8jayj02fDibO2s2+
	 WEGbqcXx4Zqx83NK4ZFyewu+An1scyEoRBLzfd4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Bruno Thomsen <bruno.thomsen@gmail.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 203/614] ARM: dts: am33xx: Add missing serial console speed
Date: Tue, 16 Dec 2025 12:09:30 +0100
Message-ID: <20251216111408.733481388@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 9c95fc710b0d05f797db9e26d56524efa74f8978 ]

Without a serial console speed specified in chosen/stdout-path in the
DTB, the serial console uses the default speed of the serial driver,
unless explicitly overridden in a legacy console= kernel command-line
parameter.

After dropping "ti,omap3-uart" from the list of compatible values in DT,
AM33xx serial ports can no longer be used with the legacy OMAP serial
driver, but only with the OMAP-flavored 8250 serial driver (which is
mutually-exclusive with the former).  However, replacing
CONFIG_SERIAL_OMAP=y by CONFIG_SERIAL_8250_OMAP=y (with/without enabling
CONFIG_SERIAL_8250_OMAP_TTYO_FIXUP) may not be sufficient to restore
serial console functionality: the legacy OMAP serial driver defaults to
115200 bps, while the 8250 serial driver defaults to 9600 bps, causing
no visible output on the serial console when no appropriate console=
kernel command-line parameter is specified.

Fix this for all AM33xx boards by adding ":115200n8" to
chosen/stdout-path.  This requires replacing the "&uartN" reference by
the corresponding "serialN" DT alias.

Fixes: ca8be8fc2c306efb ("ARM: dts: am33xx-l4: fix UART compatible")
Fixes: 077e1cde78c3f904 ("ARM: omap2plus_defconfig: Enable 8250_OMAP")
Closes: https://lore.kernel.org/CAMuHMdUb7Jb2=GqK3=Rn+Gv5G9KogcQieqDvjDCkJA4zyX4VcA@mail.gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Matti Vaittinen <mazziesaccount@gmail.com>
Tested-by: Matti Vaittinen <mazziesaccount@gmail.com>
Reviewed-by: Bruno Thomsen <bruno.thomsen@gmail.com>
Link: https://lore.kernel.org/r/63cef5c3643d359e8ec13366ca79377f12dd73b1.1759398641.git.geert+renesas@glider.be
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ti/omap/am335x-bone-common.dtsi   | 2 +-
 arch/arm/boot/dts/ti/omap/am335x-boneblue.dts       | 2 +-
 arch/arm/boot/dts/ti/omap/am335x-chiliboard.dts     | 2 +-
 arch/arm/boot/dts/ti/omap/am335x-evm.dts            | 2 +-
 arch/arm/boot/dts/ti/omap/am335x-evmsk.dts          | 2 +-
 arch/arm/boot/dts/ti/omap/am335x-guardian.dts       | 2 +-
 arch/arm/boot/dts/ti/omap/am335x-icev2.dts          | 2 +-
 arch/arm/boot/dts/ti/omap/am335x-myirtech-myd.dts   | 2 +-
 arch/arm/boot/dts/ti/omap/am335x-osd3358-sm-red.dts | 2 +-
 arch/arm/boot/dts/ti/omap/am335x-pdu001.dts         | 2 +-
 arch/arm/boot/dts/ti/omap/am335x-pocketbeagle.dts   | 2 +-
 arch/arm/boot/dts/ti/omap/am335x-sl50.dts           | 2 +-
 12 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm/boot/dts/ti/omap/am335x-bone-common.dtsi b/arch/arm/boot/dts/ti/omap/am335x-bone-common.dtsi
index ad1e60a9b6fde..b75dabfa56ae7 100644
--- a/arch/arm/boot/dts/ti/omap/am335x-bone-common.dtsi
+++ b/arch/arm/boot/dts/ti/omap/am335x-bone-common.dtsi
@@ -16,7 +16,7 @@ memory@80000000 {
 	};
 
 	chosen {
-		stdout-path = &uart0;
+		stdout-path = "serial0:115200n8";
 	};
 
 	leds {
diff --git a/arch/arm/boot/dts/ti/omap/am335x-boneblue.dts b/arch/arm/boot/dts/ti/omap/am335x-boneblue.dts
index f579df4c2c540..d430f0bef1653 100644
--- a/arch/arm/boot/dts/ti/omap/am335x-boneblue.dts
+++ b/arch/arm/boot/dts/ti/omap/am335x-boneblue.dts
@@ -13,7 +13,7 @@ / {
 	compatible = "ti,am335x-bone-blue", "ti,am33xx";
 
 	chosen {
-		stdout-path = &uart0;
+		stdout-path = "serial0:115200n8";
 	};
 
 	leds {
diff --git a/arch/arm/boot/dts/ti/omap/am335x-chiliboard.dts b/arch/arm/boot/dts/ti/omap/am335x-chiliboard.dts
index 648e97fe1dfd5..ae5bc58984972 100644
--- a/arch/arm/boot/dts/ti/omap/am335x-chiliboard.dts
+++ b/arch/arm/boot/dts/ti/omap/am335x-chiliboard.dts
@@ -12,7 +12,7 @@ / {
 		     "ti,am33xx";
 
 	chosen {
-		stdout-path = &uart0;
+		stdout-path = "serial0:115200n8";
 	};
 
 	leds {
diff --git a/arch/arm/boot/dts/ti/omap/am335x-evm.dts b/arch/arm/boot/dts/ti/omap/am335x-evm.dts
index 20222f82f21bf..856fa1191ed24 100644
--- a/arch/arm/boot/dts/ti/omap/am335x-evm.dts
+++ b/arch/arm/boot/dts/ti/omap/am335x-evm.dts
@@ -23,7 +23,7 @@ memory@80000000 {
 	};
 
 	chosen {
-		stdout-path = &uart0;
+		stdout-path = "serial0:115200n8";
 	};
 
 	vbat: fixedregulator0 {
diff --git a/arch/arm/boot/dts/ti/omap/am335x-evmsk.dts b/arch/arm/boot/dts/ti/omap/am335x-evmsk.dts
index eba888dcd60e7..d8baccdf8bc46 100644
--- a/arch/arm/boot/dts/ti/omap/am335x-evmsk.dts
+++ b/arch/arm/boot/dts/ti/omap/am335x-evmsk.dts
@@ -30,7 +30,7 @@ memory@80000000 {
 	};
 
 	chosen {
-		stdout-path = &uart0;
+		stdout-path = "serial0:115200n8";
 	};
 
 	vbat: fixedregulator0 {
diff --git a/arch/arm/boot/dts/ti/omap/am335x-guardian.dts b/arch/arm/boot/dts/ti/omap/am335x-guardian.dts
index 4b070e634b281..6ce3a2d029eed 100644
--- a/arch/arm/boot/dts/ti/omap/am335x-guardian.dts
+++ b/arch/arm/boot/dts/ti/omap/am335x-guardian.dts
@@ -14,7 +14,7 @@ / {
 	compatible = "bosch,am335x-guardian", "ti,am33xx";
 
 	chosen {
-		stdout-path = &uart0;
+		stdout-path = "serial0:115200n8";
 		tick-timer = &timer2;
 	};
 
diff --git a/arch/arm/boot/dts/ti/omap/am335x-icev2.dts b/arch/arm/boot/dts/ti/omap/am335x-icev2.dts
index 6f0f4fba043b9..ba488bba6925d 100644
--- a/arch/arm/boot/dts/ti/omap/am335x-icev2.dts
+++ b/arch/arm/boot/dts/ti/omap/am335x-icev2.dts
@@ -22,7 +22,7 @@ memory@80000000 {
 	};
 
 	chosen {
-		stdout-path = &uart3;
+		stdout-path = "serial3:115200n8";
 	};
 
 	vbat: fixedregulator0 {
diff --git a/arch/arm/boot/dts/ti/omap/am335x-myirtech-myd.dts b/arch/arm/boot/dts/ti/omap/am335x-myirtech-myd.dts
index 06a352f98b220..476a6bdaf43f3 100644
--- a/arch/arm/boot/dts/ti/omap/am335x-myirtech-myd.dts
+++ b/arch/arm/boot/dts/ti/omap/am335x-myirtech-myd.dts
@@ -15,7 +15,7 @@ / {
 	compatible = "myir,myd-am335x", "myir,myc-am335x", "ti,am33xx";
 
 	chosen {
-		stdout-path = &uart0;
+		stdout-path = "serial0:115200n8";
 	};
 
 	clk12m: clk12m {
diff --git a/arch/arm/boot/dts/ti/omap/am335x-osd3358-sm-red.dts b/arch/arm/boot/dts/ti/omap/am335x-osd3358-sm-red.dts
index d28d397288476..23caaaabf3513 100644
--- a/arch/arm/boot/dts/ti/omap/am335x-osd3358-sm-red.dts
+++ b/arch/arm/boot/dts/ti/omap/am335x-osd3358-sm-red.dts
@@ -147,7 +147,7 @@ simple-audio-card,codec {
 	};
 
 	chosen {
-		stdout-path = &uart0;
+		stdout-path = "serial0:115200n8";
 	};
 
 	leds {
diff --git a/arch/arm/boot/dts/ti/omap/am335x-pdu001.dts b/arch/arm/boot/dts/ti/omap/am335x-pdu001.dts
index c9ccb9de21ad7..9f611debc2090 100644
--- a/arch/arm/boot/dts/ti/omap/am335x-pdu001.dts
+++ b/arch/arm/boot/dts/ti/omap/am335x-pdu001.dts
@@ -21,7 +21,7 @@ / {
 	compatible = "ti,am33xx";
 
 	chosen {
-		stdout-path = &uart3;
+		stdout-path = "serial3:115200n8";
 	};
 
 	cpus {
diff --git a/arch/arm/boot/dts/ti/omap/am335x-pocketbeagle.dts b/arch/arm/boot/dts/ti/omap/am335x-pocketbeagle.dts
index 78ce860e59b3d..24d9f90fad01f 100644
--- a/arch/arm/boot/dts/ti/omap/am335x-pocketbeagle.dts
+++ b/arch/arm/boot/dts/ti/omap/am335x-pocketbeagle.dts
@@ -15,7 +15,7 @@ / {
 	compatible = "ti,am335x-pocketbeagle", "ti,am335x-bone", "ti,am33xx";
 
 	chosen {
-		stdout-path = &uart0;
+		stdout-path = "serial0:115200n8";
 	};
 
 	leds {
diff --git a/arch/arm/boot/dts/ti/omap/am335x-sl50.dts b/arch/arm/boot/dts/ti/omap/am335x-sl50.dts
index f3524e5ee43e2..1dc4e344efd63 100644
--- a/arch/arm/boot/dts/ti/omap/am335x-sl50.dts
+++ b/arch/arm/boot/dts/ti/omap/am335x-sl50.dts
@@ -25,7 +25,7 @@ memory@80000000 {
 	};
 
 	chosen {
-		stdout-path = &uart0;
+		stdout-path = "serial0:115200n8";
 	};
 
 	leds {
-- 
2.51.0



