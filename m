Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A417286A3
	for <patches@lists.linux.dev>; Fri,  6 Oct 2023 16:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NtlD75r6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696610501; x=1728146501;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m7lg4ugaNhVT8RBGTE4Cyh9T0xB/RfOce2ILlwe3gFk=;
  b=NtlD75r688khuS3jfzsYjjIqByD+/5pS7NY4tOQJLKf12QwVGNgnGrUK
   yl4lv799l1B2DzxdsrddF2jGgSWkVJ94LlJdQlmDIAwVqefKWMLfKPAL4
   0SAGLJwBbYbrfgbmY6MhODQr8jXmswiFkf2Flh6ZBRBmuDC9yFA8vD8Ak
   rMq9dAtz2JKemSGFwcSIHL2tyBVKD3aknNkg2bo7euaqDug/HbNRRvTo9
   k4IOgLS8SfBsUThItY8gLAIm7u/+/G205yyo7/XLfTeJvtAMuZBzw1oPY
   jEOnqOOXSmgJauazCoZsv1E04cUN5Qd/lmvH4dD6tZpH+Jl3ZCCK59TZD
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="364063210"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="364063210"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="842892871"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="842892871"
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
Subject: [RFC PATCH V2 11/18] vfio/pci: Split interrupt context initialization
Date: Fri,  6 Oct 2023 09:41:06 -0700
Message-Id: <e43c64a0862960422b4e768a0336886276c7c137.1696609476.git.reinette.chatre@intel.com>
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

struct vfio_pci_intr_ctx is the context associated with interrupts
of a virtual device. The interrupt context is initialized with
backend specific data required by the particular interrupt management
backend as well as common initialization required by all interrupt
management backends.

Split interrupt context initialization into common and interrupt
management backend specific calls. The entrypoint will be the
initialization of a particular interrupt management backend which
in turn calls the common initialization.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index eb718787470f..8c9d44e99e7b 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -793,6 +793,18 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 					       count, flags, data);
 }
 
+static void _vfio_pci_init_intr_ctx(struct vfio_pci_intr_ctx *intr_ctx)
+{
+	intr_ctx->irq_type = VFIO_PCI_NUM_IRQS;
+	mutex_init(&intr_ctx->igate);
+	xa_init(&intr_ctx->ctx);
+}
+
+static void _vfio_pci_release_intr_ctx(struct vfio_pci_intr_ctx *intr_ctx)
+{
+	mutex_destroy(&intr_ctx->igate);
+}
+
 struct vfio_pci_intr_ops vfio_pci_intr_ops = {
 	.set_intx_mask = vfio_pci_set_intx_mask,
 	.set_intx_unmask = vfio_pci_set_intx_unmask,
@@ -806,17 +818,15 @@ struct vfio_pci_intr_ops vfio_pci_intr_ops = {
 void vfio_pci_init_intr_ctx(struct vfio_pci_core_device *vdev,
 			    struct vfio_pci_intr_ctx *intr_ctx)
 {
-	intr_ctx->irq_type = VFIO_PCI_NUM_IRQS;
+	_vfio_pci_init_intr_ctx(intr_ctx);
 	intr_ctx->ops = &vfio_pci_intr_ops;
 	intr_ctx->priv = vdev;
-	mutex_init(&intr_ctx->igate);
-	xa_init(&intr_ctx->ctx);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_init_intr_ctx);
 
 void vfio_pci_release_intr_ctx(struct vfio_pci_intr_ctx *intr_ctx)
 {
-	mutex_destroy(&intr_ctx->igate);
+	_vfio_pci_release_intr_ctx(intr_ctx);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_release_intr_ctx);
 
-- 
2.34.1

