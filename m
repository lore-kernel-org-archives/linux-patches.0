Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9078351DAEB;
	Wed, 30 Sep 2026 16:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784725; cv=none; b=KWA/LlpJZsDg6rzJ+bPwe9aFqA6hzvc2+CtM1qLnw4R4NsJ7pA2XQ9jBm8sr5hkAtTdKSWaA3wBAxXpM+wg+x3kZh/Jx1XQ4iwo5OFXTWJoHAmd8d05AKjDTFVLUfI/uPuLr6x5BamlYBVWfTM8mACIKXkpf6SXcMZORVWafTeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784725; c=relaxed/simple;
	bh=qYLKlIhgjJ1YmOj+OjfdbSvVsTJEUDREgjNrwuJAId0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZkp18SJKJffhzktN++haVcixLnDLM52m8e6CUrYJaciifeqkgPIeHEEUqZZEtXyp1WzI7CKG7UHSZhzKipDiSLR+t4wDr6g4Cj5xHHUf99myNhWSgy6wm/9yyKKUNhZpCEMzNrTSQN9uYr76iUpOIloUGZ6uNRgpIz/TxGUrCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mm7T5RR7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mm7T5RR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744611F0089B;
	Wed, 30 Sep 2026 16:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784720;
	bh=21VDLxKGKlHzZT2u3+FPNih2oQN32tnk1M6slWbILHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mm7T5RR7lNO2XZJeOBQbHbNRXB5rgJTBxBZ2BtUt4bF6PSdhjTgFtOR2iRUkkBkMg
	 CI0pzRHlKeF3YEAq2zvbGdHoNLgT0fo+deW3xZCjlS7LKPyZ2T9jU9or2KgMQ2OHui
	 IyDX4NzvAjOo8xatlrsmnJHZAZdxEke/FKQL6Y74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 210/982] PCI: altera: Protect root bus removal with rescan lock
Date: Wed, 30 Sep 2026 17:15:46 +0200
Message-ID: <20260930152421.318714389@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index afd03c47d6f5a..acdd8ed8c34fa 100644
--- a/drivers/pci/controller/pcie-altera.c
+++ b/drivers/pci/controller/pcie-altera.c
@@ -833,8 +833,10 @@ static int altera_pcie_remove(struct platform_device *pdev)
 	struct altera_pcie *pcie = platform_get_drvdata(pdev);
 	struct pci_host_bridge *bridge = pci_host_bridge_from_priv(pcie);
 
+	pci_lock_rescan_remove();
 	pci_stop_root_bus(bridge->bus);
 	pci_remove_root_bus(bridge->bus);
+	pci_unlock_rescan_remove();
 	altera_pcie_irq_teardown(pcie);
 
 	return 0;
-- 
2.53.0



