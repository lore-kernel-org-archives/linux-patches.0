Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD92C26F46B;
	Tue,  8 Apr 2025 12:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117015; cv=none; b=fUgTdNsJGCQyQIBwOPjfEcNfjmECCclQ+CtkIEZYsgTRJS/bFPlt6bbun0rpEiys6CLLR6WOD+wpNptPYl0/wCJWhRVzayFFCBXyu5C3ZTg+mny0AtPMytp2OCPuk5UcSZDwAvLsFbiJNGDbywPtG3bWQl4VnkmedDChe9ZHuNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117015; c=relaxed/simple;
	bh=DZgCe+CyyobC3GyCYq0B2GTYjPkflnOdQO/Xeg2JeK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RFCpLwFYXknXAj5HxqQZq5oj+rSFLwLaSTYAw6yPCglWFgnPDHKnlhkg0ZQ9m5xlwvvR9vWhm2UT3VEhDpJH1tuxD+xQBk6RWghloN/YxnkT3gA2ZYpp5WnMf5nNBcvyMSnSmW5iOR5I4Vl2xSugak/bJqS9IyAS2mfbmMEIr3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YQneRTuc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YQneRTuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1372FC4CEE5;
	Tue,  8 Apr 2025 12:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117015;
	bh=DZgCe+CyyobC3GyCYq0B2GTYjPkflnOdQO/Xeg2JeK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQneRTucnjcZNDT/8kbQpJ+7haP8kFbXJ0EE1Ku1Y/mmtqR64H6YYFT8XrJakAqrx
	 cjJJN6P90QEtCvTHBLPoRhCYdwthtuWr6wMVC+tylBlj/v4TbLAXTjV+E8lkNQXnUc
	 nDpYzKX1A47/aXO9zQ1pMSyayjtlJDL4r04lI3Ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
	Peter Geis <pgwipeout@gmail.com>,
	Bjorn Helgaas <helgaas@kernel.org>,
	Diederik de Haas <didi.debian@cknow.org>,
	Chris Vogel <chris@z9.de>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 354/423] arm64: dts: rockchip: Add missing PCIe supplies to RockPro64 board dtsi
Date: Tue,  8 Apr 2025 12:51:20 +0200
Message-ID: <20250408104854.096524210@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragan Simic <dsimic@manjaro.org>

[ Upstream commit ffcef3df680c437ca33ff434be18ec24d72907c2 ]

Add missing "vpcie0v9-supply" and "vpcie1v8-supply" properties to the "pcie0"
node in the Pine64 RockPro64 board dtsi file.  This eliminates the following
warnings from the kernel log:

  rockchip-pcie f8000000.pcie: supply vpcie1v8 not found, using dummy regulator
  rockchip-pcie f8000000.pcie: supply vpcie0v9 not found, using dummy regulator

These additions improve the accuracy of hardware description of the RockPro64
and, in theory, they should result in no functional changes to the way board
works after the changes, because the "vcca_0v9" and "vcca_1v8" regulators are
always enabled. [1][2]  However, extended reliability testing, performed by
Chris, [3] has proven that the age-old issues with some PCI Express cards,
when used with a Pine64 RockPro64, are also resolved.

Those issues were already mentioned in the commit 43853e843aa6 (arm64: dts:
rockchip: Remove unsupported node from the Pinebook Pro dts, 2024-04-01),
together with a brief description of the out-of-tree enumeration delay patch
that reportedly resolves those issues.  In a nutshell, booting a RockPro64
with some PCI Express cards attached to it caused a kernel oops. [4]

Symptomatically enough, to the commit author's best knowledge, only the Pine64
RockPro64, out of all RK3399-based boards and devices supported upstream, has
been reported to suffer from those PCI Express issues, and only the RockPro64
had some of the PCI Express supplies missing in its DT.  Thus, perhaps some
weird timing issues exist that caused the "vcca_1v8" always-on regulator,
which is part of the RK808 PMIC, to actually not be enabled before the PCI
Express is initialized and enumerated on the RockPro64, causing oopses with
some PCIe cards, and the aforementioned enumeration delay patch [4] probably
acted as just a workaround for the underlying timing issue.

Admittedly, the Pine64 RockPro64 is a bit specific board by having a standard
PCI Express slot, allowing use of various standard cards, but pretty much
standard PCI Express cards have been attached to other RK3399 boards as well,
and the commit author is unaware ot such issues reported for them.

It's quite hard to be sure that the PCI Express issues are fully resolved by
these additions to the DT, without some really extensive and time-consuming
testing.  However, these additions to the DT can result in good things and
improvements anyway, making them perfectly safe from the standpoint of being
unable to do any harm or cause some unforeseen regressions.

These changes apply to the both supported hardware revisions of the Pine64
RockPro64, i.e. to the production-run revisions 2.0 and 2.1. [1][2]

[1] https://files.pine64.org/doc/rockpro64/rockpro64_v21-SCH.pdf
[2] https://files.pine64.org/doc/rockpro64/rockpro64_v20-SCH.pdf
[3] https://z9.de/hedgedoc/s/nF4d5G7rg#reboot-tests-for-PCIe-improvements
[4] https://lore.kernel.org/lkml/20230509153912.515218-1-vincenzopalazzodev@gmail.com/T/#u

Fixes: bba821f5479e ("arm64: dts: rockchip: add PCIe nodes on rk3399-rockpro64")
Cc: stable@vger.kernel.org
Cc: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Cc: Peter Geis <pgwipeout@gmail.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>
Reported-by: Diederik de Haas <didi.debian@cknow.org>
Tested-by: Chris Vogel <chris@z9.de>
Signed-off-by: Dragan Simic <dsimic@manjaro.org>
Tested-by: Diederik de Haas <didi.debian@cknow.org>
Link: https://lore.kernel.org/r/b39cfd7490d8194f053bf3971f13a43472d1769e.1740941097.git.dsimic@manjaro.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi
index 11d99d8b34a2b..fd8296c1d3fad 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi
@@ -661,6 +661,8 @@ &pcie0 {
 	num-lanes = <4>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&pcie_perst>;
+	vpcie0v9-supply = <&vcca_0v9>;
+	vpcie1v8-supply = <&vcca_1v8>;
 	vpcie12v-supply = <&vcc12v_dcin>;
 	vpcie3v3-supply = <&vcc3v3_pcie>;
 	status = "okay";
-- 
2.39.5



