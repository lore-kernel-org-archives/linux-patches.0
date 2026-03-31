Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C0C425CF0;
	Tue, 31 Mar 2026 16:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975899; cv=none; b=kS1NP8sFqL2AZJ2Zw8wthdj/O9uudePPXlXxF3h15kbgNprmjAw0rtV4i4kDmSqCPPqQxKbd1VgqnPuABtNcHyinOB1bQddgyfbdMj/eM7RnpkiYeXAic6OmlWO74A8hkwbQ21b+gazBnZ24degadBS1BU/zYgoWs6bTqSCAzh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975899; c=relaxed/simple;
	bh=/xoixg/1ifMEdO1AWc2slFnCqjnjwpI5RuJTJ6U+amw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKkFR+24BkhXidH7k7yT0uX0sGvkqy4WkWZKMySHWCJnGsGcaP8/HOCoiXDwT4ywGBV4pSKpnDy0JEXPwB8kYg1aw4xyfUjM1t5ALK8XjlGhvBp6UeWk3Hw4bwUxDDLRt1HDEHQ+Vom/x/JBUrjmXuLFaouNTIyGU06rSryS/g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DvyKyIg5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DvyKyIg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7A5C19423;
	Tue, 31 Mar 2026 16:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975899;
	bh=/xoixg/1ifMEdO1AWc2slFnCqjnjwpI5RuJTJ6U+amw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DvyKyIg55AQQv3wh9yZy69tq+cMEVe+mCvpQs7OJtj3L+2cL0nlnKqmWK0sX4JTVs
	 2Yvnx1qC+s7E5LNbPJ7CjpJnLT5pJJHR1qpx5aYs9nvwZGQryC7/43LTZHuMn7nfiI
	 VZ1o7akSOaYW5krvgumOBnzOiiy6QB7N7QS3flLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 129/244] hwmon: (pmbus) Mark lowest/average/highest/rated attributes as read-only
Date: Tue, 31 Mar 2026 18:21:19 +0200
Message-ID: <20260331161746.419425650@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 805a5bd1c3f307d45ae4e9cf8915ef16d585a54a ]

Writing those attributes is not supported, so mark them as read-only.

Prior to this change, attempts to write into these attributes returned
an error.

Mark boolean fields in struct pmbus_limit_attr and in struct
pmbus_sensor_attr as bit fields to reduce configuration data size.
The data is scanned only while probing, so performance is not a concern.

