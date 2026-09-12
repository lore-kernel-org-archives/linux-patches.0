Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88173C1D67;
	Sat, 12 Sep 2026 11:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211104; cv=none; b=EmDJ5I4lG68AR+szMAs4pjvmrERuQrtuj1njEvH5i9tf24CtdbHxzLseccXY6vAWxOYbS+sgmuqK20THtxQ63UCPaS4pYMusCTcjeEryXABW08qUnbQsWeoKzNbB+PYcagvqR6hT0RT6PTjLM/pU/HNnEFhSvRMwIOYzVWXFOfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211104; c=relaxed/simple;
	bh=Q1ifvc4RZGEQ7/Gh8noOGJVlwKxgoAyJWH/IF3TKIpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=REo6v5mpkI4Z+EZ9ZFry4bF1A7Pwoka9Li+tZLaaJEkdPvJfPItQvZTfNpLCUTLTcbBYa/iCSqaDpjqGBLxBIlJBP2Lk8uvGznbhzr4MoSUeVS4DHBqyfdxjo+HnXpGksPNXtvzzqOQsTPBT013hExvhO1DubhCK2LY5EDpORds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yyGSjkNi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yyGSjkNi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4C21F000FF;
	Sat, 12 Sep 2026 11:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211103;
	bh=ylOJIm5S8ylKjgkGizJ/0lmXLt19GkjFKAnam8y1aA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yyGSjkNil7AHYqSko8tjUdtRPpInQI7wuRAu4qBjRaIFdBSxAgs7JRPuZg6CNFYtc
	 c2xAdIkl4diG4ryeAZ75JtZdV5sK1DuZNAvOorK6A43x/hwOH0irQWk3DmmrV0xK57
	 O6ZshNAMcqWhbdoHCxKxzdFubhBB8eaRcMo2ATs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1163/1518] PCI/ASPM: Disable/restore ASPM on every function for multi-function devices
Date: Sat, 12 Sep 2026 08:55:32 +0200
Message-ID: <20260912065649.768170125@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index af1a2c2b1f7d8..dac81130edd3d 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -821,6 +821,7 @@ static void pcie_aspm_override_default_link_state(struct pcie_link_state *link)
 static void pcie_aspm_cap_init(struct pcie_link_state *link, int blacklist)
 {
 	struct pci_dev *child = link->downstream, *parent = link->pdev;
+	struct pci_dev *fn;
 	u16 parent_lnkctl, child_lnkctl;
 	struct pci_bus *linkbus = parent->subordinate;
 
@@ -854,8 +855,9 @@ static void pcie_aspm_cap_init(struct pcie_link_state *link, int blacklist)
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
@@ -890,7 +892,8 @@ static void pcie_aspm_cap_init(struct pcie_link_state *link, int blacklist)
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



