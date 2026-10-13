Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F06C4F3910;
	Tue, 13 Oct 2026 12:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893593; cv=none; b=YKF0G50wC3Bgy8vbPFryTk9TpCdahFsrmTsPXrI5P+xfjWNn16y/MAAoP4NmfLIWtpIU3biQ6fB+bqks5e/HzjNfcOqorAmOnXeibUv6zSs0SJxzwY5GoHVimxahqI3zvNNXiM6Vdja48w3NIHLnwzhxSTp2OatQT900uwRMQHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893593; c=relaxed/simple;
	bh=G2j9R58la1VUw0J8cRk+Ff3X5ZOLeLSb/BBY1l/RIA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8eohJczoVXP73E6s/7GFx3+/3xu2fuLC7rE9ohCqvK6dUUtvAM0aAOaHERhG3SdUHo8zGV8U5JmnoJ2cIKFeYx4Wz5RJWfUQhmLSs/X/9fLmDgs3p0oZfRueNQD15HtCdf4eCPCtIz7NliyHLWlzW+84nCfVmzc8uTWzsxJyj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wVqUkjq8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wVqUkjq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF261F000FF;
	Tue, 13 Oct 2026 12:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893592;
	bh=1RtbS1PmeUfycR/v4wc0J3mIVoYItWTJpy7XMc0g47U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wVqUkjq89qnUVgcETSYMqRhPjQzlKFKJ7w2WDQ8hqLkWsHmzjPlr9MFaTNtOpmZ2R
	 3YO2H1qdFfyUiwxIUYmTpu8qpxTZuXxpMg3n4W3TfMjQYbtDcWXDTCb1JkbEvj5bpG
	 KwBU+AcEXG0ue7885ehsO88IAB7W1xsFyYSB7oew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 277/621] net/liquidio: drop cached VF pci_dev LUT
Date: Tue, 13 Oct 2026 13:34:32 +0200
Message-ID: <20261013112927.434746555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index eb620e8544cf1..4d73db01cae24 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -3791,9 +3791,7 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 static int octeon_enable_sriov(struct octeon_device *oct)
 {
 	unsigned int num_vfs_alloced = oct->sriov_info.num_vfs_alloced;
-	struct pci_dev *vfdev;
 	int err;
-	u32 u;
 
 	if (OCTEON_CN23XX_PF(oct) && num_vfs_alloced) {
 		err = pci_enable_sriov(oct->pci_dev,
@@ -3806,23 +3804,6 @@ static int octeon_enable_sriov(struct octeon_device *oct)
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
@@ -3830,8 +3811,6 @@ static int octeon_enable_sriov(struct octeon_device *oct)
 
 static int lio_pci_sriov_disable(struct octeon_device *oct)
 {
-	int u;
-
 	if (pci_vfs_assigned(oct->pci_dev)) {
 		dev_err(&oct->pci_dev->dev, "VFs are still assigned to VMs.\n");
 		return -EPERM;
@@ -3839,12 +3818,6 @@ static int lio_pci_sriov_disable(struct octeon_device *oct)
 
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
index 19344b21f8fb9..858a0fff2cc0b 100644
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



