Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C44A1E521E;
	Mon, 23 Jun 2025 21:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713859; cv=none; b=bD4TN2T+cEnV42n5dZ8kFhQ97AWZzPgGnIzHPe13NZHhHURyBJr6A8hEvUrvafFhd08zyt2B9FU7aRLMxDO3hwPMvLt25Chyighe5HRIetFEKEVzEKZk5lCiqm/zAJfPus6GvzYtQ2hA818YI1HX/oOi2Xy12wafxb2qL+90zD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713859; c=relaxed/simple;
	bh=i9NpcQM5xOaWT8Qom7lAsNmrdVVI/pgLxdJk8yHzHOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2DorqDa1NAlSdaPbmXV2vIcFpA46s5YEe1MV7IAXNHOeRhZvCSLzE1y+2nV41f1Pw3ugjJp9CngoJzUImaRr88F2Krq/soQ/KzKudreP2DdWuymIJvS+kupDf7zw5fJeneEb/686GOGyPeqlBI83NutFSQubuZan6AAfCmrltY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HRBFOpWo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HRBFOpWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3443CC4CEEA;
	Mon, 23 Jun 2025 21:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713859;
	bh=i9NpcQM5xOaWT8Qom7lAsNmrdVVI/pgLxdJk8yHzHOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HRBFOpWoY06u6qg00l8QKbGMCLD4Lv+pn9G9YK9Z2ygVKhTxfkGcj9tCUbv9C5zXW
	 Tbl+5sl5zyJpSzcsINGVJ0K1ziw260Xv5PcMb3onQeeWgCWpcouNW57cRivCttfFpn
	 j+HWOhjqqO/0wQ8HZx1Mryrdz5Lr+po+iBAxVlkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 151/508] PCI: cadence: Fix runtime atomic count underflow
Date: Mon, 23 Jun 2025 15:03:16 +0200
Message-ID: <20250623130648.996587795@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 8805f32a96d3b97cef07999fa6f52112678f7e65 ]

If the call to pci_host_probe() in cdns_pcie_host_setup() fails, PM
runtime count is decremented in the error path using pm_runtime_put_sync().
But the runtime count is not incremented by this driver, but only by the
callers (cdns_plat_pcie_probe/j721e_pcie_probe). And the callers also
decrement the runtime PM count in their error path. So this leads to the
below warning from the PM core:

	"runtime PM usage count underflow!"

So fix it by getting rid of pm_runtime_put_sync() in the error path and
directly return the errno.

Fixes: 49e427e6bdd1 ("Merge branch 'pci/host-probe-refactor'")
Signed-off-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://patch.msgid.link/20250419133058.162048-1-18255117159@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pcie-cadence-host.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/pci/controller/cadence/pcie-cadence-host.c b/drivers/pci/controller/cadence/pcie-cadence-host.c
index 5b14f7ee3c798..0a1b11d41a38a 100644
--- a/drivers/pci/controller/cadence/pcie-cadence-host.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-host.c
@@ -558,14 +558,5 @@ int cdns_pcie_host_setup(struct cdns_pcie_rc *rc)
 	if (!bridge->ops)
 		bridge->ops = &cdns_pcie_host_ops;
 
-	ret = pci_host_probe(bridge);
-	if (ret < 0)
-		goto err_init;
-
-	return 0;
-
- err_init:
-	pm_runtime_put_sync(dev);
-
-	return ret;
+	return pci_host_probe(bridge);
 }
-- 
2.39.5



