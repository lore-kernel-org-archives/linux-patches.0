Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F3B143724;
	Thu, 13 Jun 2024 12:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282247; cv=none; b=UOwKpjV68OQnV7rNxVOeGKRATzNyytUXHkycRFVv3p9bkC4oAC2qhnfWGCrSy0HoRamhQIiZePDebeGQDRpJf30Ok4EsFBraqQU6LQsRM0OaFatqqSJLaKoM/Mlq+wxGVa0T9F7GS9Sg0xwwI3/Sa4dwcjYXb6uiZT36FV2eNDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282247; c=relaxed/simple;
	bh=81kTT1X9TlGPgzylZS4FV41N6y7wXEYlW1EVkmkCYbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJQMzSUZdg03a3pFOm83sJWmmRz0px0fb3xCHg4QSDdgjGJT6PBII1T2VJkNfOtsY8l9W1f8Qb5ORLbNSDIebGrQC5h42rHARSHnyloqYh/jDgxyC741lsElc26x4ODX7paatbFLobWrHtBASGIc6vLRYo90PNSU11sqCzcim7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UoVB0myj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UoVB0myj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AEF8C2BBFC;
	Thu, 13 Jun 2024 12:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282246;
	bh=81kTT1X9TlGPgzylZS4FV41N6y7wXEYlW1EVkmkCYbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UoVB0myjyLtnfgORstGFVX/Y0NtdVDxCNQcUjCB1Q6EeAUqB8znDKgUYDsYBVP+9B
	 xSEjNOAgQkbdMZmpbjFv4csZlt/DIOtWSXuQEJdYeBsgNB/J/LlJkHmetnc4+7A98N
	 n3YsVSojKBhDH0eml9eXcnVENqsS/4gIT5gJ2S9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yilun <yilun.xu@intel.com>,
	Russ Weight <russ.weight@linux.dev>,
	Marco Pagani <marpagan@redhat.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 211/402] fpga: region: add owner module and take its refcount
Date: Thu, 13 Jun 2024 13:32:48 +0200
Message-ID: <20240613113310.378344394@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

From: Marco Pagani <marpagan@redhat.com>

[ Upstream commit b7c0e1ecee403a43abc89eb3e75672b01ff2ece9 ]

The current implementation of the fpga region assumes that the low-level
module registers a driver for the parent device and uses its owner pointer
to take the module's refcount. This approach is problematic since it can
lead to a null pointer dereference while attempting to get the region
during programming if the parent device does not have a driver.

To address this problem, add a module owner pointer to the fpga_region
struct and use it to take the module's refcount. Modify the functions for
registering a region to take an additional owner module parameter and
rename them to avoid conflicts. Use the old function names for helper
macros that automatically set the module that registers the region as the
owner. This ensures compatibility with existing low-level control modules
and reduces the chances of registering a region without setting the owner.

Also, update the documentation to keep it consistent with the new interface
for registering an fpga region.

Fixes: 0fa20cdfcc1f ("fpga: fpga-region: device tree control for FPGA")
Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Suggested-by: Xu Yilun <yilun.xu@intel.com>
Reviewed-by: Russ Weight <russ.weight@linux.dev>
Signed-off-by: Marco Pagani <marpagan@redhat.com>
Acked-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20240419083601.77403-1-marpagan@redhat.com
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/driver-api/fpga/fpga-region.rst | 13 ++++++----
 drivers/fpga/fpga-region.c                    | 24 +++++++++++--------
 include/linux/fpga/fpga-region.h              | 13 +++++++---
 3 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/Documentation/driver-api/fpga/fpga-region.rst b/Documentation/driver-api/fpga/fpga-region.rst
index dc55d60a0b4a5..2d03b5fb76575 100644
--- a/Documentation/driver-api/fpga/fpga-region.rst
+++ b/Documentation/driver-api/fpga/fpga-region.rst
@@ -46,13 +46,16 @@ API to add a new FPGA region
 ----------------------------
 
 * struct fpga_region - The FPGA region struct
-* struct fpga_region_info - Parameter structure for fpga_region_register_full()
-* fpga_region_register_full() -  Create and register an FPGA region using the
+* struct fpga_region_info - Parameter structure for __fpga_region_register_full()
+* __fpga_region_register_full() -  Create and register an FPGA region using the
   fpga_region_info structure to provide the full flexibility of options
-* fpga_region_register() -  Create and register an FPGA region using standard
+* __fpga_region_register() -  Create and register an FPGA region using standard
   arguments
 * fpga_region_unregister() -  Unregister an FPGA region
 
+Helper macros ``fpga_region_register()`` and ``fpga_region_register_full()``
+automatically set the module that registers the FPGA region as the owner.
+
 The FPGA region's probe function will need to get a reference to the FPGA
 Manager it will be using to do the programming.  This usually would happen
 during the region's probe function.
@@ -82,10 +85,10 @@ following APIs to handle building or tearing down that list.
    :functions: fpga_region_info
 
 .. kernel-doc:: drivers/fpga/fpga-region.c
-   :functions: fpga_region_register_full
+   :functions: __fpga_region_register_full
 
 .. kernel-doc:: drivers/fpga/fpga-region.c
-   :functions: fpga_region_register
+   :functions: __fpga_region_register
 
 .. kernel-doc:: drivers/fpga/fpga-region.c
    :functions: fpga_region_unregister
diff --git a/drivers/fpga/fpga-region.c b/drivers/fpga/fpga-region.c
index b0ac18de4885d..d73daea579ac7 100644
--- a/drivers/fpga/fpga-region.c
+++ b/drivers/fpga/fpga-region.c
@@ -52,7 +52,7 @@ static struct fpga_region *fpga_region_get(struct fpga_region *region)
 	}
 
 	get_device(dev);
