Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B4811713
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC82C433C8;
	Mon, 11 Sep 2023 14:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442687;
	bh=Kfc+XG8HZDVG/6ee8g3qhRr87O82t4guftMiMaPnF9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jWWOHKbAyPh3CCYy5c7B2IsJXB1A2E5G6JvxGzqnRjelizVKep8DScywXee+ZnBYh
	 boArmzC9LzzUAOo5eIQi6Hbo5gWfie1wgxijG/fyb1JpdVtsCbBmxZjj4ogySuPiR/
	 phv7G1CRyhR8w1I8Sy7G3wvc1Xw15TlNjtOtnEbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 112/737] powercap: arm_scmi: Remove recursion while parsing zones
Date: Mon, 11 Sep 2023 15:39:31 +0200
Message-ID: <20230911134653.633343466@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit 3e767d6850f867cc33ac16ca097350a1d2417982 ]

Powercap zones can be defined as arranged in a hierarchy of trees and when
registering a zone with powercap_register_zone(), the kernel powercap
subsystem expects this to happen starting from the root zones down to the
leaves; on the other side, de-registration by powercap_deregister_zone()
must begin from the leaf zones.

Available SCMI powercap zones are retrieved dynamically from the platform
at probe time and, while any defined hierarchy between the zones is
described properly in the zones descriptor, the platform returns the
availables zones with no particular well-defined order: as a consequence,
the trees possibly composing the hierarchy of zones have to be somehow
walked properly to register the retrieved zones from the root.

Currently the ARM SCMI Powercap driver walks the zones using a recursive
algorithm; this approach, even though correct and tested can lead to kernel
stack overflow when processing a returned hierarchy of zones composed by
particularly high trees.

Avoid possible kernel stack overflow by substituting the recursive approach
with an iterative one supported by a dynamically allocated stack-like data
structure.

Fixes: b55eef5226b7 ("powercap: arm_scmi: Add SCMI Powercap based driver")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Acked-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/arm_scmi_powercap.c | 159 ++++++++++++++++-----------
 1 file changed, 92 insertions(+), 67 deletions(-)

diff --git a/drivers/powercap/arm_scmi_powercap.c b/drivers/powercap/arm_scmi_powercap.c
index 05d0e516176a5..5d7330280bd83 100644
--- a/drivers/powercap/arm_scmi_powercap.c
+++ b/drivers/powercap/arm_scmi_powercap.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/powercap.h>
 #include <linux/scmi_protocol.h>
+#include <linux/slab.h>
 
 #define to_scmi_powercap_zone(z)		\
 	container_of(z, struct scmi_powercap_zone, zone)
@@ -19,6 +20,8 @@
 static const struct scmi_powercap_proto_ops *powercap_ops;
 
 struct scmi_powercap_zone {
+	bool registered;
+	bool invalid;
 	unsigned int height;
 	struct device *dev;
 	struct scmi_protocol_handle *ph;
@@ -32,6 +35,7 @@ struct scmi_powercap_root {
 	unsigned int num_zones;
 	struct scmi_powercap_zone *spzones;
 	struct list_head *registered_zones;
+	struct list_head scmi_zones;
 };
 
 static struct powercap_control_type *scmi_top_pcntrl;
@@ -255,12 +259,6 @@ static void scmi_powercap_unregister_all_zones(struct scmi_powercap_root *pr)
 	}
 }
 
-static inline bool
-scmi_powercap_is_zone_registered(struct scmi_powercap_zone *spz)
-{
-	return !list_empty(&spz->node);
-}
-
 static inline unsigned int
 scmi_powercap_get_zone_height(struct scmi_powercap_zone *spz)
 {
@@ -279,11 +277,46 @@ scmi_powercap_get_parent_zone(struct scmi_powercap_zone *spz)
 	return &spz->spzones[spz->info->parent_id];
 }
 
