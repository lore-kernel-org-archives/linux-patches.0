Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15AC2931FB;
	Sat, 12 Sep 2026 08:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200234; cv=none; b=rivCwX25F4FTKU8hz5FHeJH8tjEgUWpLXeWtqbs5dJjXJmNGBwDZdPEAH8Py4tmilevjnYuK0jXoyli7uFYY6xtqKDcG+XJXzlgYGwj17mU0udRtTwcoEQohOMJ4/2W8uNbGEpah5AYkgAwnSWQfumv4s2mVCTQY0wVeb2TnZ8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200234; c=relaxed/simple;
	bh=G7Nc8ONCMWH90FSZYNtCmbT2Ywo1emopxjvRIEXfano=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOR77adfUy8Gd+zzif07Y9TK8jMRPseS7FRCeAe0EWAiZwAvNyyFov4Z+CbjsnlZjeUMY6kQANet3j374vFSAoNeUc5yPxudh4kS4mrRLLNEpfBx5cNCDDrujkknXwE4ml/692miXKVbf7WT54+rlYklgd4hVN+Z9TK5cIjSFLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I1GyY2pg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I1GyY2pg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DAB1F000FF;
	Sat, 12 Sep 2026 08:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200233;
	bh=PegmSjJaTb+YZoX4j1TP6/Ixy2+oUW541S5MnAGTUCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I1GyY2pgF7noWdD3Csm+xhHHfdR99f8dmrIRLJ8SSNPCzKTS5hPZeQOV9wrqXWbl4
	 bYHNzkmAhTPkxg37Sr6NwRp4x3ysipxBWeH9bvGAJFSFzyQRSk2OaY8V6ceWXxF/3p
	 7QBNpcXDvXRu9wYEkJBojJuQWJRa2E/PFwYiQYhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Tariq <alitariq45892@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0748/1815] PCI: starfive: Fix Runtime PM handling and teardown ordering
Date: Sat, 12 Sep 2026 08:41:38 +0200
Message-ID: <20260912065706.464526128@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 628f8c8d67471..0ca39f3fa1d4f 100644
--- a/drivers/pci/controller/plda/pcie-starfive.c
+++ b/drivers/pci/controller/plda/pcie-starfive.c
@@ -445,9 +445,9 @@ static void starfive_pcie_remove(struct platform_device *pdev)
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



