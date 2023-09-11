Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391771170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:03:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5102AC433C7;
	Mon, 11 Sep 2023 14:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441023;
	bh=MT4aR1hC/iPNxbXOFQNjU2Gj0HzNbCNbEQ9d6Qmb6VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUULmCLLBdqzdTNh2uCAlZQEZA49LXSoc5sO0qTPmMiebCxv/GrIKj0mPi63/c9Uh
	 v2aV2O3uNdCp777/RE/weo/BU/diC0kUqL3fjtzczbR7ewXEkx8jVkkUzPsyqXLko1
	 GybRHaI90vLyAh0x6to8wBeAnm9pvdERqQhDVjdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 269/739] ARM: dts: BCM53573: Fix Ethernet info for Luxul devices
Date: Mon, 11 Sep 2023 15:41:08 +0200
Message-ID: <20230911134658.645604376@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 44ad8207806973f4e4f7d870fff36cc01f494250 ]

Both Luxul's XAP devices (XAP-810 and XAP-1440) are access points that
use a non-default design. They don't include switch but have a single
Ethernet port and BCM54210E PHY connected to the Ethernet controller's
MDIO bus.

Support for those devices regressed due to two changes:

1. Describing MDIO bus with switch
After commit 9fb90ae6cae7 ("ARM: dts: BCM53573: Describe on-SoC BCM53125
rev 4 switch") Linux stopped probing for MDIO devices.

2. Dropping hardcoded BCM54210E delays
In commit fea7fda7f50a ("net: phy: broadcom: Fix RGMII delays
configuration for BCM54210E") support for other PHY modes was added but
that requires a proper "phy-mode" value in DT.

Both above changes are correct (they don't need to be reverted or
anything) but they need this fix for DT data to be correct and for Linux
to work properly.

Fixes: 9fb90ae6cae7 ("ARM: dts: BCM53573: Describe on-SoC BCM53125 rev 4 switch")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Link: https://lore.kernel.org/r/20230713111145.14864-1-zajec5@gmail.com
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/broadcom/bcm47189-luxul-xap-1440.dts   | 13 +++++++++++++
 .../boot/dts/broadcom/bcm47189-luxul-xap-810.dts    | 13 +++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/arch/arm/boot/dts/broadcom/bcm47189-luxul-xap-1440.dts b/arch/arm/boot/dts/broadcom/bcm47189-luxul-xap-1440.dts
index b9dd508444198..0f6d7fe30068f 100644
--- a/arch/arm/boot/dts/broadcom/bcm47189-luxul-xap-1440.dts
+++ b/arch/arm/boot/dts/broadcom/bcm47189-luxul-xap-1440.dts
@@ -45,3 +45,16 @@ button-restart {
 		};
 	};
 };
+
+&gmac0 {
+	phy-mode = "rgmii";
+	phy-handle = <&bcm54210e>;
+
+	mdio {
+		/delete-node/ switch@1e;
+
+		bcm54210e: ethernet-phy@0 {
+			reg = <0>;
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/broadcom/bcm47189-luxul-xap-810.dts b/arch/arm/boot/dts/broadcom/bcm47189-luxul-xap-810.dts
index cb22ae2a02e54..4e0ef0af726f5 100644
--- a/arch/arm/boot/dts/broadcom/bcm47189-luxul-xap-810.dts
+++ b/arch/arm/boot/dts/broadcom/bcm47189-luxul-xap-810.dts
@@ -81,3 +81,16 @@ pcie0_chipcommon: chipcommon@0 {
 		};
 	};
 };
+
+&gmac0 {
+	phy-mode = "rgmii";
+	phy-handle = <&bcm54210e>;
+
+	mdio {
+		/delete-node/ switch@1e;
+
+		bcm54210e: ethernet-phy@0 {
+			reg = <0>;
+		};
+	};
+};
-- 
2.40.1



