Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB6635B632;
	Fri,  4 Sep 2026 06:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502914; cv=none; b=jbGZksNhL9NUGW+8mZCV1CKijytD0UdeSjfLuaBjnofpKdsjtE7fnURrkqmQoaqwH+oqzgqFOEcUoKZD4ETJ8b6qF70DCszQHrU+NRvplO3UPEPpzy5lttB6Pkniist18MCm0qB+jgKFC5qBAMg1whvO7nVdEpI+Vm7h2Lbk3CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502914; c=relaxed/simple;
	bh=zQTPD5ZhWO7cKW6DZkEBfAb6iGxE+ZnLEKVImOuY2WU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/Upvgy0Cmrb3Sbntjhvq5nJcAvXwcQ1IJinzFzPKHoOz8PDg3TZTbMPhSM9sVS++/vUXT35WwNQL5nihbuYAhwZrS75996KJ7F9AcELXoJjPCC/QvOAKmSa/Nl96X410Dac290Jofr5uTSqSGBcK6wfRYf4ilEJlznfz/u8K9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=deFxDmYC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="deFxDmYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4881F00A3D;
	Fri,  4 Sep 2026 06:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502913;
	bh=tJCkRXXNoxk+qTZrsclqlFNYw7s2J+UodPLlS/klu6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=deFxDmYCTA6Yk0pKH5zW1z6TWiHcpm4EZnLL6oxaECu7WKzDRuVTJwN7+3R0Whb+S
	 olJwDmhTpXLX5on83h2txMDb+LoGEBnIOebbuLvF3FGgjgsV5lo0YsouuN22ALmf7+
	 vQobJyzaSYi0YfIv0BaeJ75ThxdtHiCPbK3pN1MU=
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
Subject: [PATCH 6.12 375/403] PCI: hv: Set irq_retrigger callback for the Hyper-V PCI MSI irqchip
Date: Fri,  4 Sep 2026 07:02:58 +0200
Message-ID: <20260904045743.324188456@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e87e54acff4b0..e9bdb4aa3b9ba 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -2051,6 +2051,7 @@ static struct irq_chip hv_msi_irq_chip = {
 	.name			= "Hyper-V PCIe MSI",
 	.irq_compose_msi_msg	= hv_compose_msi_msg,
 	.irq_set_affinity	= irq_chip_set_affinity_parent,
+	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 #ifdef CONFIG_X86
 	.irq_ack		= irq_chip_ack_parent,
 #elif defined(CONFIG_ARM64)
-- 
2.53.0



