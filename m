Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A7E1917E3;
	Tue, 29 Apr 2025 17:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948346; cv=none; b=bWHxyCo4MSg+1xXjnVrDbMtXnCWsU0DPMz82fgyNH5PJV1ZkrF2j3dUnZDNB+CFTFH66KALFDehhvYEGRNol/su35DyEk7rc3b30pZM3D7NPXDBfXymB0dp82Jl8NlJmAwk0lpGJ2zb8KhEzCFlzSjylFjdoPTQWGAuRPiWwZwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948346; c=relaxed/simple;
	bh=okEiGwmzKoERpUky7u4kX4hl4+W9dWHI2LG+i0NTWRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGvRB4G9DSUGFSRC4NNSTCnqJ9XiQVQJul9kFf2JSBQ5OIytIwClm9f1BClwmaYiIo8LTfT934G289vgB8S9CByEQrg2UvVlhZ4x5ZpxqHYA3GiZNB2uxcBX2lKkhVIH/BugR/Narn2/OnsrVtnRV99z7KJPw1HM2ifcdirr1yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cilttp3d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cilttp3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9D4C4CEE3;
	Tue, 29 Apr 2025 17:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948346;
	bh=okEiGwmzKoERpUky7u4kX4hl4+W9dWHI2LG+i0NTWRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cilttp3dLrWLVDa2QyEsPrnecrL3EE0cm5B0W6lWwfAe0YJmbTb2LOwq+Ho4GF1EK
	 pXQSGOVVAz8Gy0g1zGOwYhmCzvzlGfI0qGDh5llhNR97pLbmqe/AzLO8hUaFsYFTIJ
	 a6vX8VU2kGU1jgBRBlCGKEoAUgFaUeg7m5Dunw5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Benson Leung <bleung@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.12 259/280] usb: typec: class: Fix NULL pointer access
Date: Tue, 29 Apr 2025 18:43:20 +0200
Message-ID: <20250429161125.733215332@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Andrei Kuchynski <akuchynski@chromium.org>

commit ec27386de23a511008c53aa2f3434ad180a3ca9a upstream.

Concurrent calls to typec_partner_unlink_device can lead to a NULL pointer
dereference. This patch adds a mutex to protect USB device pointers and
prevent this issue. The same mutex protects both the device pointers and
the partner device registration.

Cc: stable@vger.kernel.org
Fixes: 59de2a56d127 ("usb: typec: Link enumerated USB devices with Type-C partner")
Signed-off-by: Andrei Kuchynski <akuchynski@chromium.org>
Reviewed-by: Benson Leung <bleung@chromium.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250321143728.4092417-2-akuchynski@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/class.c |   15 +++++++++++++--
 drivers/usb/typec/class.h |    1 +
 2 files changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -932,6 +932,7 @@ struct typec_partner *typec_register_par
 	partner->dev.type = &typec_partner_dev_type;
 	dev_set_name(&partner->dev, "%s-partner", dev_name(&port->dev));
 
+	mutex_lock(&port->partner_link_lock);
 	ret = device_register(&partner->dev);
 	if (ret) {
 		dev_err(&port->dev, "failed to register partner (%d)\n", ret);
@@ -943,6 +944,7 @@ struct typec_partner *typec_register_par
 		typec_partner_link_device(partner, port->usb2_dev);
 	if (port->usb3_dev)
 		typec_partner_link_device(partner, port->usb3_dev);
+	mutex_unlock(&port->partner_link_lock);
 
 	return partner;
 }
@@ -963,12 +965,14 @@ void typec_unregister_partner(struct typ
 
 	port = to_typec_port(partner->dev.parent);
 
+	mutex_lock(&port->partner_link_lock);
 	if (port->usb2_dev)
 		typec_partner_unlink_device(partner, port->usb2_dev);
 	if (port->usb3_dev)
 		typec_partner_unlink_device(partner, port->usb3_dev);
 
 	device_unregister(&partner->dev);
+	mutex_unlock(&port->partner_link_lock);
 }
 EXPORT_SYMBOL_GPL(typec_unregister_partner);
 
@@ -1862,25 +1866,30 @@ static struct typec_partner *typec_get_p
 static void typec_partner_attach(struct typec_connector *con, struct device *dev)
 {
 	struct typec_port *port = container_of(con, struct typec_port, con);
-	struct typec_partner *partner = typec_get_partner(port);
+	struct typec_partner *partner;
 	struct usb_device *udev = to_usb_device(dev);
 
+	mutex_lock(&port->partner_link_lock);
 	if (udev->speed < USB_SPEED_SUPER)
 		port->usb2_dev = dev;
 	else
 		port->usb3_dev = dev;
 
+	partner = typec_get_partner(port);
 	if (partner) {
 		typec_partner_link_device(partner, dev);
 		put_device(&partner->dev);
 	}
+	mutex_unlock(&port->partner_link_lock);
 }
 
 static void typec_partner_deattach(struct typec_connector *con, struct device *dev)
 {
 	struct typec_port *port = container_of(con, struct typec_port, con);
-	struct typec_partner *partner = typec_get_partner(port);
+	struct typec_partner *partner;
 
+	mutex_lock(&port->partner_link_lock);
+	partner = typec_get_partner(port);
 	if (partner) {
 		typec_partner_unlink_device(partner, dev);
 		put_device(&partner->dev);
@@ -1890,6 +1899,7 @@ static void typec_partner_deattach(struc
 		port->usb2_dev = NULL;
 	else if (port->usb3_dev == dev)
 		port->usb3_dev = NULL;
+	mutex_unlock(&port->partner_link_lock);
 }
 
 /**
@@ -2425,6 +2435,7 @@ struct typec_port *typec_register_port(s
 
 	ida_init(&port->mode_ids);
 	mutex_init(&port->port_type_lock);
+	mutex_init(&port->partner_link_lock);
 
 	port->id = id;
 	port->ops = cap->ops;
--- a/drivers/usb/typec/class.h
+++ b/drivers/usb/typec/class.h
@@ -56,6 +56,7 @@ struct typec_port {
 	enum typec_pwr_opmode		pwr_opmode;
 	enum typec_port_type		port_type;
 	struct mutex			port_type_lock;
+	struct mutex			partner_link_lock;
 
 	enum typec_orientation		orientation;
 	struct typec_switch		*sw;


