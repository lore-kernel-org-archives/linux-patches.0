Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C5F42FCC9;
	Tue, 21 Jul 2026 19:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662463; cv=none; b=Y6YSrdJQypEQ7soOLGgsFLgWwlc0LW4GT46kcKMIBbDzE9XxyAUrsZoZ+yqgl/T9F2Sy24W3vjojFt+QcrJNoj7yNzGvK+4vNujYLEMp2DgwGNRa89Op0q88ftQv8xDE2d2OJMGDBrSPk++KQOFFdZUe1A4WHxbNbGIOIPcxay4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662463; c=relaxed/simple;
	bh=ZjG7YZWHbzJRZKyOB7eV25qDRPG/vavW1Td0ttWPmLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uceyb94YBQrIq2C1kn19Mo6W9dZyrg5TVDsJSTGBP7RGZmyFJOlW1YwoAaIIemO/FSJx95pgOA0845Ish+4YaLfp4I3W9iHe/SsDx7lnZBJ/VkhsxmwUzqrN5kW6Jk5r42R5MLFdtm3tiRfywM5Q+tIEnQGRIjynSrxunHtwFUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ACWHK+mL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ACWHK+mL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD3F1F00A3A;
	Tue, 21 Jul 2026 19:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662462;
	bh=YQ7Y/1qaU2VMhcaGytlxl99cjoc/VjapPwYw9lNsZSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ACWHK+mL1Y6v+WcJvfsloIHKk9656yyGMyDGG9ufblUAmTY4j0+afSTTzzmPYvzXa
	 lv4B6OLnOTCsIGLdZCCs9eJSj6DreETpwUFgHZCX1Y97Lw32/dyr38i34+L2UjwQ5m
	 sxhP10WxqSatkYgxL+pF2Ka+7x1dpzTtTIZEILmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Carlos Bilbao (Lambda)" <carlos.bilbao@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0417/1276] PCI/ASPM: Dont reconfigure ASPM entering low-power state
Date: Tue, 21 Jul 2026 17:14:20 +0200
Message-ID: <20260721152455.432041368@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Carlos Bilbao <carlos.bilbao@kernel.org>

[ Upstream commit c855c9921da72e535c24737c748f603a52d03f7e ]

Reconfiguring ASPM when a device transitions to low-power state can enable
L1.1/L1.2 substates on the PCIe link at a time when the device is sleeping
and may be unable to exit them. ASPM should be reconfigured on D0 entry
(resume), not on the way down.

pci_set_low_power_state() calls pcie_aspm_pm_state_change() after writing
D3hot to PCI_PM_CTRL. pcie_aspm_pm_state_change() resets link->aspm_capable
to link->aspm_support and then calls pcie_config_aspm_path(), which can
enable ASPM L1.1/L1.2 substates on the PCIe link. If the device cannot
recover the link from L1.2 while in D3hot, subsequent config space reads
return 0xFFFF ("device inaccessible") and pci_power_up() fails with
messages like:

  vfio-pci 0000:5d:00.0: Unable to change power state from D3hot to D0, device inaccessible

This was observed on NVIDIA H100 SXM5 GPUs bound to vfio-pci when Linux
runtime PM suspends them to D3hot: the GPU becomes permanently inaccessible
and disappears from the PCIe bus.

The call to pcie_aspm_pm_state_change() in pci_set_low_power_state() was
restored by f93e71aea6c6 ("Revert "PCI/ASPM: Remove
pcie_aspm_pm_state_change()""), which reverted 08d0cc5f3426 ("PCI/ASPM:
Remove pcie_aspm_pm_state_change()").  The revert was necessary because the
removal broke suspend/resume on certain platforms that required ASPM to be
reconfigured on D0 entry. However, the revert restored the call in both
pci_set_full_power_state() (D0 entry) and pci_set_low_power_state()
(low-power entry).

Only the D0-entry call is needed to fix the suspend/resume regression. The
low-power-entry call is harmful: reconfiguring ASPM immediately after
putting a device into D3hot can enable link substates that the device or
platform cannot exit while the device is sleeping.

Remove the pcie_aspm_pm_state_change() call from pci_set_low_power_state().
ASPM will still be reconfigured correctly when the device returns to D0 via
pci_set_full_power_state().

Fixes: f93e71aea6c6 ("Revert "PCI/ASPM: Remove pcie_aspm_pm_state_change()"")
Signed-off-by: Carlos Bilbao (Lambda) <carlos.bilbao@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260428040104.78524-1-carlos.bilbao@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index d44c07bb0a2290..4fe6843a73a49c 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1604,9 +1604,6 @@ static int pci_set_low_power_state(struct pci_dev *dev, pci_power_t state, bool
 				     pci_power_name(dev->current_state),
 				     pci_power_name(state));
 
-	if (dev->bus->self)
-		pcie_aspm_pm_state_change(dev->bus->self, locked);
-
 	return 0;
 }
 
-- 
2.53.0



