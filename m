Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D65F2D0C94;
	Sat, 12 Sep 2026 18:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237698; cv=none; b=W4jJzW8dP/2M9jeojGfA8CsTxYTwpcXW+a6KdmGpqUawHAxtyfvTefZi1pKqygo8ktccfntVCbb75r9py8FBTSVom6HTw2v0zE5Spy+yOy4on/KdsR000Zr0N57/Spgw177lBeZoUGZ+nwrjdVretW5lJHxBSck/IZkGjPU6tsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237698; c=relaxed/simple;
	bh=IEdldheKqvoYxbzXvkYQrImRcNDgWHaU4mwRJN6sORg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U50+Z1DovM/oE7KIiaIn4sbCD727JirI8GFfxRoQz5Nzo72BVSEsLg5l6DNz7hlkXAtoJ7NbAyutGMgbKlr64Xvc+i4poAnrJyDePD2NhQWnESpCN1oULMyxGYqmkxfsUX5E4RgZmYtslXULTH0F34Z6epddMC4PEUHBJ1drM6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dKZg3rUr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dKZg3rUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954231F000FF;
	Sat, 12 Sep 2026 18:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237697;
	bh=EjCozH2myEicoo0AExKhI5vhZstxTP1xSMIbjote19Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dKZg3rUrcYfa8MwmGMz0dH0Ry6hcv6+zJ8HHjdhh/B5ysPvnKhbGAlZ4AnLyowtJ2
	 yV4CXrYfquuRccpuXWjAzGTqoMigSzEdJ0V/MF88/7PumaeoXrz+kN2xFwqWO3n+Aj
	 vVq1zCkP4x0wFFIDaHz+Wqvw1+AWKfdK94edQdb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Miguel Garcia <miguelgarciaroman8@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 258/935] Input: aiptek - switch to using dev_groups for driver-specific attributes
Date: Sat, 12 Sep 2026 08:54:48 +0200
Message-ID: <20260912065532.744399994@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit f4e7a254299bcdfe7bced700a7d96690b1b9a6f2 upstream.

On 5.15.y, the attributes are removed manually from disconnect after
intfdata has been cleared and the input device unregistered. A concurrent
sysfs callback can therefore observe cleared driver data or use the input
device after unregistration. Letting the driver core manage the group
removes and drains it before the disconnect callback.

The driver core now has the ability to handle the creation and removal
of device-specific sysfs files, let's use it instead of registering and
unregistering attributes by hand.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20220903051119.1332808-3-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Miguel Garcia <miguelgarciaroman8@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/tablet/aiptek.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
index 64113810e16dc..e1705aaf8f649 100644
--- a/drivers/input/tablet/aiptek.c
+++ b/drivers/input/tablet/aiptek.c
@@ -1623,7 +1623,7 @@ static ssize_t show_firmwareCode(struct device *dev, struct device_attribute *at
 
 static DEVICE_ATTR(firmware_code, S_IRUGO, show_firmwareCode, NULL);
 
-static struct attribute *aiptek_attributes[] = {
+static struct attribute *aiptek_dev_attrs[] = {
 	&dev_attr_size.attr,
 	&dev_attr_pointer_mode.attr,
 	&dev_attr_coordinate_mode.attr,
@@ -1647,9 +1647,7 @@ static struct attribute *aiptek_attributes[] = {
 	NULL
 };
 
-static const struct attribute_group aiptek_attribute_group = {
-	.attrs	= aiptek_attributes,
-};
+ATTRIBUTE_GROUPS(aiptek_dev);
 
 /***********************************************************************
  * This routine is called when a tablet has been identified. It basically
@@ -1848,26 +1846,16 @@ aiptek_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	 */
 	usb_set_intfdata(intf, aiptek);
 
-	/* Set up the sysfs files
-	 */
-	err = sysfs_create_group(&intf->dev.kobj, &aiptek_attribute_group);
-	if (err) {
-		dev_warn(&intf->dev, "cannot create sysfs group err: %d\n",
-			 err);
-		goto fail3;
-        }
-
 	/* Register the tablet as an Input Device
 	 */
 	err = input_register_device(aiptek->inputdev);
 	if (err) {
 		dev_warn(&intf->dev,
 			 "input_register_device returned err: %d\n", err);
-		goto fail4;
+		goto fail3;
         }
 	return 0;
 
- fail4:	sysfs_remove_group(&intf->dev.kobj, &aiptek_attribute_group);
  fail3: usb_free_urb(aiptek->urb);
  fail2:	usb_free_coherent(usbdev, AIPTEK_PACKET_LENGTH, aiptek->data,
 			  aiptek->data_dma);
@@ -1892,7 +1880,6 @@ static void aiptek_disconnect(struct usb_interface *intf)
 		 */
 		usb_kill_urb(aiptek->urb);
 		input_unregister_device(aiptek->inputdev);
-		sysfs_remove_group(&intf->dev.kobj, &aiptek_attribute_group);
 		usb_free_urb(aiptek->urb);
 		usb_free_coherent(interface_to_usbdev(intf),
 				  AIPTEK_PACKET_LENGTH,
@@ -1906,6 +1893,7 @@ static struct usb_driver aiptek_driver = {
 	.probe = aiptek_probe,
 	.disconnect = aiptek_disconnect,
 	.id_table = aiptek_ids,
+	.dev_groups = aiptek_dev_groups,
 };
 
 module_usb_driver(aiptek_driver);
-- 
2.53.0



