Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE48C3EA9A;
	Wed,  7 Aug 2024 15:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043099; cv=none; b=SkSaJFFl3w+N/at+iAXlcnd2W0Q75SqNwvmkuO3GbMg9LKXp2+RFWYx8MTmre/PnMXDLqa1YxqM5GlRyGrmnToSwJqaGT22XP0+eCBnJtfLoXgCT7MXLiWnl7xXo/1mybbuZd3cebPnEWgcYTkeWAWtf7PtmWvQ8I9CMGSqQj/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043099; c=relaxed/simple;
	bh=cCH3rqr5R9qD9eq4gUI+jisyPwAVAz7XVun+67Tr598=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LN041Gf86g1x07DgVenBURoO8rJFn+veEemjJsAHJIpm9zNR1q4s2t84DM9QtAhaos0u+g5eDrqIXDwHBnPPnX1ivASMy+9BPX3omB3aoi0mxzlFH83shsubWWVlkuwsnuDiQSZ1uzzzzKw6/cVH3m7a7+HSSJChA5YUUHuHCFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJf4k7ud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJf4k7ud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F08C4AF0B;
	Wed,  7 Aug 2024 15:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043099;
	bh=cCH3rqr5R9qD9eq4gUI+jisyPwAVAz7XVun+67Tr598=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJf4k7udv1e8700hI8Ib6YMHXiCXim7CxWgloOWxziVyUh1r9OJKVseZJWFl15W5Y
	 loZ1+XdoD660QVC3jlkXf0oHvWPi5Agzt3rVGmkihVUoaYU97vhJlyzjvtCsl3CHCT
	 eo6Kd52QLY5BzCsKCs7Oz4ET9egGbG+cmsGNBXOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Blazej Kucman <blazej.kucman@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.10 090/123] PCI: pciehp: Retain Power Indicator bits for userspace indicators
Date: Wed,  7 Aug 2024 17:00:09 +0200
Message-ID: <20240807150023.724114434@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Blazej Kucman <blazej.kucman@intel.com>

commit 5560a612c20d3daacbf5da7913deefa5c31742f4 upstream.

The sysfs "attention" file normally controls the Slot Control Attention
Indicator with 0 (off), 1 (on), 2 (blink) settings.

576243b3f9ea ("PCI: pciehp: Allow exclusive userspace control of
indicators") added pciehp_set_raw_indicator_status() to allow userspace to
directly control all four bits in both the Attention Indicator and the
Power Indicator fields via the "attention" file.

This is used on Intel VMD bridges so utilities like "ledmon" can use sysfs
"attention" to control up to 16 indicators for NVMe device RAID status.

abaaac4845a0 ("PCI: hotplug: Use FIELD_GET/PREP()") broke this by masking
the sysfs data with PCI_EXP_SLTCTL_AIC, which discards the upper two bits
intended for the Power Indicator Control field (PCI_EXP_SLTCTL_PIC).

For NVMe devices behind an Intel VMD, ledmon settings that use the
PCI_EXP_SLTCTL_PIC bits, i.e., ATTENTION_REBUILD (0x5), ATTENTION_LOCATE
(0x7), ATTENTION_FAILURE (0xD), ATTENTION_OFF (0xF), no longer worked
correctly.

Mask with PCI_EXP_SLTCTL_AIC | PCI_EXP_SLTCTL_PIC to retain both the
Attention Indicator and the Power Indicator bits.

Fixes: abaaac4845a0 ("PCI: hotplug: Use FIELD_GET/PREP()")
Link: https://lore.kernel.org/r/20240722141440.7210-1-blazej.kucman@intel.com
Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org	# v6.7+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/hotplug/pciehp_hpc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 061f01f60db4..736ad8baa2a5 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -485,7 +485,9 @@ int pciehp_set_raw_indicator_status(struct hotplug_slot *hotplug_slot,
 	struct pci_dev *pdev = ctrl_dev(ctrl);
 
 	pci_config_pm_runtime_get(pdev);
-	pcie_write_cmd_nowait(ctrl, FIELD_PREP(PCI_EXP_SLTCTL_AIC, status),
+
+	/* Attention and Power Indicator Control bits are supported */
+	pcie_write_cmd_nowait(ctrl, FIELD_PREP(PCI_EXP_SLTCTL_AIC | PCI_EXP_SLTCTL_PIC, status),
 			      PCI_EXP_SLTCTL_AIC | PCI_EXP_SLTCTL_PIC);
 	pci_config_pm_runtime_put(pdev);
 	return 0;
-- 
2.46.0



