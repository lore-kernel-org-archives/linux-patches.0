Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C153624C4;
	Thu, 15 Jan 2026 17:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498428; cv=none; b=TefNf4rkngsQAtpA5ElYp2NFLuzB1J7E78c7UIb5j8/QzCkWj0xnpQ7g8vNGaJx6qUevkpHhp5AkTKkv+l5bHTzjPdyBCbnfbrfLQ2cSz1zb1q4F6v0IWBBZdOv3wJbj3J0Vf44mvBiXPP7wEq3uI941ntzNjJwiHl0OE77wp6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498428; c=relaxed/simple;
	bh=k3vdV8MCn0+QcNTPBfUDCC0iazgo1J2eTYEE80OaJhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1IfhwKt3jA87JeuXFquKqmm2eAIBK8UeEqUcHCo6vlOqXFf/tD3lLbBgyX7u66rdCqVqkXWPbnPDKQW4hkenvcSWjWHxT5P6700QxSHx+QKB1G2VAmeu3GQpkLY3g22Ao93ML72e+6QEua1t4PKXi0DUN1upullWRdKEdpWpjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1IrTM6vj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1IrTM6vj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC4FC116D0;
	Thu, 15 Jan 2026 17:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498428;
	bh=k3vdV8MCn0+QcNTPBfUDCC0iazgo1J2eTYEE80OaJhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1IrTM6vjbmcWs3la7BI2yS9S9ii6Bdb6UUhCiWxuHCueeSnRP9PmSju29kEk5y80a
	 bLkIZs/Ej3H5kfLNkBQNmJYs/ipsinXO1UMWS+yfrhkkYqFyKoucxiYIIe1UP+dQwt
	 yMORzvqHxYLJ3Lz8IW09Kekm757vtWIxjowePf5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 429/554] xhci: dbgtty: use IDR to support several dbc instances.
Date: Thu, 15 Jan 2026 17:48:15 +0100
Message-ID: <20260115164301.788488385@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit e1ec140f273e1e30cea7e6d5f50934d877232121 ]

To support systems with several xhci controllers with active
dbc on each xhci we need to use IDR to identify and give
an index to each port.

Avoid using global struct tty_driver.driver_state for storing
dbc port pointer as it won't work with several dbc ports

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20220216095153.1303105-6-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 1f73b8b56cf3 ("xhci: dbgtty: fix device unregister")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-dbgcap.h |    1 
 drivers/usb/host/xhci-dbgtty.c |   46 ++++++++++++++++++++++++++++++++++-------
 2 files changed, 40 insertions(+), 7 deletions(-)

