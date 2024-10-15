Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FBE1C57B1;
	Tue, 15 Oct 2024 12:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993933; cv=none; b=hCcgWz+fYIwdwaV0ZFOWwvEuCalM1YITuFV1FVrn3h/b9+95epIut/HOdA41zd3f/vi1ny/qUdwcuK5lVtGjfmHmjZ96Kgc3uUktPg5yeDAZKHp9iEjceoWvXv/043+AJmmue83NEGkGYjYyzsNiVxNH6tkWPbIknJ4pYEMRnkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993933; c=relaxed/simple;
	bh=QckrsCEl35rfwqJoBCvNCV/zVdHBTbMvgkHffWtDDCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3SafdQ0TxpTePj+nRQ2c69H+qRVK7/9/AQI0bN6Nwgj0QyoeORJABzaVg4k8nnN24pWRkfY1LGfPyFqk1vQ7CjxiJhegwDbDrLl79z7qLehDQRCIqU4FuwGFcaSZJhbb30F/t0Vp5ixsvDKIQTtdmwYVRQB7uK7tjeahwksNFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vt9nUGoo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vt9nUGoo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5395C4CEC6;
	Tue, 15 Oct 2024 12:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993933;
	bh=QckrsCEl35rfwqJoBCvNCV/zVdHBTbMvgkHffWtDDCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vt9nUGoo8FcJnBNQICYsxPiziybLjOc7yQrOTxVfidX35bQKcgts8sUl9I9L2w0Iy
	 HGxZ2p0Pvn+SiBrRY2q/IHs9bwRZLe4mcCclFdpE4FEb4vho6ovxE3luSgtFDdJ5gO
	 Inw1B9n5YshB8FBwtXSYPNRpMcgn/Cf2G69Lu83M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Anand Ashok Dumbre <anand.ashok.dumbre@xilinx.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 550/691] device property: Add fwnode_iomap()
Date: Tue, 15 Oct 2024 13:28:18 +0200
Message-ID: <20241015112502.170230814@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anand Ashok Dumbre <anand.ashok.dumbre@xilinx.com>

[ Upstream commit eca6e2d4a4a4b824f055eeaaa24f1c2327fb91a2 ]

This patch introduces a new helper routine - fwnode_iomap(), which
allows to map the memory mapped IO for a given device node.

This implementation does not cover the ACPI case and may be expanded
in the future. The main purpose here is to be able to develop resource
provider agnostic drivers.

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Anand Ashok Dumbre <anand.ashok.dumbre@xilinx.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/20211203212358.31444-2-anand.ashok.dumbre@xilinx.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 8d3cefaf6592 ("i2c: core: Lock address during client device instantiation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/property.c  | 16 ++++++++++++++++
 include/linux/property.h |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index 21f4184db42fc..87bb97e12749e 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -1050,6 +1050,22 @@ int fwnode_irq_get(const struct fwnode_handle *fwnode, unsigned int index)
 }
 EXPORT_SYMBOL(fwnode_irq_get);
 
+/**
+ * fwnode_iomap - Maps the memory mapped IO for a given fwnode
+ * @fwnode:	Pointer to the firmware node
+ * @index:	Index of the IO range
+ *
+ * Returns a pointer to the mapped memory.
+ */
+void __iomem *fwnode_iomap(struct fwnode_handle *fwnode, int index)
+{
+	if (IS_ENABLED(CONFIG_OF_ADDRESS) && is_of_node(fwnode))
+		return of_iomap(to_of_node(fwnode), index);
+
+	return NULL;
+}
+EXPORT_SYMBOL(fwnode_iomap);
+
 /**
  * fwnode_graph_get_next_endpoint - Get next endpoint firmware node
  * @fwnode: Pointer to the parent firmware node
diff --git a/include/linux/property.h b/include/linux/property.h
index fe2092e39aedb..032262e3d9991 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -126,6 +126,8 @@ void fwnode_handle_put(struct fwnode_handle *fwnode);
 
 int fwnode_irq_get(const struct fwnode_handle *fwnode, unsigned int index);
 
+void __iomem *fwnode_iomap(struct fwnode_handle *fwnode, int index);
+
 unsigned int device_get_child_node_count(struct device *dev);
 
 static inline bool device_property_read_bool(struct device *dev,
-- 
2.43.0



