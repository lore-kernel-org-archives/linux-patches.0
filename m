Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1D3185E7F;
	Tue, 27 May 2025 17:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366553; cv=none; b=feQzSr0ep0hgI9N46mmdq09pm4FMtHvcPH/q82gArCHBgIgSZiNHTluqDs7Oqzw3++7X5wvAV7JNu/CVZBjiWxyc/2n3kqQtEha5Pk54473v4aU5X7YPVOEOwRTYXsRaB7W3AGNs12k9nbTOSGV44vz33Kgr2cOgOEmEPfv+wRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366553; c=relaxed/simple;
	bh=hu9AIQqrONGpK404PKNQkRur1hpT5DvDDmnNAQ7IskQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KyRrI0Q7HAAKqUE3UnX9drB7W+RDUFu69UqbfbntDq+4LQK/ggF10WAiW+nVious1xi49EFUpvUoez6E5ZvIHgZ6MNEBuh2squhe3CfJvXeb7GkOdfgrQt/l8orICTpq4RLk9TEO1ZVTVmqM4OhR5TfNLVCdC+5Qr4j3gNFZfX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CLmrGgwp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CLmrGgwp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB2DC4CEE9;
	Tue, 27 May 2025 17:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366553;
	bh=hu9AIQqrONGpK404PKNQkRur1hpT5DvDDmnNAQ7IskQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CLmrGgwpjXOT3cAubL5MHNWmWsoTei+tVL7vad/sYDa9zUtZ4s9zw+VRvlxl/VvyT
	 6fiebdt2qEOdgFbBQlYq4uWz2aOUwmZaXyxDPeqNkJMil5zlInqvmi4ApZ/H4o+vBf
	 /y9lkd/4f+y32eAIbrdMEfO5TjwlriVTj3AT+Kww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 105/783] xen/pci: Do not register devices with segments >= 0x10000
Date: Tue, 27 May 2025 18:18:22 +0200
Message-ID: <20250527162517.418996246@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Pau Monne <roger.pau@citrix.com>

[ Upstream commit 5ccf1b8ae76ddf348e02a0d1564ff9baf8b6c415 ]

The current hypercall interface for doing PCI device operations always uses
a segment field that has a 16 bit width.  However on Linux there are buses
like VMD that hook up devices into the PCI hierarchy at segment >= 0x10000,
after the maximum possible segment enumerated in ACPI.

Attempting to register or manage those devices with Xen would result in
errors at best, or overlaps with existing devices living on the truncated
equivalent segment values.  Note also that the VMD segment numbers are
arbitrarily assigned by the OS, and hence there would need to be some
negotiation between Xen and the OS to agree on how to enumerate VMD
segments and devices behind them.

Skip notifying Xen about those devices.  Given how VMD bridges can
multiplex interrupts on behalf of devices behind them there's no need for
Xen to be aware of such devices for them to be usable by Linux.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Acked-by: Juergen Gross <jgross@suse.com>
Message-ID: <20250219092059.90850-2-roger.pau@citrix.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/pci.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/xen/pci.c b/drivers/xen/pci.c
index 416f231809cb6..bfe07adb3e3a6 100644
--- a/drivers/xen/pci.c
+++ b/drivers/xen/pci.c
@@ -43,6 +43,18 @@ static int xen_add_device(struct device *dev)
 		pci_mcfg_reserved = true;
 	}
 #endif
+
+	if (pci_domain_nr(pci_dev->bus) >> 16) {
+		/*
+		 * The hypercall interface is limited to 16bit PCI segment
+		 * values, do not attempt to register devices with Xen in
+		 * segments greater or equal than 0x10000.
+		 */
+		dev_info(dev,
+			 "not registering with Xen: invalid PCI segment\n");
+		return 0;
+	}
+
 	if (pci_seg_supported) {
 		DEFINE_RAW_FLEX(struct physdev_pci_device_add, add, optarr, 1);
 
@@ -149,6 +161,16 @@ static int xen_remove_device(struct device *dev)
 	int r;
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 
+	if (pci_domain_nr(pci_dev->bus) >> 16) {
+		/*
+		 * The hypercall interface is limited to 16bit PCI segment
+		 * values.
+		 */
+		dev_info(dev,
+			 "not unregistering with Xen: invalid PCI segment\n");
+		return 0;
+	}
+
 	if (pci_seg_supported) {
 		struct physdev_pci_device device = {
 			.seg = pci_domain_nr(pci_dev->bus),
@@ -182,6 +204,16 @@ int xen_reset_device(const struct pci_dev *dev)
 		.flags = PCI_DEVICE_RESET_FLR,
 	};
 
+	if (pci_domain_nr(dev->bus) >> 16) {
+		/*
+		 * The hypercall interface is limited to 16bit PCI segment
+		 * values.
+		 */
+		dev_info(&dev->dev,
+			 "unable to notify Xen of device reset: invalid PCI segment\n");
+		return 0;
+	}
+
 	return HYPERVISOR_physdev_op(PHYSDEVOP_pci_device_reset, &device);
 }
 EXPORT_SYMBOL_GPL(xen_reset_device);
-- 
2.39.5



