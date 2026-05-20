Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4447B372691;
	Wed, 20 May 2026 17:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297200; cv=none; b=KH9Yey31Ht5J8IU6trVtlnQ+k0B5wVwwWmP+MKvhtyQQCBA1EVkJJa1KdMPL746toCyccAXu/ZtM38igHB1r7Grl0DKGvEvRg0JIE4mfyZoHoNqQ+cX9U+xlWeXBDpQs+m1WCelgb2mX+qAo0tew/9tOnXIMUGg636r3NBMN3vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297200; c=relaxed/simple;
	bh=bPHks68DfYr/pXOPT15kcbcsjUr9FNQBbDlkLkozEHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i3gKEeeKjzbEOXBYsJotTly+UC8HiQvJOdrbL/yKTLAkAAj+Kdvn2DxtmCbWa1B7DFn83kndEpRByiy7tfPwlFMIzc0Gi6kvkqHZ/cY0g0btH+so6cG2cGn2Pl1Lj1Mnqb5/eswLl824IS6Y6ZSbGrBC9cNUwpIfpr0UoriLAJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=il0M+lJZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="il0M+lJZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A965C1F000E9;
	Wed, 20 May 2026 17:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297199;
	bh=Q0kDc5RgP4n7iZe1x10j/zV90FvQxvQdaVbQuh5nCYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=il0M+lJZ7T0H6hyTyXGGy/+HZVMZUkc9Ljmt2SZIOuv2+X3lI49ORqm1OOyomLSj4
	 8qq5/TQYbWEmDYxYgEexrP3BKjho5sz7ztpeYBisek/Ol7h459HQHLwmQk+fO/IJNQ
	 v4hzA2BM/kfyocgLvUbz57kiXfgKJYIFC0/6qEqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Borja <kuurtb@gmail.com>,
	Rong Zhang <i@rong.moe>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	"Derek J. Clark" <derekjohn.clark@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.0 1086/1146] platform/x86: lenovo-wmi-other: Limit adding attributes to supported devices
Date: Wed, 20 May 2026 18:22:16 +0200
Message-ID: <20260520162212.812721643@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Derek J. Clark <derekjohn.clark@gmail.com>

commit 03bb5147da083cb91e5c8c2599fcb2f8fd05cb8f upstream.

Adds lwmi_is_attr_01_supported, and only creates the attribute subfolder
if the attribute is supported by the hardware. Due to some poorly
implemented BIOS this is a multi-step sequence of events. This is
because:
- Some BIOS support getting the capability data from custom mode (0xff),
  while others only support it in no-mode (0x00).
- Some BIOS support get/set for the current value from custom mode (0xff),
  while others only support it in no-mode (0x00).
- Some BIOS report capability data for a method that is not fully
  implemented.
- Some BIOS have methods fully implemented, but no complimentary
  capability data.

To ensure we only expose fully implemented methods with corresponding
capability data, we check each outcome before reporting that an
attribute can be supported.

Checking for lwmi_is_attr_01_supported during remove is not done to
ensure that we don't attempt to call cd01 or send WMI events if one of
the interfaces being removed was the cause of the driver unloading.

Fixes: edc4b183b794 ("platform/x86: Add Lenovo Other Mode WMI Driver")
Reported-by: Kurt Borja <kuurtb@gmail.com>
Closes: https://lore.kernel.org/platform-driver-x86/DG60P3SHXR8H.3NSEHMZ6J7XRC@gmail.com/
Cc: stable@vger.kernel.org
Reviewed-by: Rong Zhang <i@rong.moe>
Tested-by: Rong Zhang <i@rong.moe>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Signed-off-by: Derek J. Clark <derekjohn.clark@gmail.com>
Link: https://patch.msgid.link/20260510042546.436874-10-derekjohn.clark@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/lenovo/wmi-other.c |   92 ++++++++++++++++++++++++++++++--
 1 file changed, 88 insertions(+), 4 deletions(-)

