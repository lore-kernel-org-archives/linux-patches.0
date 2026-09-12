Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB80208D0;
	Sat, 12 Sep 2026 08:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203364; cv=none; b=CwuSwkfejKgsccPfTNIZBbg+v0H9Hx+mWBNFVtZHeZtPKKBGrUUrqs5KViLheVJrI66BQSOQvzHebXhaUrsxsDfsM54HLALXNNGkGaX3KFs6faoXJbUjBLrKBntQfyqsTcuLHp3fXR7ZIoimj26pTQawcum3B59Sn/ZYCZr//bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203364; c=relaxed/simple;
	bh=1EIxNZirMqWU4Or0e5Syzeo4zL1kWSrzLEI+rvmM0EM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=krYHz8vgpOHJvDetfvpC+XoFyGBcCyayCEtox/Q+mdvqtObkLup3ba0XHAuZhm2RUs1JtDx6TN++YteHa9l6EqJNDooPNlhrstQybD9/eufvwfIB2rknW6ITjqqS/NLML5OZVbjJfomf2rkdKIWgPvygXE76E0qRDETTrYVQvNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=scOVIakB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="scOVIakB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D1D1F000FF;
	Sat, 12 Sep 2026 08:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203363;
	bh=1VdJnQ9ooILE1KN/dCHi1GonJUFE1M4Ze5LgFMBuINI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=scOVIakBDhXaIWGskJj4py6lBOQpuTi8r7xDFQH5KaN56Ch10khDidVZmLeWW9cOJ
	 xG2scF4H5Uw1S9gT6jrtxZHRFYJVlY7LDVATh/L2s3koQHFLV3korYdrGfGI3nl7PE
	 gSu7bugBqamgF1vv25ajnTSpj+efhQGKKMoOa9+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1393/1815] PCI/ASPM: Use pcie_capability_clear_and_set_word() for ASPM disable/restore
Date: Sat, 12 Sep 2026 08:52:23 +0200
Message-ID: <20260912065721.726763972@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>

[ Upstream commit 75a3b50ad9dc99ce9693a0086b968c6d3501db21 ]

pcie_aspm_cap_init() disables ASPM L0s/L1 on both ends of the Link
before touching L1SS config, then later restores the LNKCTL state
that was in effect beforehand. Both steps use raw
pcie_capability_write_word() calls: the disable step computes the
new value by hand from a snapshot taken earlier in the function, and
the restore step writes that same snapshot straight back.

Switch both steps to pcie_capability_clear_and_set_word(), masked to
PCI_EXP_LNKCTL_ASPMC, matching the accessor pcie_config_aspm_dev()
already uses elsewhere in this file for the exact same register. This
does a live read-modify-write of just the ASPM Control bits instead of
relying on a stale snapshot for the rest of the word, and is
consistent with how the rest of the file already touches this
register. No functional change.

Fixes: 7447990137bf ("PCI/ASPM: Disable L1 before disabling L1 PM Substates")
Closes: https://lore.kernel.org/all/20260721143945.86E7D1F000E9@smtp.kernel.org/
Signed-off-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20260727-aspm-v6-1-2ebb3ee7ef71@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aspm.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 172783e7f519a..50ff78a62e8a4 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -894,10 +894,10 @@ static void pcie_aspm_cap_init(struct pcie_link_state *link, int blacklist)
 	/* Disable L0s/L1 before updating L1SS config */
 	if (FIELD_GET(PCI_EXP_LNKCTL_ASPMC, child_lnkctl) ||
 	    FIELD_GET(PCI_EXP_LNKCTL_ASPMC, parent_lnkctl)) {
-		pcie_capability_write_word(child, PCI_EXP_LNKCTL,
-					   child_lnkctl & ~PCI_EXP_LNKCTL_ASPMC);
-		pcie_capability_write_word(parent, PCI_EXP_LNKCTL,
-					   parent_lnkctl & ~PCI_EXP_LNKCTL_ASPMC);
+		pcie_capability_clear_and_set_word(child, PCI_EXP_LNKCTL,
+					PCI_EXP_LNKCTL_ASPMC, 0);
+		pcie_capability_clear_and_set_word(parent, PCI_EXP_LNKCTL,
+						PCI_EXP_LNKCTL_ASPMC, 0);
 	}
 
 	/*
@@ -927,8 +927,12 @@ static void pcie_aspm_cap_init(struct pcie_link_state *link, int blacklist)
 	/* Restore L0s/L1 if they were enabled */
 	if (FIELD_GET(PCI_EXP_LNKCTL_ASPMC, child_lnkctl) ||
 	    FIELD_GET(PCI_EXP_LNKCTL_ASPMC, parent_lnkctl)) {
-		pcie_capability_write_word(parent, PCI_EXP_LNKCTL, parent_lnkctl);
-		pcie_capability_write_word(child, PCI_EXP_LNKCTL, child_lnkctl);
+		pcie_capability_clear_and_set_word(parent, PCI_EXP_LNKCTL,
+					PCI_EXP_LNKCTL_ASPMC,
+					parent_lnkctl & PCI_EXP_LNKCTL_ASPMC);
+		pcie_capability_clear_and_set_word(child, PCI_EXP_LNKCTL,
+					PCI_EXP_LNKCTL_ASPMC,
+					child_lnkctl & PCI_EXP_LNKCTL_ASPMC);
 	}
 
 	/* Save default state */
-- 
2.53.0



