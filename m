Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E563D890D;
	Wed, 30 Sep 2026 16:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784729; cv=none; b=JepMIeuL0viIEE4FSEfyQQFmeLsGL/H4AUU2WDiIMxtB3xqiEWHv+qoMYmNJOa4vuIXaZbFsfjWniQZY+2/J7gXwZnoWvF4HbgxhIyp9TNZ99kZg9TLbLwk8joKr12Oe5F1LrgVo/06MzLJv/bW5kN/MVQ1PYgbmzYX21+10mIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784729; c=relaxed/simple;
	bh=LJuJU7E4AIqbrqjf2Djcn0oAQGBDoeXJecq7bFLQCXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtin8BBZlBOkzBRxqMNHC0yCcpr+RcX3OE3uqsQFLMZyeeFCxT3WV4PVhxydqz/ld6i2ITdHPkRG+1IpPFAHMjRC/hNswHeFo2Gffc7NFYmBmkI6DWtDbKZSkEJ8lOE3wyliokcQCJSg7eAyOgiwm4ofK0vf7R1YPabXsvM/pXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VX739Lnq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VX739Lnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CB51F000FF;
	Wed, 30 Sep 2026 16:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784725;
	bh=DerFdzOR7LlJZ3ZeKpZmeK98fx5CxHnUHPr/MYlt6hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VX739LnqUXtkhlvrwWNh9Nodrbd91N+tOQ4rxEVdd5Mvfq8vwOEISKj7jwNz9Q8vh
	 QOs+jmtWTo0mvvGzspgqRIIVChR1j3ebHI34om2PQnDBhVBrS6CBeoUGI2TsDNaLFK
	 j16ok9pzqeprKTAoJsLd5ggCDFxoTw94K+3QGgIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 212/982] PCI: mediatek: Protect root bus removal with rescan lock
Date: Wed, 30 Sep 2026 17:15:48 +0200
Message-ID: <20260930152421.361561193@linuxfoundation.org>
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

[ Upstream commit a29812a55da8d0dbeb071b26ac428c338e3fc389 ]

Hold the pci_rescan_remove_lock lock while stopping and removing a root bus
to avoid racing with concurrent rescan or hotplug operations triggered via
sysfs.  Such races may lead to use-after-free issues or system crashes.

Signed-off-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260521161822.132996-7-18255117159@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mediatek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/pcie-mediatek.c b/drivers/pci/controller/pcie-mediatek.c
index 2697288af4708..c58f14de19f32 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -1174,8 +1174,10 @@ static int mtk_pcie_remove(struct platform_device *pdev)
 	struct mtk_pcie *pcie = platform_get_drvdata(pdev);
 	struct pci_host_bridge *host = pci_host_bridge_from_priv(pcie);
 
+	pci_lock_rescan_remove();
 	pci_stop_root_bus(host->bus);
 	pci_remove_root_bus(host->bus);
+	pci_unlock_rescan_remove();
 	mtk_pcie_free_resources(pcie);
 
 	mtk_pcie_irq_teardown(pcie);
-- 
2.53.0



