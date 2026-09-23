Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A26448D11;
	Wed, 23 Sep 2026 14:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174682; cv=none; b=OlSZX05Q4JtAFJmycArJwIGEYdP2lqM4F7a5v1WY4mR1tc5PoWaaAAexezHCYioMo+ccOuS2YeGB35OHZJbP4ETuNQuYv7DFYKuc2s36sNiTrR8wQpcjchNUvRO07d8W2OAuz4frgQ9ulfBYv/cdSEjDtOVDXgmx1SAhW8X4l9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174682; c=relaxed/simple;
	bh=/vyR+2nvC84k+2odTbRZvYQc4fG6fT6YndcXpKPUNV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKqW75vbQjoWzUgOaSt1Ypa/KuiQyDaBe4jVx7UX6EU+oAO/LCDqskdechNcyf8DbfPUn0+6ukxN16cHupFWcpYv/+xTdMbELkaJ3SognUr6azuijFnvMGrSgu5qlDtg63Detr9Y+kZfn80cxu8gDVpANC6mb2jppn2Ll+RFaNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZaD3VOpd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZaD3VOpd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D470F1F000FF;
	Wed, 23 Sep 2026 14:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174681;
	bh=AINDF8S3+y8ET3wkdVtodrhGMtkzZHuwKV/yAxIcnOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZaD3VOpd+Y+6Wv/gwYow2400VeGqm8eItrhIo7dCWnlGzEs6Mq/2qP3TJ901FI9cF
	 W/pYkw4XU6oe69lkfIt4CceCAwWLSIARzO4KrDk4UyS9HIruZX+CIH5A6miEpQZy02
	 fG0G5XqDq7hiu19fRxo94go5638fcrxkSsCAHMdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	James Seo <james@equiv.tech>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 192/398] hwmon: (hp-wmi-sensors) Improve raw WMI string handling
Date: Wed, 23 Sep 2026 16:04:26 +0200
Message-ID: <20260923140648.403828129@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