-	if (!try_module_get(dev->parent->driver->owner)) {
+	if (!try_module_get(region->ops_owner)) {
 		put_device(dev);
 		mutex_unlock(&region->mutex);
 		return ERR_PTR(-ENODEV);
@@ -74,7 +74,7 @@ static void fpga_region_put(struct fpga_region *region)
 
 	dev_dbg(dev, "put\n");
 
-	module_put(dev->parent->driver->owner);
+	module_put(region->ops_owner);
 	put_device(dev);
 	mutex_unlock(&region->mutex);
 }
@@ -180,14 +180,16 @@ static struct attribute *fpga_region_attrs[] = {
 ATTRIBUTE_GROUPS(fpga_region);
 
 /**
- * fpga_region_register_full - create and register an FPGA Region device
+ * __fpga_region_register_full - create and register an FPGA Region device
  * @parent: device parent
  * @info: parameters for FPGA Region
+ * @owner: module containing the get_bridges function
  *
  * Return: struct fpga_region or ERR_PTR()
  */
 struct fpga_region *
-fpga_region_register_full(struct device *parent, const struct fpga_region_info *info)
+__fpga_region_register_full(struct device *parent, const struct fpga_region_info *info,
+			    struct module *owner)
 {
 	struct fpga_region *region;
 	int id, ret = 0;
@@ -212,6 +214,7 @@ fpga_region_register_full(struct device *parent, const struct fpga_region_info *
 	region->compat_id = info->compat_id;
 	region->priv = info->priv;
 	region->get_bridges = info->get_bridges;
+	region->ops_owner = owner;
 
 	mutex_init(&region->mutex);
 	INIT_LIST_HEAD(&region->bridge_list);
@@ -240,13 +243,14 @@ fpga_region_register_full(struct device *parent, const struct fpga_region_info *
 
 	return ERR_PTR(ret);
 }
-EXPORT_SYMBOL_GPL(fpga_region_register_full);
+EXPORT_SYMBOL_GPL(__fpga_region_register_full);
 
 /**
- * fpga_region_register - create and register an FPGA Region device
+ * __fpga_region_register - create and register an FPGA Region device
  * @parent: device parent
  * @mgr: manager that programs this region
  * @get_bridges: optional function to get bridges to a list
+ * @owner: module containing the get_bridges function
  *
  * This simple version of the register function should be sufficient for most users.
  * The fpga_region_register_full() function is available for users that need to
@@ -255,17 +259,17 @@ EXPORT_SYMBOL_GPL(fpga_region_register_full);
  * Return: struct fpga_region or ERR_PTR()
  */
 struct fpga_region *
-fpga_region_register(struct device *parent, struct fpga_manager *mgr,
-		     int (*get_bridges)(struct fpga_region *))
+__fpga_region_register(struct device *parent, struct fpga_manager *mgr,
+		       int (*get_bridges)(struct fpga_region *), struct module *owner)
 {
 	struct fpga_region_info info = { 0 };
 
 	info.mgr = mgr;
 	info.get_bridges = get_bridges;
 
-	return fpga_region_register_full(parent, &info);
+	return __fpga_region_register_full(parent, &info, owner);
 }
-EXPORT_SYMBOL_GPL(fpga_region_register);
+EXPORT_SYMBOL_GPL(__fpga_region_register);
 
 /**
  * fpga_region_unregister - unregister an FPGA region
diff --git a/include/linux/fpga/fpga-region.h b/include/linux/fpga/fpga-region.h
index 3b87f232425c9..1c446c2ce2f9c 100644
--- a/include/linux/fpga/fpga-region.h
+++ b/include/linux/fpga/fpga-region.h
@@ -36,6 +36,7 @@ struct fpga_region_info {
  * @mgr: FPGA manager
  * @info: FPGA image info
  * @compat_id: FPGA region id for compatibility check.
+ * @ops_owner: module containing the get_bridges function
  * @priv: private data
  * @get_bridges: optional function to get bridges to a list
  */
@@ -46,6 +47,7 @@ struct fpga_region {
 	struct fpga_manager *mgr;
 	struct fpga_image_info *info;
 	struct fpga_compat_id *compat_id;
+	struct module *ops_owner;
 	void *priv;
 	int (*get_bridges)(struct fpga_region *region);
 };
@@ -58,12 +60,17 @@ struct fpga_region *fpga_region_class_find(
 
 int fpga_region_program_fpga(struct fpga_region *region);
 
+#define fpga_region_register_full(parent, info) \
+	__fpga_region_register_full(parent, info, THIS_MODULE)
 struct fpga_region *
-fpga_region_register_full(struct device *parent, const struct fpga_region_info *info);
+__fpga_region_register_full(struct device *parent, const struct fpga_region_info *info,
+			    struct module *owner);
 
+#define fpga_region_register(parent, mgr, get_bridges) \
+	__fpga_region_register(parent, mgr, get_bridges, THIS_MODULE)
 struct fpga_region *
-fpga_region_register(struct device *parent, struct fpga_manager *mgr,
-		     int (*get_bridges)(struct fpga_region *));
+__fpga_region_register(struct device *parent, struct fpga_manager *mgr,
+		       int (*get_bridges)(struct fpga_region *), struct module *owner);
 void fpga_region_unregister(struct fpga_region *region);
 
 #endif /* _FPGA_REGION_H */
-- 
2.43.0



