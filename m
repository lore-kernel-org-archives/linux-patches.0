Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8A51F7065;
	Tue,  3 Dec 2024 15:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238158; cv=none; b=VqLoDYbmdlKBqXV80w+1q05wprpajZTUNQWRE8HoxSvlzg5CqGh/U1i3CJJo2vIjJL1qajOpjcgRnp3h34Y3xdtNYdbzN9sbY8hz/pNUscKGamdmzQwHmWBeZaAmHMUdCaGc+Ck3CJhPAZniQ3//we1lMlZgVcfZOpZpb79G8Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238158; c=relaxed/simple;
	bh=9rH1JMeDiOSXTDm85hjuBQ/GZEseWH7ZJl/ShZsRpGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6EW7+FJf8S3teyOIO93qxzN8bD9JGsEHt6sAzUDXQLdutqivsxuRZbbpp8YdeGLS7ScYNIRkycFYMcfEBdO53rgtvKiIieoy38HCCzynKFxyY2M4H4VS9FJ656fuh5+qCbwvENWpr1M7UD2WHW+vViylKR7KfmEZ5es4OUxfls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OGGwV0Vz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OGGwV0Vz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A5DC4CECF;
	Tue,  3 Dec 2024 15:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238157;
	bh=9rH1JMeDiOSXTDm85hjuBQ/GZEseWH7ZJl/ShZsRpGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OGGwV0Vz7VD2NtrUvHkVi7MFap8HtmQSn5Q37Oo8b7d9efDTExsLzgcVP/f86XU2Y
	 40Fp70DWoDz75BvU9Xf0OtYalU3kwgKWl5egEpi1Vy/BVxI4pCUeoD9buLi6gl20Lq
	 C7WQRUJZj12RgVV17pl9oU+It22FiOiE7nyQmsBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 182/817] ARM: dts: cubieboard4: Fix DCDC5 regulator constraints
Date: Tue,  3 Dec 2024 15:35:54 +0100
Message-ID: <20241203144002.835236392@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit dd36ad71ad65968f97630808bc8d605c929b128e ]

The DCDC5 voltage rail in the X-Powers AXP809 PMIC has a resolution of
50mV, so the currently enforced limits of 1.475 and 1.525 volts cannot
be set, when the existing regulator value is beyond this range.

This will lead to the whole regulator driver to give up and fail
probing, which in turn will hang the system, as essential devices depend
on the PMIC.
In this case a bug in U-Boot set the voltage to 1.75V (meant for DCDC4),
and the AXP driver's attempt to correct this lead to this error:
==================
[    4.447653] axp20x-rsb sunxi-rsb-3a3: AXP20X driver loaded
[    4.450066] vcc-dram: Bringing 1750000uV into 1575000-1575000uV
[    4.460272] vcc-dram: failed to apply 1575000-1575000uV constraint: -EINVAL
[    4.474788] axp20x-regulator axp20x-regulator.0: Failed to register dcdc5
[    4.482276] axp20x-regulator axp20x-regulator.0: probe with driver axp20x-regulator failed with error -22
==================

Set the limits to values that can be programmed, so any correction will
be successful.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Fixes: 1e1dea72651b ("ARM: dts: sun9i: cubieboard4: Add AXP809 PMIC device node and regulators")
Link: https://patch.msgid.link/20241007222916.19013-1-andre.przywara@arm.com
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/allwinner/sun9i-a80-cubieboard4.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/allwinner/sun9i-a80-cubieboard4.dts b/arch/arm/boot/dts/allwinner/sun9i-a80-cubieboard4.dts
index c8ca8cb7f5c94..52ad95a2063aa 100644
--- a/arch/arm/boot/dts/allwinner/sun9i-a80-cubieboard4.dts
+++ b/arch/arm/boot/dts/allwinner/sun9i-a80-cubieboard4.dts
@@ -280,8 +280,8 @@ reg_dcdc4: dcdc4 {
 
 			reg_dcdc5: dcdc5 {
 				regulator-always-on;
-				regulator-min-microvolt = <1425000>;
-				regulator-max-microvolt = <1575000>;
+				regulator-min-microvolt = <1450000>;
+				regulator-max-microvolt = <1550000>;
 				regulator-name = "vcc-dram";
 			};
 
-- 
2.43.0



