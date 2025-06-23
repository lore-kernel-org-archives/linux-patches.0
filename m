Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FBF70838;
	Mon, 23 Jun 2025 21:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715930; cv=none; b=MyGD1Jn06rraN8+DWExn3GwIVAojJKtmT1HQB/HdD0CtHaWekOoHS1TPw4JA16IHJ0jztSoeo1LQCpSMg8mmx0uUnBrqeduf4C2tDDrB0DG3YW7/3SwKkuuWOJEw16hLjD9EX8UgWZICgX5KavLtE3bq9oCKsWOQVh0Tgn+ylJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715930; c=relaxed/simple;
	bh=dCG1eUJF8ECtbm4tdQVeQArJUwTyWnIM3MRV4s8pBbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJMZxy2SxyppBivNkjpB1GWsFTk6vsQBuNu9dcOHuZbe7s3/Qh0fHyNgsf/9hfEKJvwV8a7e+agUConilcs9UpDkoY7uKQto+P8lSJn2GiWbvItVGvMBrMo5CV7zSUkRxFGi2YP539UX9toUDvrhRMBPRkVcXvSYNlfIQQw21PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VkR80iXK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VkR80iXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D93C4CEEA;
	Mon, 23 Jun 2025 21:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715929;
	bh=dCG1eUJF8ECtbm4tdQVeQArJUwTyWnIM3MRV4s8pBbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VkR80iXKvBC62d4bKcqzW8om5FydpPuF6GN38sSY1987c6ODDnOSWZf2dj5ejaxuC
	 TypIc8VxxxxUsT5LT8aQQObInunpc4NZTJq9NFvA+Q8OW0QOxylwGTvten5Yu/C91s
	 SYvmtogX8czbzO36qhqWXejzWU9z1BNU2aqOgpmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 305/355] hwmon: (occ) Rework attribute registration for stack usage
Date: Mon, 23 Jun 2025 15:08:26 +0200
Message-ID: <20250623130635.948411170@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 744c2fe950e936c4d62430de899d6253424200ed ]

clang produces an output with excessive stack usage when building the
occ_setup_sensor_attrs() function, apparently the result of having
a lot of struct literals and building with the -fno-strict-overflow
option that leads clang to skip some optimization in case the 'attr'
pointer overruns:

drivers/hwmon/occ/common.c:775:12: error: stack frame size (1392) exceeds limit (1280) in 'occ_setup_sensor_attrs' [-Werror,-Wframe-larger-than]

Replace the custom macros for initializing the attributes with a
simpler function call that does not run into this corner case.

Link: https://godbolt.org/z/Wf1Yx76a5
Fixes: 54076cb3b5ff ("hwmon (occ): Add sensor attributes and register hwmon device")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20250610092315.2640039-1-arnd@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/occ/common.c | 212 +++++++++++++++----------------------
 1 file changed, 85 insertions(+), 127 deletions(-)

diff --git a/drivers/hwmon/occ/common.c b/drivers/hwmon/occ/common.c
index ce4a16b475fd1..44980946281c2 100644
--- a/drivers/hwmon/occ/common.c
+++ b/drivers/hwmon/occ/common.c
@@ -759,29 +759,30 @@ static ssize_t occ_show_extended(struct device *dev,
 }
 
 /*
- * Some helper macros to make it easier to define an occ_attribute. Since these
- * are dynamically allocated, we shouldn't use the existing kernel macros which
+ * A helper to make it easier to define an occ_attribute. Since these
+ * are dynamically allocated, we cannot use the existing kernel macros which
  * stringify the name argument.
  */
-#define ATTR_OCC(_name, _mode, _show, _store) {				\
-	.attr	= {							\
-		.name = _name,						\
-		.mode = VERIFY_OCTAL_PERMISSIONS(_mode),		\
-	},								\
-	.show	= _show,						\
-	.store	= _store,						\
-}
-
-#define SENSOR_ATTR_OCC(_name, _mode, _show, _store, _nr, _index) {	\
-	.dev_attr	= ATTR_OCC(_name, _mode, _show, _store),	\
-	.index		= _index,					\
-	.nr		= _nr,						\
+static void occ_init_attribute(struct occ_attribute *attr, int mode,
+	ssize_t (*show)(struct device *dev, struct device_attribute *attr, char *buf),
+	ssize_t (*store)(struct device *dev, struct device_attribute *attr,
+				   const char *buf, size_t count),
+	int nr, int index, const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	vsnprintf(attr->name, sizeof(attr->name), fmt, args);
+	va_end(args);
+
+	attr->sensor.dev_attr.attr.name = attr->name;
+	attr->sensor.dev_attr.attr.mode = mode;
+	attr->sensor.dev_attr.show = show;
+	attr->sensor.dev_attr.store = store;
+	attr->sensor.index = index;
+	attr->sensor.nr = nr;
 }
 
