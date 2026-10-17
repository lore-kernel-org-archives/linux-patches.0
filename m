Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8029529B795;
	Sat, 17 Oct 2026 16:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254719; cv=none; b=JZcMQv/Us6nrIodem1W2otrrqbUorBtgcYINSLrAlr5SZJ+bzgFnXPdZgkALsiVuA1CFUr/QNFvuP6GXrq2F73B+GuKNg271urfWWlvt+AFlvxZZbDwVB/Q8e7Qr5KvG7Xdqb1jBFokCKkb/BPfiDBLg/9xa5RBx2fJPUV72fNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254719; c=relaxed/simple;
	bh=DWeE19V1fGWuFrjG/VeVp1fROr7qMmvNmwTeT+AY2lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFXG7Q+sUajZd8NmUWl4BhwZSzafbjqqomfHjsu/T2HHvNaDT69PnyfWQ25TNPUw3ryctPLAxIGXLYXT/HoAgHLSlRQ1Zwym9UHgMt02/NiO0bCuXfyk4UGC7EOvkIbs9Zw+q4NxUio/iPoSwrbCUOK3wilsD+ZMr6QBNmtGLSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZWVI+Vzi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZWVI+Vzi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8F21F000C4;
	Sat, 17 Oct 2026 16:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254718;
	bh=+eFNu9+rK/B9pXUNZBE5/PHHq2Ys3I/+pDKLnZ+RUdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZWVI+VziRQLtNoIU2nYQShEEsFuANTIVX5+A+qqiNDiFlIugGBPLW4PZaxcHJX15p
	 eZwqdcREV3VbYePZuB8qwCmJAzLgWtBVRN1zN7GCPYjW9rogbQDa6L11Jd2/BoeCbv
	 lCPnyq6YsGRR/o9LuOvGJ6XXsPRahVR4sU8qeKb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 539/869] scsi: hisi_sas: Add slave_destroy interface for v3 hw
Date: Sat, 17 Oct 2026 17:56:20 +0200
Message-ID: <20261017160050.917248568@linuxfoundation.org>
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

From: Yihang Li <liyihang9@huawei.com>

[ Upstream commit 67b85a88265df19f049241d8c00571a5408f4eeb ]

WARNING is triggered when executing link reset of remote PHY and rmmod
SAS driver simultaneously. Following is the WARNING log:

WARNING: CPU: 61 PID: 21818 at drivers/base/core.c:1347 __device_links_no_driver+0xb4/0xc0
 Call trace:
  __device_links_no_driver+0xb4/0xc0
  device_links_driver_cleanup+0xb0/0xfc
  __device_release_driver+0x198/0x23c
  device_release_driver+0x38/0x50
  bus_remove_device+0x130/0x140
  device_del+0x184/0x434
  __scsi_remove_device+0x118/0x150
  scsi_remove_target+0x1bc/0x240
  sas_rphy_remove+0x90/0x94
  sas_rphy_delete+0x24/0x3c
  sas_destruct_devices+0x64/0xa0 [libsas]
  sas_revalidate_domain+0xe4/0x150 [libsas]
  process_one_work+0x1e0/0x46c
  worker_thread+0x15c/0x464
  kthread+0x160/0x170
  ret_from_fork+0x10/0x20
 ---[ end trace 71e059eb58f85d4a ]---

During SAS phy up, link->status is set to DL_STATE_AVAILABLE in
device_links_driver_bound, then this setting influences
__device_links_no_driver() before driver rmmod and caused WARNING.

Add the slave_destroy interface to make sure link is removed after flush
workque.

Fixes: 16fd4a7c5917 ("scsi: hisi_sas: Add device link between SCSI devices and hisi_hba")
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Link: https://patch.msgid.link/20260425082056.2749910-1-liyihang9@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index b7dd4efca0c7f..64aad320a04a3 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2978,7 +2978,7 @@ static int device_configure_v3_hw(struct scsi_device *sdev,
 		return 0;
 
 	if (!device_link_add(&sdev->sdev_gendev, dev,
-			     DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE)) {
+			     DL_FLAG_STATELESS | DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE)) {
 		if (pm_runtime_enabled(dev)) {
 			dev_info(dev, "add device link failed, disable runtime PM for the host\n");
 			pm_runtime_disable(dev);
@@ -2988,6 +2988,15 @@ static int device_configure_v3_hw(struct scsi_device *sdev,
 	return 0;
 }
 
+static void hisi_sas_sdev_destroy(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = dev_to_shost(&sdev->sdev_gendev);
+	struct hisi_hba *hisi_hba = shost_priv(shost);
+	struct device *dev = hisi_hba->dev;
+
+	device_link_remove(&sdev->sdev_gendev, dev);
+}
+
 static struct attribute *host_v3_hw_attrs[] = {
 	&dev_attr_phy_event_threshold.attr,
 	&dev_attr_intr_conv_v3_hw.attr,
@@ -3402,6 +3411,7 @@ static const struct scsi_host_template sht_v3_hw = {
 	.sg_tablesize		= HISI_SAS_SGE_PAGE_CNT,
 	.sg_prot_tablesize	= HISI_SAS_SGE_PAGE_CNT,
 	.slave_alloc		= hisi_sas_slave_alloc,
+	.slave_destroy		= hisi_sas_sdev_destroy,
 	.shost_groups		= host_v3_hw_groups,
 	.sdev_groups		= sdev_groups_v3_hw,
 	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,
-- 
2.53.0



