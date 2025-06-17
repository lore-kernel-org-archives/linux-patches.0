Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936BE2F9492;
	Tue, 17 Jun 2025 16:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177261; cv=none; b=j0GU/3NifeSv2nx3vVjRj/waIuRrZLEOoRgwlpo5vxCH3YzV9IdVw2CJxiLH46Kd0HSS9aMcpoAwAXjMy4HWrZtIXCpt7hhLFno2efbcxHowMvlf9T2gFgvNhpzNRb9KshJVOXL7vlkSREWCB5jdZ/IOFafzr+dEmB3GjV3gt7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177261; c=relaxed/simple;
	bh=EGxRXRGUfSp4hw6RaJNWDC4BrzrFpeNy8ZHBucheS4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nu7GS3UoGDIW+JCEYKubBx0JXWtzfRU0jMJncnFtaV0Sy/rosKiJpSrZV2TwgwmQdki1SqYg4S5tcY+watEdVtvjFtjB03pOJ3SEtTzw4T+66aBCATNs0tPhqozctCbUD6Oe0cryekPPk5KYUAez2AWm8J9xjy0mSJCM7MqTxKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LF65h5xj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LF65h5xj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FAFC4CEE3;
	Tue, 17 Jun 2025 16:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177261;
	bh=EGxRXRGUfSp4hw6RaJNWDC4BrzrFpeNy8ZHBucheS4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LF65h5xjxfZJS6e7/D/T8Zm0XN8FErkWcOd59xO77iIFGkjd30dEBtw4O+NBFJzms
	 3gH1rEfRYcXfF1oaNmw5WHNJed4ESv2+qPxJ9Mws6QNFkmtqdsuj0dyCMPvGSYPNo5
	 MVK06yXRSng1wMXyiE8I1wHCV0nuKhxj71uTQiyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longfang Liu <liulongfang@huawei.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 279/780] hisi_acc_vfio_pci: bugfix live migration function without VF device driver
Date: Tue, 17 Jun 2025 17:19:47 +0200
Message-ID: <20250617152502.830496172@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Longfang Liu <liulongfang@huawei.com>

[ Upstream commit 2777a40998deb36f96b6afc48bd397cf58a4edf0 ]

If the VF device driver is not loaded in the Guest OS and we attempt to
perform device data migration, the address of the migrated data will
be NULL.
The live migration recovery operation on the destination side will
access a null address value, which will cause access errors.

Therefore, live migration of VMs without added VF device drivers
does not require device data migration.
In addition, when the queue address data obtained by the destination
is empty, device queue recovery processing will not be performed.

Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migration")
Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Link: https://lore.kernel.org/r/20250510081155.55840-6-liulongfang@huawei.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 22 +++++++++++++------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index cadc82419dca2..d12a350440d3c 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -426,13 +426,6 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 		return -EINVAL;
 	}
 
-	ret = qm_write_regs(vf_qm, QM_VF_STATE, &vf_data->vf_qm_state, 1);
-	if (ret) {
-		dev_err(dev, "failed to write QM_VF_STATE\n");
-		return ret;
-	}
-
-	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
 	hisi_acc_vdev->match_done = true;
 	return 0;
 }
@@ -498,6 +491,20 @@ static int vf_qm_load_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	if (migf->total_length < sizeof(struct acc_vf_data))
 		return -EINVAL;
 
+	if (!vf_data->eqe_dma || !vf_data->aeqe_dma ||
+	    !vf_data->sqc_dma || !vf_data->cqc_dma) {
+		dev_info(dev, "resume dma addr is NULL!\n");
+		hisi_acc_vdev->vf_qm_state = QM_NOT_READY;
+		return 0;
+	}
+
+	ret = qm_write_regs(qm, QM_VF_STATE, &vf_data->vf_qm_state, 1);
+	if (ret) {
+		dev_err(dev, "failed to write QM_VF_STATE\n");
+		return -EINVAL;
+	}
+	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
+
 	qm->eqe_dma = vf_data->eqe_dma;
 	qm->aeqe_dma = vf_data->aeqe_dma;
 	qm->sqc_dma = vf_data->sqc_dma;
@@ -1531,6 +1538,7 @@ static int hisi_acc_vfio_pci_migrn_init_dev(struct vfio_device *core_vdev)
 	hisi_acc_vdev->vf_id = pci_iov_vf_id(pdev) + 1;
 	hisi_acc_vdev->pf_qm = pf_qm;
 	hisi_acc_vdev->vf_dev = pdev;
+	hisi_acc_vdev->vf_qm_state = QM_NOT_READY;
 	mutex_init(&hisi_acc_vdev->state_mutex);
 	mutex_init(&hisi_acc_vdev->open_mutex);
 
-- 
2.39.5



