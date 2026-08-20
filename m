Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5992B37E2E5;
	Thu, 20 Aug 2026 15:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238494; cv=none; b=nHe/pq4JaAU3/Lin6tvXaC+rGHO1paZd8P9s6cymVpYR52lzKDC3kALvpYxryMwDPFYRh8xw7sgOa5HVvlPf5mrNk/f70CPqPQHefEvhyAbh73tu7VRy81l8scpQMWSfbON3QkgxWW2bZDdcsUbhzJLHKH5J7jWT64lo3KkWz4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238494; c=relaxed/simple;
	bh=2XMG5Ffl9OPMGdk3c6wNev6s+k2wqUavPniJ4B6n7JI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qg3kCBUQveMy7IH6h4/0EyoX78k7KH7WQ/DXPv7+Ic2T/IYmS31Q7giYXAX49I1HhIiayxsyGxYsbeO3J1B2NwXU3tEkHDJNgyfZ6iJY9Z9CJQME39yFujgcMiGpt8tlSwxtOpSrqoImRQpLG+ZEMSp3boFWC66Kdz5+/8p0/Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uiKC8tT3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uiKC8tT3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FAD31F000E9;
	Thu, 20 Aug 2026 15:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238491;
	bh=qCnh2J8o8ccukMU8L+wixSpsArinVPHODK4vs+kFCLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uiKC8tT3nVh2HPmWBDHOKJd+un0uBIuLSHt/WbUtoYmqgT+icpX8QvJKu9DGMKXjk
	 S+AMWRrA5LijjClg5+5GIhDxFvQiExqo1WLJhMAbsir1K40BEpA3JFd4zK7x6rMgrK
	 EFR0cCi8IwnVciqGncl4YaTJG0koJmV1wRabWTGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 166/228] arm64: tegra: Add EL2 virtual timer interrupt for Tegra194
Date: Thu, 20 Aug 2026 16:55:08 +0200
Message-ID: <20260820145249.728741279@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 849694f751d90..a5cdaa0ac69be 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -3163,6 +3163,8 @@ timer {
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



