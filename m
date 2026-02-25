Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E281E2834;
	Wed, 25 Feb 2026 01:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983236; cv=none; b=WNBcsoNqLnf/ubWbUwo4N2i8se+20gQLAgyZPbvawZmasD6vxpJVkXtX6MH71/UrYkoe3fNnHjzk40n1W31H1jAjHdYhCH4uGAEz3qX8ESbfricYWiUDOhAC1sj74mnbHH5Io+kli1YTGkr//0MzXwo4OQO0+u42vRPzplc/6Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983236; c=relaxed/simple;
	bh=E3W8S0qZ6FOs08KMjI1DwLKExnc65ZQT3lxy+FCpUPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Utwgae8wYdRpHU1CF1zuTw47SaRur3thFspCqFdu09qWP+sQtO5SRdqyfU4hpaJxjFZ5lSqCmyK9zZoG/tvaQGWL4Vhd5DYoO4isHFx9kvYsvOK3qwHXr6H4A9CFyN2TVXYEqo0iKGVaNpv5mieJackPk0Ks9gWN9ceVM3eQJuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HHJZxvXD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HHJZxvXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE99FC116D0;
	Wed, 25 Feb 2026 01:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983235;
	bh=E3W8S0qZ6FOs08KMjI1DwLKExnc65ZQT3lxy+FCpUPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HHJZxvXDtBQzkeLuiEdEpeWtBZkrc4IbB3kaXIa6Imm5SS2aKsR6bEQ1MFhPdCmBn
	 QGc/5xmsvvIZ0C9mJFzSvhb/+gWAvumrDROUKqHsF4/J3uIBFkzsq3kkpdgOcvYa2V
	 dxi8v3ndaUfz5DreW03aXhbHk1ksCwUJ26hrVRzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 378/781] PCI: Initialize RCB from pci_configure_device()
Date: Tue, 24 Feb 2026 17:18:07 -0800
Message-ID: <20260225012408.964805655@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 86665658d7047..c791bca2891f6 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2411,6 +2411,37 @@ static void pci_configure_serr(struct pci_dev *dev)
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
@@ -2420,6 +2451,7 @@ static void pci_configure_device(struct pci_dev *dev)
 	pci_configure_aspm_l1ss(dev);
 	pci_configure_eetlp_prefix(dev);
 	pci_configure_serr(dev);
+	pci_configure_rcb(dev);
 
 	pci_acpi_program_hp_params(dev);
 }
-- 
2.51.0



