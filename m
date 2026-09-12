Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C5E37F8D7;
	Sat, 12 Sep 2026 19:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241635; cv=none; b=MOZt9mjH/k5m8q3tiyatELGYiFlL2tUlpaXmbYy7hfGW/zvSd9Yb6Nl8V2vq8CimnZp0b4sRe5CItZJbChhmcqP9r/5ThZyVjCkWlW/wPOmHYfZix6jWdsQ5nI6b0fC+3/AXPXsQTHU8m78G0bmqmcKd8ezvtu297bIqtbUYl/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241635; c=relaxed/simple;
	bh=WSTPgp/8VWm4JromrdtcGVvLXoOmomacCsxLRd/57iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MnKZleBQSBZFxD0DK1LgbnRzBMPvbOMrxtBxIxiAbocfZ1/o+sdv/mtFRyMZbaSgrpEK/pOipYYIkhD6cI9Yz29s5I88wtOJYAvavRg7UEpisryORIYjQiyiD0KFvtNKGJJD+4nhYEh64fueIVsS8EgHWvpDdyaQviRZZrQR+oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JuOLVhJA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JuOLVhJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDA81F000FF;
	Sat, 12 Sep 2026 19:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241634;
	bh=6485rFL7Hgz3KllOUhlbIlkbqHoHf55vUTQ7ToiAbzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JuOLVhJAeB2TIJiZntpTMEE5frysViMCs/2OHXasoSitaD5v4PNluTxx+Ya90n3aj
	 6Xyd279ocU2JrAMRgypC4N9H8IUOWIZIuC8BFH5uYBnLyV5NmKslu/9bCQnoixAuds
	 aYB2mfy1odoChbLFEfgb+zLAPRY/Fz70fi2T7zu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Naman Jain <namjain@linux.microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 176/798] PCI: hv: Set irq_retrigger callback for the Hyper-V PCI MSI irqchip
Date: Sat, 12 Sep 2026 08:56:44 +0200
Message-ID: <20260912065521.053595436@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naman Jain <namjain@linux.microsoft.com>

[ Upstream commit 86bdd16e8f390d51bae9e77a4bc4164ca2f580fe ]

The Hyper-V vPCI MSI irqchip never installs an irq_retrigger() callback.

On CPU hot-unplug fixup_irqs() migrates the interrupts which are affine to
the outgoing CPU to a new target. If an interrupt still has its pending bit
set in the outgoing CPU's IRR at that point, fixup_irqs() resends it on the
new target through the irqchip's irq_retrigger() callback. As the Hyper-V
PCI/MSI chip does not provide that callback, the pending interrupt is
silently dropped, which can result in lost interrupts, stalls and "No irq
handler for vector" messages during CPU hotplug.

Install irq_chip_retrigger_hierarchy() as the irq_retrigger() callback for
the Hyper-V PCI/MSI irqchip, so that a pending interrupt is resent on its
new target CPU via the parent x86 vector domain.

Fixes: 4daace0d8ce85 ("PCI: hv: Add paravirtual PCI front-end for Microsoft Hyper-V VMs")
Cc: stable@vger.kernel.org
Suggested-by: Long Li <longli@microsoft.com>
Suggested-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Aditya Garg <gargaditya@linux.microsoft.com>
Reviewed-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-hyperv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -1595,6 +1595,7 @@ static struct irq_chip hv_msi_irq_chip =
 	.irq_compose_msi_msg	= hv_compose_msi_msg,
 	.irq_set_affinity	= hv_set_affinity,
 	.irq_ack		= irq_chip_ack_parent,
+	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_mask		= hv_irq_mask,
 	.irq_unmask		= hv_irq_unmask,
 };


