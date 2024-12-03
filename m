Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8F41F706A;
	Tue,  3 Dec 2024 14:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236591; cv=none; b=cNeGNghZTdlug4jOrpLADbrKrYEdGzoBFWGtdVxAxkI4u5MhyBkfjIB9S091pN18l30X8RTcrkLs3yRlVpcvxZ7GPqq0FVmMF9BJM/Xump14IYVKqBJKRbkM+EvzXhUa5+mxn82jOMig6DRh/adIYlw7hard1FbAJpHV1damphs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236591; c=relaxed/simple;
	bh=qVztrk/BZK3Nm7mSUVxID7RUlwuMHo99WkVgcYbNU3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Txtmy+ItB7vU0q7C0LJfvtEf8oKwdbF8QuiDS2WLNCVxEQPkdU9xnCutKgUh0r5WwJ2WK8jnEknw0isRfyd5C9x/syWq3XmGcEIAjevAVKMKFm9UdR+RRpYE5ZM8uf+aU0sJ64jR2ChIsw0yFDhE0AExvDLb8Ud8Jo0zr2yy0XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rPj+4zKA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rPj+4zKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D48C4CECF;
	Tue,  3 Dec 2024 14:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236591;
	bh=qVztrk/BZK3Nm7mSUVxID7RUlwuMHo99WkVgcYbNU3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rPj+4zKArkopVR/RtcqOPqLJaZfO5v0pG1+dbwuY2OetFj/LhGFwntvdBGFglJo1E
	 62mkijgSoAMNv0PIalMP26x4ocbSyBfstTZKZrT7UVLNI5ESyONp7jWzOf7CNeytEy
	 Zri4ctqYO/PgzOXXrQRRButQghxA+HPq2e+WI5qM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 033/138] ARM: dts: cubieboard4: Fix DCDC5 regulator constraints
Date: Tue,  3 Dec 2024 15:31:02 +0100
Message-ID: <20241203141924.823129598@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/sun9i-a80-cubieboard4.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/sun9i-a80-cubieboard4.dts b/arch/arm/boot/dts/sun9i-a80-cubieboard4.dts
index 85da85faf869a..0e37ae46348ad 100644
--- a/arch/arm/boot/dts/sun9i-a80-cubieboard4.dts
+++ b/arch/arm/boot/dts/sun9i-a80-cubieboard4.dts
@@ -253,8 +253,8 @@ reg_dcdc4: dcdc4 {
 
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



