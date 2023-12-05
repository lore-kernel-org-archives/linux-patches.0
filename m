Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3496E6AA0;
	Tue,  5 Dec 2023 03:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a46isaff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09B5C433C8;
	Tue,  5 Dec 2023 03:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746511;
	bh=IOn5S2+esgj68eUzP5LohglH1XXeeTosEfzfs1686Go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a46isaffNnpPsU4dPia0UptIG8Cv96o13R5/9S78NAF4x9cBoGBs9LxAL1+szMSns
	 j2DKg0eF7V6xA9OxEcOitzCend9KzPz+pnTMEjb4vBMvMqi4LVnsK/1Ml+uZ7DgO2S
	 YwQpWgSoFmnJ4R/em+lrMh/YJGxbQBvxNHNndUfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenhua Huang <quic_zhenhuah@quicinc.com>,
	Robin Murphy <robin.murphy@arm.com>,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.6 050/134] iommu: Avoid more races around device probe
Date: Tue,  5 Dec 2023 12:15:22 +0900
Message-ID: <20231205031538.762433009@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

commit a2e7e59a94269484a83386972ca07c22fd188854 upstream.

It turns out there are more subtle races beyond just the main part of
__iommu_probe_device() itself running in parallel - the dev_iommu_free()
on the way out of an unsuccessful probe can still manage to trip up
concurrent accesses to a device's fwspec. Thus, extend the scope of
iommu_probe_device_lock() to also serialise fwspec creation and initial
retrieval.

Reported-by: Zhenhua Huang <quic_zhenhuah@quicinc.com>
Link: https://lore.kernel.org/linux-iommu/e2e20e1c-6450-4ac5-9804-b0000acdf7de@quicinc.com/
Fixes: 01657bc14a39 ("iommu: Avoid races around device probe")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: André Draszik <andre.draszik@linaro.org>
Tested-by: André Draszik <andre.draszik@linaro.org>
Link: https://lore.kernel.org/r/16f433658661d7cadfea51e7c65da95826112a2b.1700071477.git.robin.murphy@arm.com
Cc: stable@vger.kernel.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/scan.c      |    7 ++++++-
 drivers/iommu/iommu.c    |   20 ++++++++++----------
 drivers/iommu/of_iommu.c |   12 +++++++++---
 include/linux/iommu.h    |    1 +
 4 files changed, 26 insertions(+), 14 deletions(-)

--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1568,17 +1568,22 @@ static const struct iommu_ops *acpi_iomm
 	int err;
 	const struct iommu_ops *ops;
 
+	/* Serialise to make dev->iommu stable under our potential fwspec */
+	mutex_lock(&iommu_probe_device_lock);
 	/*
 	 * If we already translated the fwspec there is nothing left to do,
 	 * return the iommu_ops.
 	 */
 	ops = acpi_iommu_fwspec_ops(dev);
-	if (ops)
+	if (ops) {
+		mutex_unlock(&iommu_probe_device_lock);
 		return ops;
+	}
 
 	err = iort_iommu_configure_id(dev, id_in);
 	if (err && err != -EPROBE_DEFER)
 		err = viot_iommu_configure(dev);
+	mutex_unlock(&iommu_probe_device_lock);
 
 	/*
 	 * If we have reason to believe the IOMMU driver missed the initial
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -479,11 +479,12 @@ static void iommu_deinit_device(struct d
 	dev_iommu_free(dev);
 }
 
+DEFINE_MUTEX(iommu_probe_device_lock);
+
 static int __iommu_probe_device(struct device *dev, struct list_head *group_list)
 {
 	const struct iommu_ops *ops = dev->bus->iommu_ops;
 	struct iommu_group *group;
-	static DEFINE_MUTEX(iommu_probe_device_lock);
 	struct group_device *gdev;
 	int ret;
 
@@ -496,17 +497,15 @@ static int __iommu_probe_device(struct d
 	 * probably be able to use device_lock() here to minimise the scope,
 	 * but for now enforcing a simple global ordering is fine.
 	 */
-	mutex_lock(&iommu_probe_device_lock);
+	lockdep_assert_held(&iommu_probe_device_lock);
 
 	/* Device is probed already if in a group */
-	if (dev->iommu_group) {
-		ret = 0;
-		goto out_unlock;
-	}
+	if (dev->iommu_group)
+		return 0;
 
 	ret = iommu_init_device(dev, ops);
 	if (ret)
-		goto out_unlock;
+		return ret;
 
 	group = dev->iommu_group;
 	gdev = iommu_group_alloc_device(group, dev);
@@ -542,7 +541,6 @@ static int __iommu_probe_device(struct d
 			list_add_tail(&group->entry, group_list);
 	}
 	mutex_unlock(&group->mutex);
-	mutex_unlock(&iommu_probe_device_lock);
 
 	if (dev_is_pci(dev))
 		iommu_dma_set_pci_32bit_workaround(dev);
@@ -556,8 +554,6 @@ err_put_group:
 	iommu_deinit_device(dev);
 	mutex_unlock(&group->mutex);
 	iommu_group_put(group);
-out_unlock:
-	mutex_unlock(&iommu_probe_device_lock);
 
 	return ret;
 }
@@ -567,7 +563,9 @@ int iommu_probe_device(struct device *de
 	const struct iommu_ops *ops;
 	int ret;
 
+	mutex_lock(&iommu_probe_device_lock);
 	ret = __iommu_probe_device(dev, NULL);
+	mutex_unlock(&iommu_probe_device_lock);
 	if (ret)
 		return ret;
 
@@ -1783,7 +1781,9 @@ static int probe_iommu_group(struct devi
 	struct list_head *group_list = data;
 	int ret;
 
+	mutex_lock(&iommu_probe_device_lock);
 	ret = __iommu_probe_device(dev, group_list);
+	mutex_unlock(&iommu_probe_device_lock);
 	if (ret == -ENODEV)
 		ret = 0;
 
--- a/drivers/iommu/of_iommu.c
+++ b/drivers/iommu/of_iommu.c
@@ -112,16 +112,20 @@ const struct iommu_ops *of_iommu_configu
 					   const u32 *id)
 {
 	const struct iommu_ops *ops = NULL;
-	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
+	struct iommu_fwspec *fwspec;
 	int err = NO_IOMMU;
 
 	if (!master_np)
 		return NULL;
 
+	/* Serialise to make dev->iommu stable under our potential fwspec */
+	mutex_lock(&iommu_probe_device_lock);
+	fwspec = dev_iommu_fwspec_get(dev);
 	if (fwspec) {
-		if (fwspec->ops)
+		if (fwspec->ops) {
+			mutex_unlock(&iommu_probe_device_lock);
 			return fwspec->ops;
-
+		}
 		/* In the deferred case, start again from scratch */
 		iommu_fwspec_free(dev);
 	}
@@ -155,6 +159,8 @@ const struct iommu_ops *of_iommu_configu
 		fwspec = dev_iommu_fwspec_get(dev);
 		ops    = fwspec->ops;
 	}
+	mutex_unlock(&iommu_probe_device_lock);
+
 	/*
 	 * If we have reason to believe the IOMMU driver missed the initial
 	 * probe for dev, replay it to get things in order.
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -703,6 +703,7 @@ static inline void dev_iommu_priv_set(st
 	dev->iommu->priv = priv;
 }
 
+extern struct mutex iommu_probe_device_lock;
 int iommu_probe_device(struct device *dev);
 
 int iommu_dev_enable_feature(struct device *dev, enum iommu_dev_features f);


