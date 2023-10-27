Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A8839857
	for <patches@lists.linux.dev>; Fri, 27 Oct 2023 17:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nZtYAg9b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426103; x=1729962103;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aMCoAudS/OSl3PQsYt3+4hHw4XTo4wOWeFRNgKX6Zxk=;
  b=nZtYAg9buTj4dpZvG1xGuOiqXA3xIuzJEAAPHaU2mCCSRh3TJBVfg8Qm
   0B2B7MvI5Gxh8lm+uo/QNyJ8FnQgCIneN6OFkZfUx653LRm7lgJMrd2L7
   NBwcsMLrsKoCyGnAqEUo58MeK6pIEaxf24T0WabcLKC5Q1j14fTBIWMxd
   WP/s0mtXqHcCpOGBslGAKw8qZpL4Pyu2XHnQQWMBkeaspv1sWORqKjndY
   Gb1U1Tlx4wAQGqYDiQpj5yORIZMlHVp246asoHmLgSFQz1wVrrJcfSqJs
   oQpixnOvJTzI6oCHiUXFt2GHcie6JA5PXoi+3vNar1S/oD9X71igyo1Dl
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="612114"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="612114"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988230"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988230"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:20 -0700
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
Subject: [RFC PATCH V3 22/26] vfio/pci: Introduce backend specific context initializer
Date: Fri, 27 Oct 2023 10:00:54 -0700
Message-Id: <6b3f44ab66c4408b0b7d277b40ed6edac9e83708.1698422237.git.reinette.chatre@intel.com>
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

The per-interrupt context may contain backend specific data.

Call a backend provided initializer on per-interrupt context
creation.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC V2:
- New patch

 drivers/vfio/pci/vfio_pci_intrs.c | 8 ++++++++
 include/linux/vfio_pci_core.h     | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 1e6376b048de..8c86f2d6229f 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -73,6 +73,14 @@ vfio_irq_ctx_alloc(struct vfio_pci_intr_ctx *intr_ctx, unsigned long index)
 	if (!ctx)
 		return NULL;
 
+	if (intr_ctx->ops->init_irq_ctx) {
+		ret = intr_ctx->ops->init_irq_ctx(intr_ctx, ctx);
+		if (ret < 0) {
+			kfree(ctx);
+			return NULL;
+		}
+	}
+
 	ret = xa_insert(&intr_ctx->ctx, index, ctx, GFP_KERNEL_ACCOUNT);
 	if (ret) {
 		kfree(ctx);
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index f0951084a26f..d5140a732741 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -106,6 +106,8 @@ struct vfio_pci_intr_ops {
 				   unsigned int vector);
 	char *(*msi_device_name)(struct vfio_pci_intr_ctx *intr_ctx,
 				 unsigned int vector, unsigned int index);
+	int (*init_irq_ctx)(struct vfio_pci_intr_ctx *intr_ctx,
+			    struct vfio_pci_irq_ctx *ctx);
 };
 
 struct vfio_pci_core_device {
-- 
2.34.1

