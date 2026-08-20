Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA531382371;
	Thu, 20 Aug 2026 15:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239270; cv=none; b=G+m+MSvNsb9UBJs/06LqBBGdFImimBbfQskku3kcnBijFTkYimEEKTB+20FmrqoqnQOvpXQ2eLbAs0sgJeI5sq0BtGXZZGs7co1/qYQCUni9++KHoMOubnYo4/TvUTkmyYsfxIey7Swif29VyV2mrMpDBVnQrRyBn6yXQ7KaRLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239270; c=relaxed/simple;
	bh=6c2HtcC65Gd25t2I8bAkltXcIQFAoSDr/FUgifnkdiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNlJMz3arYGzTdTMOMRFQWwEzE6AeUVg37mcZB6XjWXgjrtE9tknxz4+npqydvFtA5XYl/5F4Lw5b2Rb8X+H53ynqHFNc4uhzyFR+2vS64ss98TyehRAkQyE/g67jcGw7kxlCoyLONAAS7n6yh7jiHhTXhrOsuKPb+3zYIVhRZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rYfcpiBe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rYfcpiBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A501F000E9;
	Thu, 20 Aug 2026 15:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239268;
	bh=7koQmJgUd4V9Rr63K3c2mLvLozpun5PhlSVpWHdm2dI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rYfcpiBeSwjZjGCuIQsjyM4UiwjtEAm6r5ixPTtn6f9YDlBKxd9Z0qg4BstwmXm/S
	 44+0EK+9yihSEOzOaJ9oMqbY5UZOnX2ilMuCmX82H1hMfmYP28LA6Xpe4QM4LadBwx
	 3PWQA4lNbVTQ/kgMJ3BAaFAQEp1p4C6uMsAZbNgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 169/217] arm64: tegra: Add EL2 virtual timer interrupt for Tegra194
Date: Thu, 20 Aug 2026 16:55:37 +0200
Message-ID: <20260820145242.830605116@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1399342f23e1c..def60103179ff 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -3177,6 +3177,8 @@ timer {
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



