Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6260B26CE2B;
	Tue, 12 Aug 2025 18:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024509; cv=none; b=J6B7L55siNlhiLzg4Jgh8zjUdaeq6VEnVHRKQtENvlk5sCF7pCavxWdLQ4cjfhgG5AlY/aacXl0w5qfZsb25G1+PFjzhd8Q6XfXGxNzR6ONGn5id0DL6HbwcX+Xzxk1TVGLh04APUKvqUBDI1TI5Xa4GGd8wYrJKvF7XsicAzJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024509; c=relaxed/simple;
	bh=BJPPMwPGOiPmKsYLt2/PvA5pI3E5IzhS+S2/GAur2Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MC7mt4YpbBkbIWm5+jlc2HtVQ7BYiVczhBVy1rLUW46FXi6cbwXVF9NBhKVUkauuxmFQuc5krblrigvEp6Q8CseOfxwJVDYcbdtbZHo4a74Es14gwnM+An3mkXLAmJRwrxOUZyYPTrdxQG4tjn4ksfhu64ZkmM8dfUHRM3Fqu+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ubjCqbq3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ubjCqbq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F89C4CEF0;
	Tue, 12 Aug 2025 18:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024509;
	bh=BJPPMwPGOiPmKsYLt2/PvA5pI3E5IzhS+S2/GAur2Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ubjCqbq3ayFu2S1nGWaTIHGyLl2gZZnfhZj0WIKwbIanjxBOj5BMUO4faILYUBZ7y
	 WvivW4EC0cRL4ubPoNggs4BkXvce3+N5vmDTBOOUIbwmKO1PodLPJ+Q0j8w+1Bil7h
	 Y6CBiAdbn9lTF4gihMYtoI6qqK/ySyhN7oLz2b3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will McVicker <willmcvicker@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 395/627] PCI: Fix driver_managed_dma check
Date: Tue, 12 Aug 2025 19:31:30 +0200
Message-ID: <20250812173434.324094643@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 67db34fd10ee..01e6aea1b0c7 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1628,7 +1628,7 @@ static int pci_bus_num_vf(struct device *dev)
  */
 static int pci_dma_configure(struct device *dev)
 {
-	struct pci_driver *driver = to_pci_driver(dev->driver);
+	const struct device_driver *drv = READ_ONCE(dev->driver);
 	struct device *bridge;
 	int ret = 0;
 
@@ -1645,8 +1645,8 @@ static int pci_dma_configure(struct device *dev)
 
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



