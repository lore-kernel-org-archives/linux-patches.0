Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AAD140E3D;
	Thu, 11 Apr 2024 10:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830818; cv=none; b=g6GlZn9jV0x+jT2WSM7dE3jvQ2sUWRi20wYrharCfij4I51JgdYQIZ217IjXYCZqjb/a+QxqHgJDCkeYgQuTxPaIWCoZdd73E8lv+oaiKZ9SuLu51Obw9U2s+Rj7w90hRm7Xu6a3m66DhJjVHRUeQ4Ky/LEjmrBBOQu5Y/qUQMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830818; c=relaxed/simple;
	bh=DpZQDw3JaW94Ed0WUjMkuTsa9QhYyXxoAFAW7xBAlVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3AzVJ+66o9I1DiqgvtNLOqMtHO9d5u2tDhbdLCEBGnePhlYlznPYuQFY5KLtMTGpTLNtY1mvbdRRuMssu0KMxjf0FyFbOJf6HWLzrSkY168RyZG3eQqYFZEvp9K1W3Ibq0UDPoC7ktJSRoR9xWvrUTn8OuJYK2u4XVdudRJbSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TgBIJgVq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TgBIJgVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81AA4C433F1;
	Thu, 11 Apr 2024 10:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830817;
	bh=DpZQDw3JaW94Ed0WUjMkuTsa9QhYyXxoAFAW7xBAlVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TgBIJgVqgSGWm16Jzekq7lxRtZKuUTwqw7hWi3pvzWSLfkyOs/TV8+RB+9R34YG6K
	 AhdcpoB3JtOUbZ61+NQcg9Rf7nLMo3ojqrnTFuEFDG2WK4eKVqc0WJ3Sz0YjjQWyko
	 KRDWPSuFBH4T1FbwGMC1E2umUjaiXeC2U2pSsvDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.4 128/215] USB: core: Fix deadlock in usb_deauthorize_interface()
Date: Thu, 11 Apr 2024 11:55:37 +0200
Message-ID: <20240411095428.744925858@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1190,14 +1190,24 @@ static ssize_t interface_authorized_stor
 {
 	struct usb_interface *intf = to_usb_interface(dev);
 	bool val;
+	struct kernfs_node *kn;
 
 	if (strtobool(buf, &val) != 0)
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


