Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FC856B68;
	Tue, 23 Jan 2024 00:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970034; cv=none; b=LV9MNp9hRYzSj6xTf0eLIg4KdryildRrvH8uTdzOkrbbpI8aOkp+0RqJlW6eTxItJsOnVG8Ffix0ZoLjy4OyHylmsggHxMGCdDRaXf7dO0RtUjsRotGxlHoc1+BRS8Jn9M/mdIMhngR1XFWLzCEXWJvxdn8Sdsdz20L/g0dkWO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970034; c=relaxed/simple;
	bh=JU3GTohSOz3CdEKoou3u2xvPXO5HwI73nDpqdfD9OnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tw4KS7toA/MUtpdfg1RaAFLBcnCd2xB8Uc+4bQWtT+0ziUvUyomslFP3P7PlRgcI3oGtzoWGTxXHwOLLfrg9KvsP1zDwzk3iRp3AUenx4jqimE2WgRfAK9Z8vNATSUu4CozAruIYuWBEvInpAhQ09/hVkebYHtuIKYstSlau+ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lvp5+9lw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lvp5+9lw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B936C433F1;
	Tue, 23 Jan 2024 00:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970034;
	bh=JU3GTohSOz3CdEKoou3u2xvPXO5HwI73nDpqdfD9OnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lvp5+9lw0iTOk4/JzPSSEUFT5W4KNiiQs1cJmgcadUodq1i1jn7+N2o0YMdLQKP3Z
	 2xxuIrGgBPedeaow4klnhSpj7qQIjbJ9qv2MA3KhM1iCM41IULfRqz1DVVMFf8EaiB
	 XFUMSPdqhhNcj3dIgQOMr/YWILH9u3t1KPEBXpBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 570/641] hisi_acc_vfio_pci: Update migration data pointer correctly on saving/resume
Date: Mon, 22 Jan 2024 15:57:54 -0800
Message-ID: <20240122235835.999509883@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

[ Upstream commit be12ad45e15b5ee0e2526a50266ba1d295d26a88 ]

When the optional PRE_COPY support was added to speed up the device
compatibility check, it failed to update the saving/resuming data
pointers based on the fd offset. This results in migration data
corruption and when the device gets started on the destination the
following error is reported in some cases,

[  478.907684] arm-smmu-v3 arm-smmu-v3.2.auto: event 0x10 received:
[  478.913691] arm-smmu-v3 arm-smmu-v3.2.auto:  0x0000310200000010
[  478.919603] arm-smmu-v3 arm-smmu-v3.2.auto:  0x000002088000007f
[  478.925515] arm-smmu-v3 arm-smmu-v3.2.auto:  0x0000000000000000
[  478.931425] arm-smmu-v3 arm-smmu-v3.2.auto:  0x0000000000000000
[  478.947552] hisi_zip 0000:31:00.0: qm_axi_rresp [error status=0x1] found
[  478.955930] hisi_zip 0000:31:00.0: qm_db_timeout [error status=0x400] found
[  478.955944] hisi_zip 0000:31:00.0: qm sq doorbell timeout in function 2

Fixes: d9a871e4a143 ("hisi_acc_vfio_pci: Introduce support for PRE_COPY state transitions")
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20231120091406.780-1-shameerali.kolothum.thodi@huawei.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index b2f9778c8366..4d27465c8f1a 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -694,6 +694,7 @@ static ssize_t hisi_acc_vf_resume_write(struct file *filp, const char __user *bu
 					size_t len, loff_t *pos)
 {
 	struct hisi_acc_vf_migration_file *migf = filp->private_data;
+	u8 *vf_data = (u8 *)&migf->vf_data;
 	loff_t requested_length;
 	ssize_t done = 0;
 	int ret;
@@ -715,7 +716,7 @@ static ssize_t hisi_acc_vf_resume_write(struct file *filp, const char __user *bu
 		goto out_unlock;
 	}
 
-	ret = copy_from_user(&migf->vf_data, buf, len);
+	ret = copy_from_user(vf_data + *pos, buf, len);
 	if (ret) {
 		done = -EFAULT;
 		goto out_unlock;
@@ -835,7 +836,9 @@ static ssize_t hisi_acc_vf_save_read(struct file *filp, char __user *buf, size_t
 
 	len = min_t(size_t, migf->total_length - *pos, len);
 	if (len) {
-		ret = copy_to_user(buf, &migf->vf_data, len);
+		u8 *vf_data = (u8 *)&migf->vf_data;
+
+		ret = copy_to_user(buf, vf_data + *pos, len);
 		if (ret) {
 			done = -EFAULT;
 			goto out_unlock;
-- 
2.43.0



