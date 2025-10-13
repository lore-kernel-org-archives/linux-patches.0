Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6A530E0C2;
	Mon, 13 Oct 2025 15:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370112; cv=none; b=eu8LaCfoW5aV0qWtA4deySVeBJt9YXMAkIus1Kx4UTNQCLxd9CglLBXOwlltdpdFaUhOJw/uKMiieG2m+ETpGUbIpZflTIAdXzVBujKsyXdnCQ23S3+h9WtfBvTmI2LHWTLD1LOz+1OWV2CqYy/YQjV9u1hPg08shiVjvQtWRb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370112; c=relaxed/simple;
	bh=+TGd5Eb2Te0pkfCVyKg934zBVRbDAsmUpacbzcuo/nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ice1lDzVhDd5gB68e6Ydsp4zohnU7pCHX+ynGn0KP33CXjfW2bRiBUkYsyGbNOgvgfW0Q8Dj8ejlRcfdBzWyUSnkafRDeG0edyRGS1G2XtTzoKQbxMkvIJgnmAYYeJ3NzVjob896G0CJdrXcSNyoDd8+UtBjGZ14zAcfGGEQYb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MM8sNpXu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MM8sNpXu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752A5C4CEE7;
	Mon, 13 Oct 2025 15:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370111;
	bh=+TGd5Eb2Te0pkfCVyKg934zBVRbDAsmUpacbzcuo/nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MM8sNpXu5fp8SwfZiP1BoWPBKoLsHpoojTqIv3/3yD6h9Vzh7vhhCjtMnChIm/Keb
	 ClFJD6unPKKUYbpKGgwN4FKaAAlmtzi8xP/bM415LpLp6JDfvHU+ks28sqxru/SNVQ
	 awyL/JDNF206lRbfd6cWVw3n2IAA0TDNwhkiworc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Qinyun Tan <qinyuntan@linux.alibaba.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 481/563] iommufd: Register iommufd mock devices with fwspec
Date: Mon, 13 Oct 2025 16:45:42 +0200
Message-ID: <20251013144428.717213130@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 2a918911ed3d0841923525ed0fe707762ee78844 ]

Since the bus ops were retired the iommu subsystem changed to using fwspec
to match the iommu driver to the iommu device. If a device has a NULL
fwspec then it is matched to the first iommu driver with a NULL fwspec,
effectively disabling support for systems with more than one non-fwspec
iommu driver.

Thus, if the iommufd selfest are run in an x86 system that registers a
non-fwspec iommu driver they fail to bind their mock devices to the mock
iommu driver.

Fix this by allocating a software fwnode for mock iommu driver's
iommu_device, and set it to the device which mock iommu driver created.

This is done by adding a new helper iommu_mock_device_add() which abuses
the internals of the fwspec system to establish a fwspec before the device
is added and is careful not to leak it. A matching dummy fwspec is
automatically added to the mock iommu driver.

Test by "make -C toosl/testing/selftests TARGETS=iommu run_tests":
PASSED: 229 / 229 tests passed.

In addition, this issue is also can be found on amd platform, and
also tested on a amd machine.

Link: https://patch.msgid.link/r/20250925054730.3877-1-kanie@linux.alibaba.com
Fixes: 17de3f5fdd35 ("iommu: Retire bus ops")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Tested-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu-priv.h       |  2 ++
 drivers/iommu/iommu.c            | 26 ++++++++++++++++++++++++++
 drivers/iommu/iommufd/selftest.c |  2 +-
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu-priv.h b/drivers/iommu/iommu-priv.h
index e236b932e7668..c95394cd03a77 100644
--- a/drivers/iommu/iommu-priv.h
+++ b/drivers/iommu/iommu-priv.h
@@ -37,6 +37,8 @@ void iommu_device_unregister_bus(struct iommu_device *iommu,
 				 const struct bus_type *bus,
 				 struct notifier_block *nb);
 
+int iommu_mock_device_add(struct device *dev, struct iommu_device *iommu);
+
 struct iommu_attach_handle *iommu_attach_handle_get(struct iommu_group *group,
 						    ioasid_t pasid,
 						    unsigned int type);
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 060ebe330ee16..59244c744eabd 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -304,6 +304,7 @@ void iommu_device_unregister_bus(struct iommu_device *iommu,
 				 struct notifier_block *nb)
 {
 	bus_unregister_notifier(bus, nb);
+	fwnode_remove_software_node(iommu->fwnode);
 	iommu_device_unregister(iommu);
 }
 EXPORT_SYMBOL_GPL(iommu_device_unregister_bus);
@@ -326,6 +327,12 @@ int iommu_device_register_bus(struct iommu_device *iommu,
 	if (err)
 		return err;
 
+	iommu->fwnode = fwnode_create_software_node(NULL, NULL);
+	if (IS_ERR(iommu->fwnode)) {
+		bus_unregister_notifier(bus, nb);
+		return PTR_ERR(iommu->fwnode);
+	}
+
 	spin_lock(&iommu_device_lock);
 	list_add_tail(&iommu->list, &iommu_device_list);
 	spin_unlock(&iommu_device_lock);
@@ -335,9 +342,28 @@ int iommu_device_register_bus(struct iommu_device *iommu,
 		iommu_device_unregister_bus(iommu, bus, nb);
 		return err;
 	}
+	WRITE_ONCE(iommu->ready, true);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iommu_device_register_bus);
+
+int iommu_mock_device_add(struct device *dev, struct iommu_device *iommu)
+{
+	int rc;
+
+	mutex_lock(&iommu_probe_device_lock);
+	rc = iommu_fwspec_init(dev, iommu->fwnode);
+	mutex_unlock(&iommu_probe_device_lock);
+
+	if (rc)
+		return rc;
+
+	rc = device_add(dev);
+	if (rc)
+		iommu_fwspec_free(dev);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(iommu_mock_device_add);
 #endif
 
 static struct dev_iommu *dev_iommu_get(struct device *dev)
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 61686603c7693..de178827a078a 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -1126,7 +1126,7 @@ static struct mock_dev *mock_dev_create(unsigned long dev_flags)
 		goto err_put;
 	}
 
-	rc = device_add(&mdev->dev);
+	rc = iommu_mock_device_add(&mdev->dev, &mock_iommu.iommu_dev);
 	if (rc)
 		goto err_put;
 	return mdev;
-- 
2.51.0



