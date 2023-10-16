Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7450266B7
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="faoWUm7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF19C433C9;
	Mon, 16 Oct 2023 14:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467752;
	bh=9IzBizbWT76iGzgZa479s0np2tCYNE1lSrd+Lu6EO/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=faoWUm7+L32Pdz6BsRf8BTq3JkGdN/np2L4eAXlGolXdaEuCqs2Njd/B2Mzpi0sRa
	 YJwRCkoO+Bne5zFod9JYaiiKCHgYG+JBy8NbgDD8X7d8t0fkglJY2TxSztvfWWQke5
	 0ixQ8lryaJdkpktXfDn+rGGhLxXeGbD6cm2C+SWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 058/191] arm64: dts: mediatek: mt8195: Set DSU PMU status to fail
Date: Mon, 16 Oct 2023 10:40:43 +0200
Message-ID: <20231016084016.757243456@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit d192615c307ec9f74cd0582880ece698533eb99b ]

The DSU PMU allows monitoring performance events in the DSU cluster,
which is done by configuring and reading back values from the DSU PMU
system registers. However, for write-access to be allowed by ELs lower
than EL3, the EL3 firmware needs to update the setting on the ACTLR3_EL3
register, as it is disallowed by default.

That configuration is not done on the firmware used by the MT8195 SoC,
as a consequence, booting a MT8195-based machine like
mt8195-cherry-tomato-r2 with CONFIG_ARM_DSU_PMU enabled hangs the kernel
just as it writes to the CLUSTERPMOVSCLR_EL1 register, since the
instruction faults to EL3, and BL31 apparently just re-runs the
instruction over and over.

Mark the DSU PMU node in the Devicetree with status "fail", as the
machine doesn't have a suitable firmware to make use of it from the
kernel, and allowing its driver to probe would hang the kernel.

Fixes: 37f2582883be ("arm64: dts: Add mediatek SoC mt8195 and evaluation board")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20230720200753.322133-1-nfraprado@collabora.com
Link: https://lore.kernel.org/r/20231003-mediatek-fixes-v6-7-v1-5-dad7cd62a8ff@collabora.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index 4dbbf8fdab758..43011bc41da77 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -313,6 +313,7 @@ dsu-pmu {
 		interrupts = <GIC_SPI 18 IRQ_TYPE_LEVEL_HIGH 0>;
 		cpus = <&cpu0>, <&cpu1>, <&cpu2>, <&cpu3>,
 		       <&cpu4>, <&cpu5>, <&cpu6>, <&cpu7>;
+		status = "fail";
 	};
 
 	dmic_codec: dmic-codec {
-- 
2.40.1



