Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936BF2C026C;
	Sat, 17 Oct 2026 16:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254395; cv=none; b=PuKZcxYDIzHLHGFbAAlJlo20WCnhUDjMSFZw2gCfIHAXNzMINSZ2Bv58ST7tsfsLeX7d4SFtZAXBvRNDcdOE+w6ojtYvVJh4VMzSFXEqzWZ2TOXD9d9yj8V6ITtmRfLqJ0E4p7/b2YDlJw1O0yWNu6piRLah76bTwExuwdF/FTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254395; c=relaxed/simple;
	bh=z7ky3tRCyvxvp5ALZaS4gV3tf4PIr72nsssJURb/6Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SkONwFOLUURTKz4xmNImDgGU1VMjMuD7AjxQkzG26a772cxRrtEertxTitD4qCwOo+WmzuT4A6RTLtZqksen+hU2qh4gGfCTOZC5SvxKZ2GZUT5xdvZVMtJWcUuKJ5vB0tMVf2iTNHU1V2A/2QHNIvOzNUIQzEeclRIMB/cIlvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mzK4Ty7f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mzK4Ty7f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01051F000C4;
	Sat, 17 Oct 2026 16:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254394;
	bh=+T0tnb0rE7SVXzIu2M9n1sHCElahlsAOIQXVxg2/GTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mzK4Ty7fl1/3wL9PE0EYnAr7+Cu7VyEHkoqTxp7J6EXhLO4D1S9hseZ2sbmiNYoj+
	 t78R5K7TrsjSB8vaa7MzIaJbc7Qgve7s+5439kSTVn1ZkyFe8GFA40A8ekAlYBhFOi
	 JT/rxnYct3vMKSAt3Ohk9rsF4LkD++G3NkDD6E90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 433/869] net/liquidio: drop cached VF pci_dev LUT
Date: Sat, 17 Oct 2026 17:54:34 +0200
Message-ID: <20261017160048.245543413@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 5c0e3ba4f500fd4314ceb42f07f16bc445156431 ]

The PF SR-IOV enable path caches VF pci_dev pointers in
dpiring_to_vfpcidev_lut[] by iterating with pci_get_device(). Those
entries do not own a reference, because the iterator drops the previous
device reference on each step. The cached pointer is then dereferenced
later when handling OCTEON_VF_FLR_REQUEST.

Replace the cached VF mapping with runtime lookup on the mailbox DPI
ring: derive the VF index from q_no, resolve the VF via exported PCI
IOV helpers, validate it with the PF pointer and VF ID, then issue
pcie_flr() and drop the reference with pci_dev_put(). Remove the
unused VF lookup table initialization and cleanup.