--- a/drivers/platform/x86/lenovo/wmi-other.c
+++ b/drivers/platform/x86/lenovo/wmi-other.c
@@ -546,6 +546,8 @@ struct tunable_attr_01 {
 	u8 feature_id;
 	u8 device_id;
 	u8 type_id;
+	u8 cd_mode_id; /* mode arg for searching capdata */
+	u8 cv_mode_id; /* mode arg for set/get current_value */
 };
 
 /**
@@ -723,7 +725,7 @@ static ssize_t attr_capdata01_show(struc
 	u32 attribute_id;
 	int value, ret;
 
-	attribute_id = tunable_attr_01_id(tunable_attr, LWMI_GZ_THERMAL_MODE_CUSTOM);
+	attribute_id = tunable_attr_01_id(tunable_attr, tunable_attr->cd_mode_id);
 
 	ret = lwmi_cd01_get_data(priv->cd01_list, attribute_id, &capdata);
 	if (ret)
@@ -788,7 +790,7 @@ static ssize_t attr_current_value_store(
 	if (mode != LWMI_GZ_THERMAL_MODE_CUSTOM)
 		return -EBUSY;
 
-	args.arg0 = tunable_attr_01_id(tunable_attr, mode);
+	args.arg0 = tunable_attr_01_id(tunable_attr, tunable_attr->cd_mode_id);
 
 	ret = lwmi_cd01_get_data(priv->cd01_list, args.arg0, &capdata);
 	if (ret)
@@ -801,6 +803,7 @@ static ssize_t attr_current_value_store(
 	if (value < capdata.min_value || value > capdata.max_value)
 		return -EINVAL;
 
+	args.arg0 = tunable_attr_01_id(tunable_attr, tunable_attr->cv_mode_id);
 	args.arg1 = value;
 
 	ret = lwmi_dev_evaluate_int(priv->wdev, 0x0, LWMI_FEATURE_VALUE_SET,
@@ -841,6 +844,10 @@ static ssize_t attr_current_value_show(s
 	if (ret)
 		return ret;
 
+	/* If "no-mode" is the supported mode, ensure we never send current mode */
+	if (tunable_attr->cv_mode_id == LWMI_GZ_THERMAL_MODE_NONE)
+		mode = tunable_attr->cv_mode_id;
+
 	args.arg0 = tunable_attr_01_id(tunable_attr, mode);
 
 	ret = lwmi_dev_evaluate_int(priv->wdev, 0x0, LWMI_FEATURE_VALUE_GET,
@@ -852,6 +859,81 @@ static ssize_t attr_current_value_show(s
 	return sysfs_emit(buf, "%d\n", retval);
 }
 
+/**
+ * lwmi_attr_01_is_supported() - Determine if the given attribute is supported.
+ * @tunable_attr: The attribute to verify.
+ *
+ * For an attribute to be supported it must have a functional get/set method,
+ * as well as associated capability data stored in the capdata01 table.
+ *
+ * First check if the attribute has a corresponding data table under custom mode
+ * (0xff), then under no mode (0x00). If either of those passes, check if the
+ * supported field of the capdata struct is > 0. If it is supported, store the
+ * successful mode in the cd_mode_id field of tunable_attr.
+ *
+ * If the attribute capdata shows it is supported, attempt to determine the mode
+ * for the current value property get/set methods using a similar pattern to the
+ * capdata table check. If the value returned by either mode is 0 or an error,
+ * assume that mode is not supported. Otherwise, store the successful mode in the
+ * cv_mode_id field of tunable_attr.
+ *
+ * If any of the above checks fail then the attribute is not fully supported.
+ *
+ * Return: true if capdata and set/get modes are found, otherwise false.
+ */
+static bool lwmi_attr_01_is_supported(struct tunable_attr_01 *tunable_attr)
+{
+	u8 modes[2] = { LWMI_GZ_THERMAL_MODE_CUSTOM, LWMI_GZ_THERMAL_MODE_NONE };
+	struct lwmi_om_priv *priv = dev_get_drvdata(tunable_attr->dev);
+	struct wmi_method_args_32 args = {};
+	bool cd_mode_found = false;
+	bool cv_mode_found = false;
+	struct capdata01 capdata;
+	int retval, ret, i;
+
+	/* Determine tunable_attr->cd_mode_id */
+	for (i = 0; i < ARRAY_SIZE(modes); i++) {
+		args.arg0 = tunable_attr_01_id(tunable_attr, modes[i]);
+
+		ret = lwmi_cd01_get_data(priv->cd01_list, args.arg0, &capdata);
+		if (ret || !capdata.supported)
+			continue;
+
+		tunable_attr->cd_mode_id = modes[i];
+		cd_mode_found = true;
+		break;
+	}
+
+	if (!cd_mode_found)
+		return cd_mode_found;
+
+	dev_dbg(tunable_attr->dev,
+		"cd_mode_id: %#010x\n", args.arg0);
+
+	/* Determine tunable_attr->cv_mode_id, returns 1 if supported */
+	for (i = 0; i < ARRAY_SIZE(modes); i++) {
+		args.arg0 = tunable_attr_01_id(tunable_attr, modes[i]);
+
+		ret = lwmi_dev_evaluate_int(priv->wdev, 0x0, LWMI_FEATURE_VALUE_GET,
+					    (u8 *)&args, sizeof(args),
+					    &retval);
+		if (ret || !retval)
+			continue;
+
+		tunable_attr->cv_mode_id = modes[i];
+		cv_mode_found = true;
+		break;
+	}
+
+	if (!cv_mode_found)
+		return cv_mode_found;
+
+	dev_dbg(tunable_attr->dev, "cv_mode_id: %#010x, attribute support level: %#010x\n",
+		args.arg0, capdata.supported);
+
+	return capdata.supported > 0;
+}
+
 /* Lenovo WMI Other Mode Attribute macros */
 #define __LWMI_ATTR_RO(_func, _name)                                  \
 	{                                                             \
@@ -975,12 +1057,14 @@ static void lwmi_om_fw_attr_add(struct l
 	}
 
 	for (i = 0; i < ARRAY_SIZE(cd01_attr_groups) - 1; i++) {
+		cd01_attr_groups[i].tunable_attr->dev = &priv->wdev->dev;
+		if (!lwmi_attr_01_is_supported(cd01_attr_groups[i].tunable_attr))
+			continue;
+
 		err = sysfs_create_group(&priv->fw_attr_kset->kobj,
 					 cd01_attr_groups[i].attr_group);
 		if (err)
 			goto err_remove_groups;
-
-		cd01_attr_groups[i].tunable_attr->dev = &priv->wdev->dev;
 	}
 	return;
 


