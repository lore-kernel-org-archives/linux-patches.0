Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601951DDF5;
	Thu, 15 Aug 2024 13:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728527; cv=none; b=RRyqKm3o/e55DNLY6NRGEhaYIpkg96R8tKGFFaTGx9gsy8VZa7uUztMM6ikE9rXydWn/UhEiOdMrFQ5S+TlKmr32a15iludfL+K1uI5sxbpyyTmwRcTkNzMBxnLPeuU0UpS3x4/i4d1N9imOyMl23DkRD92bwgSxSGXt3m08JwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728527; c=relaxed/simple;
	bh=N7LAyKXRLd5FHJwBSkV9potIFRNjxlNzBYPN0w13HYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plOQaJ3Mu5/CQHRXxNmefE970bpGNuPk5+XGBEqhwrShKvNdNI5+QGdutKhVJoOwBgWmr9XYO1kmQmNTFjvlW6bxH75XjJMMOUyTfmP1cd+oDzM/MP/ddxHe6zjdT2L3xKEksY3aJlLPzLfH+MI6LT9+ZoKLwBbI44dX1+sHlec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sxr6vcP1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sxr6vcP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B076C32786;
	Thu, 15 Aug 2024 13:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728525;
	bh=N7LAyKXRLd5FHJwBSkV9potIFRNjxlNzBYPN0w13HYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sxr6vcP1kLrXFPr2kpkjn87mSMZsBT7iA1ah/y3aRAZ4xlFLcdWPlFXzkxzZCTStV
	 WJaKakW3kWwZFbI0JZNCEM9UwUuOoFfPVD+2eDeHJPdtsDbL7buDckAgfgW1U+w8XL
	 Gmv0Yjglblfda89JBTf/fTL9AK38q+Zi+IJvhzpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 010/196] hwmon: Introduce SENSOR_DEVICE_ATTR_{RO, RW, WO} and variants
Date: Thu, 15 Aug 2024 15:22:07 +0200
Message-ID: <20240815131852.467245466@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit a5c47c0d388b939dd578fd466aa804b7f2445390 ]

Introduce SENSOR_DEVICE_ATTR_{RO,RW,WO} and SENSOR_DEVICE_ATTR_2_{RO,RW,WO}
as simplified variants of SENSOR_DEVICE_ATTR and SENSOR_DEVICE_ATTR_2 to
simplify the source code, improve readbility, and reduce the chance of
inconsistencies.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 1ea3fd1eb986 ("hwmon: (max6697) Fix swapped temp{1,8} critical alarms")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/hwmon-kernel-api.txt | 24 ++++++++++-----
 include/linux/hwmon-sysfs.h              | 39 ++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 8 deletions(-)

diff --git a/Documentation/hwmon/hwmon-kernel-api.txt b/Documentation/hwmon/hwmon-kernel-api.txt
index eb7a78aebb380..8bdefb41be307 100644
--- a/Documentation/hwmon/hwmon-kernel-api.txt
+++ b/Documentation/hwmon/hwmon-kernel-api.txt
@@ -299,17 +299,25 @@ functions is used.
 The header file linux/hwmon-sysfs.h provides a number of useful macros to
 declare and use hardware monitoring sysfs attributes.
 
-In many cases, you can use the exsting define DEVICE_ATTR to declare such
-attributes. This is feasible if an attribute has no additional context. However,
-in many cases there will be additional information such as a sensor index which
-will need to be passed to the sysfs attribute handling function.
+In many cases, you can use the exsting define DEVICE_ATTR or its variants
+DEVICE_ATTR_{RW,RO,WO} to declare such attributes. This is feasible if an
+attribute has no additional context. However, in many cases there will be
+additional information such as a sensor index which will need to be passed
+to the sysfs attribute handling function.
 
 SENSOR_DEVICE_ATTR and SENSOR_DEVICE_ATTR_2 can be used to define attributes
 which need such additional context information. SENSOR_DEVICE_ATTR requires
 one additional argument, SENSOR_DEVICE_ATTR_2 requires two.
 
