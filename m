Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9C582C60;
	Tue, 29 Apr 2025 17:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947892; cv=none; b=NFFBoxiDocgCH4UcxL03cKowruRdXP+Xami6QUHB7FdVl/zTiGLCt3BjbAxm23T0YwLaKCmRErGabJGlGfDD+EhW7s8qHYlbnUcUtGvw9ewWWNzYC1RACvx2ElJ6NxgVnd55RrVMCVxTzHsI2u7W2+B7IYHv0RIOwAs0OF61MSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947892; c=relaxed/simple;
	bh=XSAZImW9xZ0tvzuyKwq/+06ZBjiN0L5KRwcpi4hZqbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUOWYZlVODCw5KuLgc06QotpQZgBEovTtQwLeog2KbATsDZ5nBqO5qccSiazs+U3WxlTyXKhNLAZ29g265KiEP2YkBYCurdqihQPtSxA20HJvYaRP3SfcYVEYWyUjcqiuY5y4WE6np6fkYzMS0R7Qiv8HS/SvMXNnNI/FREZIMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sIC1N5x5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sIC1N5x5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30BFC4CEE9;
	Tue, 29 Apr 2025 17:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947892;
	bh=XSAZImW9xZ0tvzuyKwq/+06ZBjiN0L5KRwcpi4hZqbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sIC1N5x5+8GgQksAnfTPpRVaQbLCSzZlV0SpEukLmi3O5yLcFB+cfi+u+G/VsNb4x
	 8wOmzsHZbQiPDquYGLmUfVfeHwHrheCLXZKxs3FZvFwHdsruKVWtu9gBpyUuin5iWg
	 /A6vEIPIaPoD7Q8NI1XLvLl+Xfo0u1xmQmquPbYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.12 106/280] irqchip/gic-v2m: Prevent use after free of gicv2m_get_fwnode()
Date: Tue, 29 Apr 2025 18:40:47 +0200
Message-ID: <20250429161119.446057663@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suzuki K Poulose <suzuki.poulose@arm.com>

commit 3318dc299b072a0511d6dfd8367f3304fb6d9827 upstream.

With ACPI in place, gicv2m_get_fwnode() is registered with the pci
subsystem as pci_msi_get_fwnode_cb(), which may get invoked at runtime
during a PCI host bridge probe. But, the call back is wrongly marked as
__init, causing it to be freed, while being registered with the PCI
subsystem and could trigger:

 Unable to handle kernel paging request at virtual address ffff8000816c0400
  gicv2m_get_fwnode+0x0/0x58 (P)
  pci_set_bus_msi_domain+0x74/0x88
  pci_register_host_bridge+0x194/0x548

This is easily reproducible on a Juno board with ACPI boot.

Retain the function for later use.

Fixes: 0644b3daca28 ("irqchip/gic-v2m: acpi: Introducing GICv2m ACPI support")
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v2m.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/irqchip/irq-gic-v2m.c
+++ b/drivers/irqchip/irq-gic-v2m.c
@@ -423,7 +423,7 @@ static int __init gicv2m_of_init(struct
 #ifdef CONFIG_ACPI
 static int acpi_num_msi;
 
-static __init struct fwnode_handle *gicv2m_get_fwnode(struct device *dev)
+static struct fwnode_handle *gicv2m_get_fwnode(struct device *dev)
 {
 	struct v2m_data *data;
 


