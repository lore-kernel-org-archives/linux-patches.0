Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CAE32D7F8;
	Sat, 12 Sep 2026 18:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237138; cv=none; b=sbQFMl4Q4wawZaPlzlBVjpkj3YKEP2TQfXTlvU/HJbCo6bRM+9VhJqigLiu+I0Gq2IX3y/lKIdufNw4R+UMvQmCPT6JV8teYEP41x58FxwDq9eg57vw1jTa/4IuYF244is7BcckQuUXmWTOCYQSUn7grNXwUfabHLy46dXtoD48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237138; c=relaxed/simple;
	bh=g26HpcW74ivP2Nx/skeC1p/yju9qPo79xsMOGdI2w0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lIuNrR42YahiCRI7E9EyeeUKsELDSiFOScOwKCTysQ5ica4aDYO5ZZWu+wYj+O4VgpE5fMi4eSlV1mPWN6mcJFVXagl6HyBTrkHZo/kMQk14ymt9+vSGAKPA0XOTp+5ydKsws0SgTH94TUj9o5vG6svI8OX+RCD3Jo/x61Uak2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GTsizOAk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GTsizOAk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D2A1F000FF;
	Sat, 12 Sep 2026 18:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237137;
	bh=c4JldvJzNOnH4+NbBA4OULK9LrQ/gAexMPBHEo+qrsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GTsizOAkoP3B66zUxEmCL91PM2v+l15nterc1WLW/zjQgYSbJ3+0rwoFVjFip6KT/
	 struJm/SP8M2RpYx1UAcxMnYW7zUD/GnirMA7/+AH38kY1ftHCWCXOpFI4H2JwQE2q
	 QS3aUVYfIO43Y2hmBI5a03tuIYn4m0BnRRzguT/I=
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
Subject: [PATCH 5.15 197/935] PCI: hv: Set irq_retrigger callback for the Hyper-V PCI MSI irqchip
Date: Sat, 12 Sep 2026 08:53:47 +0200
Message-ID: <20260912065531.332541006@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/pci/controller/pci-hyperv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 7917ed426f6a7..ef3beda509186 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -1655,6 +1655,7 @@ static struct irq_chip hv_msi_irq_chip = {
 	.irq_compose_msi_msg	= hv_compose_msi_msg,
 	.irq_set_affinity	= hv_set_affinity,
 	.irq_ack		= irq_chip_ack_parent,
+	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_mask		= hv_irq_mask,
 	.irq_unmask		= hv_irq_unmask,
 };
-- 
2.53.0



