Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C0347A0B5;
	Thu, 20 Aug 2026 16:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244341; cv=none; b=Wb9uPtwVBSW+wwmTHIUrhKyQgbFdJYVAhmiNfdwIyxvr4TPXPlWg+YTfh0FGuNX/hfJgOKXLlHMOc8nrrvDiuEGZebjs2S84m6rl0jE9/UEdqFwRjcvA5gldj2SzIO9fkrBhr6Y1ijZmuLrhXR1865CbJy2M1UJuTWo8igQV6oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244341; c=relaxed/simple;
	bh=pmYOhgPMAhL+P4KBxLh3cURnaBhxLAbA0pskEDixSMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0Nw94akL1kLjUNK88v6wGn1fHdEacHRD7ar/TeAPGeY/pF5sgouYM5ciuZV2TL2feo5GOHNj3RIa6OLkbQOU/5azA3/Njm+UNQwwmPTin87cp2ehigJT20OsUaiR408cb+bCfYsHxjlyfed/xJQRkeXubv60UIQIlEwwtnrTQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hHSjHOO8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hHSjHOO8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9490A1F00A3A;
	Thu, 20 Aug 2026 16:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244340;
	bh=VE8dhGVjib5XF3w5KDkwbvYgz9AFQqOj3uFtj77Pj3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hHSjHOO8o64EtYW6uK6XcVuPG1pFhyK3BHUcfzBX7ZUSGGutX8Enc9pp1OeE/jCLA
	 KzeZYgRZsKzv9a/i3oKbU1NWeVUFUsUmCDhnSRg46Du5esKSSO0cOEtJ7J5p+q3rTS
	 lwHYqcfsWJWoANJfqYI2UQc/wyAZERmlB3OW9kdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gustavo Pimentel <gustavo.pimentel@synopsys.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/235] PCI: Add pci_find_vsec_capability() to find a specific VSEC
Date: Thu, 20 Aug 2026 16:55:34 +0200
Message-ID: <20260820145219.429100440@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

From: Gustavo Pimentel <Gustavo.Pimentel@synopsys.com>

[ Upstream commit c124fd9a969acaa83f6dfa5e160a99a500af9e4b ]

Add pci_find_vsec_capability() to locate a Vendor-Specific Extended
Capability with the specified VSEC ID.

The Vendor-Specific Extended Capability (VSEC) allows one or more
proprietary capabilities defined by the vendor which aren't standard
or shared between vendors.

Signed-off-by: Gustavo Pimentel <gustavo.pimentel@synopsys.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://lore.kernel.org/r/d89506834fb11c6fa0bd5d515c0dd55b13ac6958.1613674948.git.gustavo.pimentel@synopsys.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 8ffba0171c6b ("dmaengine: dw-edma: Add spinlock to protect DONE_INT_MASK and ABORT_INT_MASK")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci.c   |   30 ++++++++++++++++++++++++++++++
 include/linux/pci.h |    1 +
 2 files changed, 31 insertions(+)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -691,6 +691,36 @@ int pci_find_ht_capability(struct pci_de
 EXPORT_SYMBOL_GPL(pci_find_ht_capability);
 
 /**
+ * pci_find_vsec_capability - Find a vendor-specific extended capability
+ * @dev: PCI device to query
+ * @vendor: Vendor ID for which capability is defined
+ * @cap: Vendor-specific capability ID
+ *
+ * If @dev has Vendor ID @vendor, search for a VSEC capability with
+ * VSEC ID @cap. If found, return the capability offset in
+ * config space; otherwise return 0.
+ */
+u16 pci_find_vsec_capability(struct pci_dev *dev, u16 vendor, int cap)
+{
+	u16 vsec = 0;
+	u32 header;
+
+	if (vendor != dev->vendor)
+		return 0;
+
+	while ((vsec = pci_find_next_ext_capability(dev, vsec,
+						     PCI_EXT_CAP_ID_VNDR))) {
+		if (pci_read_config_dword(dev, vsec + PCI_VNDR_HEADER,
+					  &header) == PCIBIOS_SUCCESSFUL &&
+		    PCI_VNDR_HEADER_ID(header) == cap)
+			return vsec;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_find_vsec_capability);
+
+/**
  * pci_find_parent_resource - return resource region of parent bus of given
  *			      region
  * @dev: PCI device structure contains resources to be searched
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1101,6 +1101,7 @@ int pci_find_next_ext_capability(struct
 int pci_find_ht_capability(struct pci_dev *dev, int ht_cap);
 int pci_find_next_ht_capability(struct pci_dev *dev, int pos, int ht_cap);
 struct pci_bus *pci_find_next_bus(const struct pci_bus *from);
+u16 pci_find_vsec_capability(struct pci_dev *dev, u16 vendor, int cap);
 
 u64 pci_get_dsn(struct pci_dev *dev);
 


