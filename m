Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC2E4F6463;
	Tue, 13 Oct 2026 12:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894185; cv=none; b=caTmvx+qQIheVUNahNzWnak/XWzcIPXNyqBJ29YDwfgs3YfqBVfibTUWxCKbs1Zn43iu5UPqNVv/UmZoyzGAD3LVVFjGiV0wJ1bEYMChvanbPkyoglwReoCutw3wOHIfK0u4YkDYM+jztOjgFC5fNiC1AitOjlD4hw2wKJHpISM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894185; c=relaxed/simple;
	bh=hS0Wn98szRcFqDHFG57Lv1KiW5sxEl6OSvzQcQmQDNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VD9510CDr4h9pQDathzCzN89bX/HQMXgI12zQJoU4gZNd34eLYpoeIEeUcGXHtHVhi8XTwU65W+htSeBlUO2bfo7YTJTNONNo8eli+S+wfQ6XlXmprWshHKRw0muLqWKDIzpNcYxQVtAetmgbYSIjEc0rTW3kdPzPby+GelOt9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oj7U7ZCJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oj7U7ZCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C961F000FF;
	Tue, 13 Oct 2026 12:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894184;
	bh=4OyIfT7qeIX3rfTWL7ayY6UTPnVydH17p0NtF+Rs1X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oj7U7ZCJ6rwPy5iA8ol4AXGI3EdDYpBmwWSFazKaU4H9OcfGTWXdXL7wYyvv4tSrl
	 bafww306Ye2FaknMKPI2aMdcsKkGGV2RJyevIYHaOAdSVfuBeK7I7KV6yQVKdulQ3r
	 T2+O+uz3tkSqdunc/XgXGh5Tgo+zU+lE8yiNOWAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 474/621] firmware: arm_scmi: Clear SystemPower flag on create failure
Date: Tue, 13 Oct 2026 13:37:49 +0200
Message-ID: <20261013112932.083053699@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit e4c16ae24ca027d7a72d645b42f976bb3e99b4b0 ]

__scmi_device_create() reserves the singleton SystemPower protocol device
before registering the SCMI device. If any later step fails, a stale
reservation can make a later retry reject SystemPower device creation
permanently, for example after probe deferral.

A plain global boolean is not enough to track the reservation. A delayed
final release of an older SystemPower device could clear the boolean after
a newer device has already claimed it, breaking the singleton guarantee for
the active device.

Track the reservation with the scmi_device pointer itself. Claim it with
cmpxchg(NULL, scmi_dev) after allocating the device object, and release it
with cmpxchg(scmi_dev, NULL) from the common cleanup helper. This lets the
create-failure, explicit destroy and final release paths clear only the
reservation owned by the device being cleaned up.

