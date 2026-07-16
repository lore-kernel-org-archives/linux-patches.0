Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A8D42A7AF;
	Thu, 16 Jul 2026 14:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211961; cv=none; b=df9+K339Q0xrCL9HmK1sZNVk5DfhAeNI6JQ6Pe2hSBoWskP4epUQbhrXDdJ/RMsaLsLA0LfGd7SRny6ZLda/plgheXJgDbv1hpjLaom5IbF8HbtjhY6CO5noGcNV4LE2/1VG23DO6VErMkiUCA6zb39b5CpllnVlwbTz6ETacXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211961; c=relaxed/simple;
	bh=+W/TyygeEpA4Y9huXHPizVpTx9mkhACWSIELDeHTkIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tyTjGNjYgLSQxt8T9ZGALk1lj1EY5It5Im++GNQMQtekPaOowJFiTx7siS3m+cmUzmjNuna71qkZ4lGmAn/MVr2BQ/GRXrSUYbPOUqCwDSeNejp27m0zELCAORMeYyyH3jxpcvw16FgKWUBoTYenI/G0YrsZ03WIrh/lj3kmIBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hu5oGGgP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hu5oGGgP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8961F000E9;
	Thu, 16 Jul 2026 14:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211960;
	bh=+/dsYnjiJGIVwBL3CnIlDF/fLfDWkLNXsnZ06WZTgmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hu5oGGgPeaId5Ty576w2VLR2uuDKz68UYlDFjPrf43MAkOvl6Qz5mSHsbBLIEWCtP
	 mafi42jNIHnnTDPdnlxmZsu70dzWJoXSiM4iLElMdxI4CwW3TNJNpln1vjVjv3OEgX
	 J/F9UTA6mh4JdPevE5BhYqRQRLNBkkMFTuO4tnf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Vidya Sagar <vidyas@nvidia.com>
Subject: [PATCH 6.12 103/349] PCI: host-common: Request bus reassignment when not probe-only
Date: Thu, 16 Jul 2026 15:30:37 +0200
Message-ID: <20260716133035.620048540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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
@@ -73,6 +73,10 @@ int pci_host_common_probe(struct platfor
 	if (IS_ERR(cfg))
 		return PTR_ERR(cfg);
 
+	/* Do not reassign bus numbers if probe only */
+	if (!pci_has_flag(PCI_PROBE_ONLY))
+		pci_add_flags(PCI_REASSIGN_ALL_BUS);
+
 	bridge->sysdata = cfg;
 	bridge->ops = (struct pci_ops *)&ops->pci_ops;
 	bridge->msi_domain = true;


