Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0537B3C73F6;
	Sat, 17 Oct 2026 18:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260237; cv=none; b=bdntqiMweiEsI/g+tuUd7jQbED/YVay2jCoqR51nSIpBBvCiRWEoP2bVfnTFli4v/w++bJeerlHXa4yLbb0NDeZTz2qzUBxf/x1c1dm9gtNYZyIQGK6mxEi+PlsWcu0PjWS2PQoHCQ8Iqc0z0OwAzz7CzwbR9xCV+zocT62RYyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260237; c=relaxed/simple;
	bh=mZinUA9r/iBFZ+7pUzohFvy+AYKxegqf4tvHk9EwJOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDKe+GgJbKGY/IA+l8XgadXoamfO4ymSWO4oVr/WAIFr+7Ui57LfrER2aLaguCsWFqnKv/UJceL0A+IaR0vurx5Zm7qNImhZasn1BhTzc0oWaWYMgUSrR4xvHFEmH2LteeEtbK2Eh0a+Z25chvDPeKatYEgjSjTsaPKluia/rtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4Fq85/8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4Fq85/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551ED1F000C4;
	Sat, 17 Oct 2026 18:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260235;
	bh=5y126M+i9yU2k82nATiHEIGcW7PUifVoc/d7wkzMAvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W4Fq85/8i1NXq11ixoKem4JAdDbaNnnrsLn/SkYd91A2jB9fWcygvvA01smROefga
	 uQfZfLMZqqIps99MKoJs5PpyFImQV4wWpTNh5TGhCPC6L72gRg0ygLOsThHmMEvv8d
	 NuK3jq+ktQp3/5v8azBX3uBlKPNnYPGYsGeOHA1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1478/1674] firmware: arm_scmi: Fix SCMI device destroy lifetimes
Date: Sat, 17 Oct 2026 18:02:30 +0200
Message-ID: <20261017160509.096454490@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 6abe8fe36b29ff51d1a42c2f338972883f4751a5 ]

scmi_child_dev_find() drops the reference returned by
device_find_child() before returning the scmi_device pointer. A
concurrent unregister can then release the device while the destroy path
is still using the returned pointer.

Make the lookup helper return the device_find_child() reference and keep
it until scmi_device_destroy() has finished unregistering the child.

Also split device_unregister() in __scmi_device_destroy() so the SCMI bus
ID is not made reusable until after device_del() has removed the old
scmi_dev.N name from sysfs. This avoids a new SCMI device reusing the
same ID while the old device is still registered.

The final device release callback is also a possible cleanup path when
SCMI children are deleted by driver core recursion rather than
__scmi_device_destroy(). Release the SCMI bus ID from a common helper
used by destroy, register-failure and final-release paths, and clear
scmi_dev->id after freeing it so the final release cannot free the same
ID again.

Fixes: 9ca67840c0dd ("firmware: arm_scmi: Balance device refcount when destroying devices")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-15-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/bus.c | 36 ++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/firmware/arm_scmi/bus.c b/drivers/firmware/arm_scmi/bus.c
index 22e5ed1f73202..157717ac567a9 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -249,8 +249,9 @@ static int scmi_match_by_id_table(struct device *dev, void *data)
 		(id_table->name && !strcmp(sdev->name, id_table->name));
 }
 
-static struct scmi_device *scmi_child_dev_find(struct device *parent,
-					       int prot_id, const char *name)
+/* Returns a device_find_child() reference which must be dropped by caller. */
+static struct scmi_device *
+scmi_child_dev_find_get(struct device *parent, int prot_id, const char *name)
 {
 	struct scmi_device_id id_table;
 	struct device *dev;
@@ -262,9 +263,6 @@ static struct scmi_device *scmi_child_dev_find(struct device *parent,
 	if (!dev)
 		return NULL;
 
-	/* Drop the refcnt bumped implicitly by device_find_child */
-	put_device(dev);
-
 	return to_scmi_dev(dev);
 }
 
@@ -332,10 +330,19 @@ void scmi_driver_unregister(struct scmi_driver *driver)
 }
 EXPORT_SYMBOL_GPL(scmi_driver_unregister);
 
+static void scmi_device_release_resources(struct scmi_device *scmi_dev)
+{
+	if (scmi_dev->id) {
+		ida_free(&scmi_bus_id, scmi_dev->id);
+		scmi_dev->id = 0;
+	}
+}
+
 static void scmi_device_release(struct device *dev)
 {
 	struct scmi_device *scmi_dev = to_scmi_dev(dev);
 
+	scmi_device_release_resources(scmi_dev);
 	kfree_const(scmi_dev->name);
 	kfree(scmi_dev);
 }
@@ -350,8 +357,9 @@ static void __scmi_device_destroy(struct scmi_device *scmi_dev)
 	if (scmi_dev->protocol_id == SCMI_PROTOCOL_SYSTEM)
 		atomic_set(&scmi_syspower_registered, 0);
 
-	ida_free(&scmi_bus_id, scmi_dev->id);
-	device_unregister(&scmi_dev->dev);
+	device_del(&scmi_dev->dev);
+	scmi_device_release_resources(scmi_dev);
+	put_device(&scmi_dev->dev);
 }
 
 static struct scmi_device *
@@ -368,9 +376,11 @@ __scmi_device_create(struct device_node *np, struct device *parent,
 	 * each DT defined protocol at probe time, and the concurrent
 	 * registration of SCMI drivers.
 	 */
-	scmi_dev = scmi_child_dev_find(parent, protocol, name);
-	if (scmi_dev)
+	scmi_dev = scmi_child_dev_find_get(parent, protocol, name);
+	if (scmi_dev) {
+		put_device(&scmi_dev->dev);
 		return scmi_dev;
+	}
 
 	/*
 	 * Ignore any possible subsequent failures while creating the device
@@ -421,8 +431,8 @@ __scmi_device_create(struct device_node *np, struct device *parent,
 
 	return scmi_dev;
 put_dev:
+	scmi_device_release_resources(scmi_dev);
 	put_device(&scmi_dev->dev);
-	ida_free(&scmi_bus_id, id);
 	return NULL;
 }
 
@@ -494,9 +504,11 @@ void scmi_device_destroy(struct device *parent, int protocol, const char *name)
 {
 	struct scmi_device *scmi_dev;
 
-	scmi_dev = scmi_child_dev_find(parent, protocol, name);
-	if (scmi_dev)
+	scmi_dev = scmi_child_dev_find_get(parent, protocol, name);
+	if (scmi_dev) {
 		__scmi_device_destroy(scmi_dev);
+		put_device(&scmi_dev->dev);
+	}
 }
 EXPORT_SYMBOL_GPL(scmi_device_destroy);
 
-- 
2.53.0



