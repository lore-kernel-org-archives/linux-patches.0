Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15F44D7D26;
	Wed, 30 Sep 2026 15:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782708; cv=none; b=j0qqxS2ItD3HZI/8eH6egPHG2qcRngKqBDuoYikJPYcdXRqBJ7DQYAx/7Nq48Jf/PCKOcreVoEFz0QEwtVFIrAEapU6ccbI4wrVDXhBmG0l4YFPy0r3spD/jIJkWKT6wiA7nNAQctm4L5daLd8a8Sc4bJr2GU85KcmYMvakzbQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782708; c=relaxed/simple;
	bh=4rUKsajbLxrOA7Zaz1c74BbxBaY0W+XRc/Z5JsAY0fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2dRBLkb0kTfSAXhu8+s64TASCK9+lTiEAWFSU3ITPe/KQWaACD9NGNgolsTcnOP/0Pp8dZhmSjOa7eneZ80/UUQ30gk4jUMKaNGzldUteQZGQT+4494zoQ+hPMbEPp70FH+nvHKXdOpcN7KUfn2Otuz4qpr6q0qJggH12Sj1YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dUzz3cxs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dUzz3cxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663A41F00899;
	Wed, 30 Sep 2026 15:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782697;
	bh=W041xjGyoLspJ1lGMytcBgFKpxmzeTy40YJ4aCtcryA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dUzz3cxsv9sQy/7QYpqR84xfw6VJpZOyPMCmgD4OKCvqsiseVX4LaflMMPA2hLBOO
	 smsxOL+k7lpuWDimWOPg6fs6ApRrkKARVKUVOkmPF6WqVJQD3M25uZwT3MbeVAZnDr
	 7Xfwx6/fAKOCZ9CmHTWtnx1obVLQNICejvgWUJwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 138/595] PCI: altera: Protect root bus removal with rescan lock
Date: Wed, 30 Sep 2026 17:20:31 +0200
Message-ID: <20260930152350.703283759@linuxfoundation.org>
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
index 68a1bdcf02f82..d7089000521cc 100644
--- a/drivers/pci/controller/pcie-altera.c
+++ b/drivers/pci/controller/pcie-altera.c
@@ -837,8 +837,10 @@ static int altera_pcie_remove(struct platform_device *pdev)
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



