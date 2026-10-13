Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932FC4EF135;
	Tue, 13 Oct 2026 11:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892459; cv=none; b=H5s7Z3+S6e9kdFiRGJuZG5oRk0IN/f+SUaNOgCnP0FDanYmbDEwQ/7wBOS1EyQDwRPjnMux3rVN2qIsuDXVyKhEGe9A/8oGS0ac0dW6DiMZaszscP1h8rHr01DogQCruH7TSn1ov2qFoh16ZXMZEaY3on286XpjBBDsRLIhcM94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892459; c=relaxed/simple;
	bh=AHpqDbGWclwdfzA9HHD7Kx9CGqJ8G4+rEe+aW0vNeUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkcKa82CeX62OvkpKsObcWNZTQT2Tvv1REmXj5JBbsU1T9tiNQWgOSaXlU+DukGFe9O/3W50E1BVkQlnFKgshq7vt+JU4iNB+SBO6vp77eJxu6S0UEoqaWG8iTqmqVQ3bw65bbHeOvoZnzCAW8OnufQ/7ZQjZ9qzzUBwfMelhxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uHigQ2Q1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uHigQ2Q1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF38E1F000FF;
	Tue, 13 Oct 2026 11:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892458;
	bh=sn5QbhK7bxQBzZskpIZ4mnY7C1sRNiRvCal72F1ylF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uHigQ2Q1siVfAgJtPF1bRB6QN2F5KAc1mUadZH+oQCksZBEGTabBcSiFmemCZoZy0
	 6NDVpr3XMTHJkbmIPp1c+rLhIRj/KAV2BIN9pwUPjbeYN01VYC7+nsyQ+LyHqwEemC
	 y8s4gUZhxPrxTMdGW1Qy+TekGgBpDdIghP7VxNog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Jardin <vjardin@free.fr>,
	Josua Mayer <josua@solid-run.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 181/281] arm64: dts: lx2160a: fix IIC1 pinmux submask rejected by pinctrl-single
Date: Tue, 13 Oct 2026 13:38:17 +0200
Message-ID: <20261013112859.559006348@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Jardin <vjardin@free.fr>

[ Upstream commit 6affdda171ca8f2e082e8c4fba56233a2f8c9910 ]

IIC1_PMUX is a single bit field at RCWSR14 bit 10, so the mask for the
two iic1 pinmux nodes was narrowed from 0x7 to 0x1 to avoid writing the
two reserved bits next to it.

With pinctrl-single,bit-per-mux the driver does not take the supplied
mask as the bits to modify. It derives the field from the node's
pinctrl-single,function-mask, which is 0x7 here, and then requires the
supplied mask to match it exactly:

	bit_pos = __ffs(mask);			/* 10 */
	mask_pos = ((pcs->fmask) << bit_pos);	/* 0x7 << 10 = 0x1c00 */
	submask = mask & mask_pos;		/* 0x400 */
	...
	if (submask != mask_pos) {
		dev_warn(pcs->dev,
			 "Invalid submask 0x%x for %pOFn at 0x%x\n",
			 submask, np, offset);
		continue;
	}

A one bit mask gives submask 0x400 against mask_pos 0x1c00, so both
nodes are rejected and the pins are never muxed with this message:

  pinctrl-single 70010012c.pinmux: Invalid submask 0x400 for iic1-i2c-pins
  pinctrl-single 70010012c.pinmux: Invalid submask 0x400 for iic1-gpio-pins

The values are not changed:
  - 0x0 selects IIC1
  - 0x1 << 10 selects GPIO_1[3:2].

Fixes: 7a3cc49ad1fc ("arm64: dts: lx2160a: change i2c0 (iic1) pinmux mask to one bit")
Signed-off-by: Vincent Jardin <vjardin@free.fr>
Reviewed-by: Josua Mayer <josua@solid-run.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
index b9f079c49e193..8f33dd26577fa 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
@@ -1868,12 +1868,19 @@ i2c6_i2c7_pins: iic8-iic7-i2c-pins {
 			};
 
 			/* RCWSR14 */
+			/*
+			 * IIC1_PMUX is a single bit at RCWSR14[10], but bit-per-mux
+			 * uses the mask for the field to clear before applying the
+			 * value.
+			 * So bits 11 and 12, which are reserved, are written as 0
+			 * on every mux switch, it is harmless.
+			 */
 			i2c0_pins: iic1-i2c-pins {
-				pinctrl-single,bits = <0x8 0x0 (0x1 << 10)>;
+				pinctrl-single,bits = <0x8 0x0 (0x7 << 10)>;
 			};
 
 			gpio0_3_2_pins: iic1-gpio-pins {
-				pinctrl-single,bits = <0x8 (0x1 << 10) (0x1 << 10)>;
+				pinctrl-single,bits = <0x8 (0x1 << 10) (0x7 << 10)>;
 			};
 		};
 
-- 
2.53.0



