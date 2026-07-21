Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD6F3770B;
	Tue, 21 Jul 2026 20:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666236; cv=none; b=AKnReFDwC5mq+C47FZQaTao4RIBo9cJmndI++7ajmvzSuaH21VMKiRrD4Yx94l0dDikB+GLsDHy4MpVeZapCRKvDArWbMKIdXZwIpsWCBQ+fL/DdmbCXhKUmP7Y6cG4qO0Vuk/w1ZZMr2hd5szCfR2ZiEgmMbOumcjlACRvz42g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666236; c=relaxed/simple;
	bh=voRQVgonjDxDrw/A0Yjeg0LTsgceL9F5E+V3s7m/2lY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJnIeazpsfV6lMMPbQb5M5xrfy+8Qu3K7iPi1NHqmoIsNv7RdA/ir/x+YV6MrMHNPN3a/Go7CxwpTGx2aL07/+97MPa0vsidnRetn/gy76r+Iwb+VkjCc7aCV+nh3SFTpUxVF3MMmR7KDh/XjQnvepzDuISMnW0xz17NOMYaZkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lEp964Uy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lEp964Uy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD201F000E9;
	Tue, 21 Jul 2026 20:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666235;
	bh=CdPES6GZ/p/5Kk6F71vwGtVMUPT8FT9qux1J2Vfrgpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lEp964Uyq/hTGJ+TvW6fZSI2gImpwe8J1Scy7zbjmSg2rMzh/oEOyV9WUNxyEX7OQ
	 YpQoPVNr2+Q6ttZyJ++NhI526txBtw83gW2midxjBPhb8DjDDII86k3gVHKg879beY
	 qWdxyjgZ4Nq2aKHUQ167W/CCiFAMJmy1MH/glqq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Carlos Bilbao (Lambda)" <carlos.bilbao@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0607/1266] PCI/ASPM: Dont reconfigure ASPM entering low-power state
Date: Tue, 21 Jul 2026 17:17:24 +0200
Message-ID: <20260721152455.446602219@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e7648a1abfdbf3..c0cfc3f44f4bf9 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1518,9 +1518,6 @@ static int pci_set_low_power_state(struct pci_dev *dev, pci_power_t state, bool
 				     pci_power_name(dev->current_state),
 				     pci_power_name(state));
 
-	if (dev->bus->self)
-		pcie_aspm_pm_state_change(dev->bus->self, locked);
-
 	return 0;
 }
 
-- 
2.53.0



