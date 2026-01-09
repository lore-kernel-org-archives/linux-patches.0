Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A112B2EAD10;
	Fri,  9 Jan 2026 12:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960802; cv=none; b=cIfPXKzvlGakAN3am+20Ak3xEONJFEG8q0EwVOo8suUkAPT4Q4kdsFKvc6/HaSvCAwQ375PsRtDSPevklTvMw0HHNQVYQg7uGEVzIxeOOJ2yZiqC/cdDJHsrwfG691dn/iw8XBP08qG4gBAZfI4bYb6L2ZAMpHY7S402BBFackE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960802; c=relaxed/simple;
	bh=Q9GZs8X8GF0bCkj6JxfPAPmZyG1aiyXF4UZvZfkwem4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KmeC4/fHFul6amuXSwASTcUb01gjMT4rVw7crqyPi3ugv5gD2hgHXTIRe/RH/iq1I5+PTFymgCdDtzZ/qRJLMTgOGx2EWl90ZMk+dwa1tWFceT8zIy6RwrLCuKJn9bGeLT1LSH0A4UjDDJHdDkODysPG/r8jABTQUXES/oT8U2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JkaVEuDY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JkaVEuDY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC1FC16AAE;
	Fri,  9 Jan 2026 12:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960802;
	bh=Q9GZs8X8GF0bCkj6JxfPAPmZyG1aiyXF4UZvZfkwem4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JkaVEuDYktxwJ3o9wPoP7qmyktwZrkk/C3sJRFh1Mu30dsKOgjHGr2a7wJiuT3bXd
	 muvQD5rvZCqPbKfwZG1X+pg9e1i5FUB/o5AlG857eae/tK1vIDxwiiJJXlhep74jzT
	 OfU0ZXAPXzdf9c8wl48Y2WEYnm8TxY3R2ym2gTWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 498/737] hwmon: (w83l786ng) Convert macros to functions to avoid TOCTOU
Date: Fri,  9 Jan 2026 12:40:37 +0100
Message-ID: <20260109112152.725375809@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Gui-Dong Han <hanguidong02@gmail.com>

commit 07272e883fc61574b8367d44de48917f622cdd83 upstream.

The macros FAN_FROM_REG and TEMP_FROM_REG evaluate their arguments
multiple times. When used in lockless contexts involving shared driver
data, this causes Time-of-Check to Time-of-Use (TOCTOU) race
conditions.

Convert the macros to static functions. This guarantees that arguments
are evaluated only once (pass-by-value), preventing the race
conditions.

Adhere to the principle of minimal changes by only converting macros
that evaluate arguments multiple times and are used in lockless
contexts.

Link: https://lore.kernel.org/all/CALbr=LYJ_ehtp53HXEVkSpYoub+XYSTU8Rg=o1xxMJ8=5z8B-g@mail.gmail.com/
Fixes: 85f03bccd6e0 ("hwmon: Add support for Winbond W83L786NG/NR")
Cc: stable@vger.kernel.org
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Link: https://lore.kernel.org/r/20251128123816.3670-1-hanguidong02@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/w83l786ng.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

--- a/drivers/hwmon/w83l786ng.c
+++ b/drivers/hwmon/w83l786ng.c
@@ -76,15 +76,25 @@ FAN_TO_REG(long rpm, int div)
 	return clamp_val((1350000 + rpm * div / 2) / (rpm * div), 1, 254);
 }
 
-#define FAN_FROM_REG(val, div)	((val) == 0   ? -1 : \
-				((val) == 255 ? 0 : \
-				1350000 / ((val) * (div))))
+static int fan_from_reg(int val, int div)
+{
+	if (val == 0)
+		return -1;
+	if (val == 255)
+		return 0;
+	return 1350000 / (val * div);
+}
 
 /* for temp */
 #define TEMP_TO_REG(val)	(clamp_val(((val) < 0 ? (val) + 0x100 * 1000 \
 						      : (val)) / 1000, 0, 0xff))
-#define TEMP_FROM_REG(val)	(((val) & 0x80 ? \
-				  (val) - 0x100 : (val)) * 1000)
+
+static int temp_from_reg(int val)
+{
+	if (val & 0x80)
+		return (val - 0x100) * 1000;
+	return val * 1000;
+}
 
 /*
  * The analog voltage inputs have 8mV LSB. Since the sysfs output is
@@ -280,7 +290,7 @@ static ssize_t show_##reg(struct device
 	int nr = to_sensor_dev_attr(attr)->index; \
 	struct w83l786ng_data *data = w83l786ng_update_device(dev); \
 	return sprintf(buf, "%d\n", \
-		FAN_FROM_REG(data->reg[nr], DIV_FROM_REG(data->fan_div[nr]))); \
+		fan_from_reg(data->reg[nr], DIV_FROM_REG(data->fan_div[nr]))); \
 }
 
 show_fan_reg(fan);
@@ -347,7 +357,7 @@ store_fan_div(struct device *dev, struct
 
 	/* Save fan_min */
 	mutex_lock(&data->update_lock);
-	min = FAN_FROM_REG(data->fan_min[nr], DIV_FROM_REG(data->fan_div[nr]));
+	min = fan_from_reg(data->fan_min[nr], DIV_FROM_REG(data->fan_div[nr]));
 
 	data->fan_div[nr] = DIV_TO_REG(val);
 
@@ -409,7 +419,7 @@ show_temp(struct device *dev, struct dev
 	int nr = sensor_attr->nr;
 	int index = sensor_attr->index;
 	struct w83l786ng_data *data = w83l786ng_update_device(dev);
-	return sprintf(buf, "%d\n", TEMP_FROM_REG(data->temp[nr][index]));
+	return sprintf(buf, "%d\n", temp_from_reg(data->temp[nr][index]));
 }
 
 static ssize_t


