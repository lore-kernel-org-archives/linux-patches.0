Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C9BB67E;
	Wed,  8 Apr 2026 18:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673457; cv=none; b=OpdltPiJzplV9G9wmO5jn6Y4TsFAC6EwUaM+WP07l7q6W61Z2NhaM7hb3Y3XrHPLjaWNpKBs73U0H2wljQD7NL4cPRyKehbCpkGMhQm75T6aJXwY5VodvozzFyX/4yQoxK5subViunf/dt9hTNOYHQ3HBtpTayBrLpZh7oAebdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673457; c=relaxed/simple;
	bh=j0d/xoyke+T3cf3brdl+FxERuAiLs1eqBW9DFAhjgLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VcXxH9HfV5NYE1a9iCPFFyjWJg83pntX48gepxRzFxIsMUVEIhO3XFBihSDmBiGc1m5W0copBlqy0PvBAgRSI25O9lpP+KIZy4c2I69qifPOpED2s1r2GV9HA340ydFvnlD6pFkETxQVi9p2ZakFtKtyHPYXCGpy9drr7JvLfhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KR/sYh06; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KR/sYh06"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEB7C19421;
	Wed,  8 Apr 2026 18:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673457;
	bh=j0d/xoyke+T3cf3brdl+FxERuAiLs1eqBW9DFAhjgLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KR/sYh06GVSwaiF/vRMmIBfhlcJHuN9u2IxI5cimSob0ji6v8IKxHsaWkPO+n2v80
	 vfq0kFzItbiT/LBLt8mOJ+qCDEMZ9nGevETPjXrzPkTMotsGusLi0ylWXGV8uOALxF
	 333ySUYo1TlmOSVMlxJtdaQsTNgE4WWrYSy4A73E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 239/277] gpio: Fix resource leaks on errors in gpiochip_add_data_with_key()
Date: Wed,  8 Apr 2026 20:03:44 +0200
Message-ID: <20260408175942.784055392@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Tzung-Bi Shih <tzungbi@kernel.org>

commit 16fdabe143fce2cbf89139677728e17e21b46c28 upstream.

Since commit aab5c6f20023 ("gpio: set device type for GPIO chips"),
`gdev->dev.release` is unset.  As a result, the reference count to
`gdev->dev` isn't dropped on the error handling paths.

Drop the reference on errors.

Also reorder the instructions to make the error handling simpler.
Now gpiochip_add_data_with_key() roughly looks like:

   >>> Some memory allocation.  Go to ERR ZONE 1 on errors.
   >>> device_initialize().

   gpiodev_release() takes over the responsibility for freeing the
   resources of `gdev->dev`.  The subsequent error handling paths
   shouldn't go through ERR ZONE 1 again which leads to double free.

   >>> Some initialization mainly on `gdev`.
   >>> The rest of initialization.  Go to ERR ZONE 2 on errors.
   >>> Chip registration success and exit.

   >>> ERR ZONE 2.  gpio_device_put() and exit.
   >>> ERR ZONE 1.

