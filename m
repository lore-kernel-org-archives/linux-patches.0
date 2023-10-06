Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD0228DBC
	for <patches@lists.linux.dev>; Fri,  6 Oct 2023 16:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kIRMSPtL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696610502; x=1728146502;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=P/uKNjSzEvnfr6wJTd3jHZzNTA5QOBXyphL09w2vknw=;
  b=kIRMSPtL3rt6qpcQwQI1tOktgl+BZZR8+JApChcLuyNycJcuOlEhsLTp
   mK7vulaUqhzrffAM/jP9XYBYJnilrjCxEpqdC6Y8uWns3Qs96zj7pK5lC
   cw2ZG/X0XppJudKtFx9MTsX6VGqKZLCPuhQcMTNI4GxiIhGi53YkRvibA
   eUb1R+O9NRj6Eu+ek4fQr6ff6amwZ0E3OSkNfzKqb7NepyCwd66ka+XaL
   z9hByU9n/s8qpV1vfe7JmwoO4Y5CMa9Quk71CFL63wYEZbAC9fj0uJUg+
   TLOLth0v+b/DRYI4FXVHaE4w+qjDryAok4UtyDkgWuWZ6PWaZ7+ei5Cra
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="364063222"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="364063222"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="842892878"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="842892878"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:26 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: jgg@nvidia.com,
	yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com,
	alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	dave.jiang@intel.com,
	jing2.liu@intel.com,
	ashok.raj@intel.com,
	fenghua.yu@intel.com,
	tom.zanussi@linux.intel.com,
	reinette.chatre@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [RFC PATCH V2 13/18] vfio/pci: Make vfio_pci_set_irqs_ioctl() available
Date: Fri,  6 Oct 2023 09:41:08 -0700
Message-Id: <adacc171a76b091a0e7404a600bd04dc4bb20c0b.1696609476.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1696609476.git.reinette.chatre@intel.com>
References: <cover.1696609476.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

vfio_pci_set_irqs_ioctl() is now a generic entrypoint that can
be configured to support different interrupt management backend.
Not limited to PCI devices it can be exported for use by
other virtual device drivers.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 1 +
 include/linux/vfio_pci_core.h     | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 0a741159368c..d04a4477c201 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -909,3 +909,4 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 	mutex_unlock(&intr_ctx->igate);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_set_irqs_ioctl);
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 893a36b5d163..1dd55d98dce9 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -158,6 +158,9 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 void vfio_pci_init_intr_ctx(struct vfio_pci_core_device *vdev,
 			    struct vfio_pci_intr_ctx *intr_ctx);
 void vfio_pci_release_intr_ctx(struct vfio_pci_intr_ctx *intr_ctx);
+int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
+			    unsigned int index, unsigned int start,
+			    unsigned int count, void *data);
 int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 				void __user *arg, size_t argsz);
 ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
-- 
2.34.1

