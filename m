Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D472B34E75C;
	Wed, 20 May 2026 17:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298306; cv=none; b=fhliSb9WJqNot2Kff9jzPN1LVPo0V9OPEceLcrqkp6CnpZV6dtsVW45ayYw8tE55RUJebzAHPlv9s4JdHzZod/Rfa7gfKfElzUQiO91w7h9n2PHfORrFgSYjQsSDmtzkYLuTcymJrobloNsPiiDTvJr0Q6Iuh4b5eCvaQkG6e1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298306; c=relaxed/simple;
	bh=CqOb5UGsSKaV++kUAnGBfqtGXp4knLUna/jUsKQ70mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BMzbmANtrikCmj5pBGp/eV1q+aKWUJMo3flDhpgzQepcY4LtSbbl52ehFnkjXOaQhfJiJv4QQEJwggT7UA1MSCLztROHRGkBLj4YuCE8eQ7Iu92/hx6J+2ue88PxjRGyyIG9VQKHY+PQBgvU0Ec6Np9HwRQ9Rvw4a5gsHssxIc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xoWH7ron; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xoWH7ron"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44EC41F000E9;
	Wed, 20 May 2026 17:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298304;
	bh=w+2Kw+PJ14FFUgdxy9v/h58kN0PhKw47d6HtTqugoA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xoWH7ronSl/+x+QmeRFT7iaVJt3muGXVs6rsHVKASdLpwmOWk3Klx4WCBTDLaWsKG
	 JGZ0pgh8F4CRVEAYUPSXKooDbM2eQcivKrALVpxVH3QYMt2SI7XDK8miKR766hmEZH
	 vb+BRGDh1vwikqb/JepaeVxcgtDtAleZcFTorhrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	David Lechner <dlechner@baylibre.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 361/957] arm64: dts: mediatek: mt8365: Describe infracfg-nao as a pure syscon
Date: Wed, 20 May 2026 18:14:04 +0200
Message-ID: <20260520162142.358490514@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 0651c24658360706c30588cec0a12c05edb03e9a ]

The infracfg-nao register space at 0x1020e000 has different registers
than the infracfg space at 0x10001000, and most importantly, doesn't
contain any clock controls. Therefore it shouldn't use the same
compatible used for the mt8365 infracfg clocks driver:
mediatek,mt8365-infracfg. Since it currently does, probe errors are
reported in the kernel logs:

  [    0.245959] Failed to register clk ifr_pmic_tmr: -EEXIST
  [    0.245998] clk-mt8365 1020e000.infracfg: probe with driver clk-mt8365 failed with error -17

This register space is used only as a syscon for bus control by the
power domain controller, so in order to properly describe it and fix the
errors, set its compatible to a distinct compatible used exclusively as
a syscon, drop the clock-cells, and while at it rename the node to
'syscon' following the naming convention.

Fixes: 6ff945376556 ("arm64: dts: mediatek: Initial mt8365-evk support")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8365.dtsi | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8365.dtsi b/arch/arm64/boot/dts/mediatek/mt8365.dtsi
index e6d2b3221a3b7..49ad4dee9c4cf 100644
--- a/arch/arm64/boot/dts/mediatek/mt8365.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8365.dtsi
@@ -495,10 +495,9 @@ iommu: iommu@10205000 {
 			#iommu-cells = <1>;
 		};
 
-		infracfg_nao: infracfg@1020e000 {
-			compatible = "mediatek,mt8365-infracfg", "syscon";
+		infracfg_nao: syscon@1020e000 {
+			compatible = "mediatek,mt8365-infracfg-nao", "syscon";
 			reg = <0 0x1020e000 0 0x1000>;
-			#clock-cells = <1>;
 		};
 
 		rng: rng@1020f000 {
-- 
2.53.0



