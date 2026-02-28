Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E3338F623
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302137; cv=none; b=cbBzcRDr+M+i0abAUFir1FbyAeR/FqcPXARZCdHYYjR7Wd0CwMTKXQ6cIhgfq1xN9LEiE/gpX/3q9ATck/ayvkxxiubIp8qQf5FoHQnE4mnWH4XvdI20KtFZPDXWV7RARhwmLlXBz9lD0oPZtkNbsfUK4qOD44sKPldSTffJXbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302137; c=relaxed/simple;
	bh=cHrLCTfDs2ij7eM9GBFF2O+X2uM/2TKh1IwmHEpqJnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=raEfotvjO7N9eMnVhtf37HBrykZbY2nDfPpkkd8XhvVIQYdSWFF8BFIT6wSNz7QdP3BEl3mnL2yFS1JaOC/u8kgZHAfz5BqyQvSNt1JWK4LcyaNpTNk8cOqwAduUj1YNmSNlhOHqANy/6HNp+W+nKloeN5uOYLmMNgjkAYcx5h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KZR2WRJz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KZR2WRJz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06E3C19425;
	Sat, 28 Feb 2026 18:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302137;
	bh=cHrLCTfDs2ij7eM9GBFF2O+X2uM/2TKh1IwmHEpqJnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZR2WRJzhhnoj2Q1dMMUTvbGfD+zjRZXQjoCK+YiSikD1v8QQut63Hpst0wvr7Dov
	 NFsF6TUvpmjhOVdNYiJxLM1Ym8Jbjx6f15N7aIk2i9+rINTq2ahkVtlVNG0QcifiN+
	 V+gLzM5tlVFIDIHwaazNjrXeKbuAkvle8NZYGJuTnreoY6XJOS/ch/bVc1bBKT431n
	 UKziHBwzgWR7+UxsXls38JekkW279M41w1NTJ91SbhBxxc3mhiQcyl3JUTVxjgIF86
	 u0HQP+b+2nTR6jFnD5nelarVz0oTx9DXisAquw4+1LBnkM9g0fW4aj79FyL2wqU0iO
	 /gYkkXONG14OQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 129/283] PCI: Initialize RCB from pci_configure_device()
Date: Sat, 28 Feb 2026 13:04:31 -0500
Message-ID: <20260228180709.1583486-129-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Håkon Bugge <haakon.bugge@oracle.com>

[ Upstream commit 1a6845aaa6de81f95959b380b45de8f10d6a8502 ]

Commit e42010d8207f ("PCI: Set Read Completion Boundary to 128 iff Root
Port supports it (_HPX)") worked around a bogus _HPX type 2 record, which
caused program_hpx_type2() to set the RCB in an endpoint even though the
Root Port did not have the RCB bit set.

e42010d8207f fixed that by setting the RCB in the endpoint only when it was
set in the Root Port.

In retrospect, program_hpx_type2() is intended for AER-related settings,
and the RCB should be configured elsewhere so it doesn't depend on the
presence or contents of an _HPX record.

Explicitly program the RCB from pci_configure_device() so it matches the
Root Port's RCB.  The Root Port may not be visible to virtualized guests;
in that case, leave RCB alone.

Fixes: e42010d8207f ("PCI: Set Read Completion Boundary to 128 iff Root Port supports it (_HPX)")
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260129175237.727059-2-haakon.bugge@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/probe.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 9b277a91d0cb4..e51a5c38739a4 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2288,6 +2288,37 @@ static void pci_configure_serr(struct pci_dev *dev)
 	}
 }
 
+static void pci_configure_rcb(struct pci_dev *dev)
+{
+	struct pci_dev *rp;
+	u16 rp_lnkctl;
+
+	/*
+	 * Per PCIe r7.0, sec 7.5.3.7, RCB is only meaningful in Root Ports
+	 * (where it is read-only), Endpoints, and Bridges.  It may only be
+	 * set for Endpoints and Bridges if it is set in the Root Port. For
+	 * Endpoints, it is 'RsvdP' for Virtual Functions.
+	 */
+	if (!pci_is_pcie(dev) ||
+	    pci_pcie_type(dev) == PCI_EXP_TYPE_ROOT_PORT ||
+	    pci_pcie_type(dev) == PCI_EXP_TYPE_UPSTREAM ||
+	    pci_pcie_type(dev) == PCI_EXP_TYPE_DOWNSTREAM ||
+	    pci_pcie_type(dev) == PCI_EXP_TYPE_RC_EC ||
+	    dev->is_virtfn)
+		return;
+
+	/* Root Port often not visible to virtualized guests */
+	rp = pcie_find_root_port(dev);
+	if (!rp)
+		return;
+
+	pcie_capability_read_word(rp, PCI_EXP_LNKCTL, &rp_lnkctl);
+	pcie_capability_clear_and_set_word(dev, PCI_EXP_LNKCTL,
+					   PCI_EXP_LNKCTL_RCB,
+					   (rp_lnkctl & PCI_EXP_LNKCTL_RCB) ?
+					   PCI_EXP_LNKCTL_RCB : 0);
+}
+
 static void pci_configure_device(struct pci_dev *dev)
 {
 	pci_configure_mps(dev);
@@ -2296,6 +2327,7 @@ static void pci_configure_device(struct pci_dev *dev)
 	pci_configure_ltr(dev);
 	pci_configure_eetlp_prefix(dev);
 	pci_configure_serr(dev);
+	pci_configure_rcb(dev);
 
 	pci_acpi_program_hp_params(dev);
 }
-- 
2.51.0