Fixes: ca6139ffc67ee ("liquidio CN23XX: sysfs VF config support")
Fixes: 8c978d059224 ("liquidio CN23XX: Mailbox support")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Link: https://patch.msgid.link/20260701040847.1897845-1-dbgh9129@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/cavium/liquidio/lio_main.c   | 27 ---------------
 .../ethernet/cavium/liquidio/octeon_device.h  |  3 --
 .../ethernet/cavium/liquidio/octeon_mailbox.c | 33 ++++++++++++++++++-
 3 files changed, 32 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index ebb82767b6e53..630cacd338fd8 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -3789,9 +3789,7 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 static int octeon_enable_sriov(struct octeon_device *oct)
 {
 	unsigned int num_vfs_alloced = oct->sriov_info.num_vfs_alloced;
-	struct pci_dev *vfdev;
 	int err;
-	u32 u;
 
 	if (OCTEON_CN23XX_PF(oct) && num_vfs_alloced) {
 		err = pci_enable_sriov(oct->pci_dev,
@@ -3804,23 +3802,6 @@ static int octeon_enable_sriov(struct octeon_device *oct)
 			return err;
 		}
 		oct->sriov_info.sriov_enabled = 1;
-
-		/* init lookup table that maps DPI ring number to VF pci_dev
-		 * struct pointer
-		 */
-		u = 0;
-		vfdev = pci_get_device(PCI_VENDOR_ID_CAVIUM,
-				       OCTEON_CN23XX_VF_VID, NULL);
-		while (vfdev) {
-			if (vfdev->is_virtfn &&
-			    (vfdev->physfn == oct->pci_dev)) {
-				oct->sriov_info.dpiring_to_vfpcidev_lut[u] =
-					vfdev;
-				u += oct->sriov_info.rings_per_vf;
-			}
-			vfdev = pci_get_device(PCI_VENDOR_ID_CAVIUM,
-					       OCTEON_CN23XX_VF_VID, vfdev);
-		}
 	}
 
 	return num_vfs_alloced;
@@ -3828,8 +3809,6 @@ static int octeon_enable_sriov(struct octeon_device *oct)
 
 static int lio_pci_sriov_disable(struct octeon_device *oct)
 {
-	int u;
-
 	if (pci_vfs_assigned(oct->pci_dev)) {
 		dev_err(&oct->pci_dev->dev, "VFs are still assigned to VMs.\n");
 		return -EPERM;
@@ -3837,12 +3816,6 @@ static int lio_pci_sriov_disable(struct octeon_device *oct)
 
 	pci_disable_sriov(oct->pci_dev);
 
-	u = 0;
-	while (u < MAX_POSSIBLE_VFS) {
-		oct->sriov_info.dpiring_to_vfpcidev_lut[u] = NULL;
-		u += oct->sriov_info.rings_per_vf;
-	}
-
 	oct->sriov_info.num_vfs_alloced = 0;
 	dev_info(&oct->pci_dev->dev, "oct->pf_num:%d disabled VFs\n",
 		 oct->pf_num);
diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_device.h b/drivers/net/ethernet/cavium/liquidio/octeon_device.h
index d26364c2ac81c..555c7ef4c04a9 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_device.h
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_device.h
@@ -390,9 +390,6 @@ struct octeon_sriov_info {
 
 	struct lio_trusted_vf	trusted_vf;
 
-	/*lookup table that maps DPI ring number to VF pci_dev struct pointer*/
-	struct pci_dev *dpiring_to_vfpcidev_lut[MAX_POSSIBLE_VFS];
-
 	u64	vf_macaddr[MAX_POSSIBLE_VFS];
 
 	u16	vf_vlantci[MAX_POSSIBLE_VFS];
diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_mailbox.c b/drivers/net/ethernet/cavium/liquidio/octeon_mailbox.c
index ad685f5d0a136..697fcdc41e3cd 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_mailbox.c
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_mailbox.c
@@ -26,6 +26,31 @@
 #include "octeon_mailbox.h"
 #include "cn23xx_pf_device.h"
 
+static struct pci_dev *lio_vf_pci_dev_by_qno(struct octeon_device *oct, u32 q_no)
+{
+	struct pci_dev *vfdev = NULL;
+	int vfidx;
+
+	if (!oct->sriov_info.rings_per_vf)
+		return NULL;
+
+	if (q_no % oct->sriov_info.rings_per_vf)
+		return NULL;
+
+	vfidx = q_no / oct->sriov_info.rings_per_vf;
+	if (vfidx >= oct->sriov_info.num_vfs_alloced)
+		return NULL;
+
+	while ((vfdev = pci_get_device(PCI_VENDOR_ID_CAVIUM,
+				       OCTEON_CN23XX_VF_VID, vfdev))) {
+		if (pci_physfn(vfdev) && pci_physfn(vfdev) == oct->pci_dev &&
+		    pci_iov_vf_id(vfdev) == vfidx)
+			return vfdev;
+	}
+
+	return NULL;
+}
+
 /**
  * octeon_mbox_read:
  * @mbox: Pointer mailbox
@@ -237,6 +262,7 @@ static int octeon_mbox_process_cmd(struct octeon_mbox *mbox,
 				   struct octeon_mbox_cmd *mbox_cmd)
 {
 	struct octeon_device *oct = mbox->oct_dev;
+	struct pci_dev *vfdev;
 
 	switch (mbox_cmd->msg.s.cmd) {
 	case OCTEON_VF_ACTIVE:
@@ -260,7 +286,12 @@ static int octeon_mbox_process_cmd(struct octeon_mbox *mbox,
 		dev_info(&oct->pci_dev->dev,
 			 "got a request for FLR from VF that owns DPI ring %u\n",
 			 mbox->q_no);
-		pcie_flr(oct->sriov_info.dpiring_to_vfpcidev_lut[mbox->q_no]);
+		vfdev = lio_vf_pci_dev_by_qno(oct, mbox->q_no);
+		if (!vfdev)
+			break;
+
+		pcie_flr(vfdev);
+		pci_dev_put(vfdev);
 		break;
 
 	case OCTEON_PF_CHANGED_VF_MACADDR:
-- 
2.53.0



