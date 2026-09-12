Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC26429000;
	Sat, 12 Sep 2026 13:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218180; cv=none; b=m6vhjVoKn3uQnSrbiXYCvrYs1ER1xS4GxWAR6pHfedc5OYdCYb9JDY75djNE24sOKTrPqpy3VtN0/Tbo9WHHdhyuYw7iyLumglyrQP5yDVl3On8La+8/OzNFAHt1FC/7CKtnZBYXP7WnnL4Ahm58bI4+5VKOkftMoFsMXv/wb7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218180; c=relaxed/simple;
	bh=eE/cBfTdnJmMP5U7Rgim0GWQpGYLZZAoekz1ctatahk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMB/y2rU42WQLC4i1YiaD1Q+3Lht5mjbRzIHgsswYuhGgsa/RZWxl5FhUMUCYwm0fHflsdpJx6dmhc1GWwZ7maQ5VQEMQjUBNUyoJwDkXnXXowSV4zqO+uj6b648KV8GNlA2HFDVUjJN6onVWwfMvU+EbR6X5oOSYOXJPSh+wOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CQ5NevEM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CQ5NevEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9975D1F000FF;
	Sat, 12 Sep 2026 13:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218178;
	bh=UXKc9xQfZnaQgWev8ZDRbJgCblbybHlFPWHkNt9QRmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CQ5NevEMgIe6lCwTJCIQ2yKj3gRWkwUvV1GHpj/PKk7gCES8uqnPe18yrBS2KskNq
	 gTmJEZgXAMYA0WPFcyaNlgdv9Z9uSnoeRTbGzWqQqvTV/9yX+/dD0rW5cmm+ylQMny
	 jJaRh86puv2OMsuXCJr6JeR/EJWjkF0nRe0DPqJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1091/1376] PCI/ASPM: Use pcie_capability_clear_and_set_word() for ASPM disable/restore
Date: Sat, 12 Sep 2026 08:58:37 +0200
Message-ID: <20260912065631.877453029@linuxfoundation.org>
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
index b746038b59e7d..fc47d5ccbf598 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -835,10 +835,10 @@ static void pcie_aspm_cap_init(struct pcie_link_state *link, int blacklist)
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
@@ -868,8 +868,12 @@ static void pcie_aspm_cap_init(struct pcie_link_state *link, int blacklist)
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



