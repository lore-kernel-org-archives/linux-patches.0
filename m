Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840EBFC06;
	Mon, 11 Dec 2023 18:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Epbe/H4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C51C433C7;
	Mon, 11 Dec 2023 18:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319646;
	bh=OF95zCORqoN0TgUGTueri3x1NY6YZDoMMCvs67cCk+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Epbe/H4zaRrwXx3ay85PIF11z+4t5Fe4ls7ei734QQO+oQde+gCzGoqwQA98BuXNB
	 /kVJ16dJx+AwHi+t8zCqxiVe1TT7MpEIX2vhO/8jl0pH7abB0jo8+jgNmEjJ35zJG4
	 qgOdNAfuCPzX1jf9LajgmfhJHPAyD38DrOptNc70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Mergnat <amergnat@baylibre.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 6.6 183/244] arm64: dts: mediatek: mt8195: Fix PM suspend/resume with venc clocks
Date: Mon, 11 Dec 2023 19:21:16 +0100
Message-ID: <20231211182054.141588141@linuxfoundation.org>
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

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

commit 61b94d54421a1f3670ddd5396ec70afe833e9405 upstream.

Before suspending the LARBs we're making sure that any operation is
done: this never happens because we are unexpectedly unclocking the
LARB20 before executing the suspend handler for the MediaTek Smart
Multimedia Interface (SMI) and the cause of this is incorrect clocks
on this LARB.

Fix this issue by changing the Local Arbiter 20 (used by the video
encoder secondary core) apb clock to CLK_VENC_CORE1_VENC;
furthermore, in order to make sure that both the PM resume and video
encoder operation is stable, add the CLK_VENC(_CORE1)_LARB clock to
the VENC (main core) and VENC_CORE1 power domains, as this IP cannot
communicate with the rest of the system (the AP) without local
arbiter clocks being operational.

Cc: stable@vger.kernel.org
Fixes: 3b5838d1d82e ("arm64: dts: mt8195: Add iommu and smi nodes")
Fixes: 2b515194bf0c ("arm64: dts: mt8195: Add power domains controller")
Reviewed-by: Alexandre Mergnat <amergnat@baylibre.com>
Link: https://lore.kernel.org/r/20230706095841.109315-1-angelogioacchino.delregno@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -627,6 +627,8 @@
 
 					power-domain@MT8195_POWER_DOMAIN_VENC_CORE1 {
 						reg = <MT8195_POWER_DOMAIN_VENC_CORE1>;
+						clocks = <&vencsys_core1 CLK_VENC_CORE1_LARB>;
+						clock-names = "venc1-larb";
 						mediatek,infracfg = <&infracfg_ao>;
 						#power-domain-cells = <0>;
 					};
@@ -689,6 +691,8 @@
 
 						power-domain@MT8195_POWER_DOMAIN_VENC {
 							reg = <MT8195_POWER_DOMAIN_VENC>;
+							clocks = <&vencsys CLK_VENC_LARB>;
+							clock-names = "venc0-larb";
 							mediatek,infracfg = <&infracfg_ao>;
 							#power-domain-cells = <0>;
 						};
@@ -2665,7 +2669,7 @@
 			reg = <0 0x1b010000 0 0x1000>;
 			mediatek,larb-id = <20>;
 			mediatek,smi = <&smi_common_vpp>;
-			clocks = <&vencsys_core1 CLK_VENC_CORE1_LARB>,
+			clocks = <&vencsys_core1 CLK_VENC_CORE1_VENC>,
 				 <&vencsys_core1 CLK_VENC_CORE1_GALS>,
 				 <&vppsys0 CLK_VPP0_GALS_VDO0_VDO1_VENCSYS_CORE1>;
 			clock-names = "apb", "smi", "gals";


