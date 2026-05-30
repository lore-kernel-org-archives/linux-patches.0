Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B4C3546EA;
	Sat, 30 May 2026 17:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163223; cv=none; b=cKnQ9aptFAkHHIEOanJUC8R5Duc02IxlzFBeUsyMgs/86718CW+TwRAIm9aURKBk5X7t9TWnBu4UWGe9koZ+09GGMdMegRc8l6TZQdBs1baIrp4N7qj2dllkfHEsY02FmfccY6L9CBcEmFU8b1wkO6UcVZrqIbG58aGKXuDS1p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163223; c=relaxed/simple;
	bh=ooFwcccv075WnkbSZ52tbQK1aLHibF9eBdFFO6gAANo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1lcKxORlO5rwDF9N7s7CPGLc98nu0jJQvf7aMMiAGPTCiLWfuveRixigA1YaNEQOQ8fEnZ0vlRdbf4+lvx99YkK2eoyo4/74pY3kt6GFP5VMjEUYUZRRLcibtot468cd7kTloXrM9ZWIyNm0+HJO0LKnHCVRN04xQRqgXNfTpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=txOLPgc9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="txOLPgc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21C61F00893;
	Sat, 30 May 2026 17:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163222;
	bh=QWx6aHlMxyZ9pRAx3GvSvF6rUyEGylzHzVYWWgdQQ/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=txOLPgc9TYpBHAIPHS4nXsw8hiAA6ehxaffDey4MklBhOzEhzOVVkW2gUhvzkEd6T
	 wvdUl8Ysp3g+22XVfkodzYZb6ckaqgNSAAaE8acN+IFD+XWR7StrtUbiMg9J+91ONE
	 53Ec3xECTa+u+EHigITFOGlkAppYgVI/TKYIpQzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Douglas Anderson <dianders@chromium.org>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 5.15 192/776] device property: Make modifications of fwnode "flags" thread safe
Date: Sat, 30 May 2026 17:58:26 +0200
Message-ID: <20260530160245.468147006@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

commit f72e77c33e4b5657af35125e75bab249256030f3 upstream.

In various places in the kernel, we modify the fwnode "flags" member
by doing either:
  fwnode->flags |= SOME_FLAG;
  fwnode->flags &= ~SOME_FLAG;

This type of modification is not thread-safe. If two threads are both
mucking with the flags at the same time then one can clobber the
other.

While flags are often modified while under the "fwnode_link_lock",
this is not universally true.

Create some accessor functions for setting, clearing, and testing the
FWNODE flags and move all users to these accessor functions. New
accessor functions use set_bit() and clear_bit(), which are
thread-safe.

