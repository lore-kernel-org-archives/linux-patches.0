Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77523161AB;
	Mon, 13 Apr 2026 17:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099809; cv=none; b=dAf+ENJzW6QJ2pP6chwDoh9OgBA9PZc41tFYRfzFHO0eMpjlfF2fmbgrC6pJcmAH+YctmNhhs8z65IBgqNTNJdqgjKbUEA+1iAd38KITp6htFGY0aR+A5zkKa+YGjf/BbC//BGP8bu4bAS04yLhEyRna74QlryUq+/HCdZUga0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099809; c=relaxed/simple;
	bh=OZldNB+5GPuMv0qPawko7KRhCW1Kpgfm7CPl/jXjWsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ef3wSxffpwBhXP1yvG/ij/FV/OlixGBt4EwVhyirwqpH+R86BUF2gQ3yw4jt9SJfoVdtKVhREQSX44GKXOa+IKpodV2ZvIodKWwABg89pGDn7OAb3h0k8evqr4Xu5F7b6tWijsEha+NjmLnaOOgjkl3AAuR4B3AhiSaCnmC7eY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yv+blHOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yv+blHOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2FAC2BCAF;
	Mon, 13 Apr 2026 17:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099808;
	bh=OZldNB+5GPuMv0qPawko7KRhCW1Kpgfm7CPl/jXjWsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yv+blHOzzT7RfuYe9n3W8xKZ9mKBlD/Y5YWqN2LsGEemifBqUmGaLnRwdKO9vTLek
	 sVjPgRBeZBy7ftziMpGNMXJOL99e1YhRZCFgbN6XlhwZ35MOH+vdZMmuj/ZY5MYG17
	 3dfANADIFAKt1rvCWqcxK2JShAEqW9bSV+nO5rwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 482/491] device property: Unify access to of_node
Date: Mon, 13 Apr 2026 18:02:07 +0200
Message-ID: <20260413155837.097914187@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit fb38f314fbd173e2e9f9f0f2e720a5f4889562da ]

Historically we have a few variants how we access dev->fwnode
and dev->of_node. Some of the functions during development
gained different versions of the getters. Unify access to of_node
and as a side change slightly refactor ACPI specific branches.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 2692c614f8f0 ("device property: Allow secondary lookup in fwnode_get_next_child_node()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/property.c  |   29 +++++++++++++----------------
 include/linux/property.h |    2 +-
 2 files changed, 14 insertions(+), 17 deletions(-)

--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -759,13 +759,8 @@ EXPORT_SYMBOL_GPL(fwnode_get_next_availa
 struct fwnode_handle *device_get_next_child_node(struct device *dev,
 						 struct fwnode_handle *child)
 {
-	struct acpi_device *adev = ACPI_COMPANION(dev);
-	struct fwnode_handle *fwnode = NULL, *next;
-
-	if (dev->of_node)
-		fwnode = of_fwnode_handle(dev->of_node);
-	else if (adev)
-		fwnode = acpi_fwnode_handle(adev);
+	const struct fwnode_handle *fwnode = dev_fwnode(dev);
+	struct fwnode_handle *next;
 
 	/* Try to find a child in primary fwnode */
 	next = fwnode_get_next_child_node(fwnode, child);
@@ -868,28 +863,31 @@ EXPORT_SYMBOL_GPL(device_get_child_node_
 
 bool device_dma_supported(struct device *dev)
 {
+	const struct fwnode_handle *fwnode = dev_fwnode(dev);
+
 	/* For DT, this is always supported.
 	 * For ACPI, this depends on CCA, which
 	 * is determined by the acpi_dma_supported().
 	 */
-	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
+	if (is_of_node(fwnode))
 		return true;
 
-	return acpi_dma_supported(ACPI_COMPANION(dev));
+	return acpi_dma_supported(to_acpi_device_node(fwnode));
 }
 EXPORT_SYMBOL_GPL(device_dma_supported);
 
 enum dev_dma_attr device_get_dma_attr(struct device *dev)
 {
+	const struct fwnode_handle *fwnode = dev_fwnode(dev);
 	enum dev_dma_attr attr = DEV_DMA_NOT_SUPPORTED;
 
-	if (IS_ENABLED(CONFIG_OF) && dev->of_node) {
-		if (of_dma_is_coherent(dev->of_node))
+	if (is_of_node(fwnode)) {
+		if (of_dma_is_coherent(to_of_node(fwnode)))
 			attr = DEV_DMA_COHERENT;
 		else
 			attr = DEV_DMA_NON_COHERENT;
 	} else
-		attr = acpi_get_dma_attr(ACPI_COMPANION(dev));
+		attr = acpi_get_dma_attr(to_acpi_device_node(fwnode));
 
 	return attr;
 }
@@ -1007,14 +1005,13 @@ EXPORT_SYMBOL(device_get_mac_address);
  * Returns Linux IRQ number on success. Other values are determined
  * accordingly to acpi_/of_ irq_get() operation.
  */
-int fwnode_irq_get(struct fwnode_handle *fwnode, unsigned int index)
+int fwnode_irq_get(const struct fwnode_handle *fwnode, unsigned int index)
 {
-	struct device_node *of_node = to_of_node(fwnode);
 	struct resource res;
 	int ret;
 
-	if (IS_ENABLED(CONFIG_OF) && of_node)
-		return of_irq_get(of_node, index);
+	if (is_of_node(fwnode))
+		return of_irq_get(to_of_node(fwnode), index);
 
 	ret = acpi_irq_get(ACPI_HANDLE_FWNODE(fwnode), index, &res);
 	if (ret)
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -119,7 +119,7 @@ struct fwnode_handle *device_get_named_c
 struct fwnode_handle *fwnode_handle_get(struct fwnode_handle *fwnode);
 void fwnode_handle_put(struct fwnode_handle *fwnode);
 
-int fwnode_irq_get(struct fwnode_handle *fwnode, unsigned int index);
+int fwnode_irq_get(const struct fwnode_handle *fwnode, unsigned int index);
 
 unsigned int device_get_child_node_count(struct device *dev);
 


