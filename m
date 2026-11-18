Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048899;
	b=dZZQtMFzzW6zjzAt/i3CdWI4XZ7KCWdcLqsl67zPFzx8gZU4MZWsgBOA41iGPJgTFwPi
	 pdhDPFPJU8lbWRnrA0DiD/W1C7FVBZ1/Kh3CSFEJN1N/UF53GsCl+rSUafhVNQZPmcMaY
	 SkmyEumIwaUYRmM2ivxho60jK431JyhmLw+uRLCAHq5Vr2M1HUf/IkXnYIkGyLgOohwBZ
	 sf2WcBqDtx8JST4rTy9NvET+3GVAe+AckCbBsdsSxT0fpPBO6gFH0WXIhwUucdQj1yoqs
	 bEBOIeifm7Ms3BqWGWiUuQLjmqH+jnWX155QOSdOaz8xxVWMgkRba24kdaXXuHSjfwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048899;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t5WFQhIjpRDdzyZrMoejn5Og88cHzpmOQ0QtQMnGkNI=;
	b=b1VMA68MLx1U/hiVNH6NHZJYLPWOoCPcFGxW6lOqiWhmqPxOKVNxG+67l7hQfQtvEb+F
	 IdhUY8u5t0L5owS0iBhKOOhX8gf9py8YZqdNX/MMDfmOvF7vjz3rLDIUkVv0YZLQFb8qc
	 IsMk5zJDGBinDSMygoVkN+96LeYNyO00lfRplAbvWfbUNZ2yY03b6XrDXGRX5xyQ5W++o
	 Lms7w7HNYRvlQNp5zYYNX7FuX8pFaywrKkjJf4OvPTuB8y5e3dqKn/svLY+GllZ6VqjhO
	 rZAitTTo30t17B67CrbT94DPUsTyTUaeiMPKXF3kcQvx7W9kMJWd9X/YBWIQUvgXlwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=teo6RSOb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96410606A331;
	Thu, 19 Nov 2026 00:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=teo6RSOb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6331F000CB;
	Thu, 19 Nov 2026 00:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048899;
	bh=t5WFQhIjpRDdzyZrMoejn5Og88cHzpmOQ0QtQMnGkNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=teo6RSObvsFoaQ1KLMWTN3VFEqdvYDaVJFYi1/4F7DKmQ7YM5rlWsTigRaajMxaeP
	 EQcbckB5FTct8GhpJ08rpem3zeCMCvJ0CBz5BT7jYrTKcoxLkTiepVHeo0jLS2RFBS
	 nEgbfMOMOD0hc82RKi5wCVJs7prxkyqHsv8tI+7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Logan Odell <loganodell@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2122/2857] PCI/IOV: Read VF config values that need not match PF
Date: Wed, 18 Nov 2026 15:52:36 +0100
Message-ID: <20261118150317.806688334@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3965e003d7b57..cfffd932c7e81 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -154,29 +154,6 @@ resource_size_t pci_iov_resource_size(struct pci_dev *dev, int resno)
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
@@ -311,8 +288,6 @@ int pci_iov_add_virtfn(struct pci_dev *dev, int id)
 	virtfn->physfn = pci_dev_get(dev);
 	virtfn->no_command_memory = 1;
 
-	if (id == 0)
-		pci_read_vf_config_common(virtfn);
 
 	rc = pci_setup_device(virtfn);
 	if (rc)
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 49a0f23ebe4aa..c1d979015cc2d 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -339,10 +339,6 @@ struct pci_sriov {
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
index 02f3fbe78c46f..f8ed6763dbc25 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1760,8 +1760,13 @@ static u32 pci_class(struct pci_dev *dev)
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
@@ -1771,8 +1776,8 @@ static void pci_subsystem_ids(struct pci_dev *dev, u16 *vendor, u16 *device)
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
@@ -1786,7 +1791,7 @@ static u8 pci_hdr_type(struct pci_dev *dev)
 
 #ifdef CONFIG_PCI_IOV
 	if (dev->is_virtfn)
-		return dev->physfn->sriov->hdr_type;
+		return 0;
 #endif
 	pci_read_config_byte(dev, PCI_HEADER_TYPE, &hdr_type);
 	return hdr_type;
-- 
2.53.0



