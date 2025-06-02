Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78ACD22B8CF;
	Mon,  2 Jun 2025 14:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874444; cv=none; b=rjhrg1gsuXi2KxK7Lg0GSd7uSoRlNctSDBg/0M+X3ZfJzvVPzeN3Rn8LI+FeErRgj5gzqpOR53/+M2OWsEviZ5ZDDzswXpt0EfqJLk55pR9MXncbywlLOede9ERX+WIFkT4CfFc23Z5sIYixaygFF1d2svEI71WWBnhmNbrIPuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874444; c=relaxed/simple;
	bh=6sySjQjg2QFDNA5IMmLmanHjtHsBntiIuOnZQpu6hhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rSNfkKUo22M900sodq4MYf+PMPB47eTYnLpJr7KyTMgtLtSg0CKLL3i8NDLQ5Av21LLK/pDtJGFWxShsnA/nZVSkJUoiUtCi3hP+rquIx8I8AotjePdngwv628/unBl/qiMal5CrsySoVwNVRs2uXsAydbTXJuc2IQBnqLeAy+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lOV7xcen; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lOV7xcen"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7166C4CEEB;
	Mon,  2 Jun 2025 14:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874444;
	bh=6sySjQjg2QFDNA5IMmLmanHjtHsBntiIuOnZQpu6hhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lOV7xcenrVKuguYgsP1/Sm0Mc1XA7W1K47A4mkARGUjSpC4Ie6wZ70KRHkjaksyP1
	 EWYm7P27wfUzpqpBTQP/4fFcVu6qWZmfKGvOP68GZosk8B2l78h3np7IykS0/vOw8J
	 lJPtnf6tOEjX/xdVhezy07szSi5QT0Sv3w8q1LU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 025/204] irqchip/gic-v2m: Prevent use after free of gicv2m_get_fwnode()
Date: Mon,  2 Jun 2025 15:45:58 +0200
Message-ID: <20250602134256.673218566@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index dbb15daf6ff1c..2468b285c77c2 100644
--- a/drivers/irqchip/irq-gic-v2m.c
+++ b/drivers/irqchip/irq-gic-v2m.c
@@ -457,7 +457,7 @@ static int __init gicv2m_of_init(struct fwnode_handle *parent_handle,
 #ifdef CONFIG_ACPI
 static int acpi_num_msi;
 
-static __init struct fwnode_handle *gicv2m_get_fwnode(struct device *dev)
+static struct fwnode_handle *gicv2m_get_fwnode(struct device *dev)
 {
 	struct v2m_data *data;
 
-- 
2.39.5



