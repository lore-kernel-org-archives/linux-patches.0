Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A6F2F9483;
	Tue, 17 Jun 2025 16:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177254; cv=none; b=tYroDu9b5YC0EtIu3zvgVa3ua7P8mVw9mtG7ujghzG0kAbBuYz/OJZQRsNeI+E3tMNkDo2aK0eofT+3jX35CRYlG0UwV0LFKMT3ABel2Nk99fZjnF5vyjw9rwoAuFxTVm5CEzOmwAaCsgAjgX+smzfPqmam2UdZ2xc4PIy679Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177254; c=relaxed/simple;
	bh=UO1rLui/vi5KZo/TSnDgN4yId/pJossscVfQXtqdiNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FcdZ117EdOjs5Jqz9b5UL/VZyApzpsyqKM6C4DBJFU1HlrYBIn8MQPWcm4Ienp7YegY3XDZPYSlm3iLxvbpXLlW6reElKhtFPzIE3Sv4Ce5bgrc5QjCPVWZARBYszL+FZ82/2iWUZB8VYGKO9MNZEWC/swlt3oh/LO7/TgrRpHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LISPn2sR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LISPn2sR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBACC4CEE3;
	Tue, 17 Jun 2025 16:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177254;
	bh=UO1rLui/vi5KZo/TSnDgN4yId/pJossscVfQXtqdiNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LISPn2sRwyWXJa6glvzYX+sNQPiIPBtHX+lET3p4Mn7FQDREX5V7fh3yQJOqaxZWb
	 1+eG/261irbv+vLx6gLwc/3uELWPOi1nCv5yd1MooLwUHz1lydxvBwYoqYI5D+H5Rs
	 ijw30W8T40UKPDdNltNVD5SA5mTK6VF2G5EXFEyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longfang Liu <liulongfang@huawei.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 278/780] hisi_acc_vfio_pci: bugfix the problem of uninstalling driver
Date: Tue, 17 Jun 2025 17:19:46 +0200
Message-ID: <20250617152502.787205114@linuxfoundation.org>
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
index d96446f499ed0..cadc82419dca2 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1508,6 +1508,7 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
 	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
 	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
 
+	hisi_acc_vf_disable_fds(hisi_acc_vdev);
 	mutex_lock(&hisi_acc_vdev->open_mutex);
 	hisi_acc_vdev->dev_opened = false;
 	iounmap(vf_qm->io_base);
-- 
2.39.5



