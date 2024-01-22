Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2977417CA;
	Tue, 23 Jan 2024 02:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975766; cv=none; b=t4n8oEcbEu2llVxBC1HEPHKfJmF59vaPdlZDtpnjjlx4uyEMGazQrIWSj+DfS/GmA17A9eXvoiVasZBZQj0uZIYC+kkc4evUcuqIIkZmb9EQs1J5Z2buThl0VEGjhdlwhjvBLTYeZBesJpKFHmMoOoD8lySuhZ79oGI1JNxuafU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975766; c=relaxed/simple;
	bh=qZac6A0My1nV4uEXzXHEcgknoHFAT6ioGyADDw2MwO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bz0HJqByAA8mq9lROaXlQni2CSM8Ds5xrisbE12HgQlGG8SuqjjumKM12cGFFxMYB2kUc5LDmlCK97DXSNoWWSiRbCZPhMla5SGPrFie23qaX0F9wlznlvGU9yaTW862sq+YSdz4hhSrTnW57f8WmsNkYtOP3+AZWjgiYaynp+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rRk2ex2F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rRk2ex2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB731C43394;
	Tue, 23 Jan 2024 02:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975766;
	bh=qZac6A0My1nV4uEXzXHEcgknoHFAT6ioGyADDw2MwO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rRk2ex2FKNsju7wJGXtKnUYuJFAB/3pQUJ9FTDscrXHg176QAJfXEuzf6PiS48Vyj
	 seHPEjh8pZe9NOIW4B1RnfoYUDT8hqOBWYHImEYzVVQv95FfQxb/3H+oRdQ+/6Gua1
	 Yo2w9jfl0+LjNb3fpYaF8Tvfu7HeJb10zh74eHG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 516/583] hisi_acc_vfio_pci: Update migration data pointer correctly on saving/resume
Date: Mon, 22 Jan 2024 15:59:27 -0800
Message-ID: <20240122235827.868215042@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



