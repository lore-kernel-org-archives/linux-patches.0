Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77D1263C83;
	Tue,  8 Apr 2025 12:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115413; cv=none; b=A9w+ykx7t3xIyf9FD6ERnQpl4qyRhKELJZpgh7yR7HOly/W9iTiLapfkI/209Ji/3gkUFSuaAeZY9n5V3f4vUG4EKpjsWozvq1CcRJrwywT0fH+6ZURO+w/smh1ItN0IAdT1bRGcyKP9jL2KUZK06UoNwqnIiYCM3b4KY20k5ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115413; c=relaxed/simple;
	bh=3Jz6BpAq91+QYumOLaNIa8QvjanC6RFmy4Bw1E2ufT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5qOPhTAYB8g+PnkeoJuwoFs3Nvns1NQ+hAwDJ6SpnnDII62J/0U50yHhuxw5Dp3GFs451byYXWfNfwohLRnuXb01TLSHusWHwsM4SrgAtu+4XycV5hzwocPfTAen9hPBi6ihFLMAeLaeCQtZTHVAXaHipZogfZAI7Y2/hLpako=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TceYV3RR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TceYV3RR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A570C4CEE5;
	Tue,  8 Apr 2025 12:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115412;
	bh=3Jz6BpAq91+QYumOLaNIa8QvjanC6RFmy4Bw1E2ufT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TceYV3RRVZL+q9FsgsjeoaAUjHWRbvBCKVprF+SdF73Y3YjTM60CRQFqWRXFcrVze
	 w3aXO0rdIDT3nyDYH+iHxSgDgW05QHPlMQtAVbRcOKq0/F9t2plAefg1RjMFg1tWAg
	 NtCRH8zpqnWZrb37EsmVHYiTSzWBWOFv6zeQGFzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 426/499] staging: gpib: Agilent usb code cleanup
Date: Tue,  8 Apr 2025 12:50:38 +0200
Message-ID: <20250408104901.852284160@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Penkler <dpenkler@gmail.com>

[ Upstream commit 579b6f18c5ca162af040f44684cc55f7da182236 ]

Remove useless #ifdef RESET_USB_CONFIG code.

Change kalloc / memset to kzalloc

The attach function was not freeing the private data on error
returns. Separate the releasing of urbs and private data and
add a common error exit for attach failure.

Set the board private data pointer to NULL after freeing
the private data.

Reduce console spam by emitting only one attach message.

Change last pr_err in attach to dev_err

Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Link: https://lore.kernel.org/r/20250118145046.12181-3-dpenkler@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 8491e73a5223 ("staging: gpib: Fix Oops after disconnect in agilent usb")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpib/agilent_82357a/agilent_82357a.c      | 84 ++++++++-----------
 1 file changed, 36 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/gpib/agilent_82357a/agilent_82357a.c b/drivers/staging/gpib/agilent_82357a/agilent_82357a.c
index d072c63651629..0d8d495d3dfc6 100644
--- a/drivers/staging/gpib/agilent_82357a/agilent_82357a.c
+++ b/drivers/staging/gpib/agilent_82357a/agilent_82357a.c
@@ -1146,25 +1146,6 @@ static int agilent_82357a_setup_urbs(gpib_board_t *board)
 	return retval;
 }
 
-#ifdef RESET_USB_CONFIG
-static int agilent_82357a_reset_usb_configuration(gpib_board_t *board)
-{
-	struct agilent_82357a_priv *a_priv = board->private_data;
-	struct usb_device *usb_dev = interface_to_usbdev(a_priv->bus_interface);
-	struct usb_device *usb_dev;
-	int retval;
-
-	if (!a_priv->bus_interface)
-		return -ENODEV;
-	usb_dev = interface_to_usbdev(a_priv->bus_interface);
-	retval = usb_reset_configuration(usb_dev);
-	if (retval)
-		dev_err(&usb_dev->dev, "%s: usb_reset_configuration() returned %i\n",
-			__func__, retval);
-	return retval;
-}
-#endif
-
 static void agilent_82357a_cleanup_urbs(struct agilent_82357a_priv *a_priv)
 {
 	if (a_priv && a_priv->bus_interface) {
@@ -1175,15 +1156,23 @@ static void agilent_82357a_cleanup_urbs(struct agilent_82357a_priv *a_priv)
 	}
 };
 
+static void agilent_82357a_release_urbs(struct agilent_82357a_priv *a_priv)
+{
+	if (a_priv) {
+		usb_free_urb(a_priv->interrupt_urb);
+		a_priv->interrupt_urb = NULL;
+		kfree(a_priv->interrupt_buffer);
+	}
+}
+
 static int agilent_82357a_allocate_private(gpib_board_t *board)
 {
 	struct agilent_82357a_priv *a_priv;
 
-	board->private_data = kmalloc(sizeof(struct agilent_82357a_priv), GFP_KERNEL);
+	board->private_data = kzalloc(sizeof(struct agilent_82357a_priv), GFP_KERNEL);
 	if (!board->private_data)
 		return -ENOMEM;
 	a_priv = board->private_data;
-	memset(a_priv, 0, sizeof(struct agilent_82357a_priv));
 	mutex_init(&a_priv->bulk_transfer_lock);
 	mutex_init(&a_priv->bulk_alloc_lock);
 	mutex_init(&a_priv->control_alloc_lock);
@@ -1191,11 +1180,11 @@ static int agilent_82357a_allocate_private(gpib_board_t *board)
 	return 0;
 }
 