Fixes: 6f183d33a02e6 ("hwmon: (pmbus) Add support for peak attributes")
Reviewed-by: Sanman Pradhan <psanman@juniper.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus_core.c | 48 ++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index a8ffafc7411e3..f452876287556 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -1492,8 +1492,9 @@ static int pmbus_add_label(struct pmbus_data *data,
 struct pmbus_limit_attr {
 	u16 reg;		/* Limit register */
 	u16 sbit;		/* Alarm attribute status bit */
-	bool update;		/* True if register needs updates */
-	bool low;		/* True if low limit; for limits with compare functions only */
+	bool readonly:1;	/* True if the attribute is read-only */
+	bool update:1;		/* True if register needs updates */
+	bool low:1;		/* True if low limit; for limits with compare functions only */
 	const char *attr;	/* Attribute name */
 	const char *alarm;	/* Alarm attribute name */
 };
@@ -1508,9 +1509,9 @@ struct pmbus_sensor_attr {
 	u8 nlimit;			/* # of limit registers */
 	enum pmbus_sensor_classes class;/* sensor class */
 	const char *label;		/* sensor label */
-	bool paged;			/* true if paged sensor */
-	bool update;			/* true if update needed */
-	bool compare;			/* true if compare function needed */
+	bool paged:1;			/* true if paged sensor */
+	bool update:1;			/* true if update needed */
+	bool compare:1;			/* true if compare function needed */
 	u32 func;			/* sensor mask */
 	u32 sfunc;			/* sensor status mask */
 	int sreg;			/* status register */
@@ -1541,7 +1542,7 @@ static int pmbus_add_limit_attrs(struct i2c_client *client,
 			curr = pmbus_add_sensor(data, name, l->attr, index,
 						page, 0xff, l->reg, attr->class,
 						attr->update || l->update,
-						false, true);
+						l->readonly, true);
 			if (!curr)
 				return -ENOMEM;
 			if (l->sbit && (info->func[page] & attr->sfunc)) {
@@ -1704,23 +1705,28 @@ static const struct pmbus_limit_attr vin_limit_attrs[] = {
 	}, {
 		.reg = PMBUS_VIRT_READ_VIN_AVG,
 		.update = true,
+		.readonly = true,
 		.attr = "average",
 	}, {
 		.reg = PMBUS_VIRT_READ_VIN_MIN,
 		.update = true,
+		.readonly = true,
 		.attr = "lowest",
 	}, {
 		.reg = PMBUS_VIRT_READ_VIN_MAX,
 		.update = true,
+		.readonly = true,
 		.attr = "highest",
 	}, {
 		.reg = PMBUS_VIRT_RESET_VIN_HISTORY,
 		.attr = "reset_history",
 	}, {
 		.reg = PMBUS_MFR_VIN_MIN,
+		.readonly = true,
 		.attr = "rated_min",
 	}, {
 		.reg = PMBUS_MFR_VIN_MAX,
+		.readonly = true,
 		.attr = "rated_max",
 	},
 };
@@ -1773,23 +1779,28 @@ static const struct pmbus_limit_attr vout_limit_attrs[] = {
 	}, {
 		.reg = PMBUS_VIRT_READ_VOUT_AVG,
 		.update = true,
+		.readonly = true,
 		.attr = "average",
 	}, {
 		.reg = PMBUS_VIRT_READ_VOUT_MIN,
 		.update = true,
+		.readonly = true,
 		.attr = "lowest",
 	}, {
 		.reg = PMBUS_VIRT_READ_VOUT_MAX,
 		.update = true,
+		.readonly = true,
 		.attr = "highest",
 	}, {
 		.reg = PMBUS_VIRT_RESET_VOUT_HISTORY,
 		.attr = "reset_history",
 	}, {
 		.reg = PMBUS_MFR_VOUT_MIN,
+		.readonly = true,
 		.attr = "rated_min",
 	}, {
 		.reg = PMBUS_MFR_VOUT_MAX,
+		.readonly = true,
 		.attr = "rated_max",
 	},
 };
@@ -1849,20 +1860,24 @@ static const struct pmbus_limit_attr iin_limit_attrs[] = {
 	}, {
 		.reg = PMBUS_VIRT_READ_IIN_AVG,
 		.update = true,
+		.readonly = true,
 		.attr = "average",
 	}, {
 		.reg = PMBUS_VIRT_READ_IIN_MIN,
 		.update = true,
+		.readonly = true,
 		.attr = "lowest",
 	}, {
 		.reg = PMBUS_VIRT_READ_IIN_MAX,
 		.update = true,
+		.readonly = true,
 		.attr = "highest",
 	}, {
 		.reg = PMBUS_VIRT_RESET_IIN_HISTORY,
 		.attr = "reset_history",
 	}, {
 		.reg = PMBUS_MFR_IIN_MAX,
+		.readonly = true,
 		.attr = "rated_max",
 	},
 };
@@ -1886,20 +1901,24 @@ static const struct pmbus_limit_attr iout_limit_attrs[] = {
 	}, {
 		.reg = PMBUS_VIRT_READ_IOUT_AVG,
 		.update = true,
+		.readonly = true,
 		.attr = "average",
 	}, {
 		.reg = PMBUS_VIRT_READ_IOUT_MIN,
 		.update = true,
+		.readonly = true,
 		.attr = "lowest",
 	}, {
 		.reg = PMBUS_VIRT_READ_IOUT_MAX,
 		.update = true,
+		.readonly = true,
 		.attr = "highest",
 	}, {
 		.reg = PMBUS_VIRT_RESET_IOUT_HISTORY,
 		.attr = "reset_history",
 	}, {
 		.reg = PMBUS_MFR_IOUT_MAX,
+		.readonly = true,
 		.attr = "rated_max",
 	},
 };