Cc: stable@vger.kernel.org
Fixes: aab5c6f20023 ("gpio: set device type for GPIO chips")
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://patch.msgid.link/20260205092840.2574840-1-tzungbi@kernel.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib.c |  101 +++++++++++++++++++++++--------------------------
 1 file changed, 48 insertions(+), 53 deletions(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -882,13 +882,15 @@ static const struct device_type gpio_dev
 #define gcdev_unregister(gdev)		device_del(&(gdev)->dev)
 #endif
 
+/*
+ * An initial reference count has been held in gpiochip_add_data_with_key().
+ * The caller should drop the reference via gpio_device_put() on errors.
+ */
 static int gpiochip_setup_dev(struct gpio_device *gdev)
 {
 	struct fwnode_handle *fwnode = dev_fwnode(&gdev->dev);
 	int ret;
 
-	device_initialize(&gdev->dev);
-
 	/*
 	 * If fwnode doesn't belong to another device, it's safe to clear its
 	 * initialized flag.
@@ -954,9 +956,11 @@ static void gpiochip_setup_devs(void)
 	list_for_each_entry_srcu(gdev, &gpio_devices, list,
 				 srcu_read_lock_held(&gpio_devices_srcu)) {
 		ret = gpiochip_setup_dev(gdev);
-		if (ret)
+		if (ret) {
+			gpio_device_put(gdev);
 			dev_err(&gdev->dev,
 				"Failed to initialize gpio device (%d)\n", ret);
+		}
 	}
 }
 
@@ -1037,71 +1041,72 @@ int gpiochip_add_data_with_key(struct gp
 	int base = 0;
 	int ret;
 
-	/*
-	 * First: allocate and populate the internal stat container, and
-	 * set up the struct device.
-	 */
 	gdev = kzalloc(sizeof(*gdev), GFP_KERNEL);
 	if (!gdev)
 		return -ENOMEM;
-
-	gdev->dev.type = &gpio_dev_type;
-	gdev->dev.bus = &gpio_bus_type;
-	gdev->dev.parent = gc->parent;
-	rcu_assign_pointer(gdev->chip, gc);
-
 	gc->gpiodev = gdev;
 	gpiochip_set_data(gc, data);
 
-	device_set_node(&gdev->dev, gpiochip_choose_fwnode(gc));
-
 	ret = ida_alloc(&gpio_ida, GFP_KERNEL);
 	if (ret < 0)
 		goto err_free_gdev;
 	gdev->id = ret;
 
-	ret = dev_set_name(&gdev->dev, GPIOCHIP_NAME "%d", gdev->id);
+	ret = init_srcu_struct(&gdev->srcu);
 	if (ret)
 		goto err_free_ida;
+	rcu_assign_pointer(gdev->chip, gc);
 
-	if (gc->parent && gc->parent->driver)
-		gdev->owner = gc->parent->driver->owner;
-	else if (gc->owner)
-		/* TODO: remove chip->owner */
-		gdev->owner = gc->owner;
-	else
-		gdev->owner = THIS_MODULE;
+	ret = init_srcu_struct(&gdev->desc_srcu);
+	if (ret)
+		goto err_cleanup_gdev_srcu;
+
+	ret = dev_set_name(&gdev->dev, GPIOCHIP_NAME "%d", gdev->id);
+	if (ret)
+		goto err_cleanup_desc_srcu;
+
+	device_initialize(&gdev->dev);
+	/*
+	 * After this point any allocated resources to `gdev` will be
+	 * free():ed by gpiodev_release().  If you add new resources
+	 * then make sure they get free():ed there.
+	 */
+	gdev->dev.type = &gpio_dev_type;
+	gdev->dev.bus = &gpio_bus_type;
+	gdev->dev.parent = gc->parent;
+	device_set_node(&gdev->dev, gpiochip_choose_fwnode(gc));
 
 	ret = gpiochip_get_ngpios(gc, &gdev->dev);
 	if (ret)
-		goto err_free_dev_name;
+		goto err_put_device;
+	gdev->ngpio = gc->ngpio;
 
 	gdev->descs = kcalloc(gc->ngpio, sizeof(*gdev->descs), GFP_KERNEL);
 	if (!gdev->descs) {
 		ret = -ENOMEM;
-		goto err_free_dev_name;
+		goto err_put_device;
 	}
 
 	gdev->label = kstrdup_const(gc->label ?: "unknown", GFP_KERNEL);
 	if (!gdev->label) {
 		ret = -ENOMEM;
-		goto err_free_descs;
+		goto err_put_device;
 	}
 
-	gdev->ngpio = gc->ngpio;
 	gdev->can_sleep = gc->can_sleep;
-
 	rwlock_init(&gdev->line_state_lock);
 	RAW_INIT_NOTIFIER_HEAD(&gdev->line_state_notifier);
 	BLOCKING_INIT_NOTIFIER_HEAD(&gdev->device_notifier);
-
-	ret = init_srcu_struct(&gdev->srcu);
-	if (ret)
-		goto err_free_label;
-
-	ret = init_srcu_struct(&gdev->desc_srcu);
-	if (ret)
-		goto err_cleanup_gdev_srcu;
+#ifdef CONFIG_PINCTRL
+	INIT_LIST_HEAD(&gdev->pin_ranges);
+#endif
+	if (gc->parent && gc->parent->driver)
+		gdev->owner = gc->parent->driver->owner;
+	else if (gc->owner)
+		/* TODO: remove chip->owner */
+		gdev->owner = gc->owner;
+	else
+		gdev->owner = THIS_MODULE;
 
 	scoped_guard(mutex, &gpio_devices_lock) {
 		/*
@@ -1117,7 +1122,7 @@ int gpiochip_add_data_with_key(struct gp
 			if (base < 0) {
 				ret = base;
 				base = 0;
-				goto err_cleanup_desc_srcu;
+				goto err_put_device;
 			}
 
 			/*
@@ -1137,14 +1142,10 @@ int gpiochip_add_data_with_key(struct gp
 		ret = gpiodev_add_to_list_unlocked(gdev);
 		if (ret) {
 			gpiochip_err(gc, "GPIO integer space overlap, cannot add chip\n");
-			goto err_cleanup_desc_srcu;
+			goto err_put_device;
 		}
 	}
 
-#ifdef CONFIG_PINCTRL
-	INIT_LIST_HEAD(&gdev->pin_ranges);
-#endif
-
 	if (gc->names)
 		gpiochip_set_desc_names(gc);
 
@@ -1231,25 +1232,19 @@ err_remove_from_list:
 	scoped_guard(mutex, &gpio_devices_lock)
 		list_del_rcu(&gdev->list);
 	synchronize_srcu(&gpio_devices_srcu);
-	if (gdev->dev.release) {
-		/* release() has been registered by gpiochip_setup_dev() */
-		gpio_device_put(gdev);
-		goto err_print_message;
-	}
+err_put_device:
+	gpio_device_put(gdev);
+	goto err_print_message;
+
 err_cleanup_desc_srcu:
 	cleanup_srcu_struct(&gdev->desc_srcu);
 err_cleanup_gdev_srcu:
 	cleanup_srcu_struct(&gdev->srcu);
-err_free_label:
-	kfree_const(gdev->label);
-err_free_descs:
-	kfree(gdev->descs);
-err_free_dev_name:
-	kfree(dev_name(&gdev->dev));
 err_free_ida:
 	ida_free(&gpio_ida, gdev->id);
 err_free_gdev:
 	kfree(gdev);
+
 err_print_message:
 	/* failures here can mean systems won't boot... */
 	if (ret != -EPROBE_DEFER) {


