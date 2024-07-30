Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CC91A616E;
	Tue, 30 Jul 2024 16:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355904; cv=none; b=NaIOQF64clbkN1J9SJHtKb2qK/gOM9eb8KmLSRXIjj3+YtIcbXvGAFgljntsei28FZeIZnh7ClcNEedEZqFIiuaFApXqv+sEvXwxvMAZ7qTM32seyTLiifNmOU3X/kmTdkdTp6DkWjgyu4asy7VBiRDp3vtHZ8rZRSbVgepLW18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355904; c=relaxed/simple;
	bh=qmagBXG07vOiRkjYo/APIewVcafigg/BCMDu2VUCucM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XoDJZ364wQSNvQmmAoJvugTgait+M+vga7c7reIIHC2OgBBwP8/yhGQveMGy1f+ttqH0M+iw6Fh4TolQtTkz8NIXVE/fZPyFH+4oH2pvDIG3hjC2oOojfN6UuYCLKIXckJ9LlaTyJjr74m84rHAuQAh4adYdaXSbr0189WUxjks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/J7nHsU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/J7nHsU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBA8C32782;
	Tue, 30 Jul 2024 16:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355903;
	bh=qmagBXG07vOiRkjYo/APIewVcafigg/BCMDu2VUCucM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0/J7nHsUnpvPk/Qi5SoSvdU7sudKaT/TiI9UPOWUXreNuhBrdhWKOHUXKWF9DgBdd
	 ZI3kWn4D6Nw2wjPH41ZVl3vWwWo979dHzn1oF1PV5Kavw4X1D9Hf1RIIjB1HIJ/Bgf
	 hdMH14Od8e9GWxGCojf00q/SeEfIBPcLKQvEmnlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 103/809] arm64: dts: mediatek: mt8192-asurada: Add off-on-delay-us for pp3300_mipibrdg
Date: Tue, 30 Jul 2024 17:39:39 +0200
Message-ID: <20240730151728.697489663@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pin-yen Lin <treapking@chromium.org>

[ Upstream commit 897a7edba9330974726c564dfdbf4fb5e203b9ac ]

Set off-on-delay-us to 500000 us for pp3300_mipibrdg to make sure it
complies with the panel's unprepare delay (the time to power down
completely) of the power sequence. Explicit configuration on the
regulator node is required because mt8192-asurada uses the same power
supply for the panel and the anx7625 DP bridge.

For example, the power sequence could be violated in this sequence:
1. Bridge on: panel goes off, but regulator doesn't turn off (refcount=1).
2. Bridge off: regulator turns off (refcount=0).
3. Bridge resume -> regulator turns on but the bridge driver doesn't
   check the delay.

Or in this sequence:
1. Bridge on: panel goes off. The regulator doesn't turn off (refcount=1),
   but the .unprepared_time in panel_edp is still updated.
2. Bridge off, regulator goes off (refcount=0).
3. Panel on, but the panel driver uses the wrong .unprepared_time to check
   the unprepare delay.

Fixes: f9f00b1f6b9b ("arm64: dts: mediatek: asurada: Add display regulators")
Signed-off-by: Pin-yen Lin <treapking@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240502154455.3427793-1-treapking@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi b/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi
index 7a704246678f0..08d71ddf36683 100644
--- a/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi
@@ -147,6 +147,7 @@ pp3300_mipibrdg: regulator-3v3-mipibrdg {
 		regulator-boot-on;
 		gpio = <&pio 127 GPIO_ACTIVE_HIGH>;
 		vin-supply = <&pp3300_g>;
+		off-on-delay-us = <500000>;
 	};
 
 	/* separately switched 3.3V power rail */
-- 
2.43.0



