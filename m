Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28716214A84;
	Sat, 12 Sep 2026 12:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216417; cv=none; b=dHhy4lne+X2TCtPVK4KxmMlhcpXIfOy7pvXupcRAAhanlgijYroUPdRXBRdf+1rXySFqy8CtdewVddsiOloaasLD2BgT/xbd9guSKKXxgH2xuSboQNXlWuQbZljKYQxJQOgfOVy5FIGqbUMEAFEsXR9ML0CoI2enp6SYbDaG+9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216417; c=relaxed/simple;
	bh=sqrVQ/UnySYS7jxUi4zyGrpmSq33Lkh4I02/n+jiRWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZ+CqlIBuQRuq+GNPv4jZD7HVoqcqrKvM8IEJJQ/k5vYYnW+JWsvKpQGHKLxwb45fulX7/lphgse9PEF5hdIfdoVYaomb1yAb4rcdfhW68nWkHk6y4nF0brbcYPY9BzRIh+pmUuUhFUoANpJsCD9rAd88cOFL7yiwymvvcTk0BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nFF+254Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nFF+254Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EBF1F000FF;
	Sat, 12 Sep 2026 12:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216415;
	bh=y3GfPDkEDIDXze1A9jSUNVNs2ENwe0SrYS8UhFnttRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nFF+254ZVDahJOUUWQ/5ZUrplUl5Qc2SAPQPKuZ8I6zhQEa0jhRBflnvOpwz5V7wN
	 eehRpAqgnsXgRhmQpm8ZS1GxmsU1lQACkN+Al75FMNvljuh4G1hG0OWJNd+8hCF8be
	 8Scyfhft3Hr5yEWjGfNLL4VibxT12ztQvvsie4G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Tariq <alitariq45892@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0731/1376] PCI: starfive: Fix Runtime PM handling and teardown ordering
Date: Sat, 12 Sep 2026 08:52:37 +0200
Message-ID: <20260912065623.838546799@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Ali Tariq <alitariq45892@gmail.com>

[ Upstream commit fb9f7973473fc30d62e0f5f90d59df8ef5223777 ]

The starfive_pcie_remove() path incorrectly disabled runtime PM
before executing plda_pcie_host_deinit(), which can cause unmanaged
hardware register access in plda_pcie_host_deinit() while power domains or
clocks are disabled.

Fix this by restructuring starfive_pcie_remove() to deinitialize the host
controller first while runtime PM is active, followed by a synchronous
pm_runtime_put_sync() and pm_runtime_disable().

This bug was found in automated AI review by sashiko-bot.

Fixes: 39b91eb40c6a ("PCI: starfive: Add JH7110 PCIe controller")
Closes: https://lore.kernel.org/linux-pci/20260712180440.423421F000E9@smtp.kernel.org/
Signed-off-by: Ali Tariq <alitariq45892@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260718133825.445041-1-alitariq45892@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/plda/pcie-starfive.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/plda/pcie-starfive.c b/drivers/pci/controller/plda/pcie-starfive.c
index 0a0b5a7d84d7e..d859c14eb1e23 100644
--- a/drivers/pci/controller/plda/pcie-starfive.c
+++ b/drivers/pci/controller/plda/pcie-starfive.c
@@ -431,9 +431,9 @@ static void starfive_pcie_remove(struct platform_device *pdev)
 {
 	struct starfive_jh7110_pcie *pcie = platform_get_drvdata(pdev);
 
-	pm_runtime_put(&pdev->dev);
-	pm_runtime_disable(&pdev->dev);
 	plda_pcie_host_deinit(&pcie->plda);
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
 	platform_set_drvdata(pdev, NULL);
 }
 
-- 
2.53.0