-SENSOR_DEVICE_ATTR defines a struct sensor_device_attribute variable.
-This structure has the following fields.
+Simplified variants of SENSOR_DEVICE_ATTR and SENSOR_DEVICE_ATTR_2 are available
+and should be used if standard attribute permissions and function names are
+feasible. Standard permissions are 0644 for SENSOR_DEVICE_ATTR[_2]_RW,
+0444 for SENSOR_DEVICE_ATTR[_2]_RO, and 0200 for SENSOR_DEVICE_ATTR[_2]_WO.
+Standard functions, similar to DEVICE_ATTR_{RW,RO,WO}, have _show and _store
+appended to the provided function name.
+
+SENSOR_DEVICE_ATTR and its variants define a struct sensor_device_attribute
+variable. This structure has the following fields.
 
 struct sensor_device_attribute {
 	struct device_attribute dev_attr;
@@ -320,8 +328,8 @@ You can use to_sensor_dev_attr to get the pointer to this structure from the
 attribute read or write function. Its parameter is the device to which the
 attribute is attached.
 
-SENSOR_DEVICE_ATTR_2 defines a struct sensor_device_attribute_2 variable,
-which is defined as follows.
+SENSOR_DEVICE_ATTR_2 and its variants define a struct sensor_device_attribute_2
+variable, which is defined as follows.
 
 struct sensor_device_attribute_2 {
 	struct device_attribute dev_attr;
diff --git a/include/linux/hwmon-sysfs.h b/include/linux/hwmon-sysfs.h
index 1c7b89ae6bdcb..473897bbd898a 100644
--- a/include/linux/hwmon-sysfs.h
+++ b/include/linux/hwmon-sysfs.h
@@ -33,10 +33,28 @@ struct sensor_device_attribute{
 	{ .dev_attr = __ATTR(_name, _mode, _show, _store),	\
 	  .index = _index }
 
+#define SENSOR_ATTR_RO(_name, _func, _index)			\
+	SENSOR_ATTR(_name, 0444, _func##_show, NULL, _index)
+
+#define SENSOR_ATTR_RW(_name, _func, _index)			\
+	SENSOR_ATTR(_name, 0644, _func##_show, _func##_store, _index)
+
+#define SENSOR_ATTR_WO(_name, _func, _index)			\
+	SENSOR_ATTR(_name, 0200, NULL, _func##_store, _index)
+
 #define SENSOR_DEVICE_ATTR(_name, _mode, _show, _store, _index)	\
 struct sensor_device_attribute sensor_dev_attr_##_name		\
 	= SENSOR_ATTR(_name, _mode, _show, _store, _index)
 
+#define SENSOR_DEVICE_ATTR_RO(_name, _func, _index)		\
+	SENSOR_DEVICE_ATTR(_name, 0444, _func##_show, NULL, _index)
+
+#define SENSOR_DEVICE_ATTR_RW(_name, _func, _index)		\
+	SENSOR_DEVICE_ATTR(_name, 0644, _func##_show, _func##_store, _index)
+
+#define SENSOR_DEVICE_ATTR_WO(_name, _func, _index)		\
+	SENSOR_DEVICE_ATTR(_name, 0200, NULL, _func##_store, _index)
+
 struct sensor_device_attribute_2 {
 	struct device_attribute dev_attr;
 	u8 index;
@@ -50,8 +68,29 @@ struct sensor_device_attribute_2 {
 	  .index = _index,					\
 	  .nr = _nr }
 
+#define SENSOR_ATTR_2_RO(_name, _func, _nr, _index)		\
+	SENSOR_ATTR_2(_name, 0444, _func##_show, NULL, _nr, _index)
+
+#define SENSOR_ATTR_2_RW(_name, _func, _nr, _index)		\
+	SENSOR_ATTR_2(_name, 0644, _func##_show, _func##_store, _nr, _index)
+
+#define SENSOR_ATTR_2_WO(_name, _func, _nr, _index)		\
+	SENSOR_ATTR_2(_name, 0200, NULL, _func##_store, _nr, _index)
+
 #define SENSOR_DEVICE_ATTR_2(_name,_mode,_show,_store,_nr,_index)	\
 struct sensor_device_attribute_2 sensor_dev_attr_##_name		\
 	= SENSOR_ATTR_2(_name, _mode, _show, _store, _nr, _index)
 
+#define SENSOR_DEVICE_ATTR_2_RO(_name, _func, _nr, _index)		\
+	SENSOR_DEVICE_ATTR_2(_name, 0444, _func##_show, NULL,		\
+			     _nr, _index)
+
+#define SENSOR_DEVICE_ATTR_2_RW(_name, _func, _nr, _index)		\
+	SENSOR_DEVICE_ATTR_2(_name, 0644, _func##_show, _func##_store,	\
+			     _nr, _index)
+
+#define SENSOR_DEVICE_ATTR_2_WO(_name, _func, _nr, _index)		\
+	SENSOR_DEVICE_ATTR_2(_name, 0200, NULL, _func##_store,		\
+			     _nr, _index)
+
 #endif /* _LINUX_HWMON_SYSFS_H */
-- 
2.43.0



