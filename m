Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAAA39854
	for <patches@lists.linux.dev>; Fri, 27 Oct 2023 17:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XTpQ1vUl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426100; x=1729962100;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TB0MfEQ6zMbspsfmMyNqxCW0CYXal0biIXEhDTEl/2E=;
  b=XTpQ1vUl2ZcFBTSrU3V5P6iE6nxZGX3HKwJ714qW6L+zVGahymgWCH26
   chxAWyxtrenReb/kHsTr4yjeQqWOtakz/a1Mr9R6Eorqb54eL2W0FyKrx
   hvv8OVaRiozCt4KNVdk9ehGrDR+GItxsrbG/m0tkP901bHhTM7Y8Ho9xQ
   OlIAmcfSqgwGTt6rbgOAxxfLOUpVLYCYTsH59PY+g3RzuiAkc12lUrmNX
   UiaIcSiq9uTH0BZu9hsoJ8ZqsifZaNi+eQ15eTvjPk/mPnm1D065c++2P
   H4cbZvRvM15cF3Sqec4UXbpsfWN+LtHTf5bjwnl6Hr3lQB5o4LDYMQyhx
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="612032"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="612032"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988211"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988211"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:18 -0700
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
Subject: [RFC PATCH V3 17/26] vfio/pci: Make vfio_pci_set_irqs_ioctl() available
Date: Fri, 27 Oct 2023 10:00:49 -0700
Message-Id: <1b51730bac31a6f491ef44b722f0bd19da4312dc.1698422237.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1698422237.git.reinette.chatre@intel.com>
References: <cover.1698422237.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

vfio_pci_set_irqs_ioctl() is now a generic entrypoint that can
be configured to support different interrupt management backend.

Export vfio_pci_set_irqs_ioctl() for use by other virtual device
drivers.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC V2:
- Improve changelog.

 drivers/vfio/pci/vfio_pci_intrs.c | 1 +
 include/linux/vfio_pci_core.h     | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 14131d5288e3..80040fde6f6b 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -916,3 +916,4 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 	mutex_unlock(&intr_ctx->igate);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_set_irqs_ioctl);
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index e666c19da223..8d2fb51a2dcc 100644
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