-static void agilent_82357a_free_private(struct agilent_82357a_priv *a_priv)
+static void agilent_82357a_free_private(gpib_board_t *board)
 {
-	usb_free_urb(a_priv->interrupt_urb);
-	kfree(a_priv->interrupt_buffer);
-	kfree(a_priv);
+	kfree(board->private_data);
+	board->private_data = NULL;
+
 }
 
 static int agilent_82357a_init(gpib_board_t *board)
@@ -1342,16 +1331,14 @@ static int agilent_82357a_attach(gpib_board_t *board, const gpib_board_config_t
 			a_priv->bus_interface = agilent_82357a_driver_interfaces[i];
 			usb_set_intfdata(agilent_82357a_driver_interfaces[i], board);
 			usb_dev = interface_to_usbdev(a_priv->bus_interface);
-			dev_info(&usb_dev->dev,
-				 "bus %d dev num %d attached to gpib minor %d, agilent usb interface %i\n",
-				 usb_dev->bus->busnum, usb_dev->devnum, board->minor, i);
 			break;
 		}
 	}
 	if (i == MAX_NUM_82357A_INTERFACES) {
-		mutex_unlock(&agilent_82357a_hotplug_lock);
-		pr_err("No Agilent 82357 gpib adapters found, have you loaded its firmware?\n");
-		return -ENODEV;
+		dev_err(board->gpib_dev,
+			"No Agilent 82357 gpib adapters found, have you loaded its firmware?\n");
+		retval = -ENODEV;
+		goto attach_fail;
 	}
 	product_id = le16_to_cpu(interface_to_usbdev(a_priv->bus_interface)->descriptor.idProduct);
 	switch (product_id) {
@@ -1365,21 +1352,13 @@ static int agilent_82357a_attach(gpib_board_t *board, const gpib_board_config_t
 		break;
 	default:
 		dev_err(&usb_dev->dev, "bug, unhandled product_id in switch?\n");
-		mutex_unlock(&agilent_82357a_hotplug_lock);
-		return -EIO;
-	}
-#ifdef RESET_USB_CONFIG
-	retval = agilent_82357a_reset_usb_configuration(board);
-	if (retval < 0)	{
-		mutex_unlock(&agilent_82357a_hotplug_lock);
-		return retval;
+		retval = -EIO;
+		goto attach_fail;
 	}
-#endif
+
 	retval = agilent_82357a_setup_urbs(board);
-	if (retval < 0)	{
-		mutex_unlock(&agilent_82357a_hotplug_lock);
-		return retval;
-	}
+	if (retval < 0)
+		goto attach_fail;
 
 	timer_setup(&a_priv->bulk_timer, agilent_82357a_timeout_handler, 0);
 
@@ -1388,11 +1367,19 @@ static int agilent_82357a_attach(gpib_board_t *board, const gpib_board_config_t
 	retval = agilent_82357a_init(board);
 
 	if (retval < 0)	{
-		mutex_unlock(&agilent_82357a_hotplug_lock);
-		return retval;
+		agilent_82357a_cleanup_urbs(a_priv);
+		agilent_82357a_release_urbs(a_priv);
+		goto attach_fail;
 	}
 
-	dev_info(&usb_dev->dev, "%s: attached\n", __func__);
+	dev_info(&usb_dev->dev,
+		 "bus %d dev num %d attached to gpib minor %d, agilent usb interface %i\n",
+		 usb_dev->bus->busnum, usb_dev->devnum, board->minor, i);
+	mutex_unlock(&agilent_82357a_hotplug_lock);
+	return retval;
+
+attach_fail:
+	agilent_82357a_free_private(board);
 	mutex_unlock(&agilent_82357a_hotplug_lock);
 	return retval;
 }
@@ -1455,7 +1442,8 @@ static void agilent_82357a_detach(gpib_board_t *board)
 		mutex_lock(&a_priv->bulk_alloc_lock);
 		mutex_lock(&a_priv->interrupt_alloc_lock);
 		agilent_82357a_cleanup_urbs(a_priv);
-		agilent_82357a_free_private(a_priv);
+		agilent_82357a_release_urbs(a_priv);
+		agilent_82357a_free_private(board);
 	}
 	dev_info(board->gpib_dev, "%s: detached\n", __func__);
 	mutex_unlock(&agilent_82357a_hotplug_lock);
-- 
2.39.5



