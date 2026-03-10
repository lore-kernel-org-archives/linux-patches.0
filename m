Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B1E3803CD;
	Tue, 10 Mar 2026 11:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141987; cv=none; b=Mg9Z3J7AztJFCLwZ6Rzw8Kx4r1WQqZl9f4s5+8KaHCzgHwBV3LYysu/7ifVsOJQlMicoaehXqNnJ14myt55MDfg89C1tILlc3NfuX025HTT4WU0WRv5pl1zHqzPl1IWH4kD/VFLkqVjmMnxnq8T4Dr6XG4+gvpXUePSYzJUO9ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141987; c=relaxed/simple;
	bh=n+YSX5CP2sWAu9KaVI9SbDj4GmPT5ls6uNhMwPPC7AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVzmOtgr2+kcwwQItnnVJjrcPOZKP9FkOJ9b3Bm9V1paB7j1evRx+LcY/9Mi6m5h5IAD5OoZPNBeeLAgcFHr6XJKYuGRsRsc1WwjNAR+o9qXTh1XV55ZhAYu8eXTa8MX4ZBFewv9wQEXuF0P6b5cb1EAJL/8ettVkwF4wKtC/bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O4ndnqQ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O4ndnqQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8471C19423;
	Tue, 10 Mar 2026 11:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141987;
	bh=n+YSX5CP2sWAu9KaVI9SbDj4GmPT5ls6uNhMwPPC7AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O4ndnqQ1LXKxrpQ1+/GUHvpqh4bbBgVbo2vFRAVOQMuck2vGd0iVE8CAIjOcMSNnk
	 sc1sVDODOy1scMJjly9We1JxYnL2L72rTyoqLO8fGwvagSwI+N9b26sHkERaua8hsV
	 DF3nG/w2WGJdftKPsPX7HVTFal5jSEqDz5J66IU9g6JVNdw/f2ONfmKOVZ6BGkBTqQ
	 9IXdssarMY2a9l8Y4LRAcIgyqDyzkDzbpuMrnCCiiJd/mYvQHfo+2e18DPyqVf6Kpe
	 vLOVDcVhildxIySVzCSq79MWFUq07JoatI8ZLyQwh1uwzAKuVg3tnKX3r3IELXC0C0
	 QFglIyeVWlSyQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Qiang Yu <qiang.yu@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 112/314] PCI: Add preceding capability position support in PCI_FIND_NEXT_*_CAP macros
Date: Tue, 10 Mar 2026 07:16:11 -0400
Message-ID: <22acd0f48afd9436cafbaaad28c1978e79239bb2.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Qiang Yu <qiang.yu@oss.qualcomm.com>

[ Upstream commit a2582e05e39adf9ab82a02561cd6f70738540ae0 ]

Add support for finding the preceding capability position in PCI
capability list by extending the capability finding macros with an
additional parameter. This functionality is essential for modifying PCI
capability list, as it provides the necessary information to update the
"next" pointer of the predecessor capability when removing entries.

Modify two macros to accept a new 'prev_ptr' parameter:
- PCI_FIND_NEXT_CAP - Now accepts 'prev_ptr' parameter for standard
  capabilities
- PCI_FIND_NEXT_EXT_CAP - Now accepts 'prev_ptr' parameter for extended
  capabilities

When a capability is found, these macros:
- Store the position of the preceding capability in *prev_ptr
  (if prev_ptr != NULL)
- Maintain all existing functionality when prev_ptr is NULL

Update current callers to accommodate this API change by passing NULL to
'prev_ptr' argument if they do not care about the preceding capability
position.

No functional changes to driver behavior result from this commit as it
maintains the existing capability finding functionality while adding the
infrastructure for future capability removal operations.

Signed-off-by: Qiang Yu <qiang.yu@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20251109-remove_cap-v1-1-2208f46f4dc2@oss.qualcomm.com
Stable-dep-of: 43d67ec26b32 ("PCI: dwc: ep: Fix resizable BAR support for multi-PF configurations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pcie-cadence.c |  4 ++--
 .../pci/controller/dwc/pcie-designware-ep.c   |  2 +-
 drivers/pci/controller/dwc/pcie-designware.c  |  6 ++---
 drivers/pci/pci.c                             |  8 +++----
 drivers/pci/pci.h                             | 23 +++++++++++++++----
 5 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/controller/cadence/pcie-cadence.c b/drivers/pci/controller/cadence/pcie-cadence.c
index bd683d0fecb22..d614452861f77 100644
--- a/drivers/pci/controller/cadence/pcie-cadence.c
+++ b/drivers/pci/controller/cadence/pcie-cadence.c
@@ -13,13 +13,13 @@
 u8 cdns_pcie_find_capability(struct cdns_pcie *pcie, u8 cap)
 {
 	return PCI_FIND_NEXT_CAP(cdns_pcie_read_cfg, PCI_CAPABILITY_LIST,
-				 cap, pcie);
+				 cap, NULL, pcie);
 }
 EXPORT_SYMBOL_GPL(cdns_pcie_find_capability);
 
 u16 cdns_pcie_find_ext_capability(struct cdns_pcie *pcie, u8 cap)
 {
-	return PCI_FIND_NEXT_EXT_CAP(cdns_pcie_read_cfg, 0, cap, pcie);
+	return PCI_FIND_NEXT_EXT_CAP(cdns_pcie_read_cfg, 0, cap, NULL, pcie);
 }
 EXPORT_SYMBOL_GPL(cdns_pcie_find_ext_capability);
 
diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index 6d3beec92b54e..7f10d764f52b0 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -72,7 +72,7 @@ EXPORT_SYMBOL_GPL(dw_pcie_ep_reset_bar);
 static u8 dw_pcie_ep_find_capability(struct dw_pcie_ep *ep, u8 func_no, u8 cap)
 {
 	return PCI_FIND_NEXT_CAP(dw_pcie_ep_read_cfg, PCI_CAPABILITY_LIST,
-				 cap, ep, func_no);
+				 cap, NULL, ep, func_no);
 }
 
 /**
diff --git a/drivers/pci/controller/dwc/pcie-designware.c b/drivers/pci/controller/dwc/pcie-designware.c
index 75fc8b767fccf..5d7a7e6f5724e 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -226,13 +226,13 @@ void dw_pcie_version_detect(struct dw_pcie *pci)
 u8 dw_pcie_find_capability(struct dw_pcie *pci, u8 cap)
 {
 	return PCI_FIND_NEXT_CAP(dw_pcie_read_cfg, PCI_CAPABILITY_LIST, cap,
-				 pci);
+				 NULL, pci);
 }
 EXPORT_SYMBOL_GPL(dw_pcie_find_capability);
 
 u16 dw_pcie_find_ext_capability(struct dw_pcie *pci, u8 cap)
 {
-	return PCI_FIND_NEXT_EXT_CAP(dw_pcie_read_cfg, 0, cap, pci);
+	return PCI_FIND_NEXT_EXT_CAP(dw_pcie_read_cfg, 0, cap, NULL, pci);
 }
 EXPORT_SYMBOL_GPL(dw_pcie_find_ext_capability);
 
@@ -246,7 +246,7 @@ static u16 __dw_pcie_find_vsec_capability(struct dw_pcie *pci, u16 vendor_id,
 		return 0;
 
 	while ((vsec = PCI_FIND_NEXT_EXT_CAP(dw_pcie_read_cfg, vsec,
-					     PCI_EXT_CAP_ID_VNDR, pci))) {
+					     PCI_EXT_CAP_ID_VNDR, NULL, pci))) {
 		header = dw_pcie_readl_dbi(pci, vsec + PCI_VNDR_HEADER);
 		if (PCI_VNDR_HEADER_ID(header) == vsec_id)
 			return vsec;
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index d4e70570d09f2..e128696d5b761 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -426,7 +426,7 @@ static int pci_dev_str_match(struct pci_dev *dev, const char *p,
 static u8 __pci_find_next_cap(struct pci_bus *bus, unsigned int devfn,
 			      u8 pos, int cap)
 {
-	return PCI_FIND_NEXT_CAP(pci_bus_read_config, pos, cap, bus, devfn);
+	return PCI_FIND_NEXT_CAP(pci_bus_read_config, pos, cap, NULL, bus, devfn);
 }
 
 u8 pci_find_next_capability(struct pci_dev *dev, u8 pos, int cap)
@@ -531,7 +531,7 @@ u16 pci_find_next_ext_capability(struct pci_dev *dev, u16 start, int cap)
 		return 0;
 
 	return PCI_FIND_NEXT_EXT_CAP(pci_bus_read_config, start, cap,
-				     dev->bus, dev->devfn);
+				     NULL, dev->bus, dev->devfn);
 }
 EXPORT_SYMBOL_GPL(pci_find_next_ext_capability);
 
@@ -600,7 +600,7 @@ static u8 __pci_find_next_ht_cap(struct pci_dev *dev, u8 pos, int ht_cap)
 		mask = HT_5BIT_CAP_MASK;
 
 	pos = PCI_FIND_NEXT_CAP(pci_bus_read_config, pos,
-				PCI_CAP_ID_HT, dev->bus, dev->devfn);
+				PCI_CAP_ID_HT, NULL, dev->bus, dev->devfn);
 	while (pos) {
 		rc = pci_read_config_byte(dev, pos + 3, &cap);
 		if (rc != PCIBIOS_SUCCESSFUL)
@@ -611,7 +611,7 @@ static u8 __pci_find_next_ht_cap(struct pci_dev *dev, u8 pos, int ht_cap)
 
 		pos = PCI_FIND_NEXT_CAP(pci_bus_read_config,
 					pos + PCI_CAP_LIST_NEXT,
-					PCI_CAP_ID_HT, dev->bus,
+					PCI_CAP_ID_HT, NULL, dev->bus,
 					dev->devfn);
 	}
 
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 36cf1ffb2023c..5510c103be2d3 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -106,17 +106,21 @@ bool pcie_cap_has_rtctl(const struct pci_dev *dev);
  * @read_cfg: Function pointer for reading PCI config space
  * @start: Starting position to begin search
  * @cap: Capability ID to find
+ * @prev_ptr: Pointer to store position of preceding capability (optional)
  * @args: Arguments to pass to read_cfg function
  *
- * Search the capability list in PCI config space to find @cap.
+ * Search the capability list in PCI config space to find @cap. If
+ * found, update *prev_ptr with the position of the preceding capability
+ * (if prev_ptr != NULL)
  * Implements TTL (time-to-live) protection against infinite loops.
  *
  * Return: Position of the capability if found, 0 otherwise.
  */
