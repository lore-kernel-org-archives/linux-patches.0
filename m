Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D12372230;
	Sat, 28 Feb 2026 17:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301478; cv=none; b=eHniODzwV739NSNRyU8G8zRCns5TtGAro9tSsJkhgdFASICYaMRY8L1zEQHm7mAe5Q25ZCUzPRdhWGlNhS9P/yGh5poDNr9ksZ+1SykujLEB9KuBeNEcuTDSQeT6qp/JQTpO+fNs49j1QXb6e7qQOM4QFterWP6zXH1WwokfX5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301478; c=relaxed/simple;
	bh=9yg6gEIB6VPiQHdPSO7HxnxGTnItCHe9WzeyRxoJk4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJJIVgCKzx1+QKk7GMxqPVBa0w5VCNirJsrpbovUPUKXWG5rEVTTg9K5hnWNGcZCGESUPUkaz9PzhVruaiB0Cq3lUrw91PjbqSITXntrKwPr15Ha4WQJQeQeOhq1pdInWUZq0d5f9rPZU+bFDQoRDmkik1IwizHQPzHff2bIQSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NJKDTjO2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NJKDTjO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892C3C19423;
	Sat, 28 Feb 2026 17:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301478;
	bh=9yg6gEIB6VPiQHdPSO7HxnxGTnItCHe9WzeyRxoJk4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NJKDTjO2m4PteIOjZJJ+oSL1r6CNhJNciyMkUn9qdIw9jl53vXjS29eonNppHAVF5
	 61/8CK+qBQ8+VQiaZkWM98Qq09INf/7F7sYRVjIHxx0uk62Pb5ks+cXaIt+a+rUzfL
	 /Qg9kYde4wK7W27v4mTUdg4FMlecd4OMIxfVsHsvqK9SB9bqLfIPiToz+tm2BG6aqV
	 eopqf4F6b3lxiYXsKvazJjVqgyNqSnaeoCzvPUUhQlVDvuNP2ZMoEQPRNrHDljlsUv
	 eYRD2Uc5Zco0P/UriA87L63vXR03o94qVXq8abtU60Rh0llZACUq24r9/OknIemAdD
	 /duP8qUO1lZPA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Zhang <zhanghuabing@ecosda.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 663/752] PCI: dwc: Fix msg_atu_index assignment
Date: Sat, 28 Feb 2026 12:46:14 -0500
Message-ID: <20260228174750.1542406-663-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 58fbf08935d9c4396417e5887df89a4e681fa7e3 ]

When dw_pcie_iatu_setup() configures outbound address translation for both
type PCIE_ATU_TYPE_MEM and PCIE_ATU_TYPE_IO, the iATU index to use is
incremented before calling dw_pcie_prog_outbound_atu().

However for msg_atu_index, the index is not incremented before use,
causing the iATU index to be the same as the last configured iATU index,
which means that it will incorrectly use the same iATU index that is
already in use, breaking outbound address translation.

In total there are three problems with this code:
-It assigns msg_atu_index the same index that was used for the last
 outbound address translation window, rather than incrementing the index
 before assignment.
-The index should only be incremented (and msg_atu_index assigned) if the
 use_atu_msg feature is actually requested/in use (pp->use_atu_msg is set).
-If the use_atu_msg feature is requested/in use, and there are no outbound
 iATUs available, the code should return an error, as otherwise when this
 this feature is used, it will use an iATU index that is out of bounds.

Fixes: e1a4ec1a9520 ("PCI: dwc: Add generic MSG TLP support for sending PME_Turn_Off when system suspend")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Tested-by: Maciej W. Rozycki <macro@orcam.me.uk>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hans Zhang <zhanghuabing@ecosda.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260127151038.1484881-6-cassel@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-host.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
index 03d01d051e9b0..925d5f818f12b 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -936,7 +936,14 @@ static int dw_pcie_iatu_setup(struct dw_pcie_rp *pp)
 		dev_warn(pci->dev, "Ranges exceed outbound iATU size (%d)\n",
 			 pci->num_ob_windows);
 
-	pp->msg_atu_index = i;
+	if (pp->use_atu_msg) {
+		if (pci->num_ob_windows > ++i) {
+			pp->msg_atu_index = i;
+		} else {
+			dev_err(pci->dev, "Cannot add outbound window for MSG TLP\n");
+			return -ENOMEM;
+		}
+	}
 
 	i = 0;
 	resource_list_for_each_entry(entry, &pp->bridge->dma_ranges) {
-- 
2.51.0

