Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F11034A3C4;
	Sat, 30 May 2026 18:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164244; cv=none; b=JU0b6bS3ZA026jnCccGRm5xgaV2I4wG67hJhML4jkzO0rOjcoUnAhACwKvWxdoNUEsLsrMMBdloHxTMJ/olpIWrb/DUDi+Jk7i1zfR1j8PdhIVmnUQnoz1BGdiu5qX03VwJYAzDiPoHKe3ZfWwPKYTOsDxZq/wtIhnWg/l8M+4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164244; c=relaxed/simple;
	bh=nngrD/WVoiPhNomPzNrK/d0NTXSnfTRd4I3Ebso96aU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rw4D2Nzh8sxUnzRrlg4W87Xn8BhIbPHQXByWBcpkNamrpwYEotinFfX+lVW3KGNmv+E61/mionY83VrA3twOS6hHP5DY4iFNDJYkzTewDi7ffU4NpZu6pABRlxZiZ42IBhdBGoJjLTlrFuT5FfqvacEhv+jLcQ+DMpjALzXK9Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ek8JfJsZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ek8JfJsZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45751F00893;
	Sat, 30 May 2026 18:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164242;
	bh=bBhr2qCMyyx0Lu1a2rY9W8E/bChbW0oI1z0oAwV+TIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ek8JfJsZXi7Gaud5lSPtwPVtcCE6ChJ8AzlQLtCCAn8LSlCeXs+S25Z3WLFWEs0Y5
	 V3gBU3ifHhs+RhnePL1StcUicnxV729YVoiQ24h2MP4V2jUkicQwNq7YCMsQQFQuor
	 7ohZ8TGvu5VrA1Fn/goBtN5Ha+qcFneY0BFwYfRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Schmidt <alexs@linux.ibm.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 467/776] PCI: Enable AtomicOps only if Root Port supports them
Date: Sat, 30 May 2026 18:03:01 +0200
Message-ID: <20260530160252.419901484@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Gerd Bayer <gbayer@linux.ibm.com>

[ Upstream commit 1ae8c4ce157037e266184064a182af9ef9af278b ]

When inspecting the config space of a Connect-X physical function in an
s390 system after it was initialized by the mlx5_core device driver, we
found the function to be enabled to request AtomicOps despite the Root Port
lacking support for completing them:

  00:00.1 Ethernet controller: Mellanox Technologies MT2894 Family [ConnectX-6 Lx]
          Subsystem: Mellanox Technologies Device 0002
          DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                   AtomicOpsCtl: ReqEn+

On s390 and many virtualized guests, the Endpoint is visible but the Root
Port is not.  In this case, pci_enable_atomic_ops_to_root() previously
enabled AtomicOps in the Endpoint even though it can't tell whether the
Root Port supports them as a completer.

Change pci_enable_atomic_ops_to_root() to fail if there's no Root Port or
the Root Port doesn't support AtomicOps.

Fixes: 430a23689dea ("PCI: Add pci_enable_atomic_ops_to_root()")
Reported-by: Alexander Schmidt <alexs@linux.ibm.com>
Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
[bhelgaas: commit log, check RP first to simplify flow]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260330-fix_pciatops-v7-2-f601818417e8@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 5233490502dd1..a67207649ce39 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3742,8 +3742,7 @@ int pci_rebar_set_size(struct pci_dev *pdev, int bar, int size)
  */
 int pci_enable_atomic_ops_to_root(struct pci_dev *dev, u32 cap_mask)
 {
-	struct pci_bus *bus = dev->bus;
-	struct pci_dev *bridge;
+	struct pci_dev *root, *bridge;
 	u32 cap, ctl2;
 
 	/*
@@ -3773,35 +3772,35 @@ int pci_enable_atomic_ops_to_root(struct pci_dev *dev, u32 cap_mask)
 		return -EINVAL;
 	}
 
-	while (bus->parent) {
-		bridge = bus->self;
+	root = pcie_find_root_port(dev);
+	if (!root)
+		return -EINVAL;
 
-		pcie_capability_read_dword(bridge, PCI_EXP_DEVCAP2, &cap);
+	pcie_capability_read_dword(root, PCI_EXP_DEVCAP2, &cap);
+	if ((cap & cap_mask) != cap_mask)
+		return -EINVAL;
 
+	bridge = pci_upstream_bridge(dev);
+	while (bridge != root) {
 		switch (pci_pcie_type(bridge)) {
-		/* Ensure switch ports support AtomicOp routing */
 		case PCI_EXP_TYPE_UPSTREAM:
-		case PCI_EXP_TYPE_DOWNSTREAM:
-			if (!(cap & PCI_EXP_DEVCAP2_ATOMIC_ROUTE))
-				return -EINVAL;
-			break;
-
-		/* Ensure root port supports all the sizes we care about */
-		case PCI_EXP_TYPE_ROOT_PORT:
-			if ((cap & cap_mask) != cap_mask)
-				return -EINVAL;
-			break;
-		}
-
-		/* Ensure upstream ports don't block AtomicOps on egress */
-		if (pci_pcie_type(bridge) == PCI_EXP_TYPE_UPSTREAM) {
+			/* Upstream ports must not block AtomicOps on egress */
 			pcie_capability_read_dword(bridge, PCI_EXP_DEVCTL2,
 						   &ctl2);
 			if (ctl2 & PCI_EXP_DEVCTL2_ATOMIC_EGRESS_BLOCK)
 				return -EINVAL;
+			fallthrough;
+
+		/* All switch ports need to route AtomicOps */
+		case PCI_EXP_TYPE_DOWNSTREAM:
+			pcie_capability_read_dword(bridge, PCI_EXP_DEVCAP2,
+						   &cap);
+			if (!(cap & PCI_EXP_DEVCAP2_ATOMIC_ROUTE))
+				return -EINVAL;
+			break;
 		}
 
-		bus = bus->parent;
+		bridge = pci_upstream_bridge(bridge);
 	}
 
 	pcie_capability_set_word(dev, PCI_EXP_DEVCTL2,
-- 
2.53.0