Fixes: 2c3e674465e7 ("firmware: arm_scmi: Refactor device create/destroy helpers")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-11-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Stable-dep-of: 6abe8fe36b29 ("firmware: arm_scmi: Fix SCMI device destroy lifetimes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/bus.c | 59 ++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 27 deletions(-)

diff --git a/drivers/firmware/arm_scmi/bus.c b/drivers/firmware/arm_scmi/bus.c
index 290047b46d51d..3ead4085ad946 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -7,7 +7,6 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/atomic.h>
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/of.h>
@@ -33,8 +32,8 @@ struct scmi_requested_dev {
 	struct list_head node;
 };
 
-/* Track globally the creation of SCMI SystemPower related devices */
-static atomic_t scmi_syspower_registered = ATOMIC_INIT(0);
+/* Track globally the SCMI SystemPower protocol device. */
+static struct scmi_device *scmi_syspower_registered;
 
 /**
  * scmi_protocol_device_request  - Helper to request a device
@@ -416,10 +415,17 @@ void scmi_driver_unregister(struct scmi_driver *driver)
 }
 EXPORT_SYMBOL_GPL(scmi_driver_unregister);
 
+static void scmi_device_release_syspower(struct scmi_device *scmi_dev)
+{
+	if (scmi_dev->protocol_id == SCMI_PROTOCOL_SYSTEM)
+		cmpxchg(&scmi_syspower_registered, scmi_dev, NULL);
+}
+
 static void scmi_device_release(struct device *dev)
 {
 	struct scmi_device *scmi_dev = to_scmi_dev(dev);
 
+	scmi_device_release_syspower(scmi_dev);
 	kfree_const(scmi_dev->name);
 	kfree(scmi_dev);
 }
@@ -431,9 +437,7 @@ static void __scmi_device_destroy(struct scmi_device *scmi_dev)
 		 dev_name(&scmi_dev->dev), scmi_dev->protocol_id,
 		 scmi_dev->name);
 
-	if (scmi_dev->protocol_id == SCMI_PROTOCOL_SYSTEM)
-		atomic_set(&scmi_syspower_registered, 0);
-
+	scmi_device_release_syspower(scmi_dev);
 	ida_free(&scmi_bus_id, scmi_dev->id);
 	device_unregister(&scmi_dev->dev);
 }
@@ -444,6 +448,7 @@ __scmi_device_create(struct device_node *np, struct device *parent,
 {
 	int id, retval;
 	struct scmi_device *scmi_dev;
+	bool syspower = (protocol == SCMI_PROTOCOL_SYSTEM);
 
 	/*
 	 * If the same protocol/name device already exist under the same parent
@@ -456,39 +461,33 @@ __scmi_device_create(struct device_node *np, struct device *parent,
 	if (scmi_dev)
 		return scmi_dev;
 
+	scmi_dev = kzalloc_obj(*scmi_dev);
+	if (!scmi_dev)
+		return NULL;
+
+	scmi_dev->protocol_id = protocol;
+
 	/*
-	 * Ignore any possible subsequent failures while creating the device
-	 * since we are doomed anyway at that point; not using a mutex which
-	 * spans across this whole function to keep things simple and to avoid
-	 * to serialize all the __scmi_device_create calls across possibly
-	 * different SCMI server instances (parent)
+	 * Reserve the singleton SystemPower protocol device using the device
+	 * pointer itself, so delayed release of an older device cannot clear
+	 * a reservation owned by a newer device.
 	 */
-	if (protocol == SCMI_PROTOCOL_SYSTEM &&
-	    atomic_cmpxchg(&scmi_syspower_registered, 0, 1)) {
+	if (syspower && cmpxchg(&scmi_syspower_registered, NULL, scmi_dev)) {
 		dev_warn(parent,
 			 "SCMI SystemPower protocol device must be unique !\n");
+		kfree(scmi_dev);
 		return NULL;
 	}
 
-	scmi_dev = kzalloc(sizeof(*scmi_dev), GFP_KERNEL);
-	if (!scmi_dev)
-		return NULL;
-
 	scmi_dev->name = kstrdup_const(name ?: "unknown", GFP_KERNEL);
-	if (!scmi_dev->name) {
-		kfree(scmi_dev);
-		return NULL;
-	}
+	if (!scmi_dev->name)
+		goto free_dev;
 
 	id = ida_alloc_min(&scmi_bus_id, 1, GFP_KERNEL);
-	if (id < 0) {
-		kfree_const(scmi_dev->name);
-		kfree(scmi_dev);
-		return NULL;
-	}
+	if (id < 0)
+		goto free_name;
 
 	scmi_dev->id = id;
-	scmi_dev->protocol_id = protocol;
 	scmi_dev->dev.parent = parent;
 	device_set_node(&scmi_dev->dev, of_fwnode_handle(np));
 	scmi_dev->dev.bus = &scmi_bus_type;
@@ -507,6 +506,12 @@ __scmi_device_create(struct device_node *np, struct device *parent,
 	put_device(&scmi_dev->dev);
 	ida_free(&scmi_bus_id, id);
 	return NULL;
+free_name:
+	kfree_const(scmi_dev->name);
+free_dev:
+	scmi_device_release_syspower(scmi_dev);
+	kfree(scmi_dev);
+	return NULL;
 }
 
 static struct scmi_device *
-- 
2.53.0



