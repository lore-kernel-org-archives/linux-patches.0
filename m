Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25487309EF2;
	Wed, 30 Sep 2026 18:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794536; cv=none; b=TePo8uYc3lhndKeK4PJFP1M8cJbpEkHSZDwk4MTHzR5sZLjqRz2jyS9HHPumimv/ixdPdMBzz28PeGgPhGM8aeYQ29h410wuKJkbxk6VugZEAqe+R8mdJ/dT5KTWPZS+899zO4/0k7JmhWqtAnKII2sC1/vNqvxaaomDyNquUgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794536; c=relaxed/simple;
	bh=Xh4aG10RsborfcKi6SYeyeOiR5y7s1A338VYzbawiMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLCW/LGMY5/xMVdi28XEmS/fEsW8/0zraYoKO99ywRyEEHwEpcfJ9+DVPiVYcc15R9rUiLXJhTtqEV+llFXKWNXU39Wgk3ykxmEdPTtm+sY1uVf4rdLXpeU7Y3OPBDrOk9OCIEeVuGueE2oy+DCWsQbZUMSgdsTPnJZgwhuSzus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dpfiHP7R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dpfiHP7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9D61F000FF;
	Wed, 30 Sep 2026 18:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794535;
	bh=CZvBvbJshV2X1vvQzy6uekIi5gyor/0TvE7vI9e11cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dpfiHP7RTQpQqvpxEV+kDD5x4QYe/g0eE6iwtXFtghaTFCwdow+PljwO8i7t61R++
	 pHMS6rA5ur0c1ekfbz6Nw+tD31srzvye6k6TMBQfP6RGY5ci/aDcFN6Xr5cwekrCyF
	 hng4wRMKcTfn6iUEomaqKCuaD7IH3be6NsTJ4Sus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0246/1193] PCI: rockchip: Protect root bus removal with rescan lock
Date: Wed, 30 Sep 2026 17:15:30 +0200
Message-ID: <20260930152439.657067853@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index c25f32abbdf64..c63db46faee5d 100644
--- a/drivers/pci/controller/pcie-rockchip-host.c
+++ b/drivers/pci/controller/pcie-rockchip-host.c
@@ -1018,8 +1018,10 @@ static void rockchip_pcie_remove(struct platform_device *pdev)
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



