Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAB32ED150;
	Tue, 17 Jun 2025 16:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177809; cv=none; b=ZJHH+UHT7hULjOrcJ4is/HbNUO3whIae1LKZY8RQUpjLDYzMaxsHrPdB9pBEc67p2+K7DqyTzAE21xUL2nlAddBjPRV59EHII0R6iPBQdDEAPgHBBZo7XI8bOEyXNOfkb3XLU1h5SPqjpx8raHu9EqgZyy8VDC9TuTEjUuctD7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177809; c=relaxed/simple;
	bh=rhxqsohmuJ7rhhQmMqj630Qm3QH607dQ8N24Ou4ZxV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XSFXRTP7PRHX8C1fs9OZupAaSWYdIlEixLPAK3DWZD2L/xBDE7VLIblvUcD/MgEOrGpIGkWw5E2Tb+LC4lUmJG3ICj6BHdVX+0CCXPP3u4msa8cO33KxlfibneStVpWJDKDyGaSnFVDLJFK0/9Ne+25kds57gFozXP6IWkmDsW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mRLqetRc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mRLqetRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3BF7C4CEE3;
	Tue, 17 Jun 2025 16:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177809;
	bh=rhxqsohmuJ7rhhQmMqj630Qm3QH607dQ8N24Ou4ZxV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mRLqetRcO9o+PwHAxGWFL9SOAAQo9XLO2Dei5MGFGB+kKbK5+T510zfZv6TOXPS+U
	 8TuIpBqq4LZWP6ZHn+jV2jc1q2FIG0TnCgEaFr8tC10GD0kutuzvBmGSIVjni4gbN5
	 1kkUJDMniolj00DlN7NhAfFQM16A4XgrkNAIxycg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Jason-JH Lin <jason-jh.lin@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 366/780] arm64: dts: mediatek: mt8188: Fix IOMMU device for rdma0
Date: Tue, 17 Jun 2025 17:21:14 +0200
Message-ID: <20250617152506.359008786@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 267623000d11f6d483214be2484555f600393a12 ]

Based on the comments in the MT8188 IOMMU binding header, the rdma0
device specifies the wrong IOMMU device for the IOMMU port it is
tied to:

    This SoC have two MM IOMMU HWs, this is the connected information:
    iommu-vdo: larb0/2/5/9/10/11A/11C/13/16B/17B/19/21
    iommu-vpp: larb1/3/4/6/7/11B/12/14/15/16A/17A/23/27

rdma0's endpoint is M4U_PORT_L1_DISP_RDMA0 (on larb1), which should use
iommu-vpp, but it is currently tied to iommu-vdo.

Somehow this went undetected until recently in Linux v6.15-rc1 with some
IOMMU subsystem framework changes that caused the IOMMU to no longer
work. The IOMMU would fail to probe if any devices associated with it
could not be successfully attached. Prior to these changes, only the
end device would be left without an IOMMU attached.

Fixes: 7075b21d1a8e ("arm64: dts: mediatek: mt8188: Add display nodes for vdosys0")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Jason-JH Lin <jason-jh.lin@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20250408092303.3563231-1-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8188.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8188.dtsi b/arch/arm64/boot/dts/mediatek/mt8188.dtsi
index 69a8423d38589..29d35ca945973 100644
--- a/arch/arm64/boot/dts/mediatek/mt8188.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8188.dtsi
@@ -2579,7 +2579,7 @@
 			reg = <0 0x1c002000 0 0x1000>;
 			clocks = <&vdosys0 CLK_VDO0_DISP_RDMA0>;
 			interrupts = <GIC_SPI 638 IRQ_TYPE_LEVEL_HIGH 0>;
-			iommus = <&vdo_iommu M4U_PORT_L1_DISP_RDMA0>;
+			iommus = <&vpp_iommu M4U_PORT_L1_DISP_RDMA0>;
 			power-domains = <&spm MT8188_POWER_DOMAIN_VDOSYS0>;
 			mediatek,gce-client-reg = <&gce0 SUBSYS_1c00XXXX 0x2000 0x1000>;
 
-- 
2.39.5



