Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E87327BEC;
	Wed, 30 Sep 2026 18:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794533; cv=none; b=KbcDXfVLT0xspsqKiF0ZKJod8WK+o3UTYlGiImyZL6WTYAHk5PSVRBePpx4yHcs3aSoPqTFjVeZFvlG0APICVnb/7alniefBaSGGSKI3oijWg+NLW1KY+Eve90q95m7KZmkWxNJdQYoFvtpO5oVIFlrcZDjnSEpSKxiGTiq6RYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794533; c=relaxed/simple;
	bh=T9o2GN40GfQdAZ+btaba98mK/Wji5hwrxoGDHRxDY4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+obEN8SX5N6YCPQH4rXQPR8vrzX3NdCfPcFhpS4T5Gs2d1nkcj0NH9cGIgdmv863GTS5nFA3SS0VgRyreJw+d/JqQhT5XWXH1qNKJZX5sjGfkYs0TxKWNS7+EIZU3eyuq6iD3xxLJ1JdfHUJ/loTBsIcaPu9F/Be1AaECuzbpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ITQjGBut; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ITQjGBut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992E81F000FF;
	Wed, 30 Sep 2026 18:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794532;
	bh=k1NTazfqGzHtrw3Hy1SjInl88npSTkEwiWuXtiAR0Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ITQjGBut3WnK7zL7cSiXnK+UGnO76uH17YH6rXnYSyj1wsYNZxHbKsKkYXUtFK0Rs
	 QY9e2I7/qd/jHWOROSXszTUekFhh41UZJbjM4SxVgCJK2kb2BoWolM/BYE6Tzw0563
	 wutYdwd5L3uZqrQRCVFppx0kuDw2wA9DYh/6O37M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0245/1193] PCI: altera: Protect root bus removal with rescan lock
Date: Wed, 30 Sep 2026 17:15:29 +0200
Message-ID: <20260930152439.634877956@linuxfoundation.org>
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
index 3ce6e1efbba50..b154fbeacd8cb 100644
--- a/drivers/pci/controller/pcie-altera.c
+++ b/drivers/pci/controller/pcie-altera.c
@@ -832,8 +832,10 @@ static void altera_pcie_remove(struct platform_device *pdev)
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



