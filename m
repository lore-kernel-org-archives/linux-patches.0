Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E3421A43B;
	Tue, 12 Aug 2025 19:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026272; cv=none; b=LdNa3t+TYigjdCgsLyoolf9RDbcV/nEC9UBv95RBvWJS/rwNg+PIcpTf8DaTRItT7lrRVfAPJmAubtqeuz5YZPptfBYZwgdheemrwuFk90dKZeuFI9mGi8grtvUN0dzOz2nSwTR32Jg3QyyAPR78fwI5NnPkBt6wCmeDhvGaALo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026272; c=relaxed/simple;
	bh=p9Hx426pxT5/sCRB+Q76EGy564uyy+ENs8HfYZWqa/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oew6MrYRnyt1dijrKWnFwpmVtV/fn0APqevsF9p1WVGO4ku+frNYKedoMU91j3vqgoaHCp+y//YT/k4a68T++1uevZPq63A28YIzRxlJZaeLbUOkScdqCwRQt6p/1MEF3lLiqjJ0BEKrinNjfRtd4XOf2X+pBOX6hXGMdTyjYZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THLNyhEh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THLNyhEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB52FC4CEF0;
	Tue, 12 Aug 2025 19:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026272;
	bh=p9Hx426pxT5/sCRB+Q76EGy564uyy+ENs8HfYZWqa/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=THLNyhEhyqiYNE7MQLFc8y2UKTZc3hg8Y6zwG++5Ov1UUG6ZbtMka10rMVU3YS2Hl
	 1h0QVFvhkKqituvbAff50CmCjClQVWxldyKaJMi7HD1ZHFETGNE5NuL45opa4ZpCk1
	 bKmPUGY4zYcL2PykUuhp1iIa/2a6seQQik3xSqBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will McVicker <willmcvicker@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 287/480] PCI: Fix driver_managed_dma check
Date: Tue, 12 Aug 2025 19:48:15 +0200
Message-ID: <20250812174409.267769872@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 78447d4545b2ea76ee04f4e46d473639483158b2 ]

Since it's not currently safe to take device_lock() in the IOMMU probe
path, that can race against really_probe() setting dev->driver before
attempting to bind. The race itself isn't so bad, since we're only
concerned with dereferencing dev->driver itself anyway, but sadly my
attempt to implement the check with minimal churn leads to a kind of
Time-of-Check to Time-of-Use (TOCTOU) issue, where dev->driver becomes
valid after to_pci_driver(NULL) is already computed, and thus the check
fails to work as intended.

Will and I both hit this with the platform bus, but the pattern here is
the same, so fix it for correctness too.

Fixes: bcb81ac6ae3c ("iommu: Get DT/ACPI parsing into the proper probe path")
Reported-by: Will McVicker <willmcvicker@google.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Will McVicker <willmcvicker@google.com>
Link: https://patch.msgid.link/20250425133929.646493-4-robin.murphy@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-driver.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index c8bd71a739f7..66e3bea7dc1a 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1634,7 +1634,7 @@ static int pci_bus_num_vf(struct device *dev)
  */
 static int pci_dma_configure(struct device *dev)
 {
-	struct pci_driver *driver = to_pci_driver(dev->driver);
+	const struct device_driver *drv = READ_ONCE(dev->driver);
 	struct device *bridge;
 	int ret = 0;
 
@@ -1651,8 +1651,8 @@ static int pci_dma_configure(struct device *dev)
 
 	pci_put_host_bridge_device(bridge);
 
-	/* @driver may not be valid when we're called from the IOMMU layer */
-	if (!ret && dev->driver && !driver->driver_managed_dma) {
+	/* @drv may not be valid when we're called from the IOMMU layer */
+	if (!ret && drv && !to_pci_driver(drv)->driver_managed_dma) {
 		ret = iommu_device_use_default_domain(dev);
 		if (ret)
 			arch_teardown_dma_ops(dev);
-- 
2.39.5



