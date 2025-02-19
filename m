Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B2D1DB546;
	Wed, 19 Feb 2025 09:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957135; cv=none; b=O0sP5SQLhj6owZ3PjTrEOSGvq1jjhtcBAfx2497eR4TRgoYsq9EPT5bbKMQO6Ydx/EqvU4NA2spKRliK1yG490XAifuZuHF7lRBpPb0ewjbaIHDa3Bq2lS57nhlv2b9p2Fy/pWwsfiVAve9FyifMHa0fvIkaYnCRoPVmVir4dNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957135; c=relaxed/simple;
	bh=RMwBODmdnyZF8gL6qXVnhlEf3qc6RS2Fd3Ev0S/6GTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A9CgrEvCVmGr6YIx0WwFtc2jYMRAfbR2HivxR6TK4etbhv/F/aTnVnVBeJCO8Hwmz2jEo6sfhy4/OonTi/8gD3cW4IQGxbKoDLrgKTHPhVm5NefzumeZZHRYSQUfH4G1xvRKj2civQ8Btb2RyQ2TBLYc+FCtqGhoMnEGbmr2GL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bE25apru; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bE25apru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2AF3C4CED1;
	Wed, 19 Feb 2025 09:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957135;
	bh=RMwBODmdnyZF8gL6qXVnhlEf3qc6RS2Fd3Ev0S/6GTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bE25apruEZgHo/AcGXq589QgO8ildAsfperfhbbP0vl4G4dTj7gR8KVELHzbuYZyG
	 jCYVR+fJnSAUcFp3j85QgMBu6O+mX5KVpHHl22mhKmzhqwrQXVbkD67UfbsBU6I1O8
	 9HZ4XW6ky8qpsLGbpBt2ea5WRMpzI+ZoX13YzsOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brad Griffis <bgriffis@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.1 389/578] arm64: tegra: Fix Tegra234 PCIe interrupt-map
Date: Wed, 19 Feb 2025 09:26:33 +0100
Message-ID: <20250219082708.327427684@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1574,6 +1574,8 @@
 			#redistributor-regions = <1>;
 			#interrupt-cells = <3>;
 			interrupt-controller;
+
+			#address-cells = <0>;
 		};
 
 		smmu_iso: iommu@10000000{


