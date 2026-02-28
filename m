Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFCE4611C5;
	Sat, 28 Feb 2026 17:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301292; cv=none; b=f7afWOfhTLeV6czh0hKUUYe6gbXyqK7dqf/z248WAKgiahoPpM5VXePo0/0TZTKVxlcNJSpISJigft84OP700xeCxauRcuwj6cftREN8seQVmJQLs2inczqRg0Xz9HLzue5RdL2H+QSyfMsmcVTTKvht/JuXIRYa9NSFGcthCCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301292; c=relaxed/simple;
	bh=KepthDvKN58g5vtpAh7QeLEvGzLhyxX9qFM1TkOmNq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9iAlKdlOKkOP9rOCXQrr3h8c3lwh/4ojoFteDqJoPN1ANXDiydhUB9A8wby3tmivhj+1X6D7IJrj5n0u8AsKcAttgkUrRjEePnAIInrcRmgtD6uj5YNHb7tBeODqy8pl82bC8+iVNMyXRW9xykC3VLckPESgKIUmCPodyxPJpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LLkOBxvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LLkOBxvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2151EC19424;
	Sat, 28 Feb 2026 17:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301291;
	bh=KepthDvKN58g5vtpAh7QeLEvGzLhyxX9qFM1TkOmNq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LLkOBxvE8ixiDBhii1PF6AyY4f6SMJVmyOBdpacSFyzcwHziCDnfcLxknZKPWxYbp
	 cBV2aZQ8yoFDxzsIetHDJE46JeGdWOP4arOCzL08GBl9x4EnuFDgY9Qd1nrFYP6FXL
	 6XJQHA0Budjy8IEbrULBUrUsxBg/Qnia/FwJLqpD8Yz4nqQBHPahWs9khhE7Y9Gcps
	 p6GnBsl41SBdF/XRELuIQ+HGhXQ1AhZTclraJMKr3x/OxV+bIm/z8tVnXOZeYpWhF/
	 cXtU7Gmaf8DglZW5384Qx91hSttpsTa5uUFSfx6aDPdDxywvmTv6V/6sVFP54xYlpq
	 mKLL7Edffzg+w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 476/752] Revert "PCI: dwc: Don't wait for link up if driver can detect Link Up event"
Date: Sat, 28 Feb 2026 12:43:07 -0500
Message-ID: <20260228174750.1542406-476-sashal@kernel.org>
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

[ Upstream commit 142d5869f6eec3110adda0ad2d931f5b3c22371d ]

This reverts commit 8d3bf19f1b585a3cc0027f508b64c33484db8d0d.

While this fake hotplugging was a nice idea, it has shown that this feature
does not handle PCIe switches correctly:
pci_bus 0004:43: busn_res: can not insert [bus 43-41] under [bus 42-41] (conflicts with (null) [bus 42-41])
pci_bus 0004:43: busn_res: [bus 43-41] end is updated to 43
pci_bus 0004:43: busn_res: can not insert [bus 43] under [bus 42-41] (conflicts with (null) [bus 42-41])
pci 0004:42:00.0: devices behind bridge are unusable because [bus 43] cannot be assigned for them
pci_bus 0004:44: busn_res: can not insert [bus 44-41] under [bus 42-41] (conflicts with (null) [bus 42-41])
pci_bus 0004:44: busn_res: [bus 44-41] end is updated to 44
pci_bus 0004:44: busn_res: can not insert [bus 44] under [bus 42-41] (conflicts with (null) [bus 42-41])
pci 0004:42:02.0: devices behind bridge are unusable because [bus 44] cannot be assigned for them
pci_bus 0004:45: busn_res: can not insert [bus 45-41] under [bus 42-41] (conflicts with (null) [bus 42-41])
pci_bus 0004:45: busn_res: [bus 45-41] end is updated to 45
pci_bus 0004:45: busn_res: can not insert [bus 45] under [bus 42-41] (conflicts with (null) [bus 42-41])
pci 0004:42:06.0: devices behind bridge are unusable because [bus 45] cannot be assigned for them
pci_bus 0004:46: busn_res: can not insert [bus 46-41] under [bus 42-41] (conflicts with (null) [bus 42-41])
pci_bus 0004:46: busn_res: [bus 46-41] end is updated to 46
pci_bus 0004:46: busn_res: can not insert [bus 46] under [bus 42-41] (conflicts with (null) [bus 42-41])
pci 0004:42:0e.0: devices behind bridge are unusable because [bus 46] cannot be assigned for them
pci_bus 0004:42: busn_res: [bus 42-41] end is updated to 46
pci_bus 0004:42: busn_res: can not insert [bus 42-46] under [bus 41] (conflicts with (null) [bus 41])
pci 0004:41:00.0: devices behind bridge are unusable because [bus 42-46] cannot be assigned for them
pcieport 0004:40:00.0: bridge has subordinate 41 but max busn 46

During the initial scan, PCI core doesn't see the switch and since the Root
Port is not hot plug capable, the secondary bus number gets assigned as the
subordinate bus number. This means, the PCI core assumes that only one bus
will appear behind the Root Port since the Root Port is not hot plug
capable.

This works perfectly fine for PCIe endpoints connected to the Root Port,
since they don't extend the bus. However, if a PCIe switch is connected,
then there is a problem when the downstream busses starts showing up and
the PCI core doesn't extend the subordinate bus number and bridge resources
after initial scan during boot.

So revert the change that skipped dw_pcie_wait_for_link() if the Link up
IRQ was used by a vendor glue driver.

Suggested-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Tested-by: Shawn Lin <shawn.lin@rock-chips.com>
Acked-by: Shawn Lin <shawn.lin@rock-chips.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251222064207.3246632-14-cassel@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-host.c | 10 ++--------
 drivers/pci/controller/dwc/pcie-designware.h      |  1 -
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
index 702885c53f467..60fadaa1c0bd2 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -664,14 +664,8 @@ int dw_pcie_host_init(struct dw_pcie_rp *pp)
 			goto err_remove_edma;
 	}
 
-	/*
-	 * Note: Skip the link up delay only when a Link Up IRQ is present.
-	 * If there is no Link Up IRQ, we should not bypass the delay
-	 * because that would require users to manually rescan for devices.
-	 */
-	if (!pp->use_linkup_irq)
-		/* Ignore errors, the link may come up later */
-		dw_pcie_wait_for_link(pci);
+	/* Ignore errors, the link may come up later */
+	dw_pcie_wait_for_link(pci);
 
 	ret = pci_host_probe(bridge);
 	if (ret)
diff --git a/drivers/pci/controller/dwc/pcie-designware.h b/drivers/pci/controller/dwc/pcie-designware.h
index 24bfa5231923a..7c56146b95f6b 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -426,7 +426,6 @@ struct dw_pcie_rp {
 	bool			use_atu_msg;
 	int			msg_atu_index;
 	struct resource		*msg_res;
-	bool			use_linkup_irq;
 	struct pci_eq_presets	presets;
 	struct pci_config_window *cfg;
 	bool			ecam_enabled;
-- 
2.51.0

