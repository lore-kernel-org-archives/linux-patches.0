Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AE63F4103;
	Sat, 12 Sep 2026 07:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198175; cv=none; b=VDgNt7Eb0ggIRGpGF1yBHbX6y0MUUJhU4FCGWk70qmhhz32hD9c7KDYswX9PGJ4UzbGYAePkZp29cJHmjJ8QNb3lk/NTjfZyPwiae75t9HH1wPe26c9LbqaYgihJiQwijflpEnDfIHwtMEOqSCznWFQsoJXKbg1w/MHprLYdExA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198175; c=relaxed/simple;
	bh=0nslVAdRAZ3i7n79RpmhRiS4gw14Nn+6ffSmA4XLq+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRNynO6+VgrqnwrPaEVuM2gZfFAee3xJQznwRUZw/dH42+9HgdRuqLsYc8ig03bIp0RSSQsGMWvadRcZ3YnezZs83TjRMlmU34b3ya6HWziDn+DwSXriuCSB4iMRZ9UynoGJmDxrhodd31Ix2Nk7mFRtrDl+CI5N5XjMGgEsn80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3kSvFer; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3kSvFer"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DCE1F000FF;
	Sat, 12 Sep 2026 07:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198168;
	bh=HGiLyxeNLM34tUPgDOjLrOyfOaVNvilCxf4w9ELelSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3kSvFerAgdtdcXaIZBJ5h8/t74Yro5/ao2Hnabd9Wvb9M1gsrPbnLQFUUkX9XPHR
	 w87dQsGKEAM/OozfIHHZWhrnqSv8Cb5sC7CTPYzFPJ821vxZ3fjsKx3Q83liNM/dcX
	 mrUs3fK1FbFupJYD9gmr1vr01+UXJrCoSx2h00D0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0326/1815] usb: fix UAF when probe runs concurrent to dyn ID removal
Date: Sat, 12 Sep 2026 08:34:36 +0200
Message-ID: <20260912065656.585468718@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gary Guo <gary@garyguo.net>

[ Upstream commit ef8154d8b52d60338c1fd8d793cd8e891c604c14 ]

Dynamic IDs are only guaranteed to be valid when usb_dynids_lock is held,
as remove_id_store can free the node. Thus, make a copy in
usb_probe_interface. Clarify the documentation that the id parameter is
only valid during the probe.

USB serial has the same pattern, but it does not need fixing as the IDs
cannot be removed via sysfs.

Fixes: 0c7a2b72746a ("USB: add remove_id sysfs attr for usb drivers")
Signed-off-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patch.msgid.link/20260707-usb_dyn_id_uaf-v2-7-632dcf3adfba@garyguo.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/driver.c | 12 ++++++++----
 include/linux/usb.h       |  3 ++-
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index f63004417058e..7f33fe5ba03bd 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -228,14 +228,16 @@ static void usb_free_dynids(struct usb_driver *usb_drv)
 }
 
 static const struct usb_device_id *usb_match_dynamic_id(struct usb_interface *intf,
-							const struct usb_driver *drv)
+							const struct usb_driver *drv,
+							struct usb_device_id *id_copy)
 {
 	struct usb_dynid *dynid;
 
 	guard(mutex)(&usb_dynids_lock);
 	list_for_each_entry(dynid, &drv->dynids.list, node) {
 		if (usb_match_one_id(intf, &dynid->id)) {
-			return &dynid->id;
+			*id_copy = dynid->id;
+			return id_copy;
 		}
 	}
 	return NULL;
@@ -321,6 +323,7 @@ static int usb_probe_interface(struct device *dev)
 	struct usb_interface *intf = to_usb_interface(dev);
 	struct usb_device *udev = interface_to_usbdev(intf);
 	const struct usb_device_id *id;
+	struct usb_device_id id_copy;
 	int error = -ENODEV;
 	int lpm_disable_error = -ENODEV;
 
@@ -340,7 +343,7 @@ static int usb_probe_interface(struct device *dev)
 		return error;
 	}
 
-	id = usb_match_dynamic_id(intf, driver);
+	id = usb_match_dynamic_id(intf, driver, &id_copy);
 	if (!id)
 		id = usb_match_id(intf, driver->id_table);
 	if (!id)
@@ -892,6 +895,7 @@ static int usb_device_match(struct device *dev, const struct device_driver *drv)
 		struct usb_interface *intf;
 		const struct usb_driver *usb_drv;
 		const struct usb_device_id *id;
+		struct usb_device_id id_copy;
 
 		/* device drivers never match interfaces */
 		if (is_usb_device_driver(drv))
@@ -904,7 +908,7 @@ static int usb_device_match(struct device *dev, const struct device_driver *drv)
 		if (id)
 			return 1;
 
-		id = usb_match_dynamic_id(intf, usb_drv);
+		id = usb_match_dynamic_id(intf, usb_drv, &id_copy);
 		if (id)
 			return 1;
 	}
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 1da4ad1610bca..49ab8dbb885f6 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1185,7 +1185,8 @@ extern ssize_t usb_show_dynids(struct usb_dynids *dynids, char *buf);
  *	interface.  It may also use usb_set_interface() to specify the
  *	appropriate altsetting.  If unwilling to manage the interface,
  *	return -ENODEV, if genuine IO errors occurred, an appropriate
- *	negative errno value.
+ *	negative errno value.  The usb_device_id parameter is only valid during
+ *	probe.
  * @disconnect: Called when the interface is no longer accessible, usually
  *	because its device has been (or is being) disconnected or the
  *	driver module is being unloaded.
-- 
2.53.0



