Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D121926A1DE;
	Tue,  8 Apr 2025 12:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116380; cv=none; b=OZdu984ykbsvF0q1GtcOCc9RMj3cmF041G2emudLLlDYVQI09dYjufbPVPRfZejlhkNP7StTWW9uMYCyeaShsCdDjRPo0aOqJ3srt5m0+BF37R3njJfqYPZqs66/4eoB6mx+xU1Pnl/anxMSNzaaHPNZuZ81ASLCs/XjtZ5Mk1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116380; c=relaxed/simple;
	bh=NKbogLMnXPlnzwcBjOrTHzb2IxnNQS4bCcgcE9IkKUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JeE45KGHSOa7CJBARqQTwWKp9TVnC8fB6ltSEtjWBTG72TaGmvLZuy+vcagNUNlHOX41rBV0Afe1ZR8CzNntqpzxTGe8fSSmreeOBSDGgqbqu2R0KcN3zWMEpdN/y1cy6HqZTXQ83PJKZ0iqkl4GLJya+Z+fzwI8iVbkuarqo1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k8ejFl+w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k8ejFl+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36979C4CEE5;
	Tue,  8 Apr 2025 12:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116380;
	bh=NKbogLMnXPlnzwcBjOrTHzb2IxnNQS4bCcgcE9IkKUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k8ejFl+w0hSiu66UEXw86wf+GdnwcR67uB0U9DiFcaZkdht5+e/XsTJjaPHU02En3
	 TX6nzY109O7sr+A68OugAMsqk4m/Pn4LMET6CTd0dY7YafmwCoQ2C0uTS/Xhwl8bf3
	 Ik5n1pna1s9Eh2NeJSVmraRYhX5WZFmpRKhWinLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 092/423] PCI: pciehp: Dont enable HPIE when resuming in poll mode
Date: Tue,  8 Apr 2025 12:46:58 +0200
Message-ID: <20250408104847.884375604@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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
index 736ad8baa2a55..8f3e4c7de961f 100644
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



