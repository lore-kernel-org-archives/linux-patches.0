Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3973818B482;
	Tue, 30 Jul 2024 16:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355606; cv=none; b=k3bzKa5/FBJa+UgiVJdz4waDha//Ms7FpukWzD+HM2IU68BZHt+B0WPGbDkTJ6Rqu6tjQWwzQ49IDih8ci91jP9At+w5GCTpP3cFN7ggm0p/6lIDlB4kvIuDEF+4RzM8vKyxzzMz4lPBe1nbXjst14EgwLadge0b80GEiEXeZx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355606; c=relaxed/simple;
	bh=BYgRjivsXBWxinTUa5Q6gDa8Nfwl6R+JNBXkfkAqYSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlHvs56Azgbn5Rz43EK4kUKYaISQMgLeuM7wclwnnqrLHFdWb225iqHaV+pflPMgsOKSWxhgCPLljkrmvw4rKzLuOn/MsCVKJCpwYmamiiR1LN3i7cux9ckt2lLbosDBqpWANaFsO+NifpIk0mHneRzDE5mVBRB1k0u4xavao4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cj5OW+qy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cj5OW+qy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC989C32782;
	Tue, 30 Jul 2024 16:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355606;
	bh=BYgRjivsXBWxinTUa5Q6gDa8Nfwl6R+JNBXkfkAqYSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cj5OW+qywJ2raq17aZ2vdcsCsuIyHvfphTk4Mu5Auip9a15aiDLunZTLg/w7udeHp
	 P6Qftvgu9SRQyZFT7KeYDomvMitW6JUKlEfEIfICwp60V/j0BhWL5zQIFj9/n0xlBx
	 xgeFWySB5rea6YoRxs0cfp2NXMU96CD7p9XCTkhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/568] arm64: dts: mediatek: mt8192-asurada: Add off-on-delay-us for pp3300_mipibrdg
Date: Tue, 30 Jul 2024 17:43:00 +0200
Message-ID: <20240730151642.713247762@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
index dc39ebd1bbfc8..6b4b7a7cd35ef 100644
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



