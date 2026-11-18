Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055521;
	b=jbWVqqXP+GfsN7u+xkn5I/aVTD4iq1F5X5Dw0Ua0w9yNim2q3IhVOygq0m5/MMQg0QCw
	 b6scYot/8hVmmwwptCI0fgdiypSo5BTy9YYKuN+62GeLxHOkfTDprtDQghqmHaWmqgKS9
	 JKNPQLHTop4u6meqAhOKPG5MsASCFNlAuF5G9raCwgF6uy5b27dMnsuMaGomfBsGko4eQ
	 KDAhgHRjN1CvXSPayFc+LL2EoNKLcx9fDx5SE1iy1dAGVjPWCJU0st/p2+XEJWbgPRvWd
	 a75XCwAYiy0wLK/ak417NQk0XjAqcFkuiBJRGKzEQrJw4k8bplBK9oBV5doZlOq/qMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MedEgoAYDXBP23PQNS1xuuPaVhBQI1584Rq3eNPMcxc=;
	b=5pmarG1JRejqtyAphFfvz66exR+fmHhmJV4OMmfxXACcyPcN93L7D612l8JtnERzRZCx
	 ictd9w8mxDjVZGys6sahoV5BL/v1OYmpReK0KazjfNQm4tZgeaAilSazt66pqMRqlFMiL
	 G1h24QLw4hQu/tKNwzrzqfMowAIad4yKWo6rZOS+ur6P39dvh6h99cvYeu/IMi+plY+GQ
	 QHtRJ7cEn6gJkf3pnETdFi1tnVMbzgu6gh44girvKS0vCqCfI/WW7tr7a9R/v5m0jtyK3
	 PnDVb3OUXFU6+AJzP5JaVG2yLbAe8Gdxhe6zu4cn62vHr8PpecFEyMpifgV5vGsgJ6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zoq4MBFg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49436606A31C;
	Thu, 19 Nov 2026 02:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zoq4MBFg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 981C41F000C4;
	Thu, 19 Nov 2026 02:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055521;
	bh=MedEgoAYDXBP23PQNS1xuuPaVhBQI1584Rq3eNPMcxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zoq4MBFgaLXxXZOiVck3RtUYjTLL5oLsl23AhUMf+Gr9V+fBOe4/dUFlLWdOSFShm
	 6EPXNMzCzf6UMeRpGP5CsRL/g76T/pWEn5sGLsitNHphIMAqLFdXrS1bIb49aZMJPV
	 kjoch3q+mD0KRpTqxjIiS/cURt5YVq85B4xAje04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Logan Odell <loganodell@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1661/2214] PCI/IOV: Read VF config values that need not match PF
Date: Wed, 18 Nov 2026 15:55:37 +0100
Message-ID: <20261118150118.312121255@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Logan Odell <loganodell@google.com>

[ Upstream commit ae43799529c480510dcc14bd0ed141a1d85b9259 ]

Per PCIe r7.0, sec 7.5.1.1.5 and 7.5.1.2.3, VF Revision IDs and Subsystem
IDs may differ from the PF's.  Read these values from VF config space
instead of using cached values from VF 0.

Per 7.5.1.1.6 and 7.5.1.2.3, VF Class Codes and Subsystem Vendor IDs must
be the same as the PF's.  Use the PF's value instead of reading from VF
config space.

Per 7.5.1.1.9, the Header Type for a VF must be 0, so hardcode that
assignment.

Fixes: cf0921bea66c ("PCI/IOV: Use VF0 cached config registers for other VFs")
Signed-off-by: Logan Odell <loganodell@google.com>
[bhelgaas: commit log, move "rev" decl inside block that uses it]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260910173648.1304517-1-loganodell@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/iov.c   | 25 -------------------------
 drivers/pci/pci.h   |  4 ----
 drivers/pci/probe.c | 15 ++++++++++-----
 3 files changed, 10 insertions(+), 34 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 50881aa7282cf..104f561a22cc6 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -111,29 +111,6 @@ resource_size_t pci_iov_resource_size(struct pci_dev *dev, int resno)
 	return dev->sriov->barsz[resno - PCI_IOV_RESOURCES];
 }
 