--- a/drivers/usb/host/xhci-dbgcap.h
+++ b/drivers/usb/host/xhci-dbgcap.h
@@ -102,6 +102,7 @@ struct dbc_ep {
 struct dbc_port {
 	struct tty_port			port;
 	spinlock_t			port_lock;	/* port access */
+	int				minor;
 
 	struct list_head		read_pool;
 	struct list_head		read_queue;
--- a/drivers/usb/host/xhci-dbgtty.c
+++ b/drivers/usb/host/xhci-dbgtty.c
@@ -10,6 +10,7 @@
 #include <linux/slab.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
+#include <linux/idr.h>
 
 #include "xhci.h"
 #include "xhci-dbgcap.h"
@@ -18,6 +19,8 @@ static int dbc_tty_init(void);
 static void dbc_tty_exit(void);
 
 static struct tty_driver *dbc_tty_driver;
+static struct idr dbc_tty_minors;
+static DEFINE_MUTEX(dbc_tty_minors_lock);
 
 static inline struct dbc_port *dbc_to_port(struct xhci_dbc *dbc)
 {
@@ -195,7 +198,14 @@ xhci_dbc_free_requests(struct list_head
 
 static int dbc_tty_install(struct tty_driver *driver, struct tty_struct *tty)
 {
-	struct dbc_port		*port = driver->driver_state;
+	struct dbc_port		*port;
+
+	mutex_lock(&dbc_tty_minors_lock);
+	port = idr_find(&dbc_tty_minors, tty->index);
+	mutex_unlock(&dbc_tty_minors_lock);
+
+	if (!port)
+		return -ENXIO;
 
 	tty->driver_data = port;
 
@@ -424,6 +434,15 @@ static int xhci_dbc_tty_register_device(
 
 	xhci_dbc_tty_init_port(dbc, port);
 
+	mutex_lock(&dbc_tty_minors_lock);
+	port->minor = idr_alloc(&dbc_tty_minors, port, 0, 64, GFP_KERNEL);
+	mutex_unlock(&dbc_tty_minors_lock);
+
+	if (port->minor < 0) {
+		ret = port->minor;
+		goto err_idr;
+	}
+
 	ret = kfifo_alloc(&port->write_fifo, DBC_WRITE_BUF_SIZE, GFP_KERNEL);
 	if (ret)
 		goto err_exit_port;
@@ -439,7 +458,7 @@ static int xhci_dbc_tty_register_device(
 		goto err_free_requests;
 
 	tty_dev = tty_port_register_device(&port->port,
-					   dbc_tty_driver, 0, NULL);
+					   dbc_tty_driver, port->minor, NULL);
 	if (IS_ERR(tty_dev)) {
 		ret = PTR_ERR(tty_dev);
 		goto err_free_requests;
@@ -455,6 +474,8 @@ err_free_requests:
 err_free_fifo:
 	kfifo_free(&port->write_fifo);
 err_exit_port:
+	idr_remove(&dbc_tty_minors, port->minor);
+err_idr:
 	xhci_dbc_tty_exit_port(port);
 
 	dev_err(dbc->dev, "can't register tty port, err %d\n", ret);
@@ -468,10 +489,14 @@ static void xhci_dbc_tty_unregister_devi
 
 	if (!port->registered)
 		return;
-	tty_unregister_device(dbc_tty_driver, 0);
+	tty_unregister_device(dbc_tty_driver, port->minor);
 	xhci_dbc_tty_exit_port(port);
 	port->registered = false;
 
+	mutex_lock(&dbc_tty_minors_lock);
+	idr_remove(&dbc_tty_minors, port->minor);
+	mutex_unlock(&dbc_tty_minors_lock);
+
 	kfifo_free(&port->write_fifo);
 	xhci_dbc_free_requests(&port->read_pool);
 	xhci_dbc_free_requests(&port->read_queue);
@@ -500,9 +525,8 @@ int xhci_dbc_tty_probe(struct device *de
 		goto out;
 	}
 
-	dbc_tty_driver->driver_state = port;
-
 	dbc = xhci_alloc_dbc(dev, base, &dbc_driver);
+
 	if (!dbc) {
 		status = -ENOMEM;
 		goto out2;
@@ -541,10 +565,14 @@ static int dbc_tty_init(void)
 {
 	int		ret;
 
-	dbc_tty_driver = tty_alloc_driver(1, TTY_DRIVER_REAL_RAW |
+	idr_init(&dbc_tty_minors);
+
+	dbc_tty_driver = tty_alloc_driver(64, TTY_DRIVER_REAL_RAW |
 					  TTY_DRIVER_DYNAMIC_DEV);
-	if (IS_ERR(dbc_tty_driver))
+	if (IS_ERR(dbc_tty_driver)) {
+		idr_destroy(&dbc_tty_minors);
 		return PTR_ERR(dbc_tty_driver);
+	}
 
 	dbc_tty_driver->driver_name = "dbc_serial";
 	dbc_tty_driver->name = "ttyDBC";
@@ -564,7 +592,9 @@ static int dbc_tty_init(void)
 	if (ret) {
 		pr_err("Can't register dbc tty driver\n");
 		tty_driver_kref_put(dbc_tty_driver);
+		idr_destroy(&dbc_tty_minors);
 	}
+
 	return ret;
 }
 
@@ -575,4 +605,6 @@ static void dbc_tty_exit(void)
 		tty_driver_kref_put(dbc_tty_driver);
 		dbc_tty_driver = NULL;
 	}
+
+	idr_destroy(&dbc_tty_minors);
 }


