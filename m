Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB1D408035;
	Fri,  4 Sep 2026 05:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499810; cv=none; b=o8xuPZ1dOonea2eOXpYX3jt/RO7lzpx+jTIdmDeWmUgz2Wf/qGsmxQCZERDWBrRp+preSMQznf3YwEQGzE9xhFoPPrFDP7LDFJ9auy4T6/z1jv+jHOapvdULNaFuMqxlxYtbVwVkPKPUAAYtj/1TNz2LBzyavBiGayrOTYRl3mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499810; c=relaxed/simple;
	bh=pgpuEdUm4qEAJQjXk/xO0WAJVESePmfxiSp/1cU2ijg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHpZ6yIWDhE/QvIeG6ShbdyxyrIN59oxGuOH6VDtZ4eK7xThnmm5ErUU8Xz8kQB/IZBD0tYdjHaWlrgoA5QRkg/N0ctuidepIbbVsU+bXsC9qA6gYlea4GTNv/lcxR4aabMV4fvoqdRo5P9RQx9wo5QCWlW7n3ZsZEbZPrvgyog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0t2iRq4A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0t2iRq4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FB51F00A3D;
	Fri,  4 Sep 2026 05:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499808;
	bh=04dzSS+ZWBhiFmpzi2yiF7FJ8JWCqzv7gLNwTg8HgLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0t2iRq4Ay8JnqF23mUDNbnCz1fqf3SBiK7skZRvsrBoIPDqppdZLj5b9vaGnvVPYh
	 vDCejNRKvCgrn9jrOa5nquqPTvuU3ZvIR6N5Lc5YuKY+gJqRGjzYCo2AQgfsiTZFUc
	 ELYkf9k9em0P5Uz9YD7H9QtrTle6jVKEY+IiVlys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Peiyang He <peiyang_he@smail.nju.edu.cn>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.2 549/713] iommufd: Fix UAF in selftest IOPF reporting
Date: Fri,  4 Sep 2026 06:58:37 +0200
Message-ID: <20260904045816.125545227@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peiyang He <peiyang_he@smail.nju.edu.cn>

