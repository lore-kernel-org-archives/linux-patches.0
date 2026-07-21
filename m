Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA3946EF8C;
	Tue, 21 Jul 2026 18:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656964; cv=none; b=oVUC/guZjc/nRzWgL0Mvxz75Ue4+T1yaTv/i8KIv49b2j91imk+C0nB3a/N6bLnAk8BtRxvyuYQxnD5NShJiHELrfkeYW5o/Af7/a3JzEymfsHMAuVy+A2ltUr2RmwbUk6EjxLteemvwmWooigUC6mZAE7zIYtqxqoVtNAUqtUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656964; c=relaxed/simple;
	bh=LpwAU+STX5Pj3nZFY/khGuGKrzp78IodVBmJHP56R60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0c/FDE9mjN9ELEvGwi/LCGdoftFzbPKfE8oJYz/xLJDVbCQqe+WdWSjVeIgHZKfuHpP2Wpxkfm/I3gZyDkl/UOVxtwgI5pqOCj/H7rHnUOyP/GPk3IG4VhLOxco2fcojS0qYpM5o6nQ5n+XfXiDsEt5xdU5QMn4FwGQQWXGjK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjbPAO6z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjbPAO6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780011F000E9;
	Tue, 21 Jul 2026 18:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656963;
	bh=e5xoFI5nhR50IPkZ1U8HmOH0AAo6R+b36H4uscVs+yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mjbPAO6z14N0uVlehgzmejtHCU7Khy4imXpA7sLzTeBZ9GNGbFPKjFqE6Uv9C/lJx
	 nhiEyh+w3Yy0ifsF3VNDJqTxxcaYCvUT2qC4EXbWU3TbKjgRMJdp+yP6b1nt6lviAp
	 FENv7Io2uESlQFrThPEpaLeNniktFcBIW1QX7nNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Carlos Bilbao (Lambda)" <carlos.bilbao@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0585/1611] PCI/ASPM: Dont reconfigure ASPM entering low-power state
Date: Tue, 21 Jul 2026 17:11:41 +0200
Message-ID: <20260721152528.538750437@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 0b6a23405f167a..6420b371aaf07f 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1519,9 +1519,6 @@ static int pci_set_low_power_state(struct pci_dev *dev, pci_power_t state, bool
 				     pci_power_name(dev->current_state),
 				     pci_power_name(state));
 
-	if (dev->bus->self)
-		pcie_aspm_pm_state_change(dev->bus->self, locked);
-
 	return 0;
 }
 
-- 
2.53.0



