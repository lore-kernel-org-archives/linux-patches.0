Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB67C2D0;
	Mon, 11 Dec 2023 18:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yca9R87d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4E7C433CC;
	Mon, 11 Dec 2023 18:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319539;
	bh=QUzUYAgT13a0Yg7otm2b7FjdOe36FSs3eUwbPxGpT7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yca9R87dJsaAO4TXbf9foeGaHbcrL26vx8KBuaMvDlYK3xkGuuVvW9I49mBO3z0zf
	 /yAbJOMFYTp8Ioym9zciDdTj048jXqetjuCt8PEsnBplWaelY1IdSVr49I4PZq7JIm
	 chzqK8JSSfrUqchxgkVhh8RjbSOTJ2i7uJgIG9X4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Rossi <nathan.rossi@digi.com>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 113/244] arm64: dts: imx8mp: imx8mq: Add parkmode-disable-ss-quirk on DWC3
Date: Mon, 11 Dec 2023 19:20:06 +0100
Message-ID: <20231211182050.867671338@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Nathan Rossi <nathan.rossi@digi.com>

[ Upstream commit 209043cf092d7b0d4739921b3f11d6d0b451eabf ]

The i.MX8MP and i.MX8MQ devices both use the same DWC3 controller and
are both affected by a known issue with the controller due to specific
behaviour when park mode is enabled in SuperSpeed host mode operation.

Under heavy USB traffic from multiple endpoints the controller will
sometimes incorrectly process transactions such that some transactions
are lost, or the controller may hang when processing transactions. When
the controller hangs it does not recover.

This issue is documented partially within the linux-imx vendor kernel
which references a Synopsys STAR number 9001415732 in commits [1] and
additional details in [2]. Those commits provide some additional
controller internal implementation specifics around the incorrect
behaviour of the SuperSpeed host controller operation when park mode is
enabled.

The summary of this issue is that the host controller can incorrectly
enter/exit park mode such that part of the controller is in a state
which behaves as if in park mode even though it is not. In this state
the controller incorrectly calculates the number of TRBs available which
results in incorrect access of the internal caches causing the overwrite
of pending requests in the cache which should have been processed but
are ignored. This can cause the controller to drop the requests or hang
waiting for the pending state of the dropped requests.

The workaround for this issue is to disable park mode for SuperSpeed
operation of the controller through the GUCTL1[17] bit. This is already
available as a quirk for the DWC3 controller and can be enabled via the
'snps,parkmode-disable-ss-quirk' device tree property.

It is possible to replicate this failure on an i.MX8MP EVK with a USB
Hub connecting 4 SuperSpeed USB flash drives. Performing continuous
small read operations (dd if=/dev/sd... of=/dev/null bs=16) on the block
devices will result in device errors initially and will eventually
result in the controller hanging.

  [13240.896936] xhci-hcd xhci-hcd.0.auto: WARN Event TRB for slot 4 ep 2 with no TDs queued?
  [13240.990708] usb 2-1.3: reset SuperSpeed USB device number 5 using xhci-hcd
  [13241.015582] sd 2:0:0:0: [sdc] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=DRIVER_OK cmd_age=0s
  [13241.025198] sd 2:0:0:0: [sdc] tag#0 CDB: opcode=0x28 28 00 00 00 03 e0 00 01 00 00
  [13241.032949] I/O error, dev sdc, sector 992 op 0x0:(READ) flags 0x80700 phys_seg 25 prio class 2
  [13272.150710] usb 2-1.2: reset SuperSpeed USB device number 4 using xhci-hcd
  [13272.175469] sd 1:0:0:0: [sdb] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x03 driverbyte=DRIVER_OK cmd_age=31s
  [13272.185365] sd 1:0:0:0: [sdb] tag#0 CDB: opcode=0x28 28 00 00 00 03 e0 00 01 00 00
  [13272.193385] I/O error, dev sdb, sector 992 op 0x0:(READ) flags 0x80700 phys_seg 18 prio class 2
  [13434.846556] xhci-hcd xhci-hcd.0.auto: xHCI host not responding to stop endpoint command
  [13434.854592] xhci-hcd xhci-hcd.0.auto: xHCI host controller not responding, assume dead
  [13434.862553] xhci-hcd xhci-hcd.0.auto: HC died; cleaning up

[1] https://github.com/nxp-imx/linux-imx/commit/97a5349d936b08cf301730b59e4e8855283f815c
[2] https://github.com/nxp-imx/linux-imx/commit/b4b5cbc5a12d7c3b920d1d7cba0ada3379e4e42b

Fixes: fb8587a2c165 ("arm64: dtsi: imx8mp: add usb nodes")
Fixes: ad37549cb5dc ("arm64: dts: imx8mq: add USB nodes")
Signed-off-by: Nathan Rossi <nathan.rossi@digi.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp.dtsi | 2 ++
 arch/arm64/boot/dts/freescale/imx8mq.dtsi | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp.dtsi b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
index 83d907294fbc7..4b50920ac2049 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -2030,6 +2030,7 @@
 				phys = <&usb3_phy0>, <&usb3_phy0>;
 				phy-names = "usb2-phy", "usb3-phy";
 				snps,gfladj-refclk-lpm-sel-quirk;
+				snps,parkmode-disable-ss-quirk;
 			};
 
 		};
@@ -2072,6 +2073,7 @@
 				phys = <&usb3_phy1>, <&usb3_phy1>;
 				phy-names = "usb2-phy", "usb3-phy";
 				snps,gfladj-refclk-lpm-sel-quirk;
+				snps,parkmode-disable-ss-quirk;
 			};
 		};
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mq.dtsi b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
index 35f07dfb4ca8d..052ba9baa400f 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
@@ -1649,6 +1649,7 @@
 			phys = <&usb3_phy0>, <&usb3_phy0>;
 			phy-names = "usb2-phy", "usb3-phy";
 			power-domains = <&pgc_otg1>;
+			snps,parkmode-disable-ss-quirk;
 			status = "disabled";
 		};
 
@@ -1680,6 +1681,7 @@
 			phys = <&usb3_phy1>, <&usb3_phy1>;
 			phy-names = "usb2-phy", "usb3-phy";
 			power-domains = <&pgc_otg2>;
+			snps,parkmode-disable-ss-quirk;
 			status = "disabled";
 		};
 
-- 
2.42.0