-#define PCI_FIND_NEXT_CAP(read_cfg, start, cap, args...)		\
+#define PCI_FIND_NEXT_CAP(read_cfg, start, cap, prev_ptr, args...)	\
 ({									\
 	int __ttl = PCI_FIND_CAP_TTL;					\
-	u8 __id, __found_pos = 0;					\
+	u8 __id,  __found_pos = 0;					\
+	u8 __prev_pos = (start);					\
 	u8 __pos = (start);						\
 	u16 __ent;							\
 									\
@@ -135,9 +139,12 @@ bool pcie_cap_has_rtctl(const struct pci_dev *dev);
 									\
 		if (__id == (cap)) {					\
 			__found_pos = __pos;				\
+			if (prev_ptr != NULL)				\
+				*(u8 *)prev_ptr = __prev_pos;		\
 			break;						\
 		}							\
 									\
+		__prev_pos = __pos;					\
 		__pos = FIELD_GET(PCI_CAP_LIST_NEXT_MASK, __ent);	\
 	}								\
 	__found_pos;							\
@@ -149,21 +156,26 @@ bool pcie_cap_has_rtctl(const struct pci_dev *dev);
  * @read_cfg: Function pointer for reading PCI config space
  * @start: Starting position to begin search (0 for initial search)
  * @cap: Extended capability ID to find
+ * @prev_ptr: Pointer to store position of preceding capability (optional)
  * @args: Arguments to pass to read_cfg function
  *
  * Search the extended capability list in PCI config space to find @cap.
+ * If found, update *prev_ptr with the position of the preceding capability
+ * (if prev_ptr != NULL)
  * Implements TTL protection against infinite loops using a calculated
  * maximum search count.
  *
  * Return: Position of the capability if found, 0 otherwise.
  */
-#define PCI_FIND_NEXT_EXT_CAP(read_cfg, start, cap, args...)		\
+#define PCI_FIND_NEXT_EXT_CAP(read_cfg, start, cap, prev_ptr, args...)	\
 ({									\
 	u16 __pos = (start) ?: PCI_CFG_SPACE_SIZE;			\
 	u16 __found_pos = 0;						\
+	u16 __prev_pos;							\
 	int __ttl, __ret;						\
 	u32 __header;							\
 									\
+	__prev_pos = __pos;						\
 	__ttl = (PCI_CFG_SPACE_EXP_SIZE - PCI_CFG_SPACE_SIZE) / 8;	\
 	while (__ttl-- > 0 && __pos >= PCI_CFG_SPACE_SIZE) {		\
 		__ret = read_cfg##_dword(args, __pos, &__header);	\
@@ -175,9 +187,12 @@ bool pcie_cap_has_rtctl(const struct pci_dev *dev);
 									\
 		if (PCI_EXT_CAP_ID(__header) == (cap) && __pos != start) {\
 			__found_pos = __pos;				\
+			if (prev_ptr != NULL)				\
+				*(u16 *)prev_ptr = __prev_pos;		\
 			break;						\
 		}							\
 									\
+		__prev_pos = __pos;					\
 		__pos = PCI_EXT_CAP_NEXT(__header);			\
 	}								\
 	__found_pos;							\
-- 
2.51.0

