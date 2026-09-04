Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33663401A25;
	Fri,  4 Sep 2026 05:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501377; cv=none; b=dZzKKWjsfjKgAo3ySVZIK5M7UoFb9+6R3iCyBmTYwuEQQM8HffRPkVO4ijDUhPrzTBU0QRABdv43NH93L5cZNu5sVcuuo4SICmYb6y3pTjEB+M2rijdzZGm5/I733C1vU4+D4ljY1LawYUE3q/0TnsKM9+QMaLhM+lv2xexqLwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501377; c=relaxed/simple;
	bh=tF6GfiBDmI3ZvgnrMkClJ7CyQ9vamu7ursHifBVU9ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EvlS19BBUn/oLVVQXLu7I0ZpeV0SF+HLT3TRDWALnkpMk8WpYixrOkLH2zfifANI/3v1zPaFwpQNMLXlMvmrOBfynOjhZkB9ODh7snrJM8Lw+veTTZNOzynswzHbw2G08qfEb/26Q+CSY1E5uqAre18Utta8DFNzlZZuHm2I/Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SMHtg0P/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SMHtg0P/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90ED31F00A3D;
	Fri,  4 Sep 2026 05:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501376;
	bh=35MPgSu0SNGLHtX1MU+Kp24DKMrRw1I6EzkaIQmKDPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SMHtg0P/htNE8096F8whalDHSARqso7tNbCzKPCAd57WVZNzDHSTF4nsz6KE58QxD
	 FiRMDrwLk7j+Q+2XzB9YfQ1fTqtAuLyWCMFUi3pPhWm9XMIVlGS1dtkGa0KgAgpRZq
	 QBoatTlXgnvZdU8u11uPxh99kfjiv+IWXzUbTsFM=
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
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 6.18 386/552] PCI: hv: Set irq_retrigger callback for the Hyper-V PCI MSI irqchip
Date: Fri,  4 Sep 2026 06:59:03 +0200
Message-ID: <20260904045758.960147336@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Naman Jain <namjain@linux.microsoft.com>

commit 86bdd16e8f390d51bae9e77a4bc4164ca2f580fe upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-hyperv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -2120,6 +2120,7 @@ static bool hv_pcie_init_dev_msi_info(st
 	info->ops->msi_prepare = hv_msi_prepare;
 
 	chip->irq_set_affinity = irq_chip_set_affinity_parent;
+	chip->irq_retrigger = irq_chip_retrigger_hierarchy;
 
 	if (IS_ENABLED(CONFIG_X86))
 		chip->flags |= IRQCHIP_MOVE_DEFERRED;


