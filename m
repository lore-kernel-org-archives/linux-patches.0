Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1649D1EB5E1;
	Wed, 25 Feb 2026 01:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983367; cv=none; b=KJsvxoDpcBL/+6CIy9qXqg9TyrOLHyXk2tllSstV9GZL9j5/g+GcMuKABk5ZXfWP6B7h1GCgYG3W3GljC29idYcPEZ0TCvvGgFM1FpaRI3ZmKAOpBaC06l0pk430ZlvauYHCOIzrV55x5VoHf8jiukX2YsptDyU2cr43V7AnBO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983367; c=relaxed/simple;
	bh=ScU3JhVJdDff8EOkZUTPOo4wPlTBpPCSXNTkqoUNrfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TiOSqUUMhIDiqnQ2IxAKkCnB5BFwIbXpeWSmtw4/troLhRjoEM8+vKP12/nwdME8MZBmmuIlYvqjjcS/6Eni+PJOIbrN5UZ6rzpGwccDt2iqIizbN3b3xaEZlGEA3Dgug1oaspmQ3fLxGTk/ZbjKISJ1e7jkZXq/4ng6g4SpZeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LD0Q6FX3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LD0Q6FX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA1BC116D0;
	Wed, 25 Feb 2026 01:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983367;
	bh=ScU3JhVJdDff8EOkZUTPOo4wPlTBpPCSXNTkqoUNrfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LD0Q6FX3SFYU+x4ruRWTs2ncqYw8lQMrJkS5A1YxQqY4OaC4CGgAHpaTT/8gDCFZT
	 QXn2PXdfXTO22AVis+/bD+h0TCzTkOmoaVMOq1y889wgn5+315t0bb+0IdmQMdQ+TQ
	 UNWT2aljX1ao7pX3GcHvMKk7maM746yPGSzyi5Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 493/781] hisi_acc_vfio_pci: fix VF reset timeout issue
Date: Tue, 24 Feb 2026 17:20:02 -0800
Message-ID: <20260225012411.899706126@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit a22099ed7936f8e8dabbdbadd97d56047797116b ]

If device error occurs during live migration, qemu will
reset the VF. At this time, VF reset and device reset are performed
simultaneously. The VF reset will timeout. Therefore, the QM_RESETTING
flag is used to ensure that VF reset and device reset are performed
serially.

Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migration")
Signed-off-by: Weili Qian <qianweili@huawei.com>
Link: https://lore.kernel.org/r/20260122020205.2884497-2-liulongfang@huawei.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 24 +++++++++++++++++++
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  2 ++
 2 files changed, 26 insertions(+)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index cf45f6370c369..d1e8053640a98 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1188,9 +1188,32 @@ hisi_acc_vfio_pci_get_device_state(struct vfio_device *vdev,
 	return 0;
 }
 
+static void hisi_acc_vf_pci_reset_prepare(struct pci_dev *pdev)
+{
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
+	struct hisi_qm *qm = hisi_acc_vdev->pf_qm;
+	struct device *dev = &qm->pdev->dev;
+	u32 delay = 0;
+
+	/* All reset requests need to be queued for processing */
+	while (test_and_set_bit(QM_RESETTING, &qm->misc_ctl)) {
+		msleep(1);
+		if (++delay > QM_RESET_WAIT_TIMEOUT) {
+			dev_err(dev, "reset prepare failed\n");
+			return;
+		}
+	}
+
+	hisi_acc_vdev->set_reset_flag = true;
+}
+
 static void hisi_acc_vf_pci_aer_reset_done(struct pci_dev *pdev)
 {
 	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
+	struct hisi_qm *qm = hisi_acc_vdev->pf_qm;
+
+	if (hisi_acc_vdev->set_reset_flag)
+		clear_bit(QM_RESETTING, &qm->misc_ctl);
 
 	if (hisi_acc_vdev->core_device.vdev.migration_flags !=
 				VFIO_MIGRATION_STOP_COPY)
@@ -1734,6 +1757,7 @@ static const struct pci_device_id hisi_acc_vfio_pci_table[] = {
 MODULE_DEVICE_TABLE(pci, hisi_acc_vfio_pci_table);
 
 static const struct pci_error_handlers hisi_acc_vf_err_handlers = {
+	.reset_prepare = hisi_acc_vf_pci_reset_prepare,
 	.reset_done = hisi_acc_vf_pci_aer_reset_done,
 	.error_detected = vfio_pci_core_aer_err_detected,
 };
diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
index cd55eba64dfb2..a3d91a31e3d88 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
@@ -27,6 +27,7 @@
 
 #define ERROR_CHECK_TIMEOUT		100
 #define CHECK_DELAY_TIME		100
+#define QM_RESET_WAIT_TIMEOUT  60000
 
 #define QM_SQC_VFT_BASE_SHIFT_V2	28
 #define QM_SQC_VFT_BASE_MASK_V2		GENMASK(15, 0)
@@ -128,6 +129,7 @@ struct hisi_acc_vf_migration_file {
 struct hisi_acc_vf_core_device {
 	struct vfio_pci_core_device core_device;
 	u8 match_done;
+	bool set_reset_flag;
 	/*
 	 * io_base is only valid when dev_opened is true,
 	 * which is protected by open_mutex.
-- 
2.51.0



