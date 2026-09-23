Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DEF3AA19B;
	Wed, 23 Sep 2026 14:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173388; cv=none; b=dte3IJL9noybDLpaYmxro8c60HLrGESdsgF5jjdseNsEbRy20YCNzAweUBulV9bFNx4mgLR5NOdMCRPC3NNHcrKpUPXSOYUge922VaVWif0ODdsWgLjD9rIekInvqsBPDlecKM3dnhmHrrzQmrTQb17CO7tG7fYo/1jrAF1+eX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173388; c=relaxed/simple;
	bh=1NoPrEXoEn0OE7rlrvTBrZmRJOH2GQgqNE1ahXzozt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bBnWJhRk8BVYhPh9UwYDGbtyfmSKpbuZIkLMf/0lwUaWgdziQVXNt/MZBs9WBSide7MdIMOLsoG/I97jrrwPO6MJ3t4dTUs2FccN9+SwDsXNfMXU9uVPjPsUqRTRuxiwqO3AN9eCp0yPIgZ1Z3ENYRtgMEROhhrTQw6TneJWpYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDaXuUKi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDaXuUKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12261F0089A;
	Wed, 23 Sep 2026 14:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173387;
	bh=89+xlVMvCKhDOss4pgQ7NnDexfp4jOF/JGQ64gXYPGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vDaXuUKiyjyiz/s5Su6EyNdpZqtKZfz+YnZp+dF3z7G4njfa/d5rAtIneS4lml3k7
	 zHb49qjozKsiu3WMVI5L7uQzdR3Azx9IA+z9clUFbxoqAodJBpCSaAkICwzjOguGxw
	 W/aao98XPV3jBecVfjw0KszYfiY7Z9meVWcfXsEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	James Seo <james@equiv.tech>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 231/438] hwmon: (hp-wmi-sensors) Improve raw WMI string handling
Date: Wed, 23 Sep 2026 16:04:12 +0200
Message-ID: <20260923140650.752707962@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: James Seo <james@equiv.tech>

[ Upstream commit 92b68492eae701e5b0e9d142ffe229921af7b1fa ]

Commit c9ba59258094 ("hwmon: (hp-wmi-sensors) Fix failure to load on
EliteDesk 800 G6") left out some logic for recognizing raw WMI
strings in check_numeric_sensor_wobj(). This issue was reported by a
user along with an incomplete and unsuitable proposed solution [1].

Add the missing logic and properly remedy the issue. Also slightly
refactor how raw WMI strings are recognized elsewhere to make the
intent that they should be treated as regular ACPI strings clearer.

Reported-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://lore.kernel.org/linux-hwmon/20260916002907.161210-1-meatuni001@gmail.com/ [1]
Fixes: c9ba59258094 ("hwmon: (hp-wmi-sensors) Fix failure to load on EliteDesk 800 G6")
Signed-off-by: James Seo <james@equiv.tech>
Link: https://patch.msgid.link/20260916221912.434119-5-james@equiv.tech
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/hp-wmi-sensors.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/hwmon/hp-wmi-sensors.c b/drivers/hwmon/hp-wmi-sensors.c
index 03c684ba83bd6..cb2eb9bd278a2 100644
--- a/drivers/hwmon/hp-wmi-sensors.c
+++ b/drivers/hwmon/hp-wmi-sensors.c
@@ -526,14 +526,12 @@ static int check_wobj(const union acpi_object *wobj,
 	for (prop = 0; prop <= last_prop; prop++) {
 		type = elements[prop].type;
 		valid_type = property_map[prop];
-		if (type != valid_type) {
-			if (type == ACPI_TYPE_BUFFER &&
-			    valid_type == ACPI_TYPE_STRING &&
-			    is_raw_wmi_string(elements[prop].buffer.pointer,
-					      elements[prop].buffer.length))
-				continue;
+		if (type == ACPI_TYPE_BUFFER &&
+		    is_raw_wmi_string(elements[prop].buffer.pointer,
+				      elements[prop].buffer.length))
+			type = ACPI_TYPE_STRING;
+		if (type != valid_type)
 			return -EINVAL;
-		}
 	}
 
 	return 0;
@@ -579,6 +577,7 @@ static int check_numeric_sensor_wobj(const union acpi_object *wobj,
 	int prop = HP_WMI_PROPERTY_NAME;
 	acpi_object_type valid_type;
 	union acpi_object *elements;
+	union acpi_object *element;
 	u32 elem_count;
 	int last_prop;
 	bool is_new;
@@ -602,13 +601,20 @@ static int check_numeric_sensor_wobj(const union acpi_object *wobj,
 	    elem_count > HP_WMI_MAX_PROPERTIES)
 		return -EINVAL;
 
-	type = elements[HP_WMI_PROPERTY_SIZE].type;
+	element = &elements[HP_WMI_PROPERTY_SIZE];
+	type = element->type;
 	switch (type) {
 	case ACPI_TYPE_INTEGER:
 		is_new = true;
 		last_prop = HP_WMI_PROPERTY_RATE_UNITS;
 		break;
 
+	case ACPI_TYPE_BUFFER:
+		if (!is_raw_wmi_string(element->buffer.pointer,
+				       element->buffer.length))
+			return -EINVAL;
+		fallthrough;
+
 	case ACPI_TYPE_STRING:
 		is_new = false;
 		last_prop = HP_WMI_PROPERTY_CURRENT_READING;
@@ -631,6 +637,10 @@ static int check_numeric_sensor_wobj(const union acpi_object *wobj,
 	for (i = 0; i < elem_count && prop <= last_prop; i++, prop++) {
 		type = elements[i].type;
 		valid_type = hp_wmi_property_map[prop];
+		if (type == ACPI_TYPE_BUFFER &&
+		    is_raw_wmi_string(elements[i].buffer.pointer,
+				      elements[i].buffer.length))
+			type = ACPI_TYPE_STRING;
 		if (type != valid_type)
 			return -EINVAL;
 
@@ -651,6 +661,10 @@ static int check_numeric_sensor_wobj(const union acpi_object *wobj,
 			/* PossibleStates[0] has already been type-checked. */
 			for (j = 0; i + 1 < elem_count && j + 1 < count; j++) {
 				type = elements[++i].type;
+				if (type == ACPI_TYPE_BUFFER &&
+				    is_raw_wmi_string(elements[i].buffer.pointer,
+						      elements[i].buffer.length))
+					type = ACPI_TYPE_STRING;
 				if (type != valid_type)
 					return -EINVAL;
 			}
-- 
2.53.0



