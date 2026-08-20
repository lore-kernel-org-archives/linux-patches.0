Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A041377A82;
	Thu, 20 Aug 2026 16:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243904; cv=none; b=fuuF+o5k8w1u+sbYbhTv1yfaM2lFBvgyXXnFixYI2L9RX/xXWHrsH/E8PY82Bhtvwf54oUfA1RaR16v8+WgAf31c2KJ2mHLWXKlZnxRmdtdnSgUxfU00HLuQncCWur/s3/HpChug9RSKUk3oRuotVfi3J7W3O1I6EmmOvFlhanM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243904; c=relaxed/simple;
	bh=y0l/8Cl1DeIj0v6gbQHzIVCbOmS59uud/HOS0RQiyQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I4V7Krv8rMvhy1IAhSleOWXme1ibm8KAL0lpmRg1yz5PvHyToQNE0imBvo07NliHzE8M185yhC8+k8ghLpZFp0lbSpJyBwBI0O9yaHLqOSiNlPVxjtp9GETW1yBShV9IBuagXF1ULvYDnRTwJ1on2ioHHY+ths8uTtNOI2nTII4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bRQXXzly; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bRQXXzly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C771F00A3A;
	Thu, 20 Aug 2026 16:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243903;
	bh=Qf2vjGe3bQN0jftyF5RjQ4IkvqTPEocTce4UUmkamfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bRQXXzlyvaOn5E+u1VX+xTeBViciPBoPIByQkbvQs32dv3vHFCknI68bBpkoIar1K
	 ygNdT5WmZ9skBYeI5tIYQJhqe6SouDso12Yy7D/UJumyJ6L4jeYoGibnBxrgD8fWlG
	 4KNN0Kudcq6KoSTkGsMgINm6a/ssO8H1vVlG8PEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 257/272] arm64: tegra: Add EL2 virtual timer interrupt for Tegra194
Date: Thu, 20 Aug 2026 16:57:21 +0200
Message-ID: <20260820145239.342860975@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit a7c28483fd57dd0e1487024af70622315320774b ]

Commit d87773de9efe ("clocksource/drivers/arm_arch_timer: Default to EL2
virtual timer when running VHE") updated the ARM arch timer driver to
use the virtual timer by default if the CPU is running at EL2 with VHE
enabled. If the CPU is running at EL2 with VHE enabled but there is no
interrupt provided for the virtual timer, then the following warning is
displayed:

 arch_timer: [Firmware Bug]: VHE-capable CPU without EL2 virtual timer
  interrupt

This warning is observed on Tegra194 platforms. Tegra194 SoC includes
NVIDIA Carmel ARM v8.2 CPUs and support an EL2 virtual timer. Fix the
above warning by adding the PPI for the EL2 virtual timer interrupt for
Tegra194.

Fixes: 5425fb15d8ee ("arm64: tegra: Add Tegra194 chip device tree")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra194.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra194.dtsi b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
index ca71b71d801a6..934ec5b048da0 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -2586,6 +2586,8 @@ timer {
 			     <GIC_PPI 11
 				(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 10
+				(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
+			     <GIC_PPI 15
 				(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>;
 		interrupt-parent = <&gic>;
 		always-on;
-- 
2.53.0



