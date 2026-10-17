Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6B6380FCA;
	Sat, 17 Oct 2026 16:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254036; cv=none; b=ZN3o7J8Yz1NBqxIiVClVVuS1lrJVC+o5GAOV7IoWm1i0p1Ax/h6iUwYpBHyRGBCbpH8tWNtMhsA4DlYNJ1iMUD+pUM37geFoT6BDI8v7ltlTZbIsRORg8rdpuCD9454YOYX+aa4vpV1q7A+V5Nj2xH/p+2MgiqJU/u1/kyOUyqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254036; c=relaxed/simple;
	bh=Pz0kGMl5ithq8hddej0Cw0797G6VdcsKg0FlmYAzMyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vi7qjbca7P8529sgpaVLapJuJVhWRlhPO3bS7EO6LaCfR4viOE2HjTJU1z8uQ8uNn9GpixyHP1Prj3G7VgUtSCLznJnpWxmaWcZxTSU6R44yjhJHWSViqyVXwC238jlDLnDwXVpL+n3CcrJxCqdOtB4nkrmY7ttKugIjU23/4lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KQivQ6XZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KQivQ6XZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010A41F000C4;
	Sat, 17 Oct 2026 16:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254035;
	bh=7SX7EOlTqiTrUlf0STZB0M9j0RbC6stjAuFuLso4Dfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KQivQ6XZnPODwAQOu302rZMSzcC8/KMHiFf9/gD1/BoseoFmwZIl7Ko2BgKmF385R
	 suol26TpHYPZx/BjaDhNDlKaLDN6dkhuyHOz3Muk40JHA9WLp+kB+7Ht8+nNsaM0Gf
	 RAAQn0wPNPGqUexR6oczwDce0pDOkcogYWteJUEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	=?UTF-8?q?Damien=20Ri=C3=A9gel?= <damien.riegel@silabs.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 314/869] greybus: raw: fix use-after-free on cdev close
Date: Sat, 17 Oct 2026 17:52:35 +0200
Message-ID: <20261017160045.125963643@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Riégel <damien.riegel@silabs.com>

[ Upstream commit 983cc2c7efbce04ecbf6328448d895044dd6ab31 ]

This addresses a use-after-free bug when a raw bundle is disconnected
but its chardev is still opened by an application. When the application
releases the cdev, it causes the following panic when init on free is
enabled (CONFIG_INIT_ON_FREE_DEFAULT_ON=y):

        refcount_t: underflow; use-after-free.
        WARNING: CPU: 0 PID: 139 at lib/refcount.c:28 refcount_warn_saturate+0xd0/0x130
         ...
        Call Trace:
         <TASK>
         cdev_put+0x18/0x30
         __fput+0x255/0x2a0
         __x64_sys_close+0x3d/0x80
         do_syscall_64+0xa4/0x290
         entry_SYSCALL_64_after_hwframe+0x77/0x7f

The cdev is contained in the "gb_raw" structure, which is freed in the
disconnect operation. When the cdev is released at a later time,
cdev_put gets an address that points to freed memory.

To fix this use-after-free, convert the struct device from a pointer to
being embedded, that makes the lifetime of the cdev and of this device
the same. Then, use cdev_device_add, which guarantees that the device
won't be released until all references to the cdev have been released.
Finally, delegate the freeing of the structure to the device release
function, instead of freeing immediately in the disconnect callback.

Fixes: e806c7fb8e9b ("greybus: raw: add raw greybus kernel driver")
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Damien Riégel <damien.riegel@silabs.com>
Link: https://patch.msgid.link/20260324140039.40001-1-damien.riegel@silabs.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/greybus/raw.c | 67 +++++++++++++++++------------------
 1 file changed, 33 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/greybus/raw.c b/drivers/staging/greybus/raw.c
index 71de6776739c2..e668438e1a2c4 100644
--- a/drivers/staging/greybus/raw.c
+++ b/drivers/staging/greybus/raw.c
@@ -21,9 +21,8 @@ struct gb_raw {
 	struct list_head list;
 	int list_data;
 	struct mutex list_lock;
-	dev_t dev;
 	struct cdev cdev;
-	struct device *device;
+	struct device dev;
 };
 
 struct raw_data {
@@ -148,6 +147,15 @@ static int gb_raw_send(struct gb_raw *raw, u32 len, const char __user *data)
 	return retval;
 }
 
