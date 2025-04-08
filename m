Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09B0268C44;
	Tue,  8 Apr 2025 11:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111298; cv=none; b=WCZOelBnoVrFGDral7XAGXt3AV/LvNSYrUfGkxJbCH0FORDWfXEb9bAYhOME7N1xNc7Y/cDEPXPbouzFDHY6CRgf9XgPiTsLBIwRTNFFHL8XMveGv1ZpwuyzZt1NwM5pidmOn/suI9qaE7M0pNsIxrY5GYyov7sszemahuPXIoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111298; c=relaxed/simple;
	bh=w1mlJ6/YkY6Aetrw4q51JhWfvb42091B68Gyd5FOqh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EAAgz3hdQmwn4KaBTxwbC3GyelvAWAhkL8t7vFh8WSc6dq2g3POr3+tJyciXmnUrNfefnTAecQsghxfKZO1aDEnsNaxbw6A6J2cSnk4sbQcROLyS4RsrBcPkIwGGWppb/Lci0VjrMrqIiz+C/KbmErHNQVlM5bKM7Q7uIy8yA5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MsEoJ2K6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MsEoJ2K6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A7EC4CEE7;
	Tue,  8 Apr 2025 11:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111298;
	bh=w1mlJ6/YkY6Aetrw4q51JhWfvb42091B68Gyd5FOqh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MsEoJ2K6nyqZ2lRyJtBPbWeH6b/2jTHmnZyBmk/9hEJU1Vt4oVitbULulhqm5qVaD
	 Ka9CtvfBKkgHrGOg70h9oRbq/shIuYXVkVl1zcBgQLkFinUcmMl7KPZI70wYtPxBGK
	 8hmsIdI2df5NKlCs/QsGRF/hFLgathpgFVYPl8OU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 341/731] PCI: pciehp: Dont enable HPIE when resuming in poll mode
Date: Tue,  8 Apr 2025 12:43:58 +0200
Message-ID: <20250408104922.207094026@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 527664f738afb6f2c58022cd35e63801e5dc7aec ]

PCIe hotplug can operate in poll mode without interrupt handlers using a
polling kthread only.  eb34da60edee ("PCI: pciehp: Disable hotplug
interrupt during suspend") failed to consider that and enables HPIE
(Hot-Plug Interrupt Enable) unconditionally when resuming the Port.

Only set HPIE if non-poll mode is in use. This makes
pcie_enable_interrupt() match how pcie_enable_notification() already
handles HPIE.

Link: https://lore.kernel.org/r/20250321162114.3939-1-ilpo.jarvinen@linux.intel.com
Fixes: eb34da60edee ("PCI: pciehp: Disable hotplug interrupt during suspend")
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/pciehp_hpc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index bb5a8d9f03ad9..28ab393af1c04 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -842,7 +842,9 @@ void pcie_enable_interrupt(struct controller *ctrl)
 {
 	u16 mask;
 
-	mask = PCI_EXP_SLTCTL_HPIE | PCI_EXP_SLTCTL_DLLSCE;
+	mask = PCI_EXP_SLTCTL_DLLSCE;
+	if (!pciehp_poll_mode)
+		mask |= PCI_EXP_SLTCTL_HPIE;
 	pcie_write_cmd(ctrl, mask, mask);
 }
 
-- 
2.39.5