+static int scmi_powercap_register_zone(struct scmi_powercap_root *pr,
+				       struct scmi_powercap_zone *spz,
+				       struct scmi_powercap_zone *parent)
+{
+	int ret = 0;
+	struct powercap_zone *z;
+
+	if (spz->invalid) {
+		list_del(&spz->node);
+		return -EINVAL;
+	}
+
+	z = powercap_register_zone(&spz->zone, scmi_top_pcntrl, spz->info->name,
+				   parent ? &parent->zone : NULL,
+				   &zone_ops, 1, &constraint_ops);
+	if (!IS_ERR(z)) {
+		spz->height = scmi_powercap_get_zone_height(spz);
+		spz->registered = true;
+		list_move(&spz->node, &pr->registered_zones[spz->height]);
+		dev_dbg(spz->dev, "Registered node %s - parent %s - height:%d\n",
+			spz->info->name, parent ? parent->info->name : "ROOT",
+			spz->height);
+	} else {
+		list_del(&spz->node);
+		ret = PTR_ERR(z);
+		dev_err(spz->dev,
+			"Error registering node:%s - parent:%s - h:%d - ret:%d\n",
+			spz->info->name,
+			parent ? parent->info->name : "ROOT",
+			spz->height, ret);
+	}
+
+	return ret;
+}
+
 /**
- * scmi_powercap_register_zone  - Register an SCMI powercap zone recursively
+ * scmi_zones_register- Register SCMI powercap zones starting from parent zones
  *
+ * @dev: A reference to the SCMI device
  * @pr: A reference to the root powercap zones descriptors
- * @spz: A reference to the SCMI powercap zone to register
  *
  * When registering SCMI powercap zones with the powercap framework we should
  * take care to always register zones starting from the root ones and to
@@ -293,10 +326,10 @@ scmi_powercap_get_parent_zone(struct scmi_powercap_zone *spz)
  * zones provided by the SCMI platform firmware is built to comply with such
  * requirement.
  *
- * This function, given an SCMI powercap zone to register, takes care to walk
- * the SCMI powercap zones tree up to the root looking recursively for
- * unregistered parent zones before registering the provided zone; at the same
- * time each registered zone height in such a tree is accounted for and each
+ * This function, given the set of SCMI powercap zones to register, takes care
+ * to walk the SCMI powercap zones trees up to the root registering any
+ * unregistered parent zone before registering the child zones; at the same
+ * time each registered-zone height in such a tree is accounted for and each
  * zone, once registered, is stored in the @registered_zones array that is
  * indexed by zone height: this way will be trivial, at unregister time, to walk
  * the @registered_zones array backward and unregister all the zones starting
@@ -314,57 +347,55 @@ scmi_powercap_get_parent_zone(struct scmi_powercap_zone *spz)
  *
  * Return: 0 on Success
  */
