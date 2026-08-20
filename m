Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38A447CC97;
	Thu, 20 Aug 2026 16:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244578; cv=none; b=QB4aGDJR+q3u5X6grw4Vp738RJ8pQ/SFr9Rg7wh8Q6sBG6RmFdkNExRlzQoPb46VGIEdPmfkJ1KdN8aoC9IaGGvHGzvZGsoeYQ34riwJE1fXk7ZoIZn3/Uke4ByWI3lRomJE01FF85OjlWdLD5fD5BVadQyRmZkECYGEwm0XnLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244578; c=relaxed/simple;
	bh=7z0JflO6m+jOoo0eif57YDUo1lFFx6b0zLakrSwfz/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5d+2yCqyOsKtD/T4/PBXcAVhwEaZUu7DuwJIhvxggHgliAXXkciN3dtArI3gk2pZK+EaUI09Oet9i53ruorW1cPhA0sx/w3nMbOkDq734tWecB4T6hAtAPLti8uTBjEg/tdE+wekl+V1ruGHOtTu6P1tI8Ak+EqLOlzPljetrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aM7IoD4+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aM7IoD4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DC11F00A3F;
	Thu, 20 Aug 2026 16:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244576;
	bh=ufI1qHLuuQSJ3wBlZO9wQGzRe70klruj3M4nNEPhPxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aM7IoD4+shqPS6R9yIWCcFB6p+I9KGdNuF4Q39+F+T1aVwYcyZpv98mJPJCcsrLBJ
	 0cW4aZ+n2DSseepauMlwDTUgPCwr4iNPAZyi8hgDtNchZtwV5Aa7cg2B9IuGR8mRrU
	 knZDBcur+ZITtS+LDl1x9rLHpfVYA8G8wo8FiJGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 216/235] arm64: tegra: Add EL2 virtual timer interrupt for Tegra194
Date: Thu, 20 Aug 2026 16:57:32 +0200
Message-ID: <20260820145223.164873913@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 05cf606b85c9f..b38c16f25f1ff 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -2375,6 +2375,8 @@ timer {
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



