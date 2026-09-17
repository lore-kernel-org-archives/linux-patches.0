Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121D54E73DD;
	Thu, 17 Sep 2026 18:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668164; cv=none; b=jYOC1u+BIdGi/Rt0YfQh88AXDJoZJAjn/ym7AFfAitR16n6r63ggtEO68Nlf/QjbFtz/I7VKWLCHkFWGAv5xiMlRK4uQMbtFcv6WUuZ3Bi9P8fKifUwXljXkZDehN+eyHFYT54DIGp1WuvjTCfmfmQTAr8jpgDn/GujsNNCC4TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668164; c=relaxed/simple;
	bh=a0fCrO9pT6/c1idwzSFxfCcuMOEnCyWlqj7XBFyj3aA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mf7h2Kmr2xbW+amDtPhRdrH3iBCee9i5HcFj0TheIwvHPXrleIZNMaSNmHjpL6R1xwrmJK3v+nq+JaaFZmHBAQuAHJZZhKbIcCWIG882G1zFKdgBWyEtu1ZH25PbqBUuN+BJaSmRe8+9cFOqBhmhvaZi7TDrjB0wqcnJ0iOVvt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0O40z4pl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0O40z4pl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2D51F000FF;
	Thu, 17 Sep 2026 18:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668163;
	bh=hvDD7fuzvr5lJ+k7o5rPlsh18AxcejV+df0yLXdkjMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0O40z4plZP5rAJzE3uyqvHX0bdHDdvLXYCXP2dvoY/qviFVujMKxVTvLzvN4YsgEM
	 rFYZ0DQPMS2OGmyCpERbEY/jNOYneujoH0UfgRIunqd5VWbabPdTtM8malbJm/VGLN
	 W7BVSAq+I655z90x5qXEXj8twafnjFHHufXEUVIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0335/1102] PCI: altera: Protect root bus removal with rescan lock
Date: Thu, 17 Sep 2026 16:04:38 +0100
Message-ID: <20260917151548.045003399@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Hans Zhang <18255117159@163.com>

[ Upstream commit a8759c8ac48c0419f5899e95a6ffc611b07c965b ]

Hold the pci_rescan_remove_lock lock while stopping and removing a root bus
to avoid racing with concurrent rescan or hotplug operations triggered via
sysfs.  Such races may lead to use-after-free issues or system crashes.

Signed-off-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260521161822.132996-4-18255117159@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-altera.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/pcie-altera.c b/drivers/pci/controller/pcie-altera.c
index 8769caa963927..c35d31067f62d 100644
--- a/drivers/pci/controller/pcie-altera.c
+++ b/drivers/pci/controller/pcie-altera.c
@@ -831,8 +831,10 @@ static void altera_pcie_remove(struct platform_device *pdev)
 	struct altera_pcie *pcie = platform_get_drvdata(pdev);
 	struct pci_host_bridge *bridge = pci_host_bridge_from_priv(pcie);
 
+	pci_lock_rescan_remove();
 	pci_stop_root_bus(bridge->bus);
 	pci_remove_root_bus(bridge->bus);
+	pci_unlock_rescan_remove();
 	altera_pcie_irq_teardown(pcie);
 }
 
-- 
2.53.0



