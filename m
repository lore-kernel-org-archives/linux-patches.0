Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87E73B8120;
	Tue, 21 Jul 2026 22:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673180; cv=none; b=g7sc/43cHZvEr2IVeasUE1K6knW+zaBp6EgS08d4Rinv/oldUo7Mu6eMVgKmoscZ3t9usUJBR6TeICr8iAnkidUvKy92av7UeuHETET29RcnQnQfsJE/Hvgb8u7XbCNlHYqhrb7pDNtoKPHRnCa5XwBKJhEm+H3tGwqxBSP6zsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673180; c=relaxed/simple;
	bh=UsrzREJ11E1LczdY7itPEPZ1LqmQKIF42AVoUTj7yVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exSBW17+FUZ3RCotrBCNVxn+ss9Zwc94L47g+8OieOSyHDMMjnPN92Ca7GwF6ipkpgHJMWnmDJN3f2ssj5LD5jfbxj0leUmdZBILs/SX52xnJ2mEQieseCXz6pNa1KmFwsbhmzXenU8eW1jzsUcVjtHqQ0v+iqje/mgiJ3B+pDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dU6DOrQd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dU6DOrQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D7A1F000E9;
	Tue, 21 Jul 2026 22:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673179;
	bh=O3wbflLc9IqXuSgH56bUXJ8l6ZipglV13Esm/x6C/6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dU6DOrQdN6SjpgqcfPTHkccyolcv7M6l1V/SLV4mOWLMG9N8uL9mE03C8VECujkRs
	 eeCIRT9+E9FiJyq+9WyQB0s52PgjdmC15Htp4Tx8DBDLbInGOLH0KuGryUxE6XyJSq
	 2DC8ALVCcegOOuxuxKuhAD331jP8O/VaEUhS5+3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Vidya Sagar <vidyas@nvidia.com>
Subject: [PATCH 5.10 064/699] PCI: host-common: Request bus reassignment when not probe-only
Date: Tue, 21 Jul 2026 17:17:03 +0200
Message-ID: <20260721152357.145256729@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ratheesh Kannoth <rkannoth@marvell.com>

commit fda8749ba73638f5bbca3ffb39bc6861eb3b23fa upstream.

pci_host_common_init() is used by several generic ECAM host drivers.
After PCI core changes around pci_flags and preserve_config, these hosts
no longer opted into full bus number reassignment the way they did
before, which broke enumeration of devices on a Marvell CN106XX board.

When PCI_PROBE_ONLY is not set, add PCI_REASSIGN_ALL_BUS so
pci_scan_bridge_extend() takes the reassignment path: bus numbers can be
assigned from firmware EA data (e.g. pci_ea_fixed_busnrs()). Skip the
flag in probe-only mode so existing assignments are not overridden.

Fixes: 7246a4520b4b ("PCI: Use preserve_config in place of pci_flags")
Closes: https://lore.kernel.org/all/abkqm_LCd9zAM8cW@rkannoth-OptiPlex-7090/
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
[mani: added stable tag]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: add problem report link]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Cc: Vidya Sagar <vidyas@nvidia.com>
Link: https://patch.msgid.link/20260414081730.3864372-1-rkannoth@marvell.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-host-common.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/pci/controller/pci-host-common.c
+++ b/drivers/pci/controller/pci-host-common.c
@@ -75,6 +75,10 @@ int pci_host_common_probe(struct platfor
 	if (!pci_has_flag(PCI_PROBE_ONLY))
 		pci_add_flags(PCI_REASSIGN_ALL_BUS);
 
+	/* Do not reassign bus numbers if probe only */
+	if (!pci_has_flag(PCI_PROBE_ONLY))
+		pci_add_flags(PCI_REASSIGN_ALL_BUS);
+
 	bridge->sysdata = cfg;
 	bridge->ops = (struct pci_ops *)&ops->pci_ops;
 


