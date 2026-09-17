Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108C1502D54;
	Thu, 17 Sep 2026 18:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668170; cv=none; b=nETVNAOIXVL7+1PhcYYn5Rpz4iKKQ2AYTLQ31ii9rm1pAg5K4yHJfskeVdltjAzTEEQ7jyZ8hzZsb++cRrkFb+vaZu4uPR7fF4IReuIJdtdCejfuf/8kPK2I32PmB9iu9YG8MaMh1/sCdOKLWlTf50ipzSgv8HrUXFZRVOugTzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668170; c=relaxed/simple;
	bh=yJmBWy9V0lkEFTnpUKhWFIb4F23nENolhB4xpbKfdag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyBohJlKibvAihhpjGjziGKYPCPZi55dpmj4YhMC4c7mH7rGPZJmVkPldzWLtQTjcexp/I1NV/jHV2iSk+Qu2q+KQ18tbALQowD95bhw/41mfqvUSXQY8VRpynJg2bgFCmmpj73LhdP+Xnfj/axn6wNBPDLqd2uFkMT53QC138E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=veaQgOq8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="veaQgOq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668CF1F000FF;
	Thu, 17 Sep 2026 18:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668169;
	bh=9cJwB8VjBuca95+PZeheaF8xbOjcEttgmq/exk0YMC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=veaQgOq8aPUnWqZHZKhHZlBcemmy3TVlRtnc6w62kFE0/5gy7CesG0ir0VWLBqPFR
	 9WEEptJ37DGnaflIy4aDyqNxdgrgQ6RiJoftnJaLazckj2uD2dpp4V/P/K0IcBXtAF
	 dskI9urPZQVJpcnfFlu3w5puNuRd7FdgE+6uznWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0337/1102] PCI: mediatek: Protect root bus removal with rescan lock
Date: Thu, 17 Sep 2026 16:04:40 +0100
Message-ID: <20260917151548.095651322@linuxfoundation.org>
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
index 18d4a0615bc88..a9e483e051a60 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -1166,8 +1166,10 @@ static void mtk_pcie_remove(struct platform_device *pdev)
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