+static void raw_dev_release(struct device *dev)
+{
+	struct gb_raw *raw = container_of(dev, struct gb_raw, dev);
+
+	ida_free(&minors, MINOR(raw->dev.devt));
+
+	kfree(raw);
+}
+
 static int gb_raw_probe(struct gb_bundle *bundle,
 			const struct greybus_bundle_id *id)
 {
@@ -164,15 +172,30 @@ static int gb_raw_probe(struct gb_bundle *bundle,
 	if (cport_desc->protocol_id != GREYBUS_PROTOCOL_RAW)
 		return -ENODEV;
 
+	minor = ida_alloc(&minors, GFP_KERNEL);
+	if (minor < 0)
+		return minor;
+
 	raw = kzalloc(sizeof(*raw), GFP_KERNEL);
-	if (!raw)
+	if (!raw) {
+		ida_free(&minors, minor);
 		return -ENOMEM;
+	}
+
+	device_initialize(&raw->dev);
+	raw->dev.devt = MKDEV(raw_major, minor);
+	raw->dev.class = &raw_class;
+	raw->dev.parent = &bundle->dev;
+	raw->dev.release = raw_dev_release;
+	retval = dev_set_name(&raw->dev, "gb!raw%d", minor);
+	if (retval)
+		goto error_put_device;
 
 	connection = gb_connection_create(bundle, le16_to_cpu(cport_desc->id),
 					  gb_raw_request_handler);
 	if (IS_ERR(connection)) {
 		retval = PTR_ERR(connection);
-		goto error_free;
+		goto error_put_device;
 	}
 
 	INIT_LIST_HEAD(&raw->list);
@@ -181,46 +204,26 @@ static int gb_raw_probe(struct gb_bundle *bundle,
 	raw->connection = connection;
 	greybus_set_drvdata(bundle, raw);
 
-	minor = ida_alloc(&minors, GFP_KERNEL);
-	if (minor < 0) {
-		retval = minor;
-		goto error_connection_destroy;
-	}
-
-	raw->dev = MKDEV(raw_major, minor);
 	cdev_init(&raw->cdev, &raw_fops);
 
 	retval = gb_connection_enable(connection);
 	if (retval)
-		goto error_remove_ida;
+		goto error_connection_destroy;
 
-	retval = cdev_add(&raw->cdev, raw->dev, 1);
+	retval = cdev_device_add(&raw->cdev, &raw->dev);
 	if (retval)
 		goto error_connection_disable;
 
-	raw->device = device_create(&raw_class, &connection->bundle->dev,
-				    raw->dev, raw, "gb!raw%d", minor);
-	if (IS_ERR(raw->device)) {
-		retval = PTR_ERR(raw->device);
-		goto error_del_cdev;
-	}
-
 	return 0;
 
-error_del_cdev:
-	cdev_del(&raw->cdev);
-
 error_connection_disable:
 	gb_connection_disable(connection);
 
-error_remove_ida:
-	ida_free(&minors, minor);
-
 error_connection_destroy:
 	gb_connection_destroy(connection);
 
-error_free:
-	kfree(raw);
+error_put_device:
+	put_device(&raw->dev);
 	return retval;
 }
 
@@ -231,11 +234,8 @@ static void gb_raw_disconnect(struct gb_bundle *bundle)
 	struct raw_data *raw_data;
 	struct raw_data *temp;
 
-	// FIXME - handle removing a connection when the char device node is open.
-	device_destroy(&raw_class, raw->dev);
-	cdev_del(&raw->cdev);
+	cdev_device_del(&raw->cdev, &raw->dev);
 	gb_connection_disable(connection);
-	ida_free(&minors, MINOR(raw->dev));
 	gb_connection_destroy(connection);
 
 	mutex_lock(&raw->list_lock);
@@ -244,8 +244,7 @@ static void gb_raw_disconnect(struct gb_bundle *bundle)
 		kfree(raw_data);
 	}
 	mutex_unlock(&raw->list_lock);
-
-	kfree(raw);
+	put_device(&raw->dev);
 }
 
 /*
-- 
2.53.0



