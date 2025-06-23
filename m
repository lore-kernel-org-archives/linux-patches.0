Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15231AD3FA;
	Mon, 23 Jun 2025 21:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715560; cv=none; b=A4ioKzdo967U4LARrXwM3kNCYArfxrPkkkdMTKkYzNv5Fdh7HUhhMZCoiFQLEOhYOQGuq8z91Mf7IVwAqr7bdf1gPtAcjkxMErpmbLVYgM4mb9IHkaHxw6dgpFvoVJYZGB8RsApk255/IqLpGX4A4XnyMIIG/KjckAmSikRydDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715560; c=relaxed/simple;
	bh=UnHDJn1/X1rFzEw/u+GJCMYpYeVOU1sVSLeXM1v8ctY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iu+g8wf7H6RRaFKgqXf/97PyYylci65vojYe+1Cs1JSDNWATiaN59RN78egMW8fP7UTqesbUC+gwqvgFiG/9I2OhNUz765Pa5kfH81AwahJ/9hg3IjoICt8NDBCeBAcwG0IMiMn/SARA0ip1xBMM3eTTRCTjBdnciclofGAGwcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CwBWA7Wa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CwBWA7Wa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03ED1C4CEEA;
	Mon, 23 Jun 2025 21:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715560;
	bh=UnHDJn1/X1rFzEw/u+GJCMYpYeVOU1sVSLeXM1v8ctY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CwBWA7WalsNQIFfo+SSdAvmUSCUxmzdyn2Xs2qyKr07lmtOy5VJjaMYkEnsgcZaLt
	 A8eAm9WD+kPc314gBKGGtizvhZKQSFC0elz+1NnzJHu7B8meZrQ/Y8cqs9xYPNQ0nm
	 nHYS7Ku5v6GqN8/o31EPplMKFUB6zEhJoA4FEbgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie James <eajames@linux.ibm.com>,
	Joel Stanley <joel@jms.id.au>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 303/355] hwmon: (occ) Add new temperature sensor type
Date: Mon, 23 Jun 2025 15:08:24 +0200
Message-ID: <20250623130635.888729801@linuxfoundation.org>
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

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit db4919ec86ff405273a767e1a9b51e2760e73ce5 ]

The latest version of the On-Chip Controller (OCC) has a different
format for the temperature sensor data. Add a new temperature sensor
version to handle this data.

Signed-off-by: Eddie James <eajames@linux.ibm.com>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20201120010315.190737-4-joel@jms.id.au
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 744c2fe950e9 ("hwmon: (occ) Rework attribute registration for stack usage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/occ/common.c | 75 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/drivers/hwmon/occ/common.c b/drivers/hwmon/occ/common.c
index d052502dc2c0e..580e63d7daa00 100644
--- a/drivers/hwmon/occ/common.c
+++ b/drivers/hwmon/occ/common.c
@@ -41,6 +41,14 @@ struct temp_sensor_2 {
 	u8 value;
 } __packed;
 
+struct temp_sensor_10 {
+	u32 sensor_id;
+	u8 fru_type;
+	u8 value;
+	u8 throttle;
+	u8 reserved;
+} __packed;
+
 struct freq_sensor_1 {
 	u16 sensor_id;
 	u16 value;
@@ -307,6 +315,60 @@ static ssize_t occ_show_temp_2(struct device *dev,
 	return snprintf(buf, PAGE_SIZE - 1, "%u\n", val);
 }
 
+static ssize_t occ_show_temp_10(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	int rc;
+	u32 val = 0;
+	struct temp_sensor_10 *temp;
+	struct occ *occ = dev_get_drvdata(dev);
+	struct occ_sensors *sensors = &occ->sensors;
+	struct sensor_device_attribute_2 *sattr = to_sensor_dev_attr_2(attr);
+
+	rc = occ_update_response(occ);
+	if (rc)
+		return rc;
+
+	temp = ((struct temp_sensor_10 *)sensors->temp.data) + sattr->index;
+
+	switch (sattr->nr) {
+	case 0:
+		val = get_unaligned_be32(&temp->sensor_id);
+		break;
+	case 1:
+		val = temp->value;
+		if (val == OCC_TEMP_SENSOR_FAULT)
+			return -EREMOTEIO;
+
+		/*
+		 * VRM doesn't return temperature, only alarm bit. This
+		 * attribute maps to tempX_alarm instead of tempX_input for
+		 * VRM
+		 */
+		if (temp->fru_type != OCC_FRU_TYPE_VRM) {
+			/* sensor not ready */
+			if (val == 0)
+				return -EAGAIN;
+
+			val *= 1000;
+		}
+		break;
+	case 2:
+		val = temp->fru_type;
+		break;
+	case 3:
+		val = temp->value == OCC_TEMP_SENSOR_FAULT;
+		break;
+	case 4:
+		val = temp->throttle * 1000;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return snprintf(buf, PAGE_SIZE - 1, "%u\n", val);
+}
+
 static ssize_t occ_show_freq_1(struct device *dev,
 			       struct device_attribute *attr, char *buf)
 {
@@ -745,6 +807,10 @@ static int occ_setup_sensor_attrs(struct occ *occ)
 		num_attrs += (sensors->temp.num_sensors * 4);
 		show_temp = occ_show_temp_2;
 		break;
+	case 0x10:
+		num_attrs += (sensors->temp.num_sensors * 5);
+		show_temp = occ_show_temp_10;
+		break;
 	default:
 		sensors->temp.num_sensors = 0;
 	}
@@ -844,6 +910,15 @@ static int occ_setup_sensor_attrs(struct occ *occ)
 			attr->sensor = OCC_INIT_ATTR(attr->name, 0444,
 						     show_temp, NULL, 3, i);
 			attr++;
+
+			if (sensors->temp.version == 0x10) {
+				snprintf(attr->name, sizeof(attr->name),
+					 "temp%d_max", s);
+				attr->sensor = OCC_INIT_ATTR(attr->name, 0444,
+							     show_temp, NULL,
+							     4, i);
+				attr++;
+			}
 		}
 	}
 
-- 
2.39.5



