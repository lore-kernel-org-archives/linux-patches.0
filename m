Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88312135A0;
	Tue, 17 Jun 2025 16:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178607; cv=none; b=OTNbR8CMm6NkpzVbM6//M7IrlDBxGi9oUDb8sC3ejoWV48caT+95Dj/1v6h+9UIJfD8GuYo4unNw4qivuEL47+92pGboekon6EGAWoYHkICuvHgZI1C0h5szHeYLFDBG/fHlJ0E8dCWmLz5207zBiYQkF/WsVNR4AVg6DA0ksb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178607; c=relaxed/simple;
	bh=Oud/0JPoomWQmHFuIArSRUJ9FgDh+S8qSij29+Y1xSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQt+LJIvR+DZm3RuuMXmynf6l0X4SjSHMj3lfmmLIPM7Go95pyrGQK7r2HMdv9Vvib4AQjXYkR9CdKoT9II2Gxd8Gx+JHtOLHc2X/aMi4JsIS6baALRifkTRp+dpe1ey3PD+Kn6/MxIGobX2gav+A4WjX0hRmTJOJBCX0Exej3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GNyoJoDC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GNyoJoDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D837C4CEE3;
	Tue, 17 Jun 2025 16:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178607;
	bh=Oud/0JPoomWQmHFuIArSRUJ9FgDh+S8qSij29+Y1xSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GNyoJoDCxPPcukJRI8umGM27x2Olmy5cVkuGjx3oSNyuR/h4Lxwga1XNJspXVIzq0
	 AP3WWf1nsiLYFtzbWLRk/fx9lDnevDpYjbeOOFG1KY75qzirlExpV0FleS79+3pMSr
	 SVeS+7US/zkr/+Yo96BfVW3VIss1CVQEuDakcff4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 498/780] PCI: cadence: Fix runtime atomic count underflow
Date: Tue, 17 Jun 2025 17:23:26 +0200
Message-ID: <20250617152511.775038085@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8af95e9da7cec..741e10a575ec7 100644
--- a/drivers/pci/controller/cadence/pcie-cadence-host.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-host.c
@@ -570,14 +570,5 @@ int cdns_pcie_host_setup(struct cdns_pcie_rc *rc)
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