-#define OCC_INIT_ATTR(_name, _mode, _show, _store, _nr, _index)		\
-	((struct sensor_device_attribute_2)				\
-		SENSOR_ATTR_OCC(_name, _mode, _show, _store, _nr, _index))
-
 /*
  * Allocate and instatiate sensor_device_attribute_2s. It's most efficient to
  * use our own instead of the built-in hwmon attribute types.
@@ -867,14 +868,15 @@ static int occ_setup_sensor_attrs(struct occ *occ)
 		sensors->extended.num_sensors = 0;
 	}
 
-	occ->attrs = devm_kzalloc(dev, sizeof(*occ->attrs) * num_attrs,
+	occ->attrs = devm_kcalloc(dev, num_attrs, sizeof(*occ->attrs),
 				  GFP_KERNEL);
 	if (!occ->attrs)
 		return -ENOMEM;
 
 	/* null-terminated list */
-	occ->group.attrs = devm_kzalloc(dev, sizeof(*occ->group.attrs) *
-					num_attrs + 1, GFP_KERNEL);
+	occ->group.attrs = devm_kcalloc(dev, num_attrs + 1,
+					sizeof(*occ->group.attrs),
+					GFP_KERNEL);
 	if (!occ->group.attrs)
 		return -ENOMEM;
 
@@ -884,43 +886,33 @@ static int occ_setup_sensor_attrs(struct occ *occ)
 		s = i + 1;
 		temp = ((struct temp_sensor_2 *)sensors->temp.data) + i;
 
-		snprintf(attr->name, sizeof(attr->name), "temp%d_label", s);
-		attr->sensor = OCC_INIT_ATTR(attr->name, 0444, show_temp, NULL,
-					     0, i);
+		occ_init_attribute(attr, 0444, show_temp, NULL,
+				   0, i, "temp%d_label", s);
 		attr++;
 
 		if (sensors->temp.version > 1 &&
 		    temp->fru_type == OCC_FRU_TYPE_VRM) {
-			snprintf(attr->name, sizeof(attr->name),
-				 "temp%d_alarm", s);
+			occ_init_attribute(attr, 0444, show_temp, NULL,
+					   1, i, "temp%d_alarm", s);
 		} else {
-			snprintf(attr->name, sizeof(attr->name),
-				 "temp%d_input", s);
+			occ_init_attribute(attr, 0444, show_temp, NULL,
+					   1, i, "temp%d_input", s);
 		}
 
-		attr->sensor = OCC_INIT_ATTR(attr->name, 0444, show_temp, NULL,
-					     1, i);
 		attr++;
 
 		if (sensors->temp.version > 1) {
-			snprintf(attr->name, sizeof(attr->name),
-				 "temp%d_fru_type", s);
-			attr->sensor = OCC_INIT_ATTR(attr->name, 0444,
-						     show_temp, NULL, 2, i);
+			occ_init_attribute(attr, 0444, show_temp, NULL,
+					   2, i, "temp%d_fru_type", s);
 			attr++;
 
-			snprintf(attr->name, sizeof(attr->name),
-				 "temp%d_fault", s);
-			attr->sensor = OCC_INIT_ATTR(attr->name, 0444,
-						     show_temp, NULL, 3, i);
+			occ_init_attribute(attr, 0444, show_temp, NULL,
+					   3, i, "temp%d_fault", s);
 			attr++;
 
 			if (sensors->temp.version == 0x10) {
-				snprintf(attr->name, sizeof(attr->name),
-					 "temp%d_max", s);
-				attr->sensor = OCC_INIT_ATTR(attr->name, 0444,
-							     show_temp, NULL,
-							     4, i);
+				occ_init_attribute(attr, 0444, show_temp, NULL,
+						   4, i, "temp%d_max", s);
 				attr++;
 			}
 		}
