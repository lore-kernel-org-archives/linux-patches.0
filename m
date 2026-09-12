Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD691472541;
	Sat, 12 Sep 2026 13:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218225; cv=none; b=LZ/1/b9Zrv1FanG31kG//qhlagJRnOuT/YFaoUjSfM0+iNSqb+emqsZQaHftxVEXibphz3uaQKtaFBwGm/M0QRMain7M2UH4WswYqz7ZFK6CBH3z+ShXJWhoxllDz8cOanR0ZjmnlFGS5Y85ju6byn8Aysz/0b6jnlsHdZ5fjTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218225; c=relaxed/simple;
	bh=Vh1ZUk4XOqePif8glwha45kScKf9a3oEe9iI9ZP30bI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvZDwUsgNGbNjPXLY95042Xwa1m1lBMi/yFVtNPUVphUNkkmLVu06pT9WPYvuJjpG5ngHl8l2x8EG5wimx/liXog8412NFIjRm86A7o5kNZAlMASBZFLCQ4Ft3d5Lyjrxzc5G+NkiL7PZQtJLad6fZdDBFT2ZEmeD2rzubl6gws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P48kMSJF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P48kMSJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B6C1F000FF;
	Sat, 12 Sep 2026 13:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218223;
	bh=LNzl1kPOmwvH9fseKJiQpuKmRXKPkgoYTbbOGvpAh5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P48kMSJFQ7GnDMzV7/qelmYWSG29zZdhzSABOezNT5swR2ELla6q8yresbABrg1Ug
	 9PsNuQ73CzJaCDkVrQYq1IBrk9MTZKIekAG5d94EpETf3J0aveqaGTCCCaHlu+ykPB
	 P+XI0dewysF47X58RKQRs9r+mS3BY68suzPEkDuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1099/1376] PCI/ASPM: Cache L0s/L1 Supported so advertised link states can be overridden
Date: Sat, 12 Sep 2026 08:58:45 +0200
Message-ID: <20260912065632.054527718@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 4495bffd86ba0fdabfaef0c41d12f68ec2a1e05b ]

Defective devices sometimes advertise support for ASPM L0s or L1 states
even if they don't work correctly.

Cache the L0s Supported and L1 Supported bits early in enumeration so
HEADER quirks can override the ASPM states advertised in Link Capabilities
before pcie_aspm_cap_init() enables ASPM.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Shawn Lin <shawn.lin@rock-chips.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Link: https://patch.msgid.link/20251110222929.2140564-2-helgaas@kernel.org
Stable-dep-of: 733cd811b3ac ("PCI/ASPM: Disable/restore ASPM on every function for multi-function devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aspm.c | 12 ++++--------
 drivers/pci/probe.c     |  7 +++++++
 include/linux/pci.h     |  2 ++
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index fc47d5ccbf598..b6aeae7904736 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -798,7 +798,6 @@ static void aspm_l1ss_init(struct pcie_link_state *link)
 static void pcie_aspm_cap_init(struct pcie_link_state *link, int blacklist)
 {
 	struct pci_dev *child = link->downstream, *parent = link->pdev;
-	u32 parent_lnkcap, child_lnkcap;
 	u16 parent_lnkctl, child_lnkctl;
 	struct pci_bus *linkbus = parent->subordinate;
 
@@ -813,9 +812,8 @@ static void pcie_aspm_cap_init(struct pcie_link_state *link, int blacklist)
 	 * If ASPM not supported, don't mess with the clocks and link,
 	 * bail out now.
 	 */
-	pcie_capability_read_dword(parent, PCI_EXP_LNKCAP, &parent_lnkcap);
-	pcie_capability_read_dword(child, PCI_EXP_LNKCAP, &child_lnkcap);
-	if (!(parent_lnkcap & child_lnkcap & PCI_EXP_LNKCAP_ASPMS))
+	if (!(parent->aspm_l0s_support && child->aspm_l0s_support) &&
+	    !(parent->aspm_l1_support && child->aspm_l1_support))
 		return;
 
 	/* Configure common clock before checking latencies */
@@ -827,8 +825,6 @@ static void pcie_aspm_cap_init(struct pcie_link_state *link, int blacklist)
 	 * read-only Link Capabilities may change depending on common clock
 	 * configuration (PCIe r5.0, sec 7.5.3.6).
 	 */
-	pcie_capability_read_dword(parent, PCI_EXP_LNKCAP, &parent_lnkcap);
-	pcie_capability_read_dword(child, PCI_EXP_LNKCAP, &child_lnkcap);
 	pcie_capability_read_word(parent, PCI_EXP_LNKCTL, &parent_lnkctl);
 	pcie_capability_read_word(child, PCI_EXP_LNKCTL, &child_lnkctl);
 
@@ -848,7 +844,7 @@ static void pcie_aspm_cap_init(struct pcie_link_state *link, int blacklist)
 	 * given link unless components on both sides of the link each
 	 * support L0s.
 	 */
-	if (parent_lnkcap & child_lnkcap & PCI_EXP_LNKCAP_ASPM_L0S)
+	if (parent->aspm_l0s_support && child->aspm_l0s_support)
 		link->aspm_support |= PCIE_LINK_STATE_L0S;
 
 	if (child_lnkctl & PCI_EXP_LNKCTL_ASPM_L0S)
@@ -857,7 +853,7 @@ static void pcie_aspm_cap_init(struct pcie_link_state *link, int blacklist)
 		link->aspm_enabled |= PCIE_LINK_STATE_L0S_DW;
 
 	/* Setup L1 state */
-	if (parent_lnkcap & child_lnkcap & PCI_EXP_LNKCAP_ASPM_L1)
+	if (parent->aspm_l1_support && child->aspm_l1_support)
 		link->aspm_support |= PCIE_LINK_STATE_L1;
 
 	if (parent_lnkctl & child_lnkctl & PCI_EXP_LNKCTL_ASPM_L1)
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index d8c5a957b70e5..718293b4bdb98 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1589,6 +1589,13 @@ void set_pcie_port_type(struct pci_dev *pdev)
 	if (reg32 & PCI_EXP_LNKCAP_DLLLARC)
 		pdev->link_active_reporting = 1;
 
+#ifdef CONFIG_PCIEASPM
+	if (reg32 & PCI_EXP_LNKCAP_ASPM_L0S)
+		pdev->aspm_l0s_support = 1;
+	if (reg32 & PCI_EXP_LNKCAP_ASPM_L1)
+		pdev->aspm_l1_support = 1;
+#endif
+
 	parent = pci_upstream_bridge(pdev);
 	if (!parent)
 		return;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 24e586153f622..2e47edd0f515b 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -409,6 +409,8 @@ struct pci_dev {
 	u16		l1ss;		/* L1SS Capability pointer */
 #ifdef CONFIG_PCIEASPM
 	struct pcie_link_state	*link_state;	/* ASPM link state */
+	unsigned int	aspm_l0s_support:1;	/* ASPM L0s support */
+	unsigned int	aspm_l1_support:1;	/* ASPM L1 support */
 	unsigned int	ltr_path:1;	/* Latency Tolerance Reporting
 					   supported from root to here */
 #endif
-- 
2.53.0



