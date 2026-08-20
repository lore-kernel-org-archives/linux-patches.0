Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA5A47D47F;
	Thu, 20 Aug 2026 16:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243180; cv=none; b=CWqJt8QDEFFDFaryIICNCVL8uanbL6XrnfpRN76y2t2EooLIk7JVwNXLs1crEJy45q9H61YXdpYTBZuTnv0zacjGtIMYnnwZNunmg9GFgkKLs4PoDZxbqIkrQ2r1sZljY0tam8NMyikZgNkji5yMgjZE+70+cKGjtZpx9QCq6VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243180; c=relaxed/simple;
	bh=QbWlpFIGQMkfi901EZ1NBy/YCwOFypRHskjvdd58TYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncdaK92ANarr24trQeK8QauddtOmxjenVuRBNo1TmoEj6ryP4J3Cd2aAfr0tK/JxpL6GfWmepuk09Yv1U0vTpz6SAEmrERMW9JbYAY0p8HZgO9+Pb/vEMhtjCcbNoqqjeNTz+bVdi5zlyNRLLaegJl+SE085Ulq/rdUnQCM1nYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sxLZYOnd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sxLZYOnd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190911F00A3A;
	Thu, 20 Aug 2026 16:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243177;
	bh=88ZEocSux1Dl2iyiNu/74G8Vj33BeTjAUgKa4vsWgaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sxLZYOndwABJwmIgjeJEIXCZHOLN1dNgs2QZCfqN9MPvyp2te4XJmrEou3gM1tWjb
	 SrSyRv+gGLaR4FYna54VdE5mqSy57jlbC4TBiIzsFoQ1N/r3owvRPQe77Iv9Z7V5W0
	 3YWQX8EEVLSQBcl86mMXpL22o4n0uQUnlC4WQDGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 277/303] arm64: tegra: Add EL2 virtual timer interrupt for Tegra194
Date: Thu, 20 Aug 2026 16:56:53 +0200
Message-ID: <20260820145301.793468769@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ed2a534dcfd62..5cd552c0c6df9 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -3166,6 +3166,8 @@ timer {
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



