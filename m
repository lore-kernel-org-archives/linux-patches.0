Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5756115252D;
	Thu, 13 Feb 2025 15:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460596; cv=none; b=onirw3iB+Bk+8onB6ZvD3SQG3JB4APV5lghLQuNFJ90DLcIQIWJiyXVKGd53sGW4drwLf4XAIjo3O8tNsnoQkTfxbyIQAbeNcstrFPT7DgB3nzR4Zz0Sc1hyub8JnhVMNRECtRoFkKhdnaJf9mhg7m0R7CGBBiPpqasosVbVdIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460596; c=relaxed/simple;
	bh=KKYmW2ige3k9vhT1Ds6k8ZgVAMRCjGGEs9vAXipekwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKmf4kfDSamz2/gMrB/Fj23K6h3q57S6/ZtfPgT+a7dXYGNaJSn5MezWjAFRREkl0GWs1R7zmjvq/3EMMDLij4w34CeiZbvtEwiAfM8TYbspmq2MOehzIyQINhzhKbvmlBrUAW2tnec7eTKJ3NgTkLh4UvZxB2U7LJakidntyao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1zmbA3c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1zmbA3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C45C4CEE8;
	Thu, 13 Feb 2025 15:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460596;
	bh=KKYmW2ige3k9vhT1Ds6k8ZgVAMRCjGGEs9vAXipekwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1zmbA3chVkYLEmbTLzs+ws6ZjSnc0R1BDwtVXos6MgHxy4OU9k30qnV1BVhU+fAj
	 zO50HiM4EG33gp1ZAScqtaeIDccdtmZDyLJ9WvZXqTOmmFAGB8wRAyM3Uebzt+LADa
	 plalbpFs9Q4tNaFTV/NYsDGPHtgLx5HFl/c4zj2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brad Griffis <bgriffis@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.6 157/273] arm64: tegra: Fix Tegra234 PCIe interrupt-map
Date: Thu, 13 Feb 2025 15:28:49 +0100
Message-ID: <20250213142413.540260220@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1912,6 +1912,8 @@
 			#redistributor-regions = <1>;
 			#interrupt-cells = <3>;
 			interrupt-controller;
+
+			#address-cells = <0>;
 		};
 
 		smmu_iso: iommu@10000000 {


