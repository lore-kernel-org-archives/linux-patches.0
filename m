Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D8A12C46D;
	Tue, 30 Apr 2024 10:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474022; cv=none; b=b4D0lmzX07W0ERk2nuBvKYprYuBnk1cOJ1Sad/2iMz/jE4rIyVZwx50iU2Zm3gIcnN0xULKIeCQNaCxYifP5tksB3hpDSTcEUlO5/Tx3RF60c82O6I3nVCIf+DazZODX7OphQxhrfw+6pfrKmEU+HSb2d+AV47Orgzl7Ojrw5no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474022; c=relaxed/simple;
	bh=L1ppSyMdUApVPFpAYDkAgKVH3Tu0tkw7gL7YVQguauY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jkRiw+M3R2U42JqgV4Qn0yFG2N2BEUJNbn6H+QZmJUqxy0sjX4Rrgwn3uCDtAaBBZ1lKkONVQE0O261mB6UP6MAdfew2kLOqLrQS65sGJjtprzxbx3fLPYvUgT3fiV9DLt9YMycySv+jcGcy6bHaSs/z/K9EuoPLw+nzOgrdYFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KrENPTKl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KrENPTKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8A5C2BBFC;
	Tue, 30 Apr 2024 10:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474021;
	bh=L1ppSyMdUApVPFpAYDkAgKVH3Tu0tkw7gL7YVQguauY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KrENPTKl5fvLRin51srDr7ooZ8p3aKouThVV9aEdiAY6Y5LCxFhpt/6cgEFEpTDlw
	 sMDU5iZa+ztOCb3qph3D9L1FDacUjrOlJBWXhgxWhu0ICYiz2oLebp6f+X+I1pt7Mm
	 mxzjErgkVd35W2SaT8p5dpY/VlT4sxy8cfrXd9eE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Luz <luzmaximilian@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 037/228] arm64: dts: qcom: sc8180x: Fix ss_phy_irq for secondary USB controller
Date: Tue, 30 Apr 2024 12:36:55 +0200
Message-ID: <20240430103104.886137896@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maximilian Luz <luzmaximilian@gmail.com>

[ Upstream commit ecda8309098402f878c96184f29a1b7ec682d772 ]

The ACPI DSDT of the Surface Pro X (SQ2) specifies the interrupts for
the secondary UBS controller as

    Name (_CRS, ResourceTemplate ()
    {
        Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
        {
            0x000000AA,
        }
        Interrupt (ResourceConsumer, Level, ActiveHigh, SharedAndWake, ,, )
        {
            0x000000A7,     // hs_phy_irq: &intc GIC_SPI 136
        }
        Interrupt (ResourceConsumer, Level, ActiveHigh, SharedAndWake, ,, )
        {
            0x00000228,     // ss_phy_irq: &pdc 40
        }
        Interrupt (ResourceConsumer, Edge, ActiveHigh, SharedAndWake, ,, )
        {
            0x0000020A,     // dm_hs_phy_irq: &pdc 10
        }
        Interrupt (ResourceConsumer, Edge, ActiveHigh, SharedAndWake, ,, )
        {
            0x0000020B,     // dp_hs_phy_irq: &pdc 11
        }
    })

Generally, the interrupts above 0x200 map to the PDC interrupts (as used
in the devicetree) as ACPI_NUMBER - 0x200. Note that this lines up with
dm_hs_phy_irq and dp_hs_phy_irq (as well as the interrupts for the
primary USB controller).

Based on the snippet above, ss_phy_irq should therefore be PDC 40 (=
0x28) and not PDC 7. The latter is according to ACPI instead used as
ss_phy_irq for port 0 of the multiport USB controller). Fix this by
setting ss_phy_irq to '&pdc 40'.

Fixes: b080f53a8f44 ("arm64: dts: qcom: sc8180x: Add remoteprocs, wifi and usb nodes")
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20240328022224.336938-1-luzmaximilian@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8180x.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x.dtsi b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
index c0dd44f146748..b481c15b255ce 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
@@ -2641,7 +2641,7 @@
 			resets = <&gcc GCC_USB30_SEC_BCR>;
 			power-domains = <&gcc USB30_SEC_GDSC>;
 			interrupts-extended = <&intc GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>,
-					      <&pdc 7 IRQ_TYPE_LEVEL_HIGH>,
+					      <&pdc 40 IRQ_TYPE_LEVEL_HIGH>,
 					      <&pdc 10 IRQ_TYPE_EDGE_BOTH>,
 					      <&pdc 11 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
-- 
2.43.0



