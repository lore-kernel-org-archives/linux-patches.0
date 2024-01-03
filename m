Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7701C295;
	Wed,  3 Jan 2024 17:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="em8CCjOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076ECC433C7;
	Wed,  3 Jan 2024 17:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301704;
	bh=Gr5GOAgYgHy3g5efdcG969dObyrfCHvlyhzzCWcufOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=em8CCjOeqHnxHFFO61LZzKnMtOLnPXmkX25k6fE7gL+CQSBPRauX0ba9d1V2Dkg/g
	 iv1zns3jU/tbWEo9/lUX2c93pKqGOz+ZCXAudlCZGWDqHbDDOtncUqCyj6uxe1+V9e
	 Q5dDNlGaYCaWSho+EQxZcoKna9pUMpxvY/JIbYis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.15 94/95] device property: Allow const parameter to dev_fwnode()
Date: Wed,  3 Jan 2024 17:55:42 +0100
Message-ID: <20240103164908.151824053@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164853.921194838@linuxfoundation.org>
References: <20240103164853.921194838@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit b295d484b97081feba72b071ffcb72fb4638ccfd upstream.

It's not fully correct to take a const parameter pointer to a struct
and return a non-const pointer to a member of that struct.

Instead, introduce a const version of the dev_fwnode() API which takes
and returns const pointers and use it where it's applicable.

With this, convert dev_fwnode() to be a macro wrapper on top of const
and non-const APIs that chooses one based on the type.

Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Fixes: aade55c86033 ("device property: Add const qualifier to device_get_match_data() parameter")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Link: https://lore.kernel.org/r/20221004092129.19412-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/property.c  |   11 +++++++++--
 include/linux/property.h |    7 ++++++-
 2 files changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -18,12 +18,19 @@
 #include <linux/etherdevice.h>
 #include <linux/phy.h>
 
-struct fwnode_handle *dev_fwnode(const struct device *dev)
+struct fwnode_handle *__dev_fwnode(struct device *dev)
 {
 	return IS_ENABLED(CONFIG_OF) && dev->of_node ?
 		of_fwnode_handle(dev->of_node) : dev->fwnode;
 }
-EXPORT_SYMBOL_GPL(dev_fwnode);
+EXPORT_SYMBOL_GPL(__dev_fwnode);
+
+const struct fwnode_handle *__dev_fwnode_const(const struct device *dev)
+{
+	return IS_ENABLED(CONFIG_OF) && dev->of_node ?
+		of_fwnode_handle(dev->of_node) : dev->fwnode;
+}
+EXPORT_SYMBOL_GPL(__dev_fwnode_const);
 
 /**
  * device_property_present - check if a property of a device is present
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -31,7 +31,12 @@ enum dev_dma_attr {
 	DEV_DMA_COHERENT,
 };
 
-struct fwnode_handle *dev_fwnode(const struct device *dev);
+const struct fwnode_handle *__dev_fwnode_const(const struct device *dev);
+struct fwnode_handle *__dev_fwnode(struct device *dev);
+#define dev_fwnode(dev)							\
+	_Generic((dev),							\
+		 const struct device *: __dev_fwnode_const,	\
+		 struct device *: __dev_fwnode)(dev)
 
 bool device_property_present(struct device *dev, const char *propname);
 int device_property_read_u8_array(struct device *dev, const char *propname,


