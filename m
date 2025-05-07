Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7B114A4C7;
	Wed,  7 May 2025 18:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643413; cv=none; b=R0RnEP975TW5n9Brx4f0NGSiHL10hWSXvUuywWNCaC/YLnM390U8sJE2Vzq112WLASbdJNrF7qqD8ic1/QaKDodrK5eVfIOZSzyWhJZ1ASj3dU5pXGmFfH4iR8HfMtfzmmZEyHvliDVwNE2YnYwwChK3H9z/UnMX/M6ZMOFgviA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643413; c=relaxed/simple;
	bh=7tPN2LFneCPZtyAm6g6ttERY3XOQuqzVh5c4b86qKV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEYM9nrSkeD7iKD8e3Y0zgXJ4a7vS49Hiez2aE88EjEQkN2nn/A1TQIz1/BDZ2EERuTiflKkGUP9NDmvAzfOgrYei++cISIDi8pK6++A7fMmqkyYVGFvXPHa6pFo5bByBC76z6x4+682It9fmXoV+WNYjePHTaS4Q+yRhcDoKR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xj4ykAEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xj4ykAEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D95EC4CEE2;
	Wed,  7 May 2025 18:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643412;
	bh=7tPN2LFneCPZtyAm6g6ttERY3XOQuqzVh5c4b86qKV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xj4ykAEEP+P3r1YMU82en1v9TqaQlzLgarHABWCFuYn1R2nTMQYZh9RN6eib+5kUr
	 lVxX8K3/pbKz23A/2+3FtedfVc/zmCq6PNuhMPuvg0BTYKp/zbmdhIs83IOs7DHE4U
	 skg8P1mv4kkfPpm0IFRCx4r8+Tj+BD9Lk6B+Z37M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 51/55] irqchip/gic-v2m: Prevent use after free of gicv2m_get_fwnode()
Date: Wed,  7 May 2025 20:39:52 +0200
Message-ID: <20250507183801.096181179@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183759.048732653@linuxfoundation.org>
References: <20250507183759.048732653@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6790a621a9324..9d99b19cd21b6 100644
--- a/drivers/irqchip/irq-gic-v2m.c
+++ b/drivers/irqchip/irq-gic-v2m.c
@@ -455,7 +455,7 @@ static int __init gicv2m_of_init(struct fwnode_handle *parent_handle,
 #ifdef CONFIG_ACPI
 static int acpi_num_msi;
 
-static __init struct fwnode_handle *gicv2m_get_fwnode(struct device *dev)
+static struct fwnode_handle *gicv2m_get_fwnode(struct device *dev)
 {
 	struct v2m_data *data;
 
-- 
2.39.5



