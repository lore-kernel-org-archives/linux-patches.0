Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3237F43E073;
	Tue, 21 Jul 2026 21:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668228; cv=none; b=Ak8ltHlXvvr9iOCVqHHR6KLxbtbnamlXZxnIGIkoNbCjCmc8iwnMPvK0+MTu5ezdTbpwfWSjSiewVXUg3AszKHCq8FIrKa2Oe6+r1Doc5qLctp/EkDtsVHCVLRBAgsCgEdQa/fDKeoHphs/0XZswTW/oj2vP1XIitZtoL5lKS5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668228; c=relaxed/simple;
	bh=WJLqEVi9p8vkkevakWCTKgiy/btdKGG4MQw4LscR7Oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nq32ktgRsTyrSbOWs8p4eAX0J0ZkPqCJH3bGxaoJPylF327Vj4ZxF7alygscEnhfOXwjdRgR28omvi6PZcon5BruKgfJZDj+gE8AK0v34nFvYu87oKhw/jJHK9uHDr59RgcqaGEqriZUY8+aELllXl15wltIHz+IfIZuKu/nxDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gyh8RSfp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gyh8RSfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96AF61F00A3A;
	Tue, 21 Jul 2026 21:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668227;
	bh=5sbFZFN98VGWkhqBuSpsB+/4Ug0GYbKc3v/vJH0dfkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gyh8RSfp5ytHsFen+ENrQj6Q6VqzGmhoyJozVGN6gCXHBx0MhK8o6miN1LsIND779
	 M/5pBj5tr4o2CPuE+JUW0gvMP4CLB1af2Kc36IkJBT+qJjeWBg033uX3OEmlz7RVPZ
	 CRjMRmuKyKIgDmSpTBGmkFZjiquz2WiUl+ivDqkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Vidya Sagar <vidyas@nvidia.com>
Subject: [PATCH 6.1 0094/1067] PCI: host-common: Request bus reassignment when not probe-only
Date: Tue, 21 Jul 2026 17:11:35 +0200
Message-ID: <20260721152426.689463785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -77,6 +77,10 @@ int pci_host_common_probe(struct platfor
 	if (!pci_has_flag(PCI_PROBE_ONLY))
 		pci_add_flags(PCI_REASSIGN_ALL_BUS);
 
+	/* Do not reassign bus numbers if probe only */
+	if (!pci_has_flag(PCI_PROBE_ONLY))
+		pci_add_flags(PCI_REASSIGN_ALL_BUS);
+
 	bridge->sysdata = cfg;
 	bridge->ops = (struct pci_ops *)&ops->pci_ops;
 	bridge->msi_domain = true;


