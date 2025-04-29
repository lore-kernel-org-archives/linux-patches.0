Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F1823F413;
	Tue, 29 Apr 2025 17:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946014; cv=none; b=pWrcv8iwx6Q6GylVpvrF1ma+yh0WTG0VGYvOZC3y2vZhV02DzV03kF0oh0wfZqQ6c+hIcFND03N/sFWGBzC5l25ELXNxUzoE9t283CNRuHKlMAhaleiLDepWa9qhmluph0coep14r8DKN9PegQo9Amdd+/I7MdeTD3PAkf9B9P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946014; c=relaxed/simple;
	bh=j5yFoS3TntcrFv4VVBot6W43S6mK/AV3pKbXypvHpTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a59/Q4BY9J4uibi4UUcDkM89Oe4iq0bcW2BiNfiCEuw5esVoVULHMlatIPM1v+XUZiNG8VtukETk+pBUgMu7wjrxJ8VyvpbbAZO6XycbUFJADD5GiuCg8HTaPysVVreBsRf7RAYfWigRsIhu3kPG9m+F6/SivHonfGNXTXS8NRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CfXLQXSZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CfXLQXSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18441C4CEE3;
	Tue, 29 Apr 2025 17:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946014;
	bh=j5yFoS3TntcrFv4VVBot6W43S6mK/AV3pKbXypvHpTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CfXLQXSZTwKLfKdX/2NzgrjByqYxK1BLY6wLygVKK/B/Y62nni72SY5O6c40cQTyJ
	 sm2LzKei+gL74hHM5ahEztTl8LmHW8XvEgPVNx/cQ8q0aU3OOO6mnGeuFpKynLhzuy
	 hEHIxCV/qJMbCW2j0tJh2HUJUG5zVP4Kq3DVpiA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.14 126/311] irqchip/gic-v2m: Prevent use after free of gicv2m_get_fwnode()
Date: Tue, 29 Apr 2025 18:39:23 +0200
Message-ID: <20250429161126.198338491@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
 


