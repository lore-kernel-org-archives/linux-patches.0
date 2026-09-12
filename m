Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6192DC321;
	Sat, 12 Sep 2026 14:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223044; cv=none; b=fpF9uDh5gdvO3I9XfMVPx77d0cYa6RuGHJiMIBNCQ7RneBAIis9YKR6tGfgI02k7kek6R360bwFXFK++aE+NdXXdwQBVlQr9BydK11kkkeBz/mbM5k+NoBdCl7LRN/SHWOOJ8h+23bn7165ivdYAhy0mkQi0bvYi7u4UZtLBjDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223044; c=relaxed/simple;
	bh=kbfb9EFOFEIwvRCB2agJAlmm//E2o9L38w319P/kKV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fk0h+M8qVDVhp37yUlGxU1ODDDVYS63dDTNvGxgOuLc0KuPQAKeDO/O6wXAJQDm5tAPPUfCb0whbAjfmBf5cubDdogaVW/DttI/74atD14V162Tg3mj++jE14+8S5MTa8lf3ZlOQ0XG7TyleDCsh+mCsLzD78LwTx5OlSfDHb0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ECeOoodC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ECeOoodC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111761F000FF;
	Sat, 12 Sep 2026 14:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223043;
	bh=TjKP0VKvbydIR+24Y0beYDxKoyRrSH5W3v9jxnMvJMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ECeOoodCfvC08I4ITX3lmSCbzmKIB195oSKd7AF/ucsAKH3oVKIlRbcbM1W0XLoQv
	 KCfywvsJ095VMxSZrnhkokySAe3CZV/zM100+Sdlm9ZtjlOF7j7a19YGSr5Qik1LY+
	 2fH0oU4kdvCDVJ18MuCujl7xtoppeoZ0fRwl5INc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0708/1424] usb: fix UAF when probe runs concurrent to dyn ID removal
Date: Sat, 12 Sep 2026 08:52:20 +0200
Message-ID: <20260912065623.155014368@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2b2eb04b57f4a..a159c465708d5 100644
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
@@ -317,6 +319,7 @@ static int usb_probe_interface(struct device *dev)
 	struct usb_interface *intf = to_usb_interface(dev);
 	struct usb_device *udev = interface_to_usbdev(intf);
 	const struct usb_device_id *id;
+	struct usb_device_id id_copy;
 	int error = -ENODEV;
 	int lpm_disable_error = -ENODEV;
 
@@ -336,7 +339,7 @@ static int usb_probe_interface(struct device *dev)
 		return error;
 	}
 
-	id = usb_match_dynamic_id(intf, driver);
+	id = usb_match_dynamic_id(intf, driver, &id_copy);
 	if (!id)
 		id = usb_match_id(intf, driver->id_table);
 	if (!id)
@@ -875,6 +878,7 @@ static int usb_device_match(struct device *dev, struct device_driver *drv)
 		struct usb_interface *intf;
 		const struct usb_driver *usb_drv;
 		const struct usb_device_id *id;
+		struct usb_device_id id_copy;
 
 		/* device drivers never match interfaces */
 		if (is_usb_device_driver(drv))
@@ -887,7 +891,7 @@ static int usb_device_match(struct device *dev, struct device_driver *drv)
 		if (id)
 			return 1;
 
-		id = usb_match_dynamic_id(intf, usb_drv);
+		id = usb_match_dynamic_id(intf, usb_drv, &id_copy);
 		if (id)
 			return 1;
 	}
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 502a2f4f13bae..899fc1e9e3010 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1155,7 +1155,8 @@ extern ssize_t usb_show_dynids(struct usb_dynids *dynids, char *buf);
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



