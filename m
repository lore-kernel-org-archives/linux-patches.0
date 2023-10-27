Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DC539855
	for <patches@lists.linux.dev>; Fri, 27 Oct 2023 17:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IbIKRCBE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426101; x=1729962101;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jAVKFX+vaV6MZ7MbRQwvQO7Qe37BB/mxkHKB6ZjkpCk=;
  b=IbIKRCBExLYySfYZEW56VViAlRpdOhVOMCPMLh+J7wFBnigYwrmeQlMF
   1EkAlBoNEZMQHxoF1wPwYG4NAsuuum91nfiE0kNV4emajTwxfiTLPBPRo
   OLFxWIB5O62C2FBXvm6i6CGezaFBWluihMqgVGa4b9GwNqJJUmV9IjKnV
   JacVijRfn53PqcRWvKkYFST9QyI+qENg/G4+goOSO0c/9ij7Y6E7wJ2t9
   fFV82qno0LIydA1z/U2A4R0euZ/xAarFv+QU5TWhN2EofI5w4XKosN+IE
   NrcTzJS/zmpTTS2R+LXztGPwZBkvlpqMWCnkkAbAVKTsBGdK0KvdhwkLm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="612085"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="612085"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988220"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988220"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:19 -0700
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
Subject: [RFC PATCH V3 19/26] vfio/pci: Store Linux IRQ number in per-interrupt context
Date: Fri, 27 Oct 2023 10:00:51 -0700
Message-Id: <fe821ea81644a358e664438e8a4af5adbac02b84.1698422237.git.reinette.chatre@intel.com>
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

The Linux IRQ number is a property shared among all interrupt
backends but not all interrupt management backends have a simple
query for it. pci_irq_vector() can be used to obtain the Linux
IRQ number of a MSI-X interrupt but there is no such
query for IMS interrupts.

The Linux IRQ number is needed during interrupt free as well
as during register of IRQ bypass producer. It is unnecessary to
query the Linux IRQ number at each stage, the number can be
stored at the time the interrupt is allocated and obtained
from its per-interrupt context when needed.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC V2:
- New patch

 drivers/vfio/pci/vfio_pci_intrs.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 8d84e7d62594..fd0713dc9f81 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -29,6 +29,7 @@ struct vfio_pci_irq_ctx {
 	char			*name;
 	bool			masked;
 	struct irq_bypass_producer	producer;
+	int			virq;
 };
 
 static bool irq_is(struct vfio_pci_intr_ctx *intr_ctx, int type)
@@ -431,10 +432,11 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_intr_ctx *intr_ctx,
 
 	if (ctx && ctx->trigger) {
 		irq_bypass_unregister_producer(&ctx->producer);
-		irq = pci_irq_vector(pdev, vector);
+		irq = ctx->virq;
 		cmd = vfio_pci_memory_lock_and_enable(vdev);
-		free_irq(irq, ctx->trigger);
+		free_irq(ctx->virq, ctx->trigger);
 		vfio_pci_memory_unlock_and_restore(vdev, cmd);
+		ctx->virq = 0;
 		/* Interrupt stays allocated, will be freed at MSI-X disable. */
 		kfree(ctx->name);
 		ctx->name = NULL;
@@ -488,8 +490,10 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_intr_ctx *intr_ctx,
 	if (ret)
 		goto out_put_eventfd_ctx;
 
+	ctx->virq = irq;
+
 	ctx->producer.token = trigger;
-	ctx->producer.irq = irq;
+	ctx->producer.irq = ctx->virq;
 	ret = irq_bypass_register_producer(&ctx->producer);
 	if (unlikely(ret)) {
 		dev_info(&pdev->dev,
-- 
2.34.1

