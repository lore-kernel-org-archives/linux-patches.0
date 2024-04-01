Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674B9BA3F;
	Mon,  1 Apr 2024 16:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990474; cv=none; b=akBMu/Lz5BkEJjYOGrwY8hg8DZw2v6JffeZkA4+s5ABX2jYhMeEeZdp9Ujc0GiWh1mZFXwszgA7JbOxIf0Z3y9WlfVl71ifEDMDt2hbITdvkQGkMkje1b257InmfjQYlOaRB8Y3hrh1Mp1bM2W0YeqZYZij8W5u4YIrRCZiiB24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990474; c=relaxed/simple;
	bh=8rxyuGXHgirr3C7+0Q+CWa8jWy13srgXLvTWlimorvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuP1DF3tUm7UpNx4PlrzMlE3LK/JkWDkxYCUJXqL5By6VkkIbZmRBfelX1Kbpt/nGC/H8Vs5hsgBAj81CRc0zGqIH8/dBqmmchrD8Z+3jbbrljhAHY3k29HrdKIjPcawL3lVgrHPsvnI76V8eHm/LyhdLrkXZRt4XBUChOtK61o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wHiWeNP+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wHiWeNP+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85DFC433F1;
	Mon,  1 Apr 2024 16:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990474;
	bh=8rxyuGXHgirr3C7+0Q+CWa8jWy13srgXLvTWlimorvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wHiWeNP+LwTqk1//5bC2RP9oB2bChz+LC7ZV5s//hgeXFZWOH27ple/Uw2TDQ9Dvk
	 FWfO+VWjrjYzD5UQDWkVuhmX+l4JbHPdkavpRltOXbx2NrAu6NJldSxNvkw8M/tvX+
	 F6zjGJIeanLJpWh/J+TsOXS+ZIHeK6UwNfU3NmuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.6 363/396] USB: core: Fix deadlock in usb_deauthorize_interface()
Date: Mon,  1 Apr 2024 17:46:52 +0200
Message-ID: <20240401152558.742975641@linuxfoundation.org>
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

commit 80ba43e9f799cbdd83842fc27db667289b3150f5 upstream.

Among the attribute file callback routines in
drivers/usb/core/sysfs.c, the interface_authorized_store() function is
the only one which acquires a device lock on an ancestor device: It
calls usb_deauthorize_interface(), which locks the interface's parent
USB device.

The will lead to deadlock if another process already owns that lock
and tries to remove the interface, whether through a configuration
change or because the device has been disconnected.  As part of the
removal procedure, device_del() waits for all ongoing sysfs attribute
callbacks to complete.  But usb_deauthorize_interface() can't complete
until the device lock has been released, and the lock won't be
released until the removal has finished.

The mechanism provided by sysfs to prevent this kind of deadlock is
to use the sysfs_break_active_protection() function, which tells sysfs
not to wait for the attribute callback.

Reported-and-tested by: Yue Sun <samsun1006219@gmail.com>
Reported by: xingwei lee <xrivendell7@gmail.com>

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/linux-usb/CAEkJfYO6jRVC8Tfrd_R=cjO0hguhrV31fDPrLrNOOHocDkPoAA@mail.gmail.com/#r
Fixes: 310d2b4124c0 ("usb: interface authorization: SysFS part of USB interface authorization")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1c37eea1-9f56-4534-b9d8-b443438dc869@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/sysfs.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -1168,14 +1168,24 @@ static ssize_t interface_authorized_stor
 {
 	struct usb_interface *intf = to_usb_interface(dev);
 	bool val;
+	struct kernfs_node *kn;
 
 	if (kstrtobool(buf, &val) != 0)
 		return -EINVAL;
 
-	if (val)
+	if (val) {
 		usb_authorize_interface(intf);
-	else
-		usb_deauthorize_interface(intf);
+	} else {
+		/*
+		 * Prevent deadlock if another process is concurrently
+		 * trying to unregister intf.
+		 */
+		kn = sysfs_break_active_protection(&dev->kobj, &attr->attr);
+		if (kn) {
+			usb_deauthorize_interface(intf);
+			sysfs_unbreak_active_protection(kn);
+		}
+	}
 
 	return count;
 }


