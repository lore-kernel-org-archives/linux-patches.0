Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEF0DF59;
	Wed,  5 Feb 2025 15:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767898; cv=none; b=E5VL3wlkiLEYprrRM4XAbAyttQY1bZGwcX9lerejo50Mzvv4/PHwSzWSWCV6lBwmNJ/Yfsp/jEkvlEAPu/XXi6hPiasrdOsi6IJpXQz+YCtIo/ukiooMXPIMbz3BNNOPbhrDgIyf46V99rPA7hnb3TU0by9gDQtVv2vgN3DBXK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767898; c=relaxed/simple;
	bh=dr1cArv6SpAzTa6cyeoqpDKpMOs7CuJpj8Zioq2orWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=djySHoIsu967+5VP+tQiasef44Q8MJUSpiJCaaYRdp2jfIOy3x1fxvMSdL2C+8WKCCzlzzyGXIy1ndH2uGPsqLEeSTsm/WViJFz+uhZpQbGTvNtCtNU0wxcxNXXjWvZPDc179w3jpIfpq4wCa1IY+Dc7fSq3gdjNuL6jxIgz5F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=toadHl7S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="toadHl7S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845DFC4CED1;
	Wed,  5 Feb 2025 15:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767897;
	bh=dr1cArv6SpAzTa6cyeoqpDKpMOs7CuJpj8Zioq2orWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=toadHl7SdOhJ0dXI84P9xTkO7TBV7wohUPgrTfLwKy3dOq0zY7XNymXe2YfIvsh7f
	 NeneRoRB0aKx3YGoPs200HkavJSTpaLBlo/tE2Csw/SbbYJPaihTSRKH3EayhlCxSh
	 9IWSQjIICaGybb7GEpZRdVk4LutxRd/1u9RVRlNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jian-Hong Pan <jhp@endlessos.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 445/623] PCI/ASPM: Save parent L1SS config in pci_save_aspm_l1ss_state()
Date: Wed,  5 Feb 2025 14:43:07 +0100
Message-ID: <20250205134513.241757556@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jian-Hong Pan <jhp@endlessos.org>

[ Upstream commit 1db806ec06b7c6e08e8af57088da067963ddf117 ]

After 17423360a27a ("PCI/ASPM: Save L1 PM Substates Capability for
suspend/resume"), pci_save_aspm_l1ss_state(dev) saves the L1SS state for
"dev", and pci_restore_aspm_l1ss_state(dev) restores the state for both
"dev" and its parent.

The problem is that unless pci_save_state() has been used in some other
path and has already saved the parent L1SS state, we will restore junk to
the parent, which means the L1 Substates likely won't work correctly.

Save the L1SS config for both the device and its parent in
pci_save_aspm_l1ss_state().  When restoring, we need both because L1SS must
be enabled at the parent (the Downstream Port) before being enabled at the
child (the Upstream Port).

Link: https://lore.kernel.org/r/20241115072200.37509-3-jhp@endlessos.org
Fixes: 17423360a27a ("PCI/ASPM: Save L1 PM Substates Capability for suspend/resume")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218394
Suggested-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Jian-Hong Pan <jhp@endlessos.org>
[bhelgaas: parallel save/restore structure, simplify commit log, patch at
https://lore.kernel.org/r/20241212230340.GA3267194@bhelgaas]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Jian-Hong Pan <jhp@endlessos.org> # Asus B1400CEAE
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aspm.c | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 28567d457613b..e0bc90597dcad 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -81,24 +81,47 @@ void pci_configure_aspm_l1ss(struct pci_dev *pdev)
 
 void pci_save_aspm_l1ss_state(struct pci_dev *pdev)
 {
+	struct pci_dev *parent = pdev->bus->self;
 	struct pci_cap_saved_state *save_state;
-	u16 l1ss = pdev->l1ss;
 	u32 *cap;
 
+	/*
+	 * If this is a Downstream Port, we never restore the L1SS state
+	 * directly; we only restore it when we restore the state of the
+	 * Upstream Port below it.
+	 */
+	if (pcie_downstream_port(pdev) || !parent)
+		return;
+
+	if (!pdev->l1ss || !parent->l1ss)
+		return;
+
 	/*
 	 * Save L1 substate configuration. The ASPM L0s/L1 configuration
 	 * in PCI_EXP_LNKCTL_ASPMC is saved by pci_save_pcie_state().
 	 */
-	if (!l1ss)
+	save_state = pci_find_saved_ext_cap(pdev, PCI_EXT_CAP_ID_L1SS);
+	if (!save_state)
 		return;
 
-	save_state = pci_find_saved_ext_cap(pdev, PCI_EXT_CAP_ID_L1SS);
+	cap = &save_state->cap.data[0];
+	pci_read_config_dword(pdev, pdev->l1ss + PCI_L1SS_CTL2, cap++);
+	pci_read_config_dword(pdev, pdev->l1ss + PCI_L1SS_CTL1, cap++);
+
+	if (parent->state_saved)
+		return;
+
+	/*
+	 * Save parent's L1 substate configuration so we have it for
+	 * pci_restore_aspm_l1ss_state(pdev) to restore.
+	 */
+	save_state = pci_find_saved_ext_cap(parent, PCI_EXT_CAP_ID_L1SS);
 	if (!save_state)
 		return;
 
 	cap = &save_state->cap.data[0];
-	pci_read_config_dword(pdev, l1ss + PCI_L1SS_CTL2, cap++);
-	pci_read_config_dword(pdev, l1ss + PCI_L1SS_CTL1, cap++);
+	pci_read_config_dword(parent, parent->l1ss + PCI_L1SS_CTL2, cap++);
+	pci_read_config_dword(parent, parent->l1ss + PCI_L1SS_CTL1, cap++);
 }
 
 void pci_restore_aspm_l1ss_state(struct pci_dev *pdev)
-- 
2.39.5



