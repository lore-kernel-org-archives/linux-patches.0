Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F49A42378D;
	Thu, 16 Jul 2026 14:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210790; cv=none; b=FnyUUT2qU5RUCfFTCLoMJ3Ly7Ioh1XL51qa1WxxIMMH+FyN6yjdH4ndd+Elgy+MiyaeBU1JpRnZC6F6CLkNbJNXz1GWsg51dtEQP/qf97ihbxRmTvwlMFD1qDWze7qA+vTmFlJexwNmQehPOzLrBTiEQQ8xP4sIyOPuYaJ0Xe8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210790; c=relaxed/simple;
	bh=xFygzBQUBN2J01Z/I1DJ/Pe88DFbzql1bjkkPzsLojU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCGGHUuspFxcU2apSxMWY6oBy2/snHIisDldbPIiZnxwjf0PUlnnCoDZ3woqeem8SHzoW0RXSytAZ7Moyax2fLrlzk7YjhxCVyPOZj2i0SNuq9qimkoUeMoUE8br1imUmCTID2e+3EkqnsLELxtFE0Mp/AaXWb0ytU2lZtxIP9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qbeJfKKF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qbeJfKKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CDD1F000E9;
	Thu, 16 Jul 2026 14:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210789;
	bh=W/9QuYrh4zrkHCpPvDTQWIzbSWlG9ZyOHTUBBtQcfyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qbeJfKKFjnMp/dy8ZvHs7Cm1bu//vJhKwC8W7z149Frla2oHukFwhysHD7O1u9fuK
	 2Ai5RVJMceLR68hXChMUw7sozTzHveJJo5ktOWJKwzXAagsrwS2rp9t5n5osM4yQyd
	 o60mDvn/hQOpT9c80858zfaD7pyDmO+9RXJmibyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 6.18 179/480] NTB: epf: Avoid calling pci_irq_vector() from hardirq context
Date: Thu, 16 Jul 2026 15:28:46 +0200
Message-ID: <20260716133048.591089681@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

commit 4dcddc1c794d1c65eda68f1f8dd04a0fecc0870f upstream.

ntb_epf_vec_isr() calls pci_irq_vector() in hardirq context to derive
the vector number. pci_irq_vector() calls msi_get_virq() that takes a
mutex and can therefore trigger "scheduling while atomic" splats:

  BUG: scheduling while atomic: kworker/u33:0/55/0x00010001
  ...
  Call trace:
   ...
   schedule+0x38/0x110
   schedule_preempt_disabled+0x28/0x50
   __mutex_lock.constprop.0+0x848/0x908
   __mutex_lock_slowpath+0x18/0x30
   mutex_lock+0x4c/0x60
   msi_domain_get_virq+0xe8/0x138
   pci_irq_vector+0x2c/0x60
   ntb_epf_vec_isr+0x28/0x120 [ntb_hw_epf]
   __handle_irq_event_percpu+0x70/0x3a8
   handle_irq_event+0x48/0x100
   handle_edge_irq+0x100/0x1c8
   ...

Cache the Linux IRQ number for vector 0 when vectors are allocated and
use it as a base in the ISR. Running the ISR in a threaded IRQ handler
would also avoid the problem, but that would be unnecessary here.

Fixes: 812ce2f8d14e ("NTB: Add support for EPF PCI Non-Transparent Bridge")
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Cc: stable@vger.kernel.org # v5.12+
Link: https://patch.msgid.link/20260304083028.1391068-3-den@valinux.co.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ntb/hw/epf/ntb_hw_epf.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/ntb/hw/epf/ntb_hw_epf.c
+++ b/drivers/ntb/hw/epf/ntb_hw_epf.c
@@ -92,6 +92,7 @@ struct ntb_epf_dev {
 
 	int db_val;
 	u64 db_valid_mask;
+	int irq_base;
 };
 
 #define ntb_ndev(__ntb) container_of(__ntb, struct ntb_epf_dev, ntb)
@@ -318,7 +319,7 @@ static irqreturn_t ntb_epf_vec_isr(int i
 	struct ntb_epf_dev *ndev = dev;
 	int irq_no;
 
-	irq_no = irq - pci_irq_vector(ndev->ntb.pdev, 0);
+	irq_no = irq - ndev->irq_base;
 	ndev->db_val = irq_no + 1;
 
 	if (irq_no == 0)
@@ -350,6 +351,7 @@ static int ntb_epf_init_isr(struct ntb_e
 		argument &= ~MSIX_ENABLE;
 	}
 
+	ndev->irq_base = pci_irq_vector(pdev, 0);
 	for (i = 0; i < irq; i++) {
 		ret = request_irq(pci_irq_vector(pdev, i), ntb_epf_vec_isr,
 				  0, "ntb_epf", ndev);


