Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFA11DB151;
	Wed, 15 Jan 2025 10:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938149; cv=none; b=Xv0kT55P8PC/cyVSQfgPODtrambVNMkd6ttABpP/sIGnUX1GvOfv+opSyD6tGLR2cO8xHaZfxX42iPQeYPp2OumkBkY4aXeHg6fGkH+YGXFay/LPlUWSSPA13cZHuuDrHWhJ8CLNjW0NGSeyDvxfyJoQLkCWBi1KmRUBNQVCSE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938149; c=relaxed/simple;
	bh=m4racqz3TrkZn9JUN3e9BcNKjWNI8zlPiTtO5jnutpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=osYTW0nYXVHNncTX6ILAF96aE7kJT5++sMr7mA5If/x3RoyN1uGdHqgGVV+0wr4TuV4RO+Thx9j627O0jBhYes5GdX/X6mQg2ieANEDCs0icezFal8H8tWlCpeyhqO7csJ5zP8not/FqEnB8HA5SEY+FdCx9XEZ4z7SwzHqUinU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oaOtMu07; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oaOtMu07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E36C4CEE1;
	Wed, 15 Jan 2025 10:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938148;
	bh=m4racqz3TrkZn9JUN3e9BcNKjWNI8zlPiTtO5jnutpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oaOtMu07JE5Gd5xPC0m5poUhxaRQWe4T/hNOlOysaZrAqj4Ru+RJCZTTUTpDBJS2T
	 4iQvLOl0s4qEtJtvmK8H3yjzDymrszUfUMCcISPdAD6TApX7y4aahKe1OTH5wjIhAF
	 vkiKklCuAeQzL1JxBa0/iGgF+csALnn4Z3/zhrgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <koichiro.den@canonical.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 067/189] gpio: virtuser: fix missing lookup table cleanups
Date: Wed, 15 Jan 2025 11:36:03 +0100
Message-ID: <20250115103609.035597867@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <koichiro.den@canonical.com>

[ Upstream commit a619cba8c69c434258ff4101d463322cd63e1bdc ]

When a virtuser device is created via configfs and the probe fails due
to an incorrect lookup table, the table is not removed. This prevents
subsequent probe attempts from succeeding, even if the issue is
corrected, unless the device is released. Additionally, cleanup is also
needed in the less likely case of platform_device_register_full()
failure.

Besides, a consistent memory leak in lookup_table->dev_id was spotted
using kmemleak by toggling the live state between 0 and 1 with a correct
lookup table.

Introduce gpio_virtuser_remove_lookup_table() as the counterpart to the
existing gpio_virtuser_make_lookup_table() and call it from all
necessary points to ensure proper cleanup.

Fixes: 91581c4b3f29 ("gpio: virtuser: new virtual testing driver for the GPIO API")
Signed-off-by: Koichiro Den <koichiro.den@canonical.com>
Link: https://lore.kernel.org/r/20250103141829.430662-2-koichiro.den@canonical.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-virtuser.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/gpio/gpio-virtuser.c b/drivers/gpio/gpio-virtuser.c
index 91b6352c957c..e89b1239b635 100644
--- a/drivers/gpio/gpio-virtuser.c
+++ b/drivers/gpio/gpio-virtuser.c
@@ -1439,6 +1439,15 @@ gpio_virtuser_make_lookup_table(struct gpio_virtuser_device *dev)
 	return 0;
 }
 
+static void
+gpio_virtuser_remove_lookup_table(struct gpio_virtuser_device *dev)
+{
+	gpiod_remove_lookup_table(dev->lookup_table);
+	kfree(dev->lookup_table->dev_id);
+	kfree(dev->lookup_table);
+	dev->lookup_table = NULL;
+}
+
 static struct fwnode_handle *
 gpio_virtuser_make_device_swnode(struct gpio_virtuser_device *dev)
 {
@@ -1487,10 +1496,8 @@ gpio_virtuser_device_activate(struct gpio_virtuser_device *dev)
 	pdevinfo.fwnode = swnode;
 
 	ret = gpio_virtuser_make_lookup_table(dev);
-	if (ret) {
-		fwnode_remove_software_node(swnode);
-		return ret;
-	}
+	if (ret)
+		goto err_remove_swnode;
 
 	reinit_completion(&dev->probe_completion);
 	dev->driver_bound = false;
@@ -1498,23 +1505,31 @@ gpio_virtuser_device_activate(struct gpio_virtuser_device *dev)
 
 	pdev = platform_device_register_full(&pdevinfo);
 	if (IS_ERR(pdev)) {
+		ret = PTR_ERR(pdev);
 		bus_unregister_notifier(&platform_bus_type, &dev->bus_notifier);
-		fwnode_remove_software_node(swnode);
-		return PTR_ERR(pdev);
+		goto err_remove_lookup_table;
 	}
 
 	wait_for_completion(&dev->probe_completion);
 	bus_unregister_notifier(&platform_bus_type, &dev->bus_notifier);
 
 	if (!dev->driver_bound) {
-		platform_device_unregister(pdev);
-		fwnode_remove_software_node(swnode);
-		return -ENXIO;
+		ret = -ENXIO;
+		goto err_unregister_pdev;
 	}
 
 	dev->pdev = pdev;
 
 	return 0;
+
+err_unregister_pdev:
+	platform_device_unregister(pdev);
+err_remove_lookup_table:
+	gpio_virtuser_remove_lookup_table(dev);
+err_remove_swnode:
+	fwnode_remove_software_node(swnode);
+
+	return ret;
 }
 
 static void
@@ -1526,10 +1541,9 @@ gpio_virtuser_device_deactivate(struct gpio_virtuser_device *dev)
 
 	swnode = dev_fwnode(&dev->pdev->dev);
 	platform_device_unregister(dev->pdev);
+	gpio_virtuser_remove_lookup_table(dev);
 	fwnode_remove_software_node(swnode);
 	dev->pdev = NULL;
-	gpiod_remove_lookup_table(dev->lookup_table);
-	kfree(dev->lookup_table);
 }
 
 static ssize_t
-- 
2.39.5



