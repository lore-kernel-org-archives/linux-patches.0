Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B53503BF7;
	Wed, 30 Sep 2026 17:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791052; cv=none; b=icFEdWOnHRQQ80pbh7+YqdpMLFHN72varErpAuaCFJEXRUvHEv4cB/529JD91LLNDGNChYE3agQ3NMYnCPA+6zh5JQr27fXfI98TPGoCN2BA7oJlAsxb3gApgb3q4t1C0O4AqO/Qd/xyV2NBaHbdwkHkqgWAr8Fin2pRqfWXkl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791052; c=relaxed/simple;
	bh=G6vytlJWHEheFgzSnl/JO6h4MlHbYgyXfqoUTMFVzoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ufrAqQJasxx9rAgx2XkpZFAtDmB0+fqeEPFQqLpJu85jMn5riRw+Qij240uXvseC+GMj1X4lMAWaJJ0pTaOXKEcQMxV2QfxGhQFfHAx97gz8TwMlK58deNfegyTgmmIPXyy655HDcoHdv5SRHl8ib5RbigN/qAv2FtxAoB1f/4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v94oWq5c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v94oWq5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70561F000FF;
	Wed, 30 Sep 2026 17:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791051;
	bh=Cb8p6K0Vwi9YbXYGqJc1hAgVMQOZ+10OWSWrjWIG0/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v94oWq5c85hfGGA+tZ3pzti9xjetPEJ1W8upsMu1O8ZGEVo/TQqI5NM7iZWwyNIT5
	 cue3g65onXWtV8Lw8ghg/7CpSUwhcZs5BIN+NCVcwW0/GX2id+k4q12xmOgnm+5U+A
	 sr/H2nGZ3ThkRDJjNf+frKQgjD8CtGVyec60YFh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 166/752] PCI: mediatek: Protect root bus removal with rescan lock
Date: Wed, 30 Sep 2026 17:20:36 +0200
Message-ID: <20260930152401.790795188@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9302864b5d2ea..0be3eb2717a11 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -1179,8 +1179,10 @@ static int mtk_pcie_remove(struct platform_device *pdev)
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



