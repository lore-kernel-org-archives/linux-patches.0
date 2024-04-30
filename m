Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755E41E50A;
	Tue, 30 Apr 2024 11:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475398; cv=none; b=bOzBtgdik/fkRPIJDSvODlwFguncftOOe+0kg9snzcET0EnfdNaXJvo7gTRTDjKmdzEuz5A1Bz3u/H3jq0/ZqDLNxiko4K9wBAgeQ/YsXMikmlI15woT318t21IOH37Z9iubPe+anjItpxmD3pPcz9DxtSVr92DxMVmyxLA1OsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475398; c=relaxed/simple;
	bh=0OrvmGWLHO2gG0AIluVW6p62FWMK7ETXVKYQFb6GZBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acpTFZDe53TH56wUJhMDyoxFvCv/127EpIMY/cKmpuTueMjEQ/ZmvHuatyVBIeHVp4iPfWQbY6x4Ck1AxsqLUDf4/VyK+7/rtrls8DcCmZwqnZGBUxs/hbB8VSBVrGkFnw8eVU1/8J5VjBaycU9CgBM8NU5BqiaELPQOFocM8qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=00+Wn3u+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="00+Wn3u+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D79C2BBFC;
	Tue, 30 Apr 2024 11:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475398;
	bh=0OrvmGWLHO2gG0AIluVW6p62FWMK7ETXVKYQFb6GZBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=00+Wn3u+2gv10RQSgPCa1aMSpBhF7cABKMnI2Fxk3y8D16zUjMlyXNBfohvBL1Rao
	 g/1X0M8QtblNDAs/rHIr/QUZ92owhumk4p7hpapSPmKtGmaFe8KaFtyihokpAjqB+5
	 VCinxlzQQfWiLcfZ6bupTanXo0W7ukV/4Kd8nVBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Luz <luzmaximilian@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/186] arm64: dts: qcom: sc8180x: Fix ss_phy_irq for secondary USB controller
Date: Tue, 30 Apr 2024 12:38:05 +0200
Message-ID: <20240430103058.991801832@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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
index 6eb4c5eb6bb8c..fbb9bf09078a0 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
@@ -2644,7 +2644,7 @@
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



