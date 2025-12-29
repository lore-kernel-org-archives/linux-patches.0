Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAEC24EF8C;
	Mon, 29 Dec 2025 16:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025684; cv=none; b=JPPs/gEJ0LwJ9dvk/U/eLzSCJOUPKlpg8Kag86RlNirKOR+/jwzTmCJSlurnEGFjMJqiTuwR7ioxvtRWzLKqzXvQbOTG+tZgBT6pqpymzLPpHf26mUEiZmo7Wo6yF+joMgG2hYdSX5LADYgas6XIy/AF0MQ8VmbuRoAKEEygbqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025684; c=relaxed/simple;
	bh=kaT1bGbt7OouUGJMIm440l2bkV1VCdhsY6qeOYapc24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/bDSZeBNzCKxHWPVkkKHhZTLfaZ04BChZSNI/PdJBtYks+cT8XDga7vySs1KJUGpULRFrzNc2PHpwHKAw+h10yV7Ot+2ezPl/WAE4pQI3hfz+XAUEE2geHnQxmMF589Ut8wp++ZMxYyQbPt+w7slUUsZ86qBSkScyWaNXO5fzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3wpx66p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3wpx66p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188D6C4CEF7;
	Mon, 29 Dec 2025 16:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025684;
	bh=kaT1bGbt7OouUGJMIm440l2bkV1VCdhsY6qeOYapc24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R3wpx66pAUu/X1rJYI3UfYobPlU6Vk5oCr49LPBWhdVIzBrJdo31qsdsyAwPQic07
	 GaDjQICn9ZnT4bfZ8vf0stCYYuUh81Ndfau2Oz68mMOp+z+X5Wis2mhTaf9h0CRG6K
	 lqhVEcJjqYVRHzHULPFhcJ3yCporqroH+8Y2jfgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.18 300/430] serial: core: Restore sysfs fwnode information
Date: Mon, 29 Dec 2025 17:11:42 +0100
Message-ID: <20251229160735.377899732@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 24ec03cc55126b7b3adf102f4b3d9f716532b329 upstream.

The change that restores sysfs fwnode information does it only for OF cases.
Update the fix to cover all possible types of fwnodes.

Fixes: d36f0e9a0002 ("serial: core: restore of_node information in sysfs")
Cc: stable <stable@kernel.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20251127163650.2942075-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_base_bus.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/serial_base_bus.c
+++ b/drivers/tty/serial/serial_base_bus.c
@@ -13,7 +13,7 @@
 #include <linux/device.h>
 #include <linux/idr.h>
 #include <linux/module.h>
-#include <linux/of.h>
+#include <linux/property.h>
 #include <linux/serial_core.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -60,6 +60,7 @@ void serial_base_driver_unregister(struc
 	driver_unregister(driver);
 }
 
+/* On failure the caller must put device @dev with put_device() */
 static int serial_base_device_init(struct uart_port *port,
 				   struct device *dev,
 				   struct device *parent_dev,
@@ -73,7 +74,8 @@ static int serial_base_device_init(struc
 	dev->parent = parent_dev;
 	dev->bus = &serial_base_bus_type;
 	dev->release = release;
-	device_set_of_node_from_dev(dev, parent_dev);
+
+	device_set_node(dev, fwnode_handle_get(dev_fwnode(parent_dev)));
 
 	if (!serial_base_initialized) {
 		dev_dbg(port->dev, "uart_add_one_port() called before arch_initcall()?\n");
@@ -94,7 +96,7 @@ static void serial_base_ctrl_release(str
 {
 	struct serial_ctrl_device *ctrl_dev = to_serial_base_ctrl_device(dev);
 
-	of_node_put(dev->of_node);
+	fwnode_handle_put(dev_fwnode(dev));
 	kfree(ctrl_dev);
 }
 
@@ -142,7 +144,7 @@ static void serial_base_port_release(str
 {
 	struct serial_port_device *port_dev = to_serial_base_port_device(dev);
 
-	of_node_put(dev->of_node);
+	fwnode_handle_put(dev_fwnode(dev));
 	kfree(port_dev);
 }
 


