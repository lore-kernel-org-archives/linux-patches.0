Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAD1265602;
	Tue,  8 Apr 2025 11:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112697; cv=none; b=U5KJ02bECE6TLccbZYzp/BrUys2BBhuTmIWA1Jt+H4zBt7fpoMKptHu033ArYn0dtojE2HbU975WoI4FW02p2AS3Jngn2cxyE6px4oIShk/is+FxSvlp34QVvSzlZaMp3B1JWP6p252Z3POsM1ydckGD/dbhK8TkXML9On9lhZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112697; c=relaxed/simple;
	bh=lU82SEjUDhCxFgkytCRCF9GbIMn6odaKKepHxHDVc18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q1R9Nf/+7BoXVh+hyH0ZcSqYFr4oqw6Ytgto9t9olAfkfc/yQgON2rfpfenbMKDC2WAhRybQpvHp9mQFAOkUuUUoz9V22T/w17ffkzfChNqg4y5T5joM5eCRpjWFiuxLzTtWpPj/YwnUcPz6gDvrnaxj78DsmzkmVGmmm9crsDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s0MOE9yp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s0MOE9yp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C252CC4CEE5;
	Tue,  8 Apr 2025 11:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112697;
	bh=lU82SEjUDhCxFgkytCRCF9GbIMn6odaKKepHxHDVc18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s0MOE9ypvM+6FYddl+wzf+zlGujAPi+8qr/kiglKq4tl1AYzxzzfuOFVKVo4Kz4if
	 9XH4yCyl66kMh6DZEiCEbn7sZeqwhZr36ZG7e7u2VXswGGfSiuDRoiIFAtUjFGu/qz
	 h7bQbduvRO7m/Qvn1GM/olLvIkC/ge/Wwc0aQXxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 162/279] PCI: pciehp: Dont enable HPIE when resuming in poll mode
Date: Tue,  8 Apr 2025 12:49:05 +0200
Message-ID: <20250408104830.708814448@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7773009b8b32e..6647ade09f054 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -840,7 +840,9 @@ void pcie_enable_interrupt(struct controller *ctrl)
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



