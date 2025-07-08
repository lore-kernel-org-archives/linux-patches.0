Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26CC7E9;
	Tue,  8 Jul 2025 16:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993036; cv=none; b=QxEfme4wttsmHkRsm0Pn4yXdBiswSAsz/9ikZq/doI3PigGy6MAwNm4km4Y9b8yp+BCeJZGczx35qRxEYIN88sdmqcJHKWQwnKc/g+bBq89cZb6N66SfJKaIdika67fXgkGg3ame8bDoQm119SJttz+VaYjoKpJIyTrpHrnSjhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993036; c=relaxed/simple;
	bh=L4NxTP4pa3DgTBVnYWWzgctjGiUGJz+DtHss/jRP8bI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOkO45xGVeRnYzHpJxJingLt/s0MGpbGeTD7/0ySLAzJ4PxC28wSnOHZTBc04YNhqgK3M8kX3gTplDumCRAMVXYyksBVrmV7ik9/uqdBT/SlFOe4ouh+Dk8CGWTWQRXLd8Sw8Ak2XYYt4Y7mn9nPbMKanumBmU6G2bJxQqIv720=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C/Dex4tK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C/Dex4tK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D684C4CEED;
	Tue,  8 Jul 2025 16:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993036;
	bh=L4NxTP4pa3DgTBVnYWWzgctjGiUGJz+DtHss/jRP8bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/Dex4tKz0pNQSfZahxQBLNJOz/MZPb2LYcdy8/lQdQGY2pQ8JQnPyoY4LdbBJ5NU
	 AEZXxqdFk2VfNu/IibXtM0LE9chibKhYrB+UnsxW4ja6sa4+44bW/xis9BbEwBn9xR
	 NgfS6YE7BK7PmaJWiVTcj3GM6yV2/fC0j4948tZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longfang Liu <liulongfang@huawei.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 135/232] hisi_acc_vfio_pci: bugfix the problem of uninstalling driver
Date: Tue,  8 Jul 2025 18:22:11 +0200
Message-ID: <20250708162244.974684204@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Longfang Liu <liulongfang@huawei.com>

[ Upstream commit db6525a8573957faea28850392f4744e5f8f7a53 ]

In a live migration scenario. If the number of VFs at the
destination is greater than the source, the recovery operation
will fail and qemu will not be able to complete the process and
exit after shutting down the device FD.

This will cause the driver to be unable to be unloaded normally due
to abnormal reference counting of the live migration driver caused
by the abnormal closing operation of fd.

Therefore, make sure the migration file descriptor references are
always released when the device is closed.

Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migration")
Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Link: https://lore.kernel.org/r/20250510081155.55840-5-liulongfang@huawei.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index e37699fc03707..dda8cb3262e0b 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1359,6 +1359,7 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
 			struct hisi_acc_vf_core_device, core_device.vdev);
 	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
 
+	hisi_acc_vf_disable_fds(hisi_acc_vdev);
 	iounmap(vf_qm->io_base);
 	vfio_pci_core_close_device(core_vdev);
 }
-- 
2.39.5



