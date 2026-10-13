Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE8C4FB9BA;
	Tue, 13 Oct 2026 12:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894194; cv=none; b=a2tP2zxl0xA1uncdxsCxxl2I1nvkmt/XVr/tGRmxiiALmGbc2qU/0sjO77uBZ9W2Z38qZ1ifMzbCR6lJs7W89NEFvgYRgwVDeNT0wEuFaZjEZp660WApREq5tJawBHigoZRRtSCVo7bTNi8darbfkaILW+HzbmuJ9r+nshnbZss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894194; c=relaxed/simple;
	bh=e4yijun1v4+RcAUJkTASIPCznc/JFjG92ADpT5DfDKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAZCnFmOA6YpoiNjZ7LuBMeioyDgLW6kUhB147ssAA2QUq4OLy2R+WcK0F1Vxqgbg7/pxIF1Vv/8OmKoSibdSecN7xtQTJhmVhdfYpOqCUg3JSufBEFjRjfuk7kNxgWAxkolsMcj9GsvHphDMkUntg80yF2RuIfHZbhnW98rjBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aM+HDUR7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aM+HDUR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FF81F000FF;
	Tue, 13 Oct 2026 12:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894192;
	bh=TVm3jdv7fgF8UONPZbe/BVE5Vuu5pwq+RXfHGZiEBt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aM+HDUR70w1qitLEjmTo3VwzauzeO8fq2XOK4FOsJYCPMFIo0qY9wbDSk3za+mtl/
	 udUl6Yvf9SdZw98WwWwDz/X5Qfvd+43Zmnez2INFfPxE2ZB9YGpJyxeilmG8Ugea9f
	 y8qfI6DrRx9DWbGY2EcNPKCFmULwE0AEFjNEyxNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 476/621] firmware: arm_scmi: Fix SCMI device destroy lifetimes
Date: Tue, 13 Oct 2026 13:37:51 +0200
Message-ID: <20261013112932.130457466@linuxfoundation.org>
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
index 169fbcba7c3cb..1115e8398668e 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -258,8 +258,9 @@ static int scmi_match_by_id_table(struct device *dev, const void *data)
 	return __scmi_dev_match_by_id_table(scmi_dev, id_table, false);
 }
 
-static struct scmi_device *scmi_child_dev_find(struct device *parent,
-					       int prot_id, const char *name)
+/* Returns a device_find_child() reference which must be dropped by caller. */
+static struct scmi_device *
+scmi_child_dev_find_get(struct device *parent, int prot_id, const char *name)
 {
 	struct scmi_device_id id_table[2] = { 0 };
 	struct device *dev;
@@ -271,9 +272,6 @@ static struct scmi_device *scmi_child_dev_find(struct device *parent,
 	if (!dev)
 		return NULL;
 
-	/* Drop the refcnt bumped implicitly by device_find_child */
-	put_device(dev);
-
 	return to_scmi_dev(dev);
 }
 
@@ -415,17 +413,22 @@ void scmi_driver_unregister(struct scmi_driver *driver)
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
@@ -438,9 +441,9 @@ static void __scmi_device_destroy(struct scmi_device *scmi_dev)
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
@@ -458,9 +461,11 @@ __scmi_device_create(struct device_node *np, struct device *parent,
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
@@ -504,13 +509,13 @@ __scmi_device_create(struct device_node *np, struct device *parent,
 
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
@@ -592,9 +597,11 @@ void scmi_device_destroy(struct device *parent, int protocol, const char *name)
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



