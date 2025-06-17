Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B2D2ECE8A;
	Tue, 17 Jun 2025 15:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174943; cv=none; b=XBJQNPEVuC4/d6rPft01IsgDdqTF89wdrTorG9vDmobKwJKuPe6hiiJEorOZkPGTzyIW0uQUMylz9hBmTHwxOQZR3Cpv1VkdPi4qSRnAswucZNbOKS4OskbtPQNbamFc8//pzzy8p0dAjTksLcr1NaxveexjFH0O2z2LA+pUPS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174943; c=relaxed/simple;
	bh=GErZEjKMCH8R36SWtJ2JVMKwx1UQwtBdu+iZZbBnANE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZShRqBP81TwA9RoBWNpEQ3MDcnq6ZOWNoronDc0+IuPophTWoPB2dnBTTiCYRnBuqAzwTcUsY2VG7NC7t9LqWdZ7i7R7tI3NcEoUB+j+T7kuDmB/dIX9nsDrIq7GQ4fChLYft6jq7AhUm8ybaVW40eUMdK6e0WZNOE4S4gUS0Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sk8lDkWa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sk8lDkWa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860C2C4CEF3;
	Tue, 17 Jun 2025 15:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174943;
	bh=GErZEjKMCH8R36SWtJ2JVMKwx1UQwtBdu+iZZbBnANE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sk8lDkWabvrh1IOD9BtmLBt6bPPFhKq2JN+Pd4Wbp5vNKYt9l6fde3Igv38N6eraR
	 krEbNJkUzCg3rwsNT8RUw/MsH0yKjMQtDoLX7HBTjgLF+yt19AZAxUqMChPcCXdQL5
	 vZuv43kaET7uoKeK7YaPczcCghrv5niMMFptViPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longfang Liu <liulongfang@huawei.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 130/356] hisi_acc_vfio_pci: bugfix live migration function without VF device driver
Date: Tue, 17 Jun 2025 17:24:05 +0200
Message-ID: <20250617152343.469431079@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 521f969e1c608..712b178c42aae 100644
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
@@ -1397,6 +1404,7 @@ static int hisi_acc_vfio_pci_migrn_init_dev(struct vfio_device *core_vdev)
 	hisi_acc_vdev->vf_id = pci_iov_vf_id(pdev) + 1;
 	hisi_acc_vdev->pf_qm = pf_qm;
 	hisi_acc_vdev->vf_dev = pdev;
+	hisi_acc_vdev->vf_qm_state = QM_NOT_READY;
 	mutex_init(&hisi_acc_vdev->state_mutex);
 
 	core_vdev->migration_flags = VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_PRE_COPY;
-- 
2.39.5



