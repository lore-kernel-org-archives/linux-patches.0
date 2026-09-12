Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58B222D785;
	Sat, 12 Sep 2026 13:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218228; cv=none; b=NZ4trsaUe/bAJiYxTjCsmCNhnQU0jRMGLIsjQiDfNh7j6ZEwjczPgA9IP+DchnTeH7ws068FWL/AcInIu1isN6tXNe1aXv3yct883sPVGVrUQk4D6X3rEKxJRlApwM20CtqX+DLwV0eNfn62pCP7NH5jSw9GXhO8coBiJ6iLvTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218228; c=relaxed/simple;
	bh=hXGMEAm16EzMZ01cfihQrztqvNKpcwZKiyoL24Dbv8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZ9HsgU5INhzT/Oiw9hvma689AMDybAtA7ZHSohf6jd/mHgakl2R8PX9oNibekMthwTD/VO16qcUZG3Lg0TMoyScYw0Dv2lyYdJYt6UesNFyRfsaAl/xLggO9tgQ3JAC3BWu/IGFYx2u1aBhnpXs9KqKY6t8OhNTAyyl2mE75T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AtqBv9p4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AtqBv9p4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049FF1F000FF;
	Sat, 12 Sep 2026 13:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218227;
	bh=si5sVrOiTckM2/EYCdRkxCpSh4cn2G8T5mJkjNxxqVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AtqBv9p47b0EWbMpIfGGW8TEMpXi+xpXC0RksI4UmJh7NEFbNcVGo/MoiR915Zb8P
	 xGxWU8N/3ZpWheKtdLxqlCR+X8ohxCEYFvWLm4df50lg5cvPQot5fu59+3u1Lt1L6d
	 1IjxJZecebIawkrtk0wtkHgdn6CcNyVHCuVsXDnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1100/1376] PCI/ASPM: Disable/restore ASPM on every function for multi-function devices
Date: Sat, 12 Sep 2026 08:58:46 +0200
Message-ID: <20260912065632.075795932@linuxfoundation.org>
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

From: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>

[ Upstream commit 733cd811b3ac50586164a0864c4351fe23e21890 ]

pcie_aspm_cap_init() disables ASPM L0s/L1 before touching L1SS config, then
restores the pre-existing state afterward. Both steps only ever touched
link->downstream, i.e. function 0 of the downstream component, leaving
sibling functions (>0) on a multi-function device untouched.

This means the "disable" step does not actually disable ASPM link-wide on a
multi-function device: a sibling function can still have L1 enabled even
after this step runs. PCIe r7.0, sec 7.5.3.7, recommends programming the
same ASPM Control value for all functions of a multi-function device, and
pcie_config_aspm_link() already loops over every function on the bus for
exactly this reason.

Loop over every function on linkbus->devices for both the disable and
restore steps, keeping the existing sec 7.5.3.7 ordering (disable
downstream functions before upstream, restore upstream before downstream
functions). The masked pcie_capability_clear_and_set_word() accessor from
the previous commit makes this safe: it only ever touches the ASPM Control
bits, so function-specific bits elsewhere in LNKCTL (e.g. Read Completion
Boundary, CLKREQ Enable) on sibling functions are left untouched.

Fixes: 7447990137bf ("PCI/ASPM: Disable L1 before disabling L1 PM Substates")
Closes: https://lore.kernel.org/all/20260721143945.86E7D1F000E9@smtp.kernel.org/
Signed-off-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20260727-aspm-v6-2-2ebb3ee7ef71@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aspm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index b6aeae7904736..fc3f526f76a23 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -798,6 +798,7 @@ static void aspm_l1ss_init(struct pcie_link_state *link)
 static void pcie_aspm_cap_init(struct pcie_link_state *link, int blacklist)
 {
 	struct pci_dev *child = link->downstream, *parent = link->pdev;
+	struct pci_dev *fn;
 	u16 parent_lnkctl, child_lnkctl;
 	struct pci_bus *linkbus = parent->subordinate;
 
@@ -831,8 +832,9 @@ static void pcie_aspm_cap_init(struct pcie_link_state *link, int blacklist)
 	/* Disable L0s/L1 before updating L1SS config */
 	if (FIELD_GET(PCI_EXP_LNKCTL_ASPMC, child_lnkctl) ||
 	    FIELD_GET(PCI_EXP_LNKCTL_ASPMC, parent_lnkctl)) {
-		pcie_capability_clear_and_set_word(child, PCI_EXP_LNKCTL,
-					PCI_EXP_LNKCTL_ASPMC, 0);
+		list_for_each_entry(fn, &linkbus->devices, bus_list)
+			pcie_capability_clear_and_set_word(fn, PCI_EXP_LNKCTL,
+						PCI_EXP_LNKCTL_ASPMC, 0);
 		pcie_capability_clear_and_set_word(parent, PCI_EXP_LNKCTL,
 						PCI_EXP_LNKCTL_ASPMC, 0);
 	}
@@ -867,7 +869,8 @@ static void pcie_aspm_cap_init(struct pcie_link_state *link, int blacklist)
 		pcie_capability_clear_and_set_word(parent, PCI_EXP_LNKCTL,
 					PCI_EXP_LNKCTL_ASPMC,
 					parent_lnkctl & PCI_EXP_LNKCTL_ASPMC);
-		pcie_capability_clear_and_set_word(child, PCI_EXP_LNKCTL,
+		list_for_each_entry(fn, &linkbus->devices, bus_list)
+			pcie_capability_clear_and_set_word(fn, PCI_EXP_LNKCTL,
 					PCI_EXP_LNKCTL_ASPMC,
 					child_lnkctl & PCI_EXP_LNKCTL_ASPMC);
 	}
-- 
2.53.0