commit 8c07df7cdfcf52f1ff276c588612aabc6c6b8399 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/selftest.c |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -177,6 +177,7 @@ struct mock_dev {
 	struct device dev;
 	struct mock_viommu *viommu;
 	struct rw_semaphore viommu_rwsem;
+	struct rw_semaphore iopf_rwsem;
 	unsigned long flags;
 	unsigned long vdev_id;
 	int id;
@@ -997,6 +998,7 @@ static struct mock_dev *mock_dev_create(
 		return ERR_PTR(-ENOMEM);
 
 	init_rwsem(&mdev->viommu_rwsem);
+	init_rwsem(&mdev->iopf_rwsem);
 	device_initialize(&mdev->dev);
 	mdev->flags = dev_flags;
 	mdev->dev.release = mock_dev_release;
@@ -1022,7 +1024,9 @@ static struct mock_dev *mock_dev_create(
 		goto err_put;
 	}
 
+	down_write(&mdev->iopf_rwsem);
 	rc = iommu_mock_device_add(&mdev->dev, &mock_iommu.iommu_dev);
+	up_write(&mdev->iopf_rwsem);
 	if (rc)
 		goto err_put;
 	return mdev;
@@ -1077,7 +1081,9 @@ static int iommufd_test_mock_domain(stru
 	}
 	sobj->idev.idev = idev;
 
+	down_write(&sobj->idev.mock_dev->iopf_rwsem);
 	rc = iommufd_device_attach(idev, IOMMU_NO_PASID, &pt_id);
+	up_write(&sobj->idev.mock_dev->iopf_rwsem);
 	if (rc)
 		goto out_unbind;
 
@@ -1092,7 +1098,9 @@ static int iommufd_test_mock_domain(stru
 	return 0;
 
 out_detach:
+	down_write(&sobj->idev.mock_dev->iopf_rwsem);
 	iommufd_device_detach(idev, IOMMU_NO_PASID);
+	up_write(&sobj->idev.mock_dev->iopf_rwsem);
 out_unbind:
 	iommufd_device_unbind(idev);
 out_mdev:
@@ -1136,7 +1144,9 @@ static int iommufd_test_mock_domain_repl
 	if (IS_ERR(sobj))
 		return PTR_ERR(sobj);
 
+	down_write(&sobj->idev.mock_dev->iopf_rwsem);
 	rc = iommufd_device_replace(sobj->idev.idev, IOMMU_NO_PASID, &pt_id);
+	up_write(&sobj->idev.mock_dev->iopf_rwsem);
 	if (rc)
 		goto out_sobj;
 
@@ -1739,10 +1749,16 @@ static int iommufd_test_trigger_iopf(str
 {
 	struct iopf_fault event = {};
 	struct iommufd_device *idev;
+	struct mock_dev *mdev;
 
 	idev = iommufd_get_device(ucmd, cmd->trigger_iopf.dev_id);
 	if (IS_ERR(idev))
 		return PTR_ERR(idev);
+	if (!iommufd_selftest_is_mock_dev(idev->dev)) {
+		iommufd_put_object(ucmd->ictx, &idev->obj);
+		return -EINVAL;
+	}
+	mdev = to_mock_dev(idev->dev);
 
 	event.fault.prm.flags = IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE;
 	if (cmd->trigger_iopf.pasid != IOMMU_NO_PASID)
@@ -1753,7 +1769,9 @@ static int iommufd_test_trigger_iopf(str
 	event.fault.prm.grpid = cmd->trigger_iopf.grpid;
 	event.fault.prm.perm = cmd->trigger_iopf.perm;
 
+	down_read(&mdev->iopf_rwsem);
 	iommu_report_device_fault(idev->dev, &event);
+	up_read(&mdev->iopf_rwsem);
 	iommufd_put_object(ucmd->ictx, &idev->obj);
 
 	return 0;
@@ -1861,14 +1879,19 @@ static int iommufd_test_pasid_attach(str
 	if (IS_ERR(sobj))
 		return PTR_ERR(sobj);
 
+	down_write(&sobj->idev.mock_dev->iopf_rwsem);
 	rc = iommufd_device_attach(sobj->idev.idev, cmd->pasid_attach.pasid,
 				   &cmd->pasid_attach.pt_id);
+	up_write(&sobj->idev.mock_dev->iopf_rwsem);
 	if (rc)
 		goto out_sobj;
 
 	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
-	if (rc)
+	if (rc) {
+		down_write(&sobj->idev.mock_dev->iopf_rwsem);
 		iommufd_device_detach(sobj->idev.idev, cmd->pasid_attach.pasid);
+		up_write(&sobj->idev.mock_dev->iopf_rwsem);
+	}
 
 out_sobj:
 	iommufd_put_object(ucmd->ictx, &sobj->obj);
@@ -1885,8 +1908,10 @@ static int iommufd_test_pasid_replace(st
 	if (IS_ERR(sobj))
 		return PTR_ERR(sobj);
 
+	down_write(&sobj->idev.mock_dev->iopf_rwsem);
 	rc = iommufd_device_replace(sobj->idev.idev, cmd->pasid_attach.pasid,
 				    &cmd->pasid_attach.pt_id);
+	up_write(&sobj->idev.mock_dev->iopf_rwsem);
 	if (rc)
 		goto out_sobj;
 
@@ -1906,7 +1931,9 @@ static int iommufd_test_pasid_detach(str
 	if (IS_ERR(sobj))
 		return PTR_ERR(sobj);
 
+	down_write(&sobj->idev.mock_dev->iopf_rwsem);
 	iommufd_device_detach(sobj->idev.idev, cmd->pasid_detach.pasid);
+	up_write(&sobj->idev.mock_dev->iopf_rwsem);
 	iommufd_put_object(ucmd->ictx, &sobj->obj);
 	return 0;
 }
@@ -1917,7 +1944,9 @@ void iommufd_selftest_destroy(struct iom
 
 	switch (sobj->type) {
 	case TYPE_IDEV:
+		down_write(&sobj->idev.mock_dev->iopf_rwsem);
 		iommufd_device_detach(sobj->idev.idev, IOMMU_NO_PASID);
+		up_write(&sobj->idev.mock_dev->iopf_rwsem);
 		iommufd_device_unbind(sobj->idev.idev);
 		mock_dev_destroy(sobj->idev.mock_dev);
 		break;


