Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CE226619A;
	Thu, 13 Feb 2025 14:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457896; cv=none; b=cZ2lyhak1z5ech43Zzz8mT+o8sM1drcGbSo7X+tqwdPW2W77yu0/vpxL6AIk69eOJ8deU4cHUpFCpzgRR6yc2QEVmAq3qoJ1Ttx+do4YEbDy7cECcIc+0L9hKVI04yOtMIzoBNagg85BGMHXV688AODTWlGOJfg7WtpZtMwEFGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457896; c=relaxed/simple;
	bh=xnYucc3aD7QkW4Jc/L70zGQMM6D1KjhNXdhGNrmozWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFXl1B57IQNn0Gl90Of8SZN2N1zGhwQY0ieOmfGh5eNIks8ZwhKfYNnJoUlGIDBWX77CtF40BLhWHv1PxtKUda/v62Nw5erY4aUmYMdfDp6bCdKlaf6SrzTZFc+I2lswHptnNS1bM/F974OClSWcrIWe6IZ/iCFlVOEHRV+r0n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=krjq6Uh0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="krjq6Uh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10851C4CEE7;
	Thu, 13 Feb 2025 14:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457896;
	bh=xnYucc3aD7QkW4Jc/L70zGQMM6D1KjhNXdhGNrmozWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=krjq6Uh0JcaBTkHClEk3fgT7vbGyoW1uIjSUil0DVOyxhSvCcv+6vv2cK0BEh7CSn
	 rBNSk8elMD8UHOF94zHc1ashCa7nMYWoRzSXMijTyLWLYNblIaTLh/sN+YBCeFfoS7
	 qkfcqIuj4EY+UR4EsLGtQezAXZ29dOztxlyqdmqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brad Griffis <bgriffis@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.12 245/422] arm64: tegra: Fix Tegra234 PCIe interrupt-map
Date: Thu, 13 Feb 2025 15:26:34 +0100
Message-ID: <20250213142445.991675377@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

From: Brad Griffis <bgriffis@nvidia.com>

commit b615fbd70fce8582d92b3bdbbf3c9b80cadcfb55 upstream.

For interrupt-map entries, the DTS specification requires
that #address-cells is defined for both the child node and the
interrupt parent.  For the PCIe interrupt-map entries, the parent
node ("gic") has not specified #address-cells. The existing layout
of the PCIe interrupt-map entries indicates that it assumes
that #address-cells is zero for this node.

Explicitly set #address-cells to zero for "gic" so that it complies
with the device tree specification.

NVIDIA EDK2 works around this issue by assuming #address-cells
is zero in this scenario, but that workaround is being removed and so
this update is needed or else NVIDIA EDK2 cannot successfully parse the
device tree and the board cannot boot.

Fixes: ec142c44b026 ("arm64: tegra: Add P2U and PCIe controller nodes to Tegra234 DT")
Signed-off-by: Brad Griffis <bgriffis@nvidia.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20241213235602.452303-1-bgriffis@nvidia.com
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/nvidia/tegra234.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -4018,6 +4018,8 @@
 			#redistributor-regions = <1>;
 			#interrupt-cells = <3>;
 			interrupt-controller;
+
+			#address-cells = <0>;
 		};
 
 		smmu_iso: iommu@10000000 {


