Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57185D8FD;
	Tue, 23 Jan 2024 01:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974979; cv=none; b=qSlKpdY86eiKCcGsCGRdnpBu0+PDV3lDKrxxdAURuZVskDSAkB9bWv5APx3bPFVBp6T1L10d2brCnwPzfy3LB+GjxRiJqH1AvIgzagegDOW0Ru236c2nOdDc0eXyICnrCw4kfA0ZTyWhOElVUqGlSlT3suqPQv9cZZhrE+2Bx+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974979; c=relaxed/simple;
	bh=coSA+yqqTJEUH37YO26nk81EIhiRLtx4Db9xhUUvbUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e20MAZzPEvk1cYRMZiLNoF6xCEU/liB1l/S1vc/9PA8a9/pZ1srX9l/iwSSI95TfWMnQmMhxT4s7TtwYyR5R73wxX9bRCd27rx+q69zaK0gr7YTXXdBzGr963KsTugCCwQnzaUOUwc2DW14wAQ5RSW83pHK5iOYsyTAJfsRumG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RMLVUJvU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RMLVUJvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C78AC433C7;
	Tue, 23 Jan 2024 01:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974979;
	bh=coSA+yqqTJEUH37YO26nk81EIhiRLtx4Db9xhUUvbUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RMLVUJvUJZCvvVydohsBJE25XsKcgy+cIpGDr7XATv9YvbhkUTle5aIsBFPcN421l
	 aqG2f24dlFY+cfF0cdSRSbRmevJJHWrlc9SJUQe4iHloYNqxQcWrHJeJIHmazn7kyu
	 KrBzyp0Mo8jba/NSplCpyyfqZWC3Eq7vRpbMCWdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 305/374] usb: core: Allow subclassed USB drivers to override usb_choose_configuration()
Date: Mon, 22 Jan 2024 15:59:21 -0800
Message-ID: <20240122235755.434019229@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit a87b8e3be926af0fc3b9b1af42b1127bd1ff077c ]

For some USB devices we might want to do something different for
usb_choose_configuration(). One example here is the r8152 driver where
we want to end up using the vendor driver with the preferred
interface.

The r8152 driver tried to make things work by implementing a USB
generic_subclass driver and then overriding the normal config
selection after it happened. This is less than ideal and also caused
breakage if someone deauthorized and re-authorized the USB device
because the USB core ended up going back to it's default logic for
choosing the best config. I made an attempt to fix this [1] but it was
a bit ugly.

Let's do this better and allow USB generic_subclass drivers to
override usb_choose_configuration().

[1] https://lore.kernel.org/r/20231130154337.1.Ie00e07f07f87149c9ce0b27ae4e26991d307e14b@changeid

Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20231201102946.v2.2.Iade5fa31997f1a0ca3e1dec0591633b02471df12@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: aa4f2b3e418e ("r8152: Choose our USB config with choose_configuration() rather than probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/generic.c | 7 +++++++
 include/linux/usb.h        | 6 ++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/usb/core/generic.c b/drivers/usb/core/generic.c
index 26f9fb9f67ca..57f6cab36ef6 100644
--- a/drivers/usb/core/generic.c
+++ b/drivers/usb/core/generic.c
@@ -59,10 +59,17 @@ int usb_choose_configuration(struct usb_device *udev)
 	int num_configs;
 	int insufficient_power = 0;
 	struct usb_host_config *c, *best;
+	struct usb_device_driver *udriver = to_usb_device_driver(udev->dev.driver);
 
 	if (usb_device_is_owned(udev))
 		return 0;
 
+	if (udriver->choose_configuration) {
+		i = udriver->choose_configuration(udev);
+		if (i >= 0)
+			return i;
+	}
+
 	best = NULL;
 	c = udev->config;
 	num_configs = udev->descriptor.bNumConfigurations;
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 987550fd46fa..d879fc573f43 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1241,6 +1241,9 @@ struct usb_driver {
  *	module is being unloaded.
  * @suspend: Called when the device is going to be suspended by the system.
  * @resume: Called when the device is being resumed by the system.
+ * @choose_configuration: If non-NULL, called instead of the default
+ *	usb_choose_configuration(). If this returns an error then we'll go
+ *	on to call the normal usb_choose_configuration().
  * @dev_groups: Attributes attached to the device that will be created once it
  *	is bound to the driver.
  * @drvwrap: Driver-model core structure wrapper.
@@ -1264,6 +1267,9 @@ struct usb_device_driver {
 
 	int (*suspend) (struct usb_device *udev, pm_message_t message);
 	int (*resume) (struct usb_device *udev, pm_message_t message);
+
+	int (*choose_configuration) (struct usb_device *udev);
+
 	const struct attribute_group **dev_groups;
 	struct usbdrv_wrap drvwrap;
 	const struct usb_device_id *id_table;
-- 
2.43.0



