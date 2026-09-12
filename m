Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF684D5A1;
	Sat, 12 Sep 2026 07:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198558; cv=none; b=uS8EnJd49ixR4NVa58uKQcnzO7jjpEqbhJ/gZVDSjA2zs/pqzcwChbsz06whmUoseJEL3VYE1PUj8hlAfY4UeGYMHrRODCpEK1ER3u9UerQN0+7Mfi6uOjS2CLGMWWmOrzWBHExSZD+HKJf7n/akPSt+ZKL+vGQGE5/t6dr6BOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198558; c=relaxed/simple;
	bh=GbdotxvbMmU1BGQXPU/OTwv+5OWlEqcCzsI5cD+Kcxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJGFOol5G+EAdZoZ6NkAZ/AWsuF0sGl05Letn0l7PcAeKhV1iSXHh7LPGsFYgSrVcHn+MBTCdB2217uksKyy4+wx6vTS5efbVXEqZi5xVqyWh9znxrqqi1T7ZSi50TQI5c+0dcxHbJYIl8diCKxucdFfxC2aDQqB8cqlXGkeX8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pzApWJLf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pzApWJLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BA61F000FF;
	Sat, 12 Sep 2026 07:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198557;
	bh=foQHsebn+Ivnn+fxTXiKaNPdvtKuGA3r+8weNumP50k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pzApWJLfr5OOrN0Cy+ooiS4Fq2ePK6Qach0dK9TvUoBH/7G7bOAnpwGPAkBhj8TTM
	 WOYTyWs5iBZ26StCRQpHOY1tcYtB5tv9rxT4ZiIsiRZkhWt3TSV7+TIn5uxueF2xto
	 co2x1NwxdDkRGcxQJ+xna7eoh7RFpNkvok+CXQhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0403/1815] firmware: arm_scmi: Clear SystemPower flag on create failure
Date: Sat, 12 Sep 2026 08:35:53 +0200
Message-ID: <20260912065658.355813710@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/bus.c | 59 ++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 27 deletions(-)

diff --git a/drivers/firmware/arm_scmi/bus.c b/drivers/firmware/arm_scmi/bus.c
index 793be9eabaedd..dcaefc1aa8929 100644
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
@@ -391,10 +390,17 @@ void scmi_driver_unregister(struct scmi_driver *driver)
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
@@ -406,9 +412,7 @@ static void __scmi_device_destroy(struct scmi_device *scmi_dev)
 		 dev_name(&scmi_dev->dev), scmi_dev->protocol_id,
 		 scmi_dev->name);
 
-	if (scmi_dev->protocol_id == SCMI_PROTOCOL_SYSTEM)
-		atomic_set(&scmi_syspower_registered, 0);
-
+	scmi_device_release_syspower(scmi_dev);
 	ida_free(&scmi_bus_id, scmi_dev->id);
 	device_unregister(&scmi_dev->dev);
 }
@@ -419,6 +423,7 @@ __scmi_device_create(struct device_node *np, struct device *parent,
 {
 	int id, retval;
 	struct scmi_device *scmi_dev;
+	bool syspower = (protocol == SCMI_PROTOCOL_SYSTEM);
 
 	/*
 	 * If the same protocol/name device already exist under the same parent
@@ -431,39 +436,33 @@ __scmi_device_create(struct device_node *np, struct device *parent,
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
 
-	scmi_dev = kzalloc_obj(*scmi_dev);
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
@@ -482,6 +481,12 @@ __scmi_device_create(struct device_node *np, struct device *parent,
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



