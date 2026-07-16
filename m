Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D152DF137;
	Thu, 16 Jul 2026 13:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209296; cv=none; b=fwca++uBh1F8eNuh6u/ZHiaXR2QMVVaQKtwZfQG9PnV5cM8DHIBX926aBCtkrWLi6SxYUYEsmhEOJllhpBFMJzJK6fUW899WigH8cGZ/Jf6+tHG+sNvrxyd3FSX/5OMFadpTWrCqyy+O/BqWOzulEkGUxK4BZdlXaB9BEdsqhic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209296; c=relaxed/simple;
	bh=bWwUYtANdnp7GhfUNoaEvIBCiaZIeSqyPOlhqqEvis8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AjELgxQYPnRwK9uYThlHRaiSSdgg8UOEa7paTAYCtFkuMdkLhbBSvUEaw+K/C+9Tnbn8GrsdYcnJETYNUt4K4TzC7Ht9yLvW4g0CRkDSZ7HerOzPY1ZGbfchuR4uLYw3UTWF4d4WsGM/trebT2bmish7s6NFBSygvHVHclMEBoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jCzan/Pf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jCzan/Pf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1911F000E9;
	Thu, 16 Jul 2026 13:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209295;
	bh=9qshh9dg336I9p/NAV7HLr1pgkDgtc22IfJsMQqiSag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jCzan/PfyD6jiDiPr9ZPRkMgHzQif+Kw4y5HGrRC/qd2F/CaQzmkS9kvhXcDpauGm
	 qY4IkVSvhUpbtkMGe9BdR5xUbZApDUUNZho/03groGnNeoIOr3djUtdP6raqV6IBzc
	 LEtid5Mf+ac1GNvidrjrvl/d5TZaMcnjMc18zkGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Vidya Sagar <vidyas@nvidia.com>
Subject: [PATCH 7.1 132/518] PCI: host-common: Request bus reassignment when not probe-only
Date: Thu, 16 Jul 2026 15:26:40 +0200
Message-ID: <20260716133050.745377788@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -68,6 +68,10 @@ int pci_host_common_init(struct platform
 	if (IS_ERR(cfg))
 		return PTR_ERR(cfg);
 
+	/* Do not reassign bus numbers if probe only */
+	if (!pci_has_flag(PCI_PROBE_ONLY))
+		pci_add_flags(PCI_REASSIGN_ALL_BUS);
+
 	bridge->sysdata = cfg;
 	bridge->ops = (struct pci_ops *)&ops->pci_ops;
 	bridge->enable_device = ops->enable_device;


