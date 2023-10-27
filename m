Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF2F39854
	for <patches@lists.linux.dev>; Fri, 27 Oct 2023 17:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RM5Mc0QA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426098; x=1729962098;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4LhbS49tlQOs/14GbzRw202WRPZQBhJkwr2CrMC/ZaY=;
  b=RM5Mc0QAOp075tqgTczu5LHwl4DmnwgWWS1Ed8SX2f+zask8LlPhoW0x
   THApy016XZ+G8pj8pWSoEhzFkVc8+JzG/6dfX49RfOnNDL+Q72jMGJKRS
   tWopdlIvVSUu9DLUNM/wLUP45A2JISdMWl+L+uMe613QpzVbFjvC5Q9Ge
   nytHzL6sUKXyfrblCipxB1AQZ2SjmxqqMRYAirzV1mwcBO+0df7PFD6p3
   ZYFej/Bgwv0bESLULVa/LaJGT1GXPO5gVbHQqkoaOwcuHxF9Hm35i3H16
   Fc9VdU+uOlpzbD+bUkb8JRh0XtPozSzv59Ej5ZFGJbChc/AKF9QEpKigz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="612004"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="612004"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988208"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988208"
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
Subject: [RFC PATCH V3 16/26] vfio/pci: Split interrupt context initialization
Date: Fri, 27 Oct 2023 10:00:48 -0700
Message-Id: <1f65808ba9e7c54c5ea1590dadfeb1e10ac5c276.1698422237.git.reinette.chatre@intel.com>
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
No changes since RFC V2.

 drivers/vfio/pci/vfio_pci_intrs.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index adad93c31ac6..14131d5288e3 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -801,6 +801,18 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_intr_ctx *intr_ctx,
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
 static struct vfio_pci_intr_ops vfio_pci_intr_ops = {
 	.set_intx_mask = vfio_pci_set_intx_mask,
 	.set_intx_unmask = vfio_pci_set_intx_unmask,
@@ -814,17 +826,15 @@ static struct vfio_pci_intr_ops vfio_pci_intr_ops = {
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