@@ -1940,20 +1959,24 @@ static const struct pmbus_limit_attr pin_limit_attrs[] = {
 	}, {
 		.reg = PMBUS_VIRT_READ_PIN_AVG,
 		.update = true,
+		.readonly = true,
 		.attr = "average",
 	}, {
 		.reg = PMBUS_VIRT_READ_PIN_MIN,
 		.update = true,
+		.readonly = true,
 		.attr = "input_lowest",
 	}, {
 		.reg = PMBUS_VIRT_READ_PIN_MAX,
 		.update = true,
+		.readonly = true,
 		.attr = "input_highest",
 	}, {
 		.reg = PMBUS_VIRT_RESET_PIN_HISTORY,
 		.attr = "reset_history",
 	}, {
 		.reg = PMBUS_MFR_PIN_MAX,
+		.readonly = true,
 		.attr = "rated_max",
 	},
 };
@@ -1977,20 +2000,24 @@ static const struct pmbus_limit_attr pout_limit_attrs[] = {
 	}, {
 		.reg = PMBUS_VIRT_READ_POUT_AVG,
 		.update = true,
+		.readonly = true,
 		.attr = "average",
 	}, {
 		.reg = PMBUS_VIRT_READ_POUT_MIN,
 		.update = true,
+		.readonly = true,
 		.attr = "input_lowest",
 	}, {
 		.reg = PMBUS_VIRT_READ_POUT_MAX,
 		.update = true,
+		.readonly = true,
 		.attr = "input_highest",
 	}, {
 		.reg = PMBUS_VIRT_RESET_POUT_HISTORY,
 		.attr = "reset_history",
 	}, {
 		.reg = PMBUS_MFR_POUT_MAX,
+		.readonly = true,
 		.attr = "rated_max",
 	},
 };
@@ -2046,18 +2073,22 @@ static const struct pmbus_limit_attr temp_limit_attrs[] = {
 		.sbit = PB_TEMP_OT_FAULT,
 	}, {
 		.reg = PMBUS_VIRT_READ_TEMP_MIN,
+		.readonly = true,
 		.attr = "lowest",
 	}, {
 		.reg = PMBUS_VIRT_READ_TEMP_AVG,
+		.readonly = true,
 		.attr = "average",
 	}, {
 		.reg = PMBUS_VIRT_READ_TEMP_MAX,
+		.readonly = true,
 		.attr = "highest",
 	}, {
 		.reg = PMBUS_VIRT_RESET_TEMP_HISTORY,
 		.attr = "reset_history",
 	}, {
 		.reg = PMBUS_MFR_MAX_TEMP_1,
+		.readonly = true,
 		.attr = "rated_max",
 	},
 };
@@ -2087,18 +2118,22 @@ static const struct pmbus_limit_attr temp_limit_attrs2[] = {
 		.sbit = PB_TEMP_OT_FAULT,
 	}, {
 		.reg = PMBUS_VIRT_READ_TEMP2_MIN,
+		.readonly = true,
 		.attr = "lowest",
 	}, {
 		.reg = PMBUS_VIRT_READ_TEMP2_AVG,
+		.readonly = true,
 		.attr = "average",
 	}, {
 		.reg = PMBUS_VIRT_READ_TEMP2_MAX,
+		.readonly = true,
 		.attr = "highest",
 	}, {
 		.reg = PMBUS_VIRT_RESET_TEMP2_HISTORY,
 		.attr = "reset_history",
 	}, {
 		.reg = PMBUS_MFR_MAX_TEMP_2,
+		.readonly = true,
 		.attr = "rated_max",
 	},
 };
@@ -2128,6 +2163,7 @@ static const struct pmbus_limit_attr temp_limit_attrs3[] = {
 		.sbit = PB_TEMP_OT_FAULT,
 	}, {
 		.reg = PMBUS_MFR_MAX_TEMP_3,
+		.readonly = true,
 		.attr = "rated_max",
 	},
 };
-- 
2.53.0



