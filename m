Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C3E4AEE0;
	Mon,  1 Apr 2024 17:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991385; cv=none; b=f8ajdsp6VqAE1Bod01hFK1jPRNskSF8zcLrYe4ncQn22ZCneR6IvqGHBzHD+a3ngupjMcD3htHEj4VPncsNrtYIaMLIJeLdIX46I6DhN1Keg/V0y716rQFBN3IgqMaBOP1dwf05oRgbhxV6NTjda6orND8SF3ovuo+1QA0PK7X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991385; c=relaxed/simple;
	bh=dXkOCjV19EPkKh2ihqfVdtwPWBgJKXUzCmK/2bGsEsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZY9jNvUA5zTLoOGQhy1PCJtXXGocOn66d4rzS3efmoMpY/vsyKChgAJFhuqeMU4d6061eXNDitgRG+4Zo7kkjGAPXY2jhCefvPyTu6p1LmTsVcqLBv7VRunD2zNFdMT9TVfWCzwYJm2CjXdT7AizFiGl4V4Y/vTxWOwUkKSybQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJhvBtlN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJhvBtlN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8827DC433C7;
	Mon,  1 Apr 2024 17:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991384;
	bh=dXkOCjV19EPkKh2ihqfVdtwPWBgJKXUzCmK/2bGsEsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJhvBtlNx1GUrAD6tC5WV/+ggy2w/r0oDIsf6FYwh+L3u9fK+UM/+k1xtzrXp2j3T
	 99cZE0Uv6WIG3j5qbFIuc4EBovJS08w9hWiaNn57Pcnhgvris8Y4fkbrz/CtcMwn+W
	 wExlOQ+llFIZLYOIJsp28zFy4tZUrLmXQm8/3nSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 241/272] USB: core: Fix deadlock in port "disable" sysfs attribute
Date: Mon,  1 Apr 2024 17:47:11 +0200
Message-ID: <20240401152538.500427258@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -28,11 +28,22 @@ static ssize_t disable_show(struct devic
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
@@ -42,9 +53,13 @@ static ssize_t disable_show(struct devic
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
@@ -62,15 +77,26 @@ static ssize_t disable_store(struct devi
 	int port1 = port_dev->portnum;
 	bool disabled;
 	int rc;
+	struct kernfs_node *kn;
 
 	rc = strtobool(buf, &disabled);
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
@@ -91,9 +117,13 @@ static ssize_t disable_store(struct devi
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


