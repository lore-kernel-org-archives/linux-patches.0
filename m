Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014111EA91;
	Tue, 27 May 2025 16:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364555; cv=none; b=oE9l9zUozooDK1s9DEtDvdmcYQXHQNOHLwdExRYoc/s0kgFC8fB/2RgHOTNGTS+cMDYiUilKUcODTxrvvoiqvB2tcdX8v39TF4UkFwjmp/7hzT2fVzRloX15MORp+z2fSHx7nOYTJ7CfhIOdlpnlMjWsuVrAD8o85LWKpFIuw9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364555; c=relaxed/simple;
	bh=kosXZ0ZinN16IZ5TKGjbfyHBboiQZ91XY6Rx6fbUYh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZlNfIWmAgI94FWdVH84hjwM9F4nQgb6swZfe1XfdwIXRYn/+LFx10gr3ZE39CDo69VV/YE3B3AIrvECauLFwzeWfSsctgaRrHUgUwJl3lkZtjHmRlj4ub5Tcn8A+30OJht9e1hrzHGwBcEnB3a+pvYGCe5Q1fDFX5BPPP/L7pxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RmhGoTzA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RmhGoTzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DD3C4CEE9;
	Tue, 27 May 2025 16:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364554;
	bh=kosXZ0ZinN16IZ5TKGjbfyHBboiQZ91XY6Rx6fbUYh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RmhGoTzAnpo/ssARuxj/KpAMOVLpG9FJXhIAA1uGaVrAk9/JT9YlvBUQ9aLe9tYC5
	 YROfEtth23zHiWsBJDgQmWMDoBzz08Y0wocZiq6Y/LUBeEKsgOqAZDip97RdE1xEHu
	 LDo3qyuVtwX9DWia4K7NR6uosNLKPVYVk0BA5jJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 094/626] xen/pci: Do not register devices with segments >= 0x10000
Date: Tue, 27 May 2025 18:19:47 +0200
Message-ID: <20250527162448.866387672@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



