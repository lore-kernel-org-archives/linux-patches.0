Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9F215B0FE;
	Tue,  2 Jul 2024 17:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940491; cv=none; b=tOUotG/Kf7CYNlYSJAjnqrWrOZqr3TkokxOxVpzPWgVB8SDIyntCTIyUP5y1uTP+ajxnOIpKUOx/Kkxhx61x2CGkOqPnUi27yWKikT49cydWy40VZoofFErEqXbCpm4N+aQ7buPVCECMImffArSOjnN7d9pfNPXgXiT/oxcmNho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940491; c=relaxed/simple;
	bh=iEqEmCFwcuaFkralKCC19lo2wMHth8Yys8bY3ALHWxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRLQi6NxR33L/vc2QuYRi/hfgQn1tRX0WCbIJp9aycTS314fnVaP6ojd/+i85jffGY5cRFSjjnK71h4sS7b2OMUbza1YAWz8jgB81WFonvoYpKa5kETJkBLqRQ24zPDTa8feXlQIkc/ITRBGtT7+5uSmhx2LQJLqN67bBSy2Muo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0GkV3D/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0GkV3D/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D5AC116B1;
	Tue,  2 Jul 2024 17:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940491;
	bh=iEqEmCFwcuaFkralKCC19lo2wMHth8Yys8bY3ALHWxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y0GkV3D/tZdAFhld+qlHCs7hLU6xqFUrSLnRvGkjIJynnyFuAIUWWqW681lsyUbOo
	 53LKQlgzVnQdyrAYoMwGBS5LEKXiCOzgsr/tMz7YPLsrbT4T62G3HhEPRYp+00pOom
	 VYz2W2X/jMsT1sD2xQ0MDkwjw7HlCqGJhKks5iA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.9 170/222] irqchip/loongson-eiointc: Use early_cpu_to_node() instead of cpu_to_node()
Date: Tue,  2 Jul 2024 19:03:28 +0200
Message-ID: <20240702170250.474551904@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 2d64eaeeeda5659d52da1af79d237269ba3c2d2c upstream.

Multi-bridge machines required that all eiointc controllers in the system
are initialized, otherwise the system does not boot.

The initialization happens on the boot CPU during early boot and relies on
cpu_to_node() for identifying the individual nodes.

That works when the number of possible CPUs is large enough, but with a
command line limit, e.g. "nr_cpus=$N" for kdump, but fails when the CPUs
of the secondary nodes are not covered.

During early ACPI enumeration all CPU to node mappings are recorded up to
CONFIG_NR_CPUS. These are accessible via early_cpu_to_node() even in the
case that "nr_cpus=N" truncates the number of possible CPUs and only
provides the possible CPUs via cpu_to_node() translation.

Change the node lookup in the driver to use early_cpu_to_node() so that
even with a limitation on the number of possible CPUs all eointc instances
are initialized.

This can't obviously cure the case where CONFIG_NR_CPUS is too small.

[ tglx: Massaged changelog ]

Fixes: 64cc451e45e1 ("irqchip/loongson-eiointc: Fix incorrect use of acpi_get_vec_parent")
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240623034113.1808727-1-chenhuacai@loongson.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-loongson-eiointc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/irqchip/irq-loongson-eiointc.c
+++ b/drivers/irqchip/irq-loongson-eiointc.c
@@ -15,6 +15,7 @@
 #include <linux/irqchip/chained_irq.h>
 #include <linux/kernel.h>
 #include <linux/syscore_ops.h>
+#include <asm/numa.h>
 
 #define EIOINTC_REG_NODEMAP	0x14a0
 #define EIOINTC_REG_IPMAP	0x14c0
@@ -339,7 +340,7 @@ static int __init pch_msi_parse_madt(uni
 	int node;
 
 	if (cpu_has_flatmode)
-		node = cpu_to_node(eiointc_priv[nr_pics - 1]->node * CORES_PER_EIO_NODE);
+		node = early_cpu_to_node(eiointc_priv[nr_pics - 1]->node * CORES_PER_EIO_NODE);
 	else
 		node = eiointc_priv[nr_pics - 1]->node;
 
@@ -431,7 +432,7 @@ int __init eiointc_acpi_init(struct irq_
 		goto out_free_handle;
 
 	if (cpu_has_flatmode)
-		node = cpu_to_node(acpi_eiointc->node * CORES_PER_EIO_NODE);
+		node = early_cpu_to_node(acpi_eiointc->node * CORES_PER_EIO_NODE);
 	else
 		node = acpi_eiointc->node;
 	acpi_set_vec_parent(node, priv->eiointc_domain, pch_group);


