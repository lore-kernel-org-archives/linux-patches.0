Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE0047252B;
	Tue, 21 Jul 2026 20:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665453; cv=none; b=Iu3XTc8hFQVwWGluIMPNXNwuuhJ1rz4wtZEB0qyx2F5tfBMi1ACc/4TEuj5hAM2uDiCeuoV0NpYv2S5B6ozdHchz3iH0PxbLd7lePdh93q54gga/Ow7bskUfzyc4U/EpxgXvAnRBFmg05eUS1mW7oDdjaxbTLZp6tHLzu29sd9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665453; c=relaxed/simple;
	bh=ljcH6scoElKAdY0G28NhJLsFVduWAYgISmoprSdZIyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWphhUmmTtYJc2BGDAqlc+r17BMnjoHMAV87/8saekQtTCjekKLH2WDNVXVZFphs4cPpoppCrT7NuM3P6FI1z85ivddYjYvU4AyPkx5jMOHWfNKuPEU5Dai+B9TF5ZI5ZW1OR30s1vAFm00+y+UR8bnmkzMwEIkVeqWl2gnBsh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/1y1BKm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/1y1BKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B624D1F000E9;
	Tue, 21 Jul 2026 20:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665451;
	bh=TFw4/LmU+WEj96e7n4vmPTdJJG8mYg/0eA3PNgucGuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A/1y1BKm1bQmb3t76+3PPK2lqxMEJKI91sGgYroCEPG9IdAVQuAnKKYby5XuM8KcQ
	 xjuUZ7ooInZIfabIbefpyvGKfjJe7KSBya6p1dUH+KMtTAN8/y751bITkooy77pxF+
	 SFdNkY5WXh0ymN+nb5soCCMSgxFZQgWuOg/7wIQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <kumarranja@chromium.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 0308/1266] Input: elan_i2c - prevent division by zero and arithmetic underflow
Date: Tue, 21 Jul 2026 17:12:25 +0200
Message-ID: <20260721152448.723252726@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Ranjan Kumar <kumarranja@chromium.org>

commit df2b818fa009c10ff6ba875a1663ff001cda9558 upstream.

The Elan I2C touchpad driver queries the device for its physical
dimensions and trace counts to calculate the device resolution and width.
However, if the device firmware or device tree provides invalid zero
values for x_traces or y_traces, it results in a fatal division-by-zero
exception leading to a kernel panic during device probe.

Add checks to ensure these parameters are non-zero before performing
the division. If invalid trace values are detected, fall back to a safe
default of 1.

Additionally, prevent an arithmetic underflow in the touch reporting
logic. Previously, if the calculated or fallback width was smaller than
ETP_FWIDTH_REDUCE (90), the subtraction would underflow, resulting in a
massive unsigned integer being reported to userspace. Clamp the adjusted
width to a minimum of 0 to safely handle small physical dimensions and
fallback scenarios.

Completing the probe with safe fallback values ensures the sysfs nodes
are created, keeping the firmware update path intact so a recovery
firmware can be flashed to the device.

Fixes: 6696777c6506 ("Input: add driver for Elan I2C/SMbus touchpad")
Fixes: e3a9a1290688 ("Input: elan_i2c - do not query the info if they are provided")
Signed-off-by: Ranjan Kumar <kumarranja@chromium.org>
Link: https://patch.msgid.link/20260612060339.3829666-1-kumarranja@chromium.org
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/elan_i2c_core.c |   36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

--- a/drivers/input/mouse/elan_i2c_core.c
+++ b/drivers/input/mouse/elan_i2c_core.c
@@ -424,8 +424,17 @@ static int elan_query_device_parameters(
 		if (error)
 			return error;
 	}
-	data->width_x = data->max_x / x_traces;
-	data->width_y = data->max_y / y_traces;
+
+	if (!x_traces || !y_traces) {
+		dev_warn(&client->dev,
+			 "invalid trace numbers: x=%u, y=%u\n",
+			 x_traces, y_traces);
+		data->width_x = 1;
+		data->width_y = 1;
+	} else {
+		data->width_x = data->max_x / x_traces;
+		data->width_y = data->max_y / y_traces;
+	}
 
 	if (device_property_read_u32(&client->dev,
 				     "touchscreen-x-mm", &x_mm) ||
@@ -439,8 +448,16 @@ static int elan_query_device_parameters(
 		data->x_res = elan_convert_resolution(hw_x_res, data->pattern);
 		data->y_res = elan_convert_resolution(hw_y_res, data->pattern);
 	} else {
-		data->x_res = (data->max_x + 1) / x_mm;
-		data->y_res = (data->max_y + 1) / y_mm;
+		if (unlikely(x_mm == 0 || y_mm == 0)) {
+			dev_warn(&client->dev,
+				 "invalid physical dimensions: x_mm=%u, y_mm=%u\n",
+				 x_mm, y_mm);
+			data->x_res = 1;
+			data->y_res = 1;
+		} else {
+			data->x_res = (data->max_x + 1) / x_mm;
+			data->y_res = (data->max_y + 1) / y_mm;
+		}
 	}
 
 	if (device_property_read_bool(&client->dev, "elan,clickpad"))
@@ -959,6 +976,7 @@ static void elan_report_contact(struct e
 
 		if (data->report_features & ETP_FEATURE_REPORT_MK) {
 			unsigned int mk_x, mk_y, area_x, area_y;
+			int adj_width_x, adj_width_y;
 			u8 mk_data = high_precision ?
 				packet[ETP_MK_DATA_OFFSET + contact_num] :
 				finger_data[3];
@@ -970,8 +988,14 @@ static void elan_report_contact(struct e
 			 * To avoid treating large finger as palm, let's reduce
 			 * the width x and y per trace.
 			 */
-			area_x = mk_x * (data->width_x - ETP_FWIDTH_REDUCE);
-			area_y = mk_y * (data->width_y - ETP_FWIDTH_REDUCE);
+
+			adj_width_x = data->width_x > ETP_FWIDTH_REDUCE ?
+					data->width_x - ETP_FWIDTH_REDUCE : 0;
+			adj_width_y = data->width_y > ETP_FWIDTH_REDUCE ?
+					data->width_y - ETP_FWIDTH_REDUCE : 0;
+
+			area_x = mk_x * adj_width_x;
+			area_y = mk_y * adj_width_y;
 
 			input_report_abs(input, ABS_TOOL_WIDTH, mk_x);
 			input_report_abs(input, ABS_MT_TOUCH_MAJOR,


