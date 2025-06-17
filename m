Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A312F2C7E;
	Tue, 17 Jun 2025 16:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178020; cv=none; b=kIXSUVHGKDM7ysAWcJeCMLl11TRTTFbKdK3a7oZQmGz9yhuS8j+deYIJxIJGt+QLI7wk8oqlh5Cqu2JXv/DG6/PsmHocAiIL/cgbbFQziDW8CLciiuj5Ms+cEEJyfpAZmQ4K5Xa4/CGDp6eiXvIaV47wGajETLvaJk9RcGf/Hag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178020; c=relaxed/simple;
	bh=arlLoX297ebA2X1P5DBT5YNjRwyuRiTelOYGu8GDD54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tsCjLJ2cafr0QeLWb+ReT0QCUiUBY1iTAgN7jYwv+iuejFcBrFIxnY4OAAbNdnFcOHO506UOEhUKmZSNfAjTzjWAQ2s+pWodqvaj9urAQGRouvX0rDt2kjCl6xmQXbqAcmrbh/5XlFBtnZgs5psW6YVVP1mq8lRu8gJ+mTjmmxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnDpJ8ot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnDpJ8ot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A96C4AF09;
	Tue, 17 Jun 2025 16:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178020;
	bh=arlLoX297ebA2X1P5DBT5YNjRwyuRiTelOYGu8GDD54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnDpJ8otq7kJUoJOtYp3BHl9SaloFN0tYwEJ1YDCvK3JT3vS41b3EWPxjiydWJNP7
	 jtY7N0Wbfrgf2vHiYg+WIr9EYL4lBE8DG3i9ZOqjC3libTWtKlUw8p9/hg8uk4qbmH
	 eqWD0Fcl/GE5HX7bdHNu1WSbQUJ08PUYHcgaY1/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will McVicker <willmcvicker@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 397/780] bus: fsl_mc: Fix driver_managed_dma check
Date: Tue, 17 Jun 2025 17:21:45 +0200
Message-ID: <20250617152507.622703505@linuxfoundation.org>
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

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 152f33ee30ee6a7f4c15bedd7529dc5945315547 ]

Since it's not currently safe to take device_lock() in the IOMMU probe
path, that can race against really_probe() setting dev->driver before
attempting to bind. The race itself isn't so bad, since we're only
concerned with dereferencing dev->driver itself anyway, but sadly my
attempt to implement the check with minimal churn leads to a kind of
TOCTOU issue, where dev->driver becomes valid after to_fsl_mc_driver(NULL)
is already computed, and thus the check fails to work as intended.

Will and I both hit this with the platform bus, but the pattern here is
the same, so fix it for correctness too.

Reported-by: Will McVicker <willmcvicker@google.com>
Fixes: bcb81ac6ae3c ("iommu: Get DT/ACPI parsing into the proper probe path")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Will McVicker <willmcvicker@google.com>
Link: https://lore.kernel.org/r/20250425133929.646493-3-robin.murphy@arm.com
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/fsl-mc/fsl-mc-bus.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/bus/fsl-mc/fsl-mc-bus.c b/drivers/bus/fsl-mc/fsl-mc-bus.c
index 0c3a38d7f3358..7671bd1585455 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -139,9 +139,9 @@ static int fsl_mc_bus_uevent(const struct device *dev, struct kobj_uevent_env *e
 
 static int fsl_mc_dma_configure(struct device *dev)
 {
+	const struct device_driver *drv = READ_ONCE(dev->driver);
 	struct device *dma_dev = dev;
 	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
-	struct fsl_mc_driver *mc_drv = to_fsl_mc_driver(dev->driver);
 	u32 input_id = mc_dev->icid;
 	int ret;
 
@@ -153,8 +153,8 @@ static int fsl_mc_dma_configure(struct device *dev)
 	else
 		ret = acpi_dma_configure_id(dev, DEV_DMA_COHERENT, &input_id);
 
-	/* @mc_drv may not be valid when we're called from the IOMMU layer */
-	if (!ret && dev->driver && !mc_drv->driver_managed_dma) {
+	/* @drv may not be valid when we're called from the IOMMU layer */
+	if (!ret && drv && !to_fsl_mc_driver(drv)->driver_managed_dma) {
 		ret = iommu_device_use_default_domain(dev);
 		if (ret)
 			arch_teardown_dma_ops(dev);
-- 
2.39.5



