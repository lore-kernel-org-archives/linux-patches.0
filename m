Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D6450E5B0;
	Wed, 30 Sep 2026 15:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782705; cv=none; b=hjhpOganrBl8Nl8JxGbLlfBzarftLRfnn5BPLPmVBG856TDDlxryzfOEDM6+AWTFX8ScZT82wnUiz4HN3dS5eeNfvms66fo/7x7fK/hPcTIo6/nuoeOQBdDtcsA252iy4CregqUm8SwbB0gUq3NQNaG5r+SZ3rYElwNwrcWRYk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782705; c=relaxed/simple;
	bh=W7DAvyl6iLQyFdj4SpBspVcIqSbTCKLKvJUFpn1eOj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLVosMnSfDcgY8wY7oXiW5JrX3O4X9mVPj1Fe53sF95hjVuPQPYkqkWHvQGePwfltmsm5x7dPdtlO+zeGQgFAXhUzYtn0F79/O/2uykljLCMxDmLKGD5s9rQx+hMOz9Lt3b8/7ZbcFM0bOCkEbhcIMrdWtGOtJd1/vGKWjJMX+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=abGA7Tqc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="abGA7Tqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1371F000FF;
	Wed, 30 Sep 2026 15:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782700;
	bh=QGtfgYW3ixFR0RqaJIfY+v8YOqF3xfH/JaWXOgZx+m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=abGA7TqcVvAOoahU+H1/ZGGZZK+HB5NwEfGNv8f+o9dTKGBxulazDkJSnHGS+OdbV
	 dyu6HFeBuylLJ321wb2x0F8Eff5gQVcU/9icFpHuOop1tI15JIMCNZBJ6cTswwFr05
	 wLedyVAG3sifcs6LR8umqQdKKI8NnRZkK32Q/8ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 139/595] PCI: rockchip: Protect root bus removal with rescan lock
Date: Wed, 30 Sep 2026 17:20:32 +0200
Message-ID: <20260930152350.725405534@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Zhang <18255117159@163.com>

[ Upstream commit 0bd9611587bb494c33566d825fe34b2705e4b167 ]

Hold the pci_rescan_remove_lock lock while stopping and removing a root bus
to avoid racing with concurrent rescan or hotplug operations triggered via
sysfs.  Such races may lead to use-after-free issues or system crashes.

Signed-off-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260521161822.132996-8-18255117159@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rockchip-host.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/pcie-rockchip-host.c b/drivers/pci/controller/pcie-rockchip-host.c
index 86bb4f82048a3..90f3e69b5d940 100644
--- a/drivers/pci/controller/pcie-rockchip-host.c
+++ b/drivers/pci/controller/pcie-rockchip-host.c
@@ -1021,8 +1021,10 @@ static int rockchip_pcie_remove(struct platform_device *pdev)
 	struct rockchip_pcie *rockchip = dev_get_drvdata(dev);
 	struct pci_host_bridge *bridge = pci_host_bridge_from_priv(rockchip);
 
+	pci_lock_rescan_remove();
 	pci_stop_root_bus(bridge->bus);
 	pci_remove_root_bus(bridge->bus);
+	pci_unlock_rescan_remove();
 	irq_domain_remove(rockchip->irq_domain);
 
 	rockchip_pcie_deinit_phys(rockchip);
-- 
2.53.0



