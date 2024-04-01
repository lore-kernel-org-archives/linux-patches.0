Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8A848CDD;
	Mon,  1 Apr 2024 16:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990599; cv=none; b=blNXLnkxP/RtRncpRuBvEEMsOFSIyTjkDC8TE8j8U8M0YlFd+t7oTSoGD1w9nPQaevzd98el4B8Uciag36c73P534AhbvzVsV2iKMSGHUkWF8wDYeSREuNjEflVpIxYYsSYeTJhGQXINBFdRP2dAgODaXRiEKPmUxXBKUmdGCw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990599; c=relaxed/simple;
	bh=biiYxTnkEBjnKeyLzgXao8gdiiW41J7FYSX5VNDJgUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l9MaMhTwCoWdD1lAWweMMNdTaN8DL57ch7U9zmA0p+pLseXSqKKX4ISMMorGTGJz4fFoNYtGmPlCt15Y1ldQu7STo2ZrrBI4VyC/d/65KrXKuf1VqOzfotMnIzEK+oJxHw477uKNQ/6Fw/K2RHJJvYTMdeddoPCf45PCyyWRKSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wV5kDN9x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wV5kDN9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE4EC433F1;
	Mon,  1 Apr 2024 16:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990599;
	bh=biiYxTnkEBjnKeyLzgXao8gdiiW41J7FYSX5VNDJgUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wV5kDN9xU6CE9oM4UwE+MCzkFiTckUdvVClHm9EeqvdgL/v4rPWx0QjUttQlb00v7
	 WH08dlzUf2uBflpra3kWIEBJs5TLh0G05YMqtyLcimlMfOjdWLLafnQ9fqzmwfzo/N
	 wLhlU53+j3pC2dJ6mFI7yG8gj1xfPJzdMwljxiFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 365/396] USB: core: Fix deadlock in port "disable" sysfs attribute
Date: Mon,  1 Apr 2024 17:46:54 +0200
Message-ID: <20240401152558.800965933@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Alan Stern <stern@rowland.harvard.edu>

commit f4d1960764d8a70318b02f15203a1be2b2554ca1 upstream.

The show and store callback routines for the "disable" sysfs attribute
file in port.c acquire the device lock for the port's parent hub
device.  This can cause problems if another process has locked the hub
to remove it or change its configuration:

	Removing the hub or changing its configuration requires the
	hub interface to be removed, which requires the port device
	to be removed, and device_del() waits until all outstanding
	sysfs attribute callbacks for the ports have returned.  The
	lock can't be released until then.

	But the disable_show() or disable_store() routine can't return
	until after it has acquired the lock.

The resulting deadlock can be avoided by calling
sysfs_break_active_protection().  This will cause the sysfs core not
to wait for the attribute's callback routine to return, allowing the
removal to proceed.  The disadvantage is that after making this call,
there is no guarantee that the hub structure won't be deallocated at
any moment.  To prevent this, we have to acquire a reference to it
first by calling hub_get().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/f7a8c135-a495-4ce6-bd49-405a45e7ea9a@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/port.c |   38 ++++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

--- a/drivers/usb/core/port.c
+++ b/drivers/usb/core/port.c
@@ -55,11 +55,22 @@ static ssize_t disable_show(struct devic
 	u16 portstatus, unused;
 	bool disabled;
 	int rc;
+	struct kernfs_node *kn;
 
+	hub_get(hub);
 	rc = usb_autopm_get_interface(intf);
 	if (rc < 0)
-		return rc;
+		goto out_hub_get;
 
+	/*
+	 * Prevent deadlock if another process is concurrently
+	 * trying to unregister hdev.
+	 */
+	kn = sysfs_break_active_protection(&dev->kobj, &attr->attr);
+	if (!kn) {
+		rc = -ENODEV;
+		goto out_autopm;
+	}
 	usb_lock_device(hdev);
 	if (hub->disconnected) {
 		rc = -ENODEV;
@@ -69,9 +80,13 @@ static ssize_t disable_show(struct devic
 	usb_hub_port_status(hub, port1, &portstatus, &unused);
 	disabled = !usb_port_is_power_on(hub, portstatus);
 
-out_hdev_lock:
+ out_hdev_lock:
 	usb_unlock_device(hdev);
+	sysfs_unbreak_active_protection(kn);
+ out_autopm:
 	usb_autopm_put_interface(intf);
+ out_hub_get:
+	hub_put(hub);
 
 	if (rc)
 		return rc;
@@ -89,15 +104,26 @@ static ssize_t disable_store(struct devi
 	int port1 = port_dev->portnum;
 	bool disabled;
 	int rc;
+	struct kernfs_node *kn;
 
 	rc = kstrtobool(buf, &disabled);
 	if (rc)
 		return rc;
 
+	hub_get(hub);
 	rc = usb_autopm_get_interface(intf);
 	if (rc < 0)
-		return rc;
+		goto out_hub_get;
 
+	/*
+	 * Prevent deadlock if another process is concurrently
+	 * trying to unregister hdev.
+	 */
+	kn = sysfs_break_active_protection(&dev->kobj, &attr->attr);
+	if (!kn) {
+		rc = -ENODEV;
+		goto out_autopm;
+	}
 	usb_lock_device(hdev);
 	if (hub->disconnected) {
 		rc = -ENODEV;
@@ -118,9 +144,13 @@ static ssize_t disable_store(struct devi
 	if (!rc)
 		rc = count;
 
-out_hdev_lock:
+ out_hdev_lock:
 	usb_unlock_device(hdev);
+	sysfs_unbreak_active_protection(kn);
+ out_autopm:
 	usb_autopm_put_interface(intf);
+ out_hub_get:
+	hub_put(hub);
 
 	return rc;
 }