-static void pci_read_vf_config_common(struct pci_dev *virtfn)
-{
-	struct pci_dev *physfn = virtfn->physfn;
-
-	/*
-	 * Some config registers are the same across all associated VFs.
-	 * Read them once from VF0 so we can skip reading them from the
-	 * other VFs.
-	 *
-	 * PCIe r4.0, sec 9.3.4.1, technically doesn't require all VFs to
-	 * have the same Revision ID and Subsystem ID, but we assume they
-	 * do.
-	 */
-	pci_read_config_dword(virtfn, PCI_CLASS_REVISION,
-			      &physfn->sriov->class);
-	pci_read_config_byte(virtfn, PCI_HEADER_TYPE,
-			     &physfn->sriov->hdr_type);
-	pci_read_config_word(virtfn, PCI_SUBSYSTEM_VENDOR_ID,
-			     &physfn->sriov->subsystem_vendor);
-	pci_read_config_word(virtfn, PCI_SUBSYSTEM_ID,
-			     &physfn->sriov->subsystem_device);
-}
-
 int pci_iov_sysfs_link(struct pci_dev *dev,
 		struct pci_dev *virtfn, int id)
 {
@@ -269,8 +246,6 @@ int pci_iov_add_virtfn(struct pci_dev *dev, int id)
 	virtfn->physfn = pci_dev_get(dev);
 	virtfn->no_command_memory = 1;
 
-	if (id == 0)
-		pci_read_vf_config_common(virtfn);
 
 	rc = pci_setup_device(virtfn);
 	if (rc)
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 1ffe8715bb5b5..b4bd21c501b7c 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -360,10 +360,6 @@ struct pci_sriov {
 	u16		driver_max_VFs;	/* Max num VFs driver supports */
 	struct pci_dev	*dev;		/* Lowest numbered PF */
 	struct pci_dev	*self;		/* This PF */
-	u32		class;		/* VF device */
-	u8		hdr_type;	/* VF header type */
-	u16		subsystem_vendor; /* VF subsystem vendor */
-	u16		subsystem_device; /* VF subsystem device */
 	resource_size_t	barsz[PCI_SRIOV_NUM_BARS];	/* VF BAR size */
 	bool		drivers_autoprobe; /* Auto probing of VFs by driver */
 };
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 2180013a1a65a..1403b1e501429 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1768,8 +1768,13 @@ static u32 pci_class(struct pci_dev *dev)
 	u32 class;
 
 #ifdef CONFIG_PCI_IOV
-	if (dev->is_virtfn)
-		return dev->physfn->sriov->class;
+	if (dev->is_virtfn) {
+		u8 rev;
+
+		if (pci_read_config_byte(dev, PCI_REVISION_ID, &rev))
+			rev = 0;
+		return (dev->physfn->class << 8) | rev;
+	}
 #endif
 	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class);
 	return class;
@@ -1779,8 +1784,8 @@ static void pci_subsystem_ids(struct pci_dev *dev, u16 *vendor, u16 *device)
 {
 #ifdef CONFIG_PCI_IOV
 	if (dev->is_virtfn) {
-		*vendor = dev->physfn->sriov->subsystem_vendor;
-		*device = dev->physfn->sriov->subsystem_device;
+		*vendor = dev->physfn->subsystem_vendor;
+		pci_read_config_word(dev, PCI_SUBSYSTEM_ID, device);
 		return;
 	}
 #endif
@@ -1794,7 +1799,7 @@ static u8 pci_hdr_type(struct pci_dev *dev)
 
 #ifdef CONFIG_PCI_IOV
 	if (dev->is_virtfn)
-		return dev->physfn->sriov->hdr_type;
+		return 0;
 #endif
 	pci_read_config_byte(dev, PCI_HEADER_TYPE, &hdr_type);
 	return hdr_type;
-- 
2.53.0



