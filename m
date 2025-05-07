Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713F21DDC23;
	Wed,  7 May 2025 18:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643732; cv=none; b=Emw1o4baxdCTlfmtIO3lmEmPNqMOT1+8eJVWyaF8vdjxxeWPLoD+ISQ0Z6zQERISHrA4TwnC4Oo098JYv5d1meVicbral+Uk674N7sAf7ZQS2kyIh4ZTEaEs12e72THkMx7dWgz5aqu2CClsnRnDhzH+j161N8wiJyaeaSACETA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643732; c=relaxed/simple;
	bh=QZd1jgdsQWAT/ODSRkZDWick5cJugx4XspmZieOA0nY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LtQLwyqfxlcgDJDDxCWHfdFoxlMEnjTpRNb3YeauyHYeDgvVVuFtq+/wzMiUrbcSZYZ7KvJVf/Vp48t126dXwYhdku8jkWAbxTuvhW/3sx5/phlA0TgYWK2K31FdXqHV8qPU5B8lG+4LBqKK6/27bg4M7/OqxcBKupfS5FXFeRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FVx0ErB1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FVx0ErB1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF52FC4CEE2;
	Wed,  7 May 2025 18:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643732;
	bh=QZd1jgdsQWAT/ODSRkZDWick5cJugx4XspmZieOA0nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FVx0ErB12tLL6xWfkd+EaNL3cGZi3pSc0ItfnI7K14SEubyeGperd0Blf/1AquSoE
	 RCiKE9o4VrN8gCd2+KnSfQ0a3eaHP8iovOiIMOk6xrr3U1WAMnmhLhoaHHTwBs12nL
	 zHDqsU23QyboWsQ+G66PFkUxa7OwTH/zFMDExPoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 86/97] irqchip/gic-v2m: Prevent use after free of gicv2m_get_fwnode()
Date: Wed,  7 May 2025 20:40:01 +0200
Message-ID: <20250507183810.438072317@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 3318dc299b072a0511d6dfd8367f3304fb6d9827 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v2m.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v2m.c b/drivers/irqchip/irq-gic-v2m.c
index c2e52c9a38546..c04f2481068bb 100644
--- a/drivers/irqchip/irq-gic-v2m.c
+++ b/drivers/irqchip/irq-gic-v2m.c
@@ -454,7 +454,7 @@ static int __init gicv2m_of_init(struct fwnode_handle *parent_handle,
 #ifdef CONFIG_ACPI
 static int acpi_num_msi;
 
-static __init struct fwnode_handle *gicv2m_get_fwnode(struct device *dev)
+static struct fwnode_handle *gicv2m_get_fwnode(struct device *dev)
 {
 	struct v2m_data *data;
 
-- 
2.39.5