-static int scmi_powercap_register_zone(struct scmi_powercap_root *pr,
-				       struct scmi_powercap_zone *spz)
+static int scmi_zones_register(struct device *dev,
+			       struct scmi_powercap_root *pr)
 {
 	int ret = 0;
-	struct scmi_powercap_zone *parent;
-
-	if (!spz->info)
-		return ret;
+	unsigned int sp = 0, reg_zones = 0;
+	struct scmi_powercap_zone *spz, **zones_stack;
 
-	parent = scmi_powercap_get_parent_zone(spz);
-	if (parent && !scmi_powercap_is_zone_registered(parent)) {
-		/*
-		 * Bail out if a parent domain was marked as unsupported:
-		 * only domains participating as leaves can be skipped.
-		 */
-		if (!parent->info)
-			return -ENODEV;
+	zones_stack = kcalloc(pr->num_zones, sizeof(spz), GFP_KERNEL);
+	if (!zones_stack)
+		return -ENOMEM;
 
-		ret = scmi_powercap_register_zone(pr, parent);
-		if (ret)
-			return ret;
-	}
+	spz = list_first_entry_or_null(&pr->scmi_zones,
+				       struct scmi_powercap_zone, node);
+	while (spz) {
+		struct scmi_powercap_zone *parent;
 
-	if (!scmi_powercap_is_zone_registered(spz)) {
-		struct powercap_zone *z;
-
-		z = powercap_register_zone(&spz->zone,
-					   scmi_top_pcntrl,
-					   spz->info->name,
-					   parent ? &parent->zone : NULL,
-					   &zone_ops, 1, &constraint_ops);
-		if (!IS_ERR(z)) {
-			spz->height = scmi_powercap_get_zone_height(spz);
-			list_add(&spz->node,
-				 &pr->registered_zones[spz->height]);
-			dev_dbg(spz->dev,
-				"Registered node %s - parent %s - height:%d\n",
-				spz->info->name,
-				parent ? parent->info->name : "ROOT",
-				spz->height);
-			ret = 0;
+		parent = scmi_powercap_get_parent_zone(spz);
+		if (parent && !parent->registered) {
+			zones_stack[sp++] = spz;
+			spz = parent;
 		} else {
-			ret = PTR_ERR(z);
-			dev_err(spz->dev,
-				"Error registering node:%s - parent:%s - h:%d - ret:%d\n",
-				 spz->info->name,
-				 parent ? parent->info->name : "ROOT",
-				 spz->height, ret);
+			ret = scmi_powercap_register_zone(pr, spz, parent);
+			if (!ret) {
+				reg_zones++;
+			} else if (sp) {
+				/* Failed to register a non-leaf zone.
+				 * Bail-out.
+				 */
+				dev_err(dev,
+					"Failed to register non-leaf zone - ret:%d\n",
+					ret);
+				scmi_powercap_unregister_all_zones(pr);
+				reg_zones = 0;
+				goto out;
+			}
+			/* Pick next zone to process */
+			if (sp)
+				spz = zones_stack[--sp];
+			else
+				spz = list_first_entry_or_null(&pr->scmi_zones,
+							       struct scmi_powercap_zone,
+							       node);
 		}
 	}
 
+out:
+	kfree(zones_stack);
+	dev_info(dev, "Registered %d SCMI Powercap domains !\n", reg_zones);
+
 	return ret;
 }
 
@@ -408,6 +439,8 @@ static int scmi_powercap_probe(struct scmi_device *sdev)
 	if (!pr->registered_zones)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&pr->scmi_zones);
+
 	for (i = 0, spz = pr->spzones; i < pr->num_zones; i++, spz++) {
 		/*
 		 * Powercap domains are validate by the protocol layer, i.e.
@@ -422,6 +455,7 @@ static int scmi_powercap_probe(struct scmi_device *sdev)
 		INIT_LIST_HEAD(&spz->node);
 		INIT_LIST_HEAD(&pr->registered_zones[i]);
 
+		list_add_tail(&spz->node, &pr->scmi_zones);
 		/*
 		 * Forcibly skip powercap domains using an abstract scale.
 		 * Note that only leaves domains can be skipped, so this could
@@ -432,7 +466,7 @@ static int scmi_powercap_probe(struct scmi_device *sdev)
 			dev_warn(dev,
 				 "Abstract power scale not supported. Skip %s.\n",
 				 spz->info->name);
-			spz->info = NULL;
+			spz->invalid = true;
 			continue;
 		}
 	}
@@ -441,21 +475,12 @@ static int scmi_powercap_probe(struct scmi_device *sdev)
 	 * Scan array of retrieved SCMI powercap domains and register them
 	 * recursively starting from the root domains.
 	 */
-	for (i = 0, spz = pr->spzones; i < pr->num_zones; i++, spz++) {
-		ret = scmi_powercap_register_zone(pr, spz);
-		if (ret) {
-			dev_err(dev,
-				"Failed to register powercap zone %s - ret:%d\n",
-				spz->info->name, ret);
-			scmi_powercap_unregister_all_zones(pr);
-			return ret;
-		}
-	}
+	ret = scmi_zones_register(dev, pr);
+	if (ret)
+		return ret;
 
 	dev_set_drvdata(dev, pr);
 
-	dev_info(dev, "Registered %d SCMI Powercap domains !\n", pr->num_zones);
-
 	return ret;
 }
 
-- 
2.40.1



