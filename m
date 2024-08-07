Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8BF78C67;
	Wed,  7 Aug 2024 15:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043274; cv=none; b=lnR9iFSafeC7nwWHfLoaIl65Grj1d0r3VWiCfp8l2zJayFWwzz43oi8OjQV1OIejke+E0pxVcUbX+N33rEjQ0Pl74b/n7XvSh+ljykXedjCOuG79BeZCs+iYwDxHEGj3c9Mf1BcpHr8ruKA/4fYgoWIEa1yCJq/Phl4Ek5cINcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043274; c=relaxed/simple;
	bh=vJNtOt9FQK9elqMtB9kax+Q4PRK/QRZsfIMQRLdOL1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZ74h6TpR5K0uhwsqMwCWndtQvAYAZ++MUcBXquUa53nx0Jh7JJYgKMlSY2sAnv7QZo7lKjJ8Lof/YXdfwqa5/Q+743NEdfihitUNaGI5AP7I2hhThZW3Yhy6k0m6/y5fzwRp7OxNwpb/0qWYL69DSGAjW0lIu0dduvqi4A53c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ub9Za0C2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ub9Za0C2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67331C32781;
	Wed,  7 Aug 2024 15:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043273;
	bh=vJNtOt9FQK9elqMtB9kax+Q4PRK/QRZsfIMQRLdOL1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ub9Za0C2IlI+b8itjTwyKwRbsCt9WQnJjFsJcDYi08gPccLSsGV1eSDIvaHXR5vGc
	 wRbK0Reta8dpQMOSYA1xY8CdLf6Vz5NG7F+TYpWacuvOQeKugsRJ1/JFB35+ZCRq03
	 ebWeNtTWG8dtd61xwDPbKkqYSFfpUU3ZqZAS4AaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sui Jingfeng <suijingfeng@loongson.cn>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/121] PCI: Add pci_get_base_class() helper
Date: Wed,  7 Aug 2024 16:59:23 +0200
Message-ID: <20240807150020.355125352@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sui Jingfeng <suijingfeng@loongson.cn>

[ Upstream commit d427da2323b093a65d8317783e76ab8fad2e2ef0 ]

There is no function to get all PCI devices in a system by matching
against the base class code only, ignoring the sub-class code and
the programming interface.  Add pci_get_base_class() to suit the
need.

For example, if a driver wants to process all PCI display devices in
a system, it can do so like this:

  pdev = NULL;
  while ((pdev = pci_get_base_class(PCI_BASE_CLASS_DISPLAY, pdev))) {
    do_something_for_pci_display_device(pdev);
  }

Link: https://lore.kernel.org/r/20230825062714.6325-2-sui.jingfeng@linux.dev
Signed-off-by: Sui Jingfeng <suijingfeng@loongson.cn>
[bhelgaas: reword commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: c2bc958b2b03 ("fbdev: vesafb: Detect VGA compatibility from screen info's VESA attributes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/search.c | 31 +++++++++++++++++++++++++++++++
 include/linux/pci.h  |  5 +++++
 2 files changed, 36 insertions(+)

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index b4c138a6ec025..53840634fbfc2 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -363,6 +363,37 @@ struct pci_dev *pci_get_class(unsigned int class, struct pci_dev *from)
 }
 EXPORT_SYMBOL(pci_get_class);
 
+/**
+ * pci_get_base_class - searching for a PCI device by matching against the base class code only
+ * @class: search for a PCI device with this base class code
+ * @from: Previous PCI device found in search, or %NULL for new search.
+ *
+ * Iterates through the list of known PCI devices. If a PCI device is found
+ * with a matching base class code, the reference count to the device is
+ * incremented. See pci_match_one_device() to figure out how does this works.
+ * A new search is initiated by passing %NULL as the @from argument.
+ * Otherwise if @from is not %NULL, searches continue from next device on the
+ * global list. The reference count for @from is always decremented if it is
+ * not %NULL.
+ *
+ * Returns:
+ * A pointer to a matched PCI device, %NULL Otherwise.
+ */
+struct pci_dev *pci_get_base_class(unsigned int class, struct pci_dev *from)
+{
+	struct pci_device_id id = {
+		.vendor = PCI_ANY_ID,
+		.device = PCI_ANY_ID,
+		.subvendor = PCI_ANY_ID,
+		.subdevice = PCI_ANY_ID,
+		.class_mask = 0xFF0000,
+		.class = class << 16,
+	};
+
+	return pci_get_dev_by_id(&id, from);
+}
+EXPORT_SYMBOL(pci_get_base_class);
+
 /**
  * pci_dev_present - Returns 1 if device matching the device list is present, 0 if not.
  * @ids: A pointer to a null terminated list of struct pci_device_id structures
diff --git a/include/linux/pci.h b/include/linux/pci.h
index f141300116219..7b18a4b3efb0e 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1182,6 +1182,8 @@ struct pci_dev *pci_get_slot(struct pci_bus *bus, unsigned int devfn);
 struct pci_dev *pci_get_domain_bus_and_slot(int domain, unsigned int bus,
 					    unsigned int devfn);
 struct pci_dev *pci_get_class(unsigned int class, struct pci_dev *from);
+struct pci_dev *pci_get_base_class(unsigned int class, struct pci_dev *from);
+
 int pci_dev_present(const struct pci_device_id *ids);
 
 int pci_bus_read_config_byte(struct pci_bus *bus, unsigned int devfn,
@@ -1958,6 +1960,9 @@ static inline struct pci_dev *pci_get_class(unsigned int class,
 					    struct pci_dev *from)
 { return NULL; }
 
+static inline struct pci_dev *pci_get_base_class(unsigned int class,
+						 struct pci_dev *from)
+{ return NULL; }
 
 static inline int pci_dev_present(const struct pci_device_id *ids)
 { return 0; }
-- 
2.43.0



