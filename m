Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732AF5A79B;
	Thu, 16 Jul 2026 14:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210751; cv=none; b=MPr8jE3ewxgXPm736geOUn1gjy6oQPArmbxmXmB5UhHWhg8UZQVu9k2+2iqBt/O5Mik0mCh0xxrfJyUpPLS6xOyhDxYNFLQVLqeeePRe8RiE2npEsDfGxOiQ8gnftO4oCHSRc7+HVdLcJKPuvbDK4V0111l6kT2zFnLolsTbApE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210751; c=relaxed/simple;
	bh=br3HN7/qU9Vt7wtFfzNIMeWC80feAnbp3wkVXazKQkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BiYBjjrUrnZsWhf6jhJGrdmnGb6NA0rYu64ldyrt4NmraTLq4469ZBk/ws1FstSQXPxox+b3Ozmmmzvz0xC4PO9eWiwAoHonpAPZSNBqKeIeHznSpGx8et6NBQ67kCzo4YFyl+Ve0VJkgqU4BiHpwi0QCqsTNY+WHwJNPByRz3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bxAbd3NI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bxAbd3NI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD901F000E9;
	Thu, 16 Jul 2026 14:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210750;
	bh=P1jkMM9oAXwPd1aHO2u4zc2XlxcTZgJm+832RK8unYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bxAbd3NI6YidYAt3icMygcshJ6tV6DW9AnY1t3DV0TEohkhNdiUG0anmscfn43sLR
	 jq7+eo3DOqrGu9FHYTHlPFDFT2Su6pBxXGOqTHg7mH9i2o3vIBrHbjsII4Vkplsqmj
	 wgaRlHoLCkaGqTWErE8dEBR7paoz0Sqx6kHTV/ZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Vidya Sagar <vidyas@nvidia.com>
Subject: [PATCH 6.18 139/480] PCI: host-common: Request bus reassignment when not probe-only
Date: Thu, 16 Jul 2026 15:28:06 +0200
Message-ID: <20260716133047.719495823@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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
@@ -72,6 +72,10 @@ int pci_host_common_init(struct platform
 	if (IS_ERR(cfg))
 		return PTR_ERR(cfg);
 
+	/* Do not reassign bus numbers if probe only */
+	if (!pci_has_flag(PCI_PROBE_ONLY))
+		pci_add_flags(PCI_REASSIGN_ALL_BUS);
+
 	bridge->sysdata = cfg;
 	bridge->ops = (struct pci_ops *)&ops->pci_ops;
 	bridge->enable_device = ops->enable_device;


