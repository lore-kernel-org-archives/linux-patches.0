Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51F3521895;
	Wed, 30 Sep 2026 17:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789729; cv=none; b=uHhoXTONvhiePuQ5lCl8jPHeHGzWZFFTkDWObV1IR+ClhIcl5OBUXmnVMbtdLu6FmQVfojaR/o1Ax6a45Kdnh7M6ij8+J5O9CwD1MCCJWZ8vjjmtDkvhs2b9JaodLqky8LfA3iAUtRlHgr2A89aiYCbavYHU0KSKkJISqyBfunE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789729; c=relaxed/simple;
	bh=enIS5Db7yQP789/ycZ9wxu+jpGrURaD2znAEyIaqxxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jNsP5D5bdo+qCH3UnwU/ctXK+Pj3Sf7G9onUK4cs0vL9izr/XjgGDdZrtUJEg0Vk5Bscj9RceFlAtyjalgfoBAUgsjPnAIHhG2+7/wn3TtG4BlGnohdtraFyPb6DhQ5w6soXfvkDBjSqv2XKP+hh0m36TVKKZ5t5SSHYP660wuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XyzH6UJ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XyzH6UJ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9A71F008A6;
	Wed, 30 Sep 2026 17:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789726;
	bh=z+SAPCBvLccd3n0Po3AzazmeTtfPmppshpYH+exR+cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XyzH6UJ5ziffR8z2CmI/6PHe9tkohPtpMsEOg0KpfNdZ5f0J8FwjPEBD739zZ/LYK
	 EhalAwoH9sizRTI/K4KoMrDBddHYtpFV7qc+GGRfrFCaMGSx8foVHaDdy5GOsCBhXt
	 Rp9gkVdiHl8zMd7SiqshIvCCTfiWRl61VKatFax4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Peiyang He <peiyang_he@smail.nju.edu.cn>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 578/877] iommufd: Fix UAF in selftest IOPF reporting
Date: Wed, 30 Sep 2026 17:24:49 +0200
Message-ID: <20260930152427.116592957@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Peiyang He <peiyang_he@smail.nju.edu.cn>

[ Upstream commit 8c07df7cdfcf52f1ff276c588612aabc6c6b8399 ]

IOMMUFD selftest TRIGGER_IOPF borrows an attach handle from
group->pasid_array without synchronizing against PASID detach,
then a concurrent iommu_report_device_fault() can dereference
that borrowed handle's domain pointer after the detach erases
the handle and frees the backing struct iommufd_attach_handle.
TRIGGER_IOPF then dereferences the freed handle, causing a UAF.

Fix by adding a iopf_rwsem in mock_dev to follow the expected design
of a real driver. Hold its read side across the whole
iommu_report_device_fault() call, and its write side around every
path that attaches, detaches, or replaces a device domain.
This can block new reports and drains in-flight reports before an old
attach handle or the IOPF fault parameter can be removed.
Also take the write side while registering a mock device, since
it can invoke the mock driver's default-domain attach callback.

Closes: https://lore.kernel.org/all/D5E3AA41600B2056+f4e15662-bd2b-43ea-91cb-518de429e72c@smail.nju.edu.cn/
Fixes: ddee19971081 ("iommufd/selftest: Add IOPF support for mock device")
Cc: stable@vger.kernel.org
Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Assisted-by: Codex:gpt-5.6-terra
Signed-off-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
Link: https://patch.msgid.link/38C8DF0A118B7176+20260811095551.2756745-1-peiyang_he@smail.nju.edu.cn
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[ adapted locking to the older non-PASID selftest device APIs. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/selftest.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -139,6 +139,7 @@ enum selftest_obj_type {
 
 struct mock_dev {
 	struct device dev;
+	struct rw_semaphore iopf_rwsem;
 	unsigned long flags;
 	int id;
 };
@@ -702,6 +703,7 @@ static struct mock_dev *mock_dev_create(
 	if (!mdev)
 		return ERR_PTR(-ENOMEM);
 
+	init_rwsem(&mdev->iopf_rwsem);
 	device_initialize(&mdev->dev);
 	mdev->flags = dev_flags;
 	mdev->dev.release = mock_dev_release;
@@ -716,7 +718,9 @@ static struct mock_dev *mock_dev_create(
 	if (rc)
 		goto err_put;
 
+	down_write(&mdev->iopf_rwsem);
 	rc = device_add(&mdev->dev);
+	up_write(&mdev->iopf_rwsem);
 	if (rc)
 		goto err_put;
 	return mdev;
@@ -771,7 +775,9 @@ static int iommufd_test_mock_domain(stru
 	}
 	sobj->idev.idev = idev;
 
+	down_write(&sobj->idev.mock_dev->iopf_rwsem);
 	rc = iommufd_device_attach(idev, &pt_id);
+	up_write(&sobj->idev.mock_dev->iopf_rwsem);
 	if (rc)
 		goto out_unbind;
 
@@ -786,7 +792,9 @@ static int iommufd_test_mock_domain(stru
 	return 0;
 
 out_detach:
+	down_write(&sobj->idev.mock_dev->iopf_rwsem);
 	iommufd_device_detach(idev);
+	up_write(&sobj->idev.mock_dev->iopf_rwsem);
 out_unbind:
 	iommufd_device_unbind(idev);
 out_mdev:
@@ -820,7 +828,9 @@ static int iommufd_test_mock_domain_repl
 		goto out_dev_obj;
 	}
 
+	down_write(&sobj->idev.mock_dev->iopf_rwsem);
 	rc = iommufd_device_replace(sobj->idev.idev, &pt_id);
+	up_write(&sobj->idev.mock_dev->iopf_rwsem);
 	if (rc)
 		goto out_dev_obj;
 
@@ -1418,10 +1428,16 @@ static int iommufd_test_trigger_iopf(str
 {
 	struct iopf_fault event = { };
 	struct iommufd_device *idev;
+	struct mock_dev *mdev;
 
 	idev = iommufd_get_device(ucmd, cmd->trigger_iopf.dev_id);
 	if (IS_ERR(idev))
 		return PTR_ERR(idev);
+	if (!iommufd_selftest_is_mock_dev(idev->dev)) {
+		iommufd_put_object(ucmd->ictx, &idev->obj);
+		return -EINVAL;
+	}
+	mdev = container_of(idev->dev, struct mock_dev, dev);
 
 	event.fault.prm.flags = IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE;
 	if (cmd->trigger_iopf.pasid != IOMMU_NO_PASID)
@@ -1432,7 +1448,9 @@ static int iommufd_test_trigger_iopf(str
 	event.fault.prm.grpid = cmd->trigger_iopf.grpid;
 	event.fault.prm.perm = cmd->trigger_iopf.perm;
 
+	down_read(&mdev->iopf_rwsem);
 	iommu_report_device_fault(idev->dev, &event);
+	up_read(&mdev->iopf_rwsem);
 	iommufd_put_object(ucmd->ictx, &idev->obj);
 
 	return 0;
@@ -1444,7 +1462,9 @@ void iommufd_selftest_destroy(struct iom
 
 	switch (sobj->type) {
 	case TYPE_IDEV:
+		down_write(&sobj->idev.mock_dev->iopf_rwsem);
 		iommufd_device_detach(sobj->idev.idev);
+		up_write(&sobj->idev.mock_dev->iopf_rwsem);
 		iommufd_device_unbind(sobj->idev.idev);
 		mock_dev_destroy(sobj->idev.mock_dev);
 		break;


