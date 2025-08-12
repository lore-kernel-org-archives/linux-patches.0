Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68FB2E4248;
	Tue, 12 Aug 2025 18:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023345; cv=none; b=kWahfLD8mnKjMijzvh3NjIcUMjPdLEgBTuhQ1URYeUareHpdnRvb9NSh61OJeV9T4c8mbKSpvbeJsrYsy1ZxVehOYXHmBa5WmjPdWL3w8SoLil02NUKRqZ5qD2wHGuGdFBol1KenFjMdDtF9rkOp0imYIrrBHnNffpLzfngokLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023345; c=relaxed/simple;
	bh=1A96BMW6HjeXJ9PpN1kSwLciFm1sucgxxiVr59q2xy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QE4FdZaHRAbM7xoErKqY2W5VX4ZcEKpOQ9gLsuE66zt22yfZhKtl8OGBXuumRHFpWT+n3QXXNZHb3/OW9nElUc819g8r2O3/2q6OMEsYnS/LLelCRMGIMNk9+RcIc3s9Z7vkehx+F5pzGXX6VJAWWExBVpRN1SgiD1qMGp2CYNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yibzcSSJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yibzcSSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C851DC4CEF0;
	Tue, 12 Aug 2025 18:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023345;
	bh=1A96BMW6HjeXJ9PpN1kSwLciFm1sucgxxiVr59q2xy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yibzcSSJE/eDPqDaqOxesNBiSrW8agFPppQyl8SXOTE2q69TIJYN2Ymgk04p458Ya
	 CTClqPaaGq0muVe2OughwR1MyaShiJF+rXMTdxnap7TqMMSfJ433cskOP1KBaKPM22
	 SW9ZY7K912TOK7LnL7RGggxboELPYwX7Ld02ZHBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charalampos Mitrodimas <charmitro@posteo.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 052/627] usb: misc: apple-mfi-fastcharge: Make power supply names unique
Date: Tue, 12 Aug 2025 19:25:47 +0200
Message-ID: <20250812173421.310516128@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charalampos Mitrodimas <charmitro@posteo.net>

[ Upstream commit 43007b89fb2de746443fbbb84aedd1089afdf582 ]

When multiple Apple devices are connected concurrently, the
apple-mfi-fastcharge driver fails to probe the subsequent devices with
the following error:

    sysfs: cannot create duplicate filename '/class/power_supply/apple_mfi_fastcharge'
    apple-mfi-fastcharge 5-2.4.3.3: probe of 5-2.4.3.3 failed with error -17

This happens because the driver uses a fixed power supply name
("apple_mfi_fastcharge") for all devices, causing a sysfs name
conflict when a second device is connected.

Fix this by generating unique names using the USB bus and device
number (e.g., "apple_mfi_fastcharge_5-12"). This ensures each
connected device gets a unique power supply entry in sysfs.

The change requires storing a copy of the power_supply_desc structure
in the per-device mfi_device struct, since the name pointer needs to
remain valid for the lifetime of the power supply registration.

Fixes: 249fa8217b84 ("USB: Add driver to control USB fast charge for iOS devices")
Signed-off-by: Charalampos Mitrodimas <charmitro@posteo.net>
Link: https://lore.kernel.org/r/20250602-apple-mfi-fastcharge-duplicate-sysfs-v1-1-5d84de34fac6@posteo.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/misc/apple-mfi-fastcharge.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/misc/apple-mfi-fastcharge.c b/drivers/usb/misc/apple-mfi-fastcharge.c
index ac8695195c13..8e852f4b8262 100644
--- a/drivers/usb/misc/apple-mfi-fastcharge.c
+++ b/drivers/usb/misc/apple-mfi-fastcharge.c
@@ -44,6 +44,7 @@ MODULE_DEVICE_TABLE(usb, mfi_fc_id_table);
 struct mfi_device {
 	struct usb_device *udev;
 	struct power_supply *battery;
+	struct power_supply_desc battery_desc;
 	int charge_type;
 };
 
@@ -178,6 +179,7 @@ static int mfi_fc_probe(struct usb_device *udev)
 {
 	struct power_supply_config battery_cfg = {};
 	struct mfi_device *mfi = NULL;
+	char *battery_name;
 	int err;
 
 	if (!mfi_fc_match(udev))
@@ -187,23 +189,38 @@ static int mfi_fc_probe(struct usb_device *udev)
 	if (!mfi)
 		return -ENOMEM;
 
+	battery_name = kasprintf(GFP_KERNEL, "apple_mfi_fastcharge_%d-%d",
+				 udev->bus->busnum, udev->devnum);
+	if (!battery_name) {
+		err = -ENOMEM;
+		goto err_free_mfi;
+	}
+
+	mfi->battery_desc = apple_mfi_fc_desc;
+	mfi->battery_desc.name = battery_name;
+
 	battery_cfg.drv_data = mfi;
 
 	mfi->charge_type = POWER_SUPPLY_CHARGE_TYPE_TRICKLE;
 	mfi->battery = power_supply_register(&udev->dev,
-						&apple_mfi_fc_desc,
+						&mfi->battery_desc,
 						&battery_cfg);
 	if (IS_ERR(mfi->battery)) {
 		dev_err(&udev->dev, "Can't register battery\n");
 		err = PTR_ERR(mfi->battery);
-		kfree(mfi);
-		return err;
+		goto err_free_name;
 	}
 
 	mfi->udev = usb_get_dev(udev);
 	dev_set_drvdata(&udev->dev, mfi);
 
 	return 0;
+
+err_free_name:
+	kfree(battery_name);
+err_free_mfi:
+	kfree(mfi);
+	return err;
 }
 
 static void mfi_fc_disconnect(struct usb_device *udev)
@@ -213,6 +230,7 @@ static void mfi_fc_disconnect(struct usb_device *udev)
 	mfi = dev_get_drvdata(&udev->dev);
 	if (mfi->battery)
 		power_supply_unregister(mfi->battery);
+	kfree(mfi->battery_desc.name);
 	dev_set_drvdata(&udev->dev, NULL);
 	usb_put_dev(mfi->udev);
 	kfree(mfi);
-- 
2.39.5



