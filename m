Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03B62E88A4;
	Sat, 12 Sep 2026 07:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198578; cv=none; b=d13xOkcc48nzDfXWk5c70CIczwBCUgngK4FMQ1W/Hh+igsBnyZvMeHvW0wP6j0Mq7QJ6jAAsKdhkO8DcV7m+3y+oDyx6EVE+Begxd5dhcXm+WhVchriTELg26Wh3HhXtkhejXqk/7ne5ncWZP+S+A+rhc5Yql5LJNeaqJLeiBco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198578; c=relaxed/simple;
	bh=8iA1ZlEOUPizC+WJNfR2fG/8PoFAUUEpwXzY2WnpHOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IpiHQMkhp9IIqPSM2SE5jVrMZouP5AfXSShKwq05nNcgEi5rGLoSMEBA7zsBFxirFGv5lpL01JDy/OD5FvFucZrFGmFrBB3kRRW9XvRMNi8TVj5WTkPPIy8YWt7uUl0m0MfVgXmI57PYs0wa8321yeUB2CZZyR0sJ/KydDpFWPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xWqUFZlq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xWqUFZlq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A5C1F000FF;
	Sat, 12 Sep 2026 07:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198576;
	bh=ERt5HnMw8tMMFBlEyVrPrpXGpNvDt9+4kd1WdY16c68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xWqUFZlq36LLvqAjMthSA/JSqJjm5coaFLoXPgJEN8SjhXd7XHDt0vavpzyMtpCZM
	 UwI9A4NL9IamT8TOfnlKUopfkezUFBe9hs/wstE336w84PIVqgDwsNGcQI0Q+xfN/l
	 5Pz0EJcHPBHL1NvLI7cZbbmZ2Oh81ojowEzKFC6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0407/1815] firmware: arm_scmi: Fix SCMI device destroy lifetimes
Date: Sat, 12 Sep 2026 08:35:57 +0200
Message-ID: <20260912065658.450139661@linuxfoundation.org>
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
 drivers/firmware/arm_scmi/bus.c | 39 +++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/firmware/arm_scmi/bus.c b/drivers/firmware/arm_scmi/bus.c
index a14df82a93106..e1f66c08c81d0 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -237,8 +237,9 @@ static int scmi_match_by_id_table(struct device *dev, const void *data)
 	return scmi_dev_match_by_id_table(scmi_dev, id_table);
 }
 
-static struct scmi_device *scmi_child_dev_find(struct device *parent,
-					       int prot_id, const char *name)
+/* Returns a device_find_child() reference which must be dropped by caller. */
+static struct scmi_device *
+scmi_child_dev_find_get(struct device *parent, int prot_id, const char *name)
 {
 	struct scmi_device_id id_table[2] = { 0 };
 	struct device *dev;
@@ -250,9 +251,6 @@ static struct scmi_device *scmi_child_dev_find(struct device *parent,
 	if (!dev)
 		return NULL;
 
-	/* Drop the refcnt bumped implicitly by device_find_child */
-	put_device(dev);
-
 	return to_scmi_dev(dev);
 }
 
@@ -390,17 +388,22 @@ void scmi_driver_unregister(struct scmi_driver *driver)
 }
 EXPORT_SYMBOL_GPL(scmi_driver_unregister);
 
-static void scmi_device_release_syspower(struct scmi_device *scmi_dev)
+static void scmi_device_release_resources(struct scmi_device *scmi_dev)
 {
 	if (scmi_dev->protocol_id == SCMI_PROTOCOL_SYSTEM)
 		cmpxchg(&scmi_syspower_registered, scmi_dev, NULL);
+
+	if (scmi_dev->id) {
+		ida_free(&scmi_bus_id, scmi_dev->id);
+		scmi_dev->id = 0;
+	}
 }
 
 static void scmi_device_release(struct device *dev)
 {
 	struct scmi_device *scmi_dev = to_scmi_dev(dev);
 
-	scmi_device_release_syspower(scmi_dev);
+	scmi_device_release_resources(scmi_dev);
 	of_node_put(dev->of_node);
 	kfree_const(scmi_dev->name);
 	kfree(scmi_dev);
@@ -413,9 +416,9 @@ static void __scmi_device_destroy(struct scmi_device *scmi_dev)
 		 dev_name(&scmi_dev->dev), scmi_dev->protocol_id,
 		 scmi_dev->name);
 
-	scmi_device_release_syspower(scmi_dev);
-	ida_free(&scmi_bus_id, scmi_dev->id);
-	device_unregister(&scmi_dev->dev);
+	device_del(&scmi_dev->dev);
+	scmi_device_release_resources(scmi_dev);
+	put_device(&scmi_dev->dev);
 }
 
 static struct scmi_device *
@@ -433,9 +436,11 @@ __scmi_device_create(struct device_node *np, struct device *parent,
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
 
 	scmi_dev = kzalloc_obj(*scmi_dev);
 	if (!scmi_dev)
@@ -479,13 +484,13 @@ __scmi_device_create(struct device_node *np, struct device *parent,
 
 	return scmi_dev;
 put_dev:
+	scmi_device_release_resources(scmi_dev);
 	put_device(&scmi_dev->dev);
-	ida_free(&scmi_bus_id, id);
 	return NULL;
 free_name:
 	kfree_const(scmi_dev->name);
 free_dev:
-	scmi_device_release_syspower(scmi_dev);
+	scmi_device_release_resources(scmi_dev);
 	kfree(scmi_dev);
 	return NULL;
 }
@@ -567,9 +572,11 @@ void scmi_device_destroy(struct device *parent, int protocol, const char *name)
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