Cc: stable@vger.kernel.org
Fixes: c2c724c868c4 ("driver core: Add fw_devlink_parse_fwtree()")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Reviewed-by: Saravana Kannan <saravanak@kernel.org>
Link: https://patch.msgid.link/20260317090112.v2.1.I0a4d03104ecd5103df3d76f66c8d21b1d15a2e38@changeid
[ Fix fwnode_clear_flag() argument alignment, restore dropped blank
  line in fwnode_dev_initialized(), and remove unnecessary parentheses
  around fwnode_test_flag() calls. - Danilo ]
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c        |   12 ++++++------
 drivers/net/phy/mdio_bus.c |    4 ++--
 drivers/of/property.c      |    2 +-
 include/linux/fwnode.h     |   40 +++++++++++++++++++++++++++++++---------
 4 files changed, 40 insertions(+), 18 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -171,7 +171,7 @@ void fw_devlink_purge_absent_suppliers(s
 	if (fwnode->dev)
 		return;
 
-	fwnode->flags |= FWNODE_FLAG_NOT_DEVICE;
+	fwnode_set_flag(fwnode, FWNODE_FLAG_NOT_DEVICE);
 	fwnode_links_purge_consumers(fwnode);
 
 	fwnode_for_each_available_child_node(fwnode, child)
@@ -1620,11 +1620,11 @@ bool fw_devlink_is_strict(void)
 
 static void fw_devlink_parse_fwnode(struct fwnode_handle *fwnode)
 {
-	if (fwnode->flags & FWNODE_FLAG_LINKS_ADDED)
+	if (fwnode_test_flag(fwnode, FWNODE_FLAG_LINKS_ADDED))
 		return;
 
 	fwnode_call_int_op(fwnode, add_links);
-	fwnode->flags |= FWNODE_FLAG_LINKS_ADDED;
+	fwnode_set_flag(fwnode, FWNODE_FLAG_LINKS_ADDED);
 }
 
 static void fw_devlink_parse_fwtree(struct fwnode_handle *fwnode)
@@ -1765,7 +1765,7 @@ static int fw_devlink_create_devlink(str
 	 * When such a flag is set, we can't create device links where P is the
 	 * supplier of C as that would delay the probe of C.
 	 */
-	if (sup_handle->flags & FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD &&
+	if (fwnode_test_flag(sup_handle, FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD) &&
 	    fwnode_is_ancestor_of(sup_handle, con->fwnode))
 		return -EINVAL;
 
@@ -1777,7 +1777,7 @@ static int fw_devlink_create_devlink(str
 		 * supplier device indefinitely.
 		 */
 		if (sup_dev->links.status == DL_DEV_NO_DRIVER &&
-		    sup_handle->flags & FWNODE_FLAG_INITIALIZED) {
+		    fwnode_test_flag(sup_handle, FWNODE_FLAG_INITIALIZED)) {
 			ret = -EINVAL;
 			goto out;
 		}
@@ -1802,7 +1802,7 @@ static int fw_devlink_create_devlink(str
 	}
 
 	/* Supplier that's already initialized without a struct device. */
-	if (sup_handle->flags & FWNODE_FLAG_INITIALIZED)
+	if (fwnode_test_flag(sup_handle, FWNODE_FLAG_INITIALIZED))
 		return -EINVAL;
 
 	/*
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -534,8 +534,8 @@ int __mdiobus_register(struct mii_bus *b
 		return -EINVAL;
 
 	if (bus->parent && bus->parent->of_node)
-		bus->parent->of_node->fwnode.flags |=
-					FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD;
+		fwnode_set_flag(&bus->parent->of_node->fwnode,
+				FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD);
 
 	BUG_ON(bus->state != MDIOBUS_ALLOCATED &&
 	       bus->state != MDIOBUS_UNREGISTERED);
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -1130,7 +1130,7 @@ static int of_link_to_phandle(struct dev
 	sup_dev = get_dev_from_fwnode(&sup_np->fwnode);
 	if (!sup_dev &&
 	    (of_node_check_flag(sup_np, OF_POPULATED) ||
-	     sup_np->fwnode.flags & FWNODE_FLAG_NOT_DEVICE)) {
+	     fwnode_test_flag(&sup_np->fwnode, FWNODE_FLAG_NOT_DEVICE))) {
 		pr_debug("Not linking %pOFP to %pOFP - No struct device\n",
 			 con_np, sup_np);
 		of_node_put(sup_np);
--- a/include/linux/fwnode.h
+++ b/include/linux/fwnode.h
@@ -11,6 +11,7 @@
 
 #include <linux/types.h>
 #include <linux/list.h>
+#include <linux/bitops.h>
 #include <linux/err.h>
 
 struct fwnode_operations;
@@ -27,10 +28,10 @@ struct device;
  *			     their respective drivers as soon as they are
  *			     added.
  */
-#define FWNODE_FLAG_LINKS_ADDED			BIT(0)
-#define FWNODE_FLAG_NOT_DEVICE			BIT(1)
-#define FWNODE_FLAG_INITIALIZED			BIT(2)
-#define FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD	BIT(3)
+#define FWNODE_FLAG_LINKS_ADDED			0
+#define FWNODE_FLAG_NOT_DEVICE			1
+#define FWNODE_FLAG_INITIALIZED			2
+#define FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD	3
 
 struct fwnode_handle {
 	struct fwnode_handle *secondary;
@@ -38,7 +39,7 @@ struct fwnode_handle {
 	struct device *dev;
 	struct list_head suppliers;
 	struct list_head consumers;
-	u8 flags;
+	unsigned long flags;
 };
 
 struct fwnode_link {
@@ -176,16 +177,37 @@ static inline void fwnode_init(struct fw
 	INIT_LIST_HEAD(&fwnode->suppliers);
 }
 
+static inline void fwnode_set_flag(struct fwnode_handle *fwnode,
+				   unsigned int bit)
+{
+	set_bit(bit, &fwnode->flags);
+}
+
+static inline void fwnode_clear_flag(struct fwnode_handle *fwnode,
+				     unsigned int bit)
+{
+	clear_bit(bit, &fwnode->flags);
+}
+
+static inline void fwnode_assign_flag(struct fwnode_handle *fwnode,
+				      unsigned int bit, bool value)
+{
+	assign_bit(bit, &fwnode->flags, value);
+}
+
+static inline bool fwnode_test_flag(struct fwnode_handle *fwnode,
+				    unsigned int bit)
+{
+	return test_bit(bit, &fwnode->flags);
+}
+
 static inline void fwnode_dev_initialized(struct fwnode_handle *fwnode,
 					  bool initialized)
 {
 	if (IS_ERR_OR_NULL(fwnode))
 		return;
 
-	if (initialized)
-		fwnode->flags |= FWNODE_FLAG_INITIALIZED;
-	else
-		fwnode->flags &= ~FWNODE_FLAG_INITIALIZED;
+	fwnode_assign_flag(fwnode, FWNODE_FLAG_INITIALIZED, initialized);
 }
 
 extern u32 fw_devlink_get_flags(void);


