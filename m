Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182083161AD;
	Thu, 16 Jul 2026 14:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210801; cv=none; b=ExSnvhJElasIAGxVhb89rlOxSIWx8asLC5AsGlg0P9b8IRNxWXTZ71Q0lXwT03VTtu7Ey/WNEdGYaGmMoiMfY5xoyvO2CuUM3wZFyLREb6M++7gQQ+bgcwFKIKD7rJLqmriIE6trYhG0hqqsSuMk0qDmOZmcryYHDl7ZcnSkbp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210801; c=relaxed/simple;
	bh=TmskAFmOGIEjh7Sjfwdz2uZIQtLf0hLlN1x7XYVOzBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghuwJz5eEP1ZXSqBJbmAz0iQ1S04KdxOJnPps5kemyMnpNnHV/aoNoSoMyhZE/arraPxVjD3X0j+Mb17vX+HChjnzD+mrfUdIqeAbllFrYB06QTcAvjengjzpOqn3svaJJXqghAj7fjdWH21YrFwsxXVJeP5+3n4OpIgaikTq/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uG306UNu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uG306UNu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B801F000E9;
	Thu, 16 Jul 2026 14:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210800;
	bh=MesiRal/69p2tz93a1ori1r0qM6lsoYQbObGZ8wS4dI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uG306UNuwKkVZpyoE/bn96EzQYrYB2ux1CoV4Ry0KmNAE4rKVjDCbGhKIQcBf548D
	 3w2jBoymi7R8wngaw6Pf7W2QpuIXrWBgHgDaIK3RRjFnMV32xT03ZmcuQStdeTDTgG
	 bbj7HRXjNAR0L8vpbq7oaCEMQ4Iuoq4JBzp3NHTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yadu M G <yadu.mg@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.18 142/480] PCI: qcom: Initialize DWC MSI lock for firmware-managed ECAM hosts
Date: Thu, 16 Jul 2026 15:28:09 +0200
Message-ID: <20260716133047.784663863@linuxfoundation.org>
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

From: Yadu M G <yadu.mg@oss.qualcomm.com>

commit e0779713a1e2f891aeec53e629dbbd33f423c629 upstream.

A lockdep warning is observed during boot on a Qcom firmware-managed
platform:

  INFO: trying to register non-static key.
  The code is fine but needs lockdep annotation, or maybe
  you didn't initialize this object before use?
  turning off the locking correctness validator.
  ...
  Call trace:
   register_lock_class+0x128/0x4d8
   __lock_acquire+0x110/0x1db0
   lock_acquire+0x278/0x3d8
   _raw_spin_lock_irq+0x6c/0xc0
   dw_pcie_irq_domain_alloc+0x48/0x190
   irq_domain_alloc_irqs_parent+0x2c/0x48
   msi_domain_alloc+0x90/0x160
  ...

dw_pcie_irq_domain_alloc() takes pp->lock while allocating MSI
interrupts. pp->lock is normally initialized by dw_pcie_host_init(), but
Qcom firmware-managed hosts use the ECAM init path instead:

  pci_host_common_ecam_create()
    pci_ecam_create()
      qcom_pcie_ecam_host_init()
        dw_pcie_msi_host_init()
          dw_pcie_allocate_domains()

That path constructs a fresh struct dw_pcie_rp and calls
dw_pcie_msi_host_init() directly, without going through
dw_pcie_host_init(). As a result, pp->lock was not initialized, which
triggers the warning.

Initialize pp->lock in qcom_pcie_ecam_host_init() before registering the
MSI domains so the firmware-managed ECAM path matches the normal DWC host
initialization sequence.

Fixes: 7d944c0f1469 ("PCI: qcom: Add support for Qualcomm SA8255p based PCIe Root Complex")
Signed-off-by: Yadu M G <yadu.mg@oss.qualcomm.com>
[mani: added fixes tag and CCed stable]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Cc: stable@kernel.org
Link: https://patch.msgid.link/20260604122418.727274-1-yadu.mg@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1626,6 +1626,12 @@ static int qcom_pcie_ecam_host_init(stru
 	pci->dbi_base = cfg->win;
 	pp->num_vectors = MSI_DEF_NUM_VECTORS;
 
+	/*
+	 * dw_pcie_msi_host_init() is called directly here, bypassing
+	 * dw_pcie_host_init() where pp->lock is normally initialized.
+	 */
+	raw_spin_lock_init(&pp->lock);
+
 	ret = dw_pcie_msi_host_init(pp);
 	if (ret)
 		return ret;


