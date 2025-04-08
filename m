Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D99625F97B;
	Tue,  8 Apr 2025 12:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114464; cv=none; b=CfCQvHsGLZGrggD3/5ZlWKi4m99AaIqkkZmPKyQzcSdKBGIuOEqXQoODG2X23jf1EUNOhuj80ZL0eNI4ltKekaFMS0k+EPHKpmKLpf+U0bjKJFN0CQkBzVpZtvwd3iRNPdrYbAnLKP8SvrOmnVRGaXsh4Xgb8TwxkUjUNoeJkxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114464; c=relaxed/simple;
	bh=0TXgf5XUY/Mb/SR6J6fg6CUYLyKF4p3BO5J/47fO5cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgyFnhi2dN4pGrI3fJduwgGSDNQks1gwfJto9WAZBA9Atb+LwVlKfiVc5GPWTd8Yz7mPpMpHL0Win94CVARzz39TaLwOvuL2igZUVH/6bp6lN+JP/3BhfBQp4MzNikU8uBHciN0y0iH0Ez6OFi9/FczeYxXr87jz78YDPlTyeLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1ft8dC/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1ft8dC/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37FADC4CEE5;
	Tue,  8 Apr 2025 12:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114463;
	bh=0TXgf5XUY/Mb/SR6J6fg6CUYLyKF4p3BO5J/47fO5cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V1ft8dC/ef+XDL5Tif1ptTIb3WJ7h89n40jtNeM+RDx3sUzb7QI5Bhk39RsSnw4hy
	 rniAImgOdcDhdLNn2HdyJV5KkkBuBnazxLbnLXjzCg00HEv55gbpOiHkcEWxT8StlF
	 i81bZyRYNWjZ65YzFIIsKC4o1ArBZN0sJ/Vdj+gM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 115/499] PCI: Fix NULL dereference in SR-IOV VF creation error path
Date: Tue,  8 Apr 2025 12:45:27 +0200
Message-ID: <20250408104854.072919600@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 04d50d953ab46d96b0b32d5ad955fceaa28622db ]

Clean up when virtfn setup fails to prevent NULL pointer dereference
during device removal. The kernel oops below occurred due to incorrect
error handling flow when pci_setup_device() fails.

Add pci_iov_scan_device(), which handles virtfn allocation and setup and
cleans up if pci_setup_device() fails, so pci_iov_add_virtfn() doesn't need
to call pci_stop_and_remove_bus_device().  This prevents accessing
partially initialized virtfn devices during removal.

  BUG: kernel NULL pointer dereference, address: 00000000000000d0
  RIP: 0010:device_del+0x3d/0x3d0
  Call Trace:
   pci_remove_bus_device+0x7c/0x100
   pci_iov_add_virtfn+0xfa/0x200
   sriov_enable+0x208/0x420
   mlx5_core_sriov_configure+0x6a/0x160 [mlx5_core]
   sriov_numvfs_store+0xae/0x1a0

Link: https://lore.kernel.org/r/20250310084524.599225-1-shayd@nvidia.com
Fixes: e3f30d563a38 ("PCI: Make pci_destroy_dev() concurrent safe")
Signed-off-by: Shay Drory <shayd@nvidia.com>
[bhelgaas: commit log, return ERR_PTR(-ENOMEM) directly]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/iov.c | 48 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 4be402fe9ab94..fd491d3d2cc61 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -285,23 +285,16 @@ const struct attribute_group sriov_vf_dev_attr_group = {
 	.is_visible = sriov_vf_attrs_are_visible,
 };
 
-int pci_iov_add_virtfn(struct pci_dev *dev, int id)
+static struct pci_dev *pci_iov_scan_device(struct pci_dev *dev, int id,
+					   struct pci_bus *bus)
 {
-	int i;
-	int rc = -ENOMEM;
-	u64 size;
-	struct pci_dev *virtfn;
-	struct resource *res;
 	struct pci_sriov *iov = dev->sriov;
-	struct pci_bus *bus;
-
-	bus = virtfn_add_bus(dev->bus, pci_iov_virtfn_bus(dev, id));
-	if (!bus)
-		goto failed;
+	struct pci_dev *virtfn;
+	int rc;
 
 	virtfn = pci_alloc_dev(bus);
 	if (!virtfn)
-		goto failed0;
+		return ERR_PTR(-ENOMEM);
 
 	virtfn->devfn = pci_iov_virtfn_devfn(dev, id);
 	virtfn->vendor = dev->vendor;
@@ -314,8 +307,35 @@ int pci_iov_add_virtfn(struct pci_dev *dev, int id)
 		pci_read_vf_config_common(virtfn);
 
 	rc = pci_setup_device(virtfn);
-	if (rc)
-		goto failed1;
+	if (rc) {
+		pci_dev_put(dev);
+		pci_bus_put(virtfn->bus);
+		kfree(virtfn);
+		return ERR_PTR(rc);
+	}
+
+	return virtfn;
+}
+
+int pci_iov_add_virtfn(struct pci_dev *dev, int id)
+{
+	struct pci_bus *bus;
+	struct pci_dev *virtfn;
+	struct resource *res;
+	int rc, i;
+	u64 size;
+
+	bus = virtfn_add_bus(dev->bus, pci_iov_virtfn_bus(dev, id));
+	if (!bus) {
+		rc = -ENOMEM;
+		goto failed;
+	}
+
+	virtfn = pci_iov_scan_device(dev, id, bus);
+	if (IS_ERR(virtfn)) {
+		rc = PTR_ERR(virtfn);
+		goto failed0;
+	}
 
 	virtfn->dev.parent = dev->dev.parent;
 	virtfn->multifunction = 0;
-- 
2.39.5



