Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38858248895;
	Mon, 23 Jun 2025 13:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686025; cv=none; b=e9FjDhxcr/WdlG7JT4jU0ar1Gs8eiO6PP5VrL5pa3AKDWkfKE/PAN7S/wEIEIYsYZYrX47kLbeby/yNiWH9ac3fsDiteA4TByEBD4aL3UjkekqCn3UF8409qkgwDw9M/++910iyB3d01MzV16MU+JVikJhRLA/xII9yRq+L8nfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686025; c=relaxed/simple;
	bh=bVviD4o6xDnv1TzBKlQSVe+5odYPWckJ/QQMZF5KH4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ESK1DBEpoSYN9Ea3y66njrM31Zw0q+puEYS235LFxWzn0E6dAwCz4TuqQU7iwPxGS6xh6WQtTcQOoOjSjycg9WlxzWrvX/AGXU+sxvNHwZG1XydFgjlHPqFk0gSE7UGG048FWxtBIPj1jE8qNpTVRTO6eGq3CRaJsbYlgMw2qpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YuEgkMQ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YuEgkMQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD61C4CEEA;
	Mon, 23 Jun 2025 13:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686025;
	bh=bVviD4o6xDnv1TzBKlQSVe+5odYPWckJ/QQMZF5KH4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YuEgkMQ0znhc0JXZ/69VctzERRSiBA0tWygv0FWT299PEkfAarZyluMCrRMvJXsa6
	 x8RqsIInfIS6/20sBWAd2mvmsHiDL27jaa+Rq1TuT8FuQRPR2ETMmCK7afe2ZvXKO6
	 dx15cmYHJNQ35SCBMKA+jb6Lv+Lv/z1CcWnA5bHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/355] PCI: cadence: Fix runtime atomic count underflow
Date: Mon, 23 Jun 2025 15:04:47 +0200
Message-ID: <20250623130629.392276908@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4d8d15ac51ef4..c29176bdecd19 100644
--- a/drivers/pci/controller/cadence/pcie-cadence-host.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-host.c
@@ -548,14 +548,5 @@ int cdns_pcie_host_setup(struct cdns_pcie_rc *rc)
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