@@ -929,14 +921,12 @@ static int occ_setup_sensor_attrs(struct occ *occ)
 	for (i = 0; i < sensors->freq.num_sensors; ++i) {
 		s = i + 1;
 
-		snprintf(attr->name, sizeof(attr->name), "freq%d_label", s);
-		attr->sensor = OCC_INIT_ATTR(attr->name, 0444, show_freq, NULL,
-					     0, i);
+		occ_init_attribute(attr, 0444, show_freq, NULL,
+				   0, i, "freq%d_label", s);
 		attr++;
 
-		snprintf(attr->name, sizeof(attr->name), "freq%d_input", s);
-		attr->sensor = OCC_INIT_ATTR(attr->name, 0444, show_freq, NULL,
-					     1, i);
+		occ_init_attribute(attr, 0444, show_freq, NULL,
+				   1, i, "freq%d_input", s);
 		attr++;
 	}
 
@@ -952,32 +942,24 @@ static int occ_setup_sensor_attrs(struct occ *occ)
 			s = (i * 4) + 1;
 
 			for (j = 0; j < 4; ++j) {
-				snprintf(attr->name, sizeof(attr->name),
-					 "power%d_label", s);
-				attr->sensor = OCC_INIT_ATTR(attr->name, 0444,
-							     show_power, NULL,
-							     nr++, i);
+				occ_init_attribute(attr, 0444, show_power,
+						   NULL, nr++, i,
+						   "power%d_label", s);
 				attr++;
 
-				snprintf(attr->name, sizeof(attr->name),
-					 "power%d_average", s);
-				attr->sensor = OCC_INIT_ATTR(attr->name, 0444,
-							     show_power, NULL,
-							     nr++, i);
+				occ_init_attribute(attr, 0444, show_power,
+						   NULL, nr++, i,
+						   "power%d_average", s);
 				attr++;
 
-				snprintf(attr->name, sizeof(attr->name),
-					 "power%d_average_interval", s);
-				attr->sensor = OCC_INIT_ATTR(attr->name, 0444,
-							     show_power, NULL,
-							     nr++, i);
+				occ_init_attribute(attr, 0444, show_power,
+						   NULL, nr++, i,
+						   "power%d_average_interval", s);
 				attr++;
 
-				snprintf(attr->name, sizeof(attr->name),
-					 "power%d_input", s);
-				attr->sensor = OCC_INIT_ATTR(attr->name, 0444,
-							     show_power, NULL,
-							     nr++, i);
+				occ_init_attribute(attr, 0444, show_power,
+						   NULL, nr++, i,
+						   "power%d_input", s);
 				attr++;
 
 				s++;
@@ -989,28 +971,20 @@ static int occ_setup_sensor_attrs(struct occ *occ)
 		for (i = 0; i < sensors->power.num_sensors; ++i) {
 			s = i + 1;
 
-			snprintf(attr->name, sizeof(attr->name),
-				 "power%d_label", s);
-			attr->sensor = OCC_INIT_ATTR(attr->name, 0444,
-						     show_power, NULL, 0, i);
+			occ_init_attribute(attr, 0444, show_power, NULL,
+					   0, i, "power%d_label", s);
 			attr++;
 
-			snprintf(attr->name, sizeof(attr->name),
-				 "power%d_average", s);
-			attr->sensor = OCC_INIT_ATTR(attr->name, 0444,
-						     show_power, NULL, 1, i);
+			occ_init_attribute(attr, 0444, show_power, NULL,
+					   1, i, "power%d_average", s);
 			attr++;
 
-			snprintf(attr->name, sizeof(attr->name),
-				 "power%d_average_interval", s);
-			attr->sensor = OCC_INIT_ATTR(attr->name, 0444,
-						     show_power, NULL, 2, i);
+			occ_init_attribute(attr, 0444, show_power, NULL,
+					   2, i, "power%d_average_interval", s);
 			attr++;
 
-			snprintf(attr->name, sizeof(attr->name),
-				 "power%d_input", s);
-			attr->sensor = OCC_INIT_ATTR(attr->name, 0444,
-						     show_power, NULL, 3, i);
+			occ_init_attribute(attr, 0444, show_power, NULL,
+					   3, i, "power%d_input", s);
 			attr++;
 		}
 
@@ -1018,56 +992,43 @@ static int occ_setup_sensor_attrs(struct occ *occ)
 	}
 
 	if (sensors->caps.num_sensors >= 1) {
-		snprintf(attr->name, sizeof(attr->name), "power%d_label", s);
-		attr->sensor = OCC_INIT_ATTR(attr->name, 0444, show_caps, NULL,
-					     0, 0);
+		occ_init_attribute(attr, 0444, show_caps, NULL,
+				   0, 0, "power%d_label", s);
 		attr++;
 
-		snprintf(attr->name, sizeof(attr->name), "power%d_cap", s);
-		attr->sensor = OCC_INIT_ATTR(attr->name, 0444, show_caps, NULL,
-					     1, 0);
+		occ_init_attribute(attr, 0444, show_caps, NULL,
+				   1, 0, "power%d_cap", s);
 		attr++;
 
-		snprintf(attr->name, sizeof(attr->name), "power%d_input", s);
-		attr->sensor = OCC_INIT_ATTR(attr->name, 0444, show_caps, NULL,
-					     2, 0);
+		occ_init_attribute(attr, 0444, show_caps, NULL,
+				   2, 0, "power%d_input", s);
 		attr++;
 
-		snprintf(attr->name, sizeof(attr->name),
-			 "power%d_cap_not_redundant", s);
-		attr->sensor = OCC_INIT_ATTR(attr->name, 0444, show_caps, NULL,
-					     3, 0);
+		occ_init_attribute(attr, 0444, show_caps, NULL,
+				   3, 0, "power%d_cap_not_redundant", s);
 		attr++;
 
-		snprintf(attr->name, sizeof(attr->name), "power%d_cap_max", s);
-		attr->sensor = OCC_INIT_ATTR(attr->name, 0444, show_caps, NULL,
-					     4, 0);
+		occ_init_attribute(attr, 0444, show_caps, NULL,
+				   4, 0, "power%d_cap_max", s);
 		attr++;
 
-		snprintf(attr->name, sizeof(attr->name), "power%d_cap_min", s);
-		attr->sensor = OCC_INIT_ATTR(attr->name, 0444, show_caps, NULL,
-					     5, 0);
+		occ_init_attribute(attr, 0444, show_caps, NULL,
+				   5, 0, "power%d_cap_min", s);
 		attr++;
 
-		snprintf(attr->name, sizeof(attr->name), "power%d_cap_user",
-			 s);
-		attr->sensor = OCC_INIT_ATTR(attr->name, 0644, show_caps,
-					     occ_store_caps_user, 6, 0);
+		occ_init_attribute(attr, 0644, show_caps, occ_store_caps_user,
+				   6, 0, "power%d_cap_user", s);
 		attr++;
 
 		if (sensors->caps.version > 1) {
-			snprintf(attr->name, sizeof(attr->name),
-				 "power%d_cap_user_source", s);
-			attr->sensor = OCC_INIT_ATTR(attr->name, 0444,
-						     show_caps, NULL, 7, 0);
+			occ_init_attribute(attr, 0444, show_caps, NULL,
+					   7, 0, "power%d_cap_user_source", s);
 			attr++;
 
 			if (sensors->caps.version > 2) {
-				snprintf(attr->name, sizeof(attr->name),
-					 "power%d_cap_min_soft", s);
-				attr->sensor = OCC_INIT_ATTR(attr->name, 0444,
-							     show_caps, NULL,
-							     8, 0);
+				occ_init_attribute(attr, 0444, show_caps, NULL,
+						   8, 0,
+						   "power%d_cap_min_soft", s);
 				attr++;
 			}
 		}
@@ -1076,19 +1037,16 @@ static int occ_setup_sensor_attrs(struct occ *occ)
 	for (i = 0; i < sensors->extended.num_sensors; ++i) {
 		s = i + 1;
 
-		snprintf(attr->name, sizeof(attr->name), "extn%d_label", s);
-		attr->sensor = OCC_INIT_ATTR(attr->name, 0444,
-					     occ_show_extended, NULL, 0, i);
+		occ_init_attribute(attr, 0444, occ_show_extended, NULL,
+				   0, i, "extn%d_label", s);
 		attr++;
 
-		snprintf(attr->name, sizeof(attr->name), "extn%d_flags", s);
-		attr->sensor = OCC_INIT_ATTR(attr->name, 0444,
-					     occ_show_extended, NULL, 1, i);
+		occ_init_attribute(attr, 0444, occ_show_extended, NULL,
+				   1, i, "extn%d_flags", s);
 		attr++;
 
-		snprintf(attr->name, sizeof(attr->name), "extn%d_input", s);
-		attr->sensor = OCC_INIT_ATTR(attr->name, 0444,
-					     occ_show_extended, NULL, 2, i);
+		occ_init_attribute(attr, 0444, occ_show_extended, NULL,
+				   2, i, "extn%d_input", s);
 		attr++;
 	}
 
-- 
2.39.5



