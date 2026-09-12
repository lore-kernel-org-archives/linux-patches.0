Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56C023BD03;
	Sat, 12 Sep 2026 12:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215237; cv=none; b=XB166k0VUAthVA0vfuzpb7+/TIIUPZWxACCe0lGnyelRzq29YwydBf4LZESsiUlQkx9krInYGK9zjxX1pMPLzPmRSKzyB6LCJxTWvWhtGc26vQZRdnsg5DyQefEY6sR3rkPop2ew80Ci4N+Ic5fk6Jsx3d0e4ehmXSe/rOZMH3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215237; c=relaxed/simple;
	bh=wX1CB7zIW3hyzdRQlKJRwzNkvjoAPGlHrJ2amIxtn3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Akg/tfOqnAL0bg4JCSFkMsRUvY9uUNIYPJwEE79o24HuWKpQ4Ym7MTZUCTHZpO+OBA53QhEgOyA3mjCNuxBPafZhcN9yxm9/dTnxvyhnw0krCIbDda0HCRGp4ZpCxSAMsYjjYqO1uHHNS0TS8FNLilF78ErZsMdhe195ngh3ZKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gTnVgorV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gTnVgorV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99CF21F000FF;
	Sat, 12 Sep 2026 12:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215235;
	bh=9bwTguAa1s2K6+plkQPmnsw6PTcz3FYPFM/rMI/b8QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gTnVgorV7yTWNiAo+meDOolfddmC7MaNfphScHjx9Ht7McI6mpCd2ic6J/ngCd8rT
	 T1qoElSUyaCLTSjNMzqKomwdR7EmTAWUBV4iqHyYySMzTjqtt5q4Iywv4yi0xjotGU
	 NqYnb9hmX3RHyLfgKmAQKW/tunzO5IVidUDs2Tb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0490/1376] usb: fix UAF when probe runs concurrent to dyn ID removal
Date: Sat, 12 Sep 2026 08:48:36 +0200
Message-ID: <20260912065618.458576452@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f0f13554709e0..528274e3cd7ad 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -227,14 +227,16 @@ static void usb_free_dynids(struct usb_driver *usb_drv)
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
@@ -320,6 +322,7 @@ static int usb_probe_interface(struct device *dev)
 	struct usb_interface *intf = to_usb_interface(dev);
 	struct usb_device *udev = interface_to_usbdev(intf);
 	const struct usb_device_id *id;
+	struct usb_device_id id_copy;
 	int error = -ENODEV;
 	int lpm_disable_error = -ENODEV;
 
@@ -339,7 +342,7 @@ static int usb_probe_interface(struct device *dev)
 		return error;
 	}
 
-	id = usb_match_dynamic_id(intf, driver);
+	id = usb_match_dynamic_id(intf, driver, &id_copy);
 	if (!id)
 		id = usb_match_id(intf, driver->id_table);
 	if (!id)
@@ -891,6 +894,7 @@ static int usb_device_match(struct device *dev, const struct device_driver *drv)
 		struct usb_interface *intf;
 		const struct usb_driver *usb_drv;
 		const struct usb_device_id *id;
+		struct usb_device_id id_copy;
 
 		/* device drivers never match interfaces */
 		if (is_usb_device_driver(drv))
@@ -903,7 +907,7 @@ static int usb_device_match(struct device *dev, const struct device_driver *drv)
 		if (id)
 			return 1;
 
-		id = usb_match_dynamic_id(intf, usb_drv);
+		id = usb_match_dynamic_id(intf, usb_drv, &id_copy);
 		if (id)
 			return 1;
 	}
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 2004a2db81ced..0012259ac910c 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1159,7 +1159,8 @@ extern ssize_t usb_show_dynids(struct usb_dynids *dynids, char *buf);
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



