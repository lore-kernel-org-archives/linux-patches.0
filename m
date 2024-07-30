Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031071A76A2;
	Tue, 30 Jul 2024 17:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359658; cv=none; b=YUkq2Qe3zlzB2mE1Iy7DrBFwi8E1XA90Tx61usecnyGh3aKaxb2tsXRbkLw32AKxz1lorjz+yGGIv2KqBW2AIrpczZ9PHefDgVk5TxifwpHBgO55dNBGO6HIwVn/K1EuU7G4Oo6TcWV6tGi7cbX4F8Kb8oU645qrypA6CYsuFog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359658; c=relaxed/simple;
	bh=qirtiAbOtOn2glX0HEhrrXETy/mlVVFiM4Rrv/qFW4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D4eX0NtxZanRkGmyY65jT9l4vTI3CNvUfFThoEye+udH9Hw9qTiZxHoOfMI7+S/d+yRNw1Os9DSlmQHt1qlzYse+Bsce14mTqdPr8XyuJNXlwROigKgm9UR1DBlmTLKa+VWhgMma03d+46Gx7EsB7qkLyFGkMwEGi0NgGUwWvEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gjk3fUSq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gjk3fUSq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66431C32782;
	Tue, 30 Jul 2024 17:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359657;
	bh=qirtiAbOtOn2glX0HEhrrXETy/mlVVFiM4Rrv/qFW4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gjk3fUSqEKR9CjSgFOj/YksbTCSjy4yhXmxanI8QjPPsY/dqcXP4Lxr1p1B7TXcd1
	 qt73r4rOy13nKrx/RDq9e5oVGQnWnnsvkuhbawOXs17z6kggK3cHOwu1r6YBASNLEK
	 tYQDOUCWw8RFE1hQCi53x8WZmW5qwdo/oMZ/Dmhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Lukas Wunner <lukas@wunner.de>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.6 513/568] PCI/DPC: Fix use-after-free on concurrent DPC and hot-removal
Date: Tue, 30 Jul 2024 17:50:20 +0200
Message-ID: <20240730151700.073384565@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

commit 11a1f4bc47362700fcbde717292158873fb847ed upstream.

Keith reports a use-after-free when a DPC event occurs concurrently to
hot-removal of the same portion of the hierarchy:

The dpc_handler() awaits readiness of the secondary bus below the
Downstream Port where the DPC event occurred.  To do so, it polls the
config space of the first child device on the secondary bus.  If that
child device is concurrently removed, accesses to its struct pci_dev
cause the kernel to oops.

That's because pci_bridge_wait_for_secondary_bus() neglects to hold a
reference on the child device.  Before v6.3, the function was only
called on resume from system sleep or on runtime resume.  Holding a
reference wasn't necessary back then because the pciehp IRQ thread
could never run concurrently.  (On resume from system sleep, IRQs are
not enabled until after the resume_noirq phase.  And runtime resume is
always awaited before a PCI device is removed.)

However starting with v6.3, pci_bridge_wait_for_secondary_bus() is also
called on a DPC event.  Commit 53b54ad074de ("PCI/DPC: Await readiness
of secondary bus after reset"), which introduced that, failed to
appreciate that pci_bridge_wait_for_secondary_bus() now needs to hold a
reference on the child device because dpc_handler() and pciehp may
indeed run concurrently.  The commit was backported to v5.10+ stable
kernels, so that's the oldest one affected.

Add the missing reference acquisition.

Abridged stack trace:

  BUG: unable to handle page fault for address: 00000000091400c0
  CPU: 15 PID: 2464 Comm: irq/53-pcie-dpc 6.9.0
  RIP: pci_bus_read_config_dword+0x17/0x50
  pci_dev_wait()
  pci_bridge_wait_for_secondary_bus()
  dpc_reset_link()
  pcie_do_recovery()
  dpc_handler()

Fixes: 53b54ad074de ("PCI/DPC: Await readiness of secondary bus after reset")
Closes: https://lore.kernel.org/r/20240612181625.3604512-3-kbusch@meta.com/
Link: https://lore.kernel.org/linux-pci/8e4bcd4116fd94f592f2bf2749f168099c480ddf.1718707743.git.lukas@wunner.de
Reported-by: Keith Busch <kbusch@kernel.org>
Tested-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5123,7 +5123,7 @@ static int pci_bus_max_d3cold_delay(cons
  */
 int pci_bridge_wait_for_secondary_bus(struct pci_dev *dev, char *reset_type)
 {
-	struct pci_dev *child;
+	struct pci_dev *child __free(pci_dev_put) = NULL;
 	int delay;
 
 	if (pci_dev_is_disconnected(dev))
@@ -5152,8 +5152,8 @@ int pci_bridge_wait_for_secondary_bus(st
 		return 0;
 	}
 
-	child = list_first_entry(&dev->subordinate->devices, struct pci_dev,
-				 bus_list);
+	child = pci_dev_get(list_first_entry(&dev->subordinate->devices,
+					     struct pci_dev, bus_list));
 	up_read(&pci_bus_sem);
 
 	/*


