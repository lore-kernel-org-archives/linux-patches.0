Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5EE1A5B9E;
	Thu, 15 Jan 2026 17:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498158; cv=none; b=ejmtU1EHFInOj6SP3tsPT88FHzbXd7dyYqkivofTeWE1sPT1qNherTgbSsglC+d+iWC2Gk5ARDs+MyVLo5V+iISPPHRcjse4nctB0koNOicCavMpLWlE/PpZS316M/tpRkYVTrl4OxcXHUkdqBFd1ksXpbd52Y35jOWjqinpn9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498158; c=relaxed/simple;
	bh=+YiyE2oyacGIpvvvKj2NVGGCMvPJZPzjS6qvNR7Ir8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLgZIfBwr4MXgPkM7xG6rOhNylsk3+ir02XbfoSUO6fk2GMzgyzCW3lh/Xh+tXB5pGxhB86nGsQPiCLr5KUz5Yms5isFPzrO8h37dZgzOqag9VDwgNF6hZORGsGknekCzB9rRt+GWDpi4Qxv9tjGeIsBfLhv7kUAEAtjbUHByh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jCTZDKpy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jCTZDKpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE930C116D0;
	Thu, 15 Jan 2026 17:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498158;
	bh=+YiyE2oyacGIpvvvKj2NVGGCMvPJZPzjS6qvNR7Ir8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jCTZDKpyElS+G2SuRkYyoWEV/Tvc5gwTGRf14/IMPaEvsrZ+/qIBie8B8X7BmS2wD
	 odrU9OUx6tx4SRGNyD4qWT7fkIbt3B7SVynv1ZdEVBTNfnDdk2jd+62CpjFuvOzkr2
	 tkY6b2clssKRyguXcA/8o8NsUxsm14fcwg/gJoes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 333/554] hwmon: (w83791d) Convert macros to functions to avoid TOCTOU
Date: Thu, 15 Jan 2026 17:46:39 +0100
Message-ID: <20260115164258.285431927@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gui-Dong Han <hanguidong02@gmail.com>

commit 670d7ef945d3a84683594429aea6ab2cdfa5ceb4 upstream.

The macro FAN_FROM_REG evaluates its arguments multiple times. When used
in lockless contexts involving shared driver data, this leads to
Time-of-Check to Time-of-Use (TOCTOU) race conditions, potentially
causing divide-by-zero errors.

Convert the macro to a static function. This guarantees that arguments
are evaluated only once (pass-by-value), preventing the race
conditions.

Additionally, in store_fan_div, move the calculation of the minimum
limit inside the update lock. This ensures that the read-modify-write
sequence operates on consistent data.

Adhere to the principle of minimal changes by only converting macros
that evaluate arguments multiple times and are used in lockless
contexts.

Link: https://lore.kernel.org/all/CALbr=LYJ_ehtp53HXEVkSpYoub+XYSTU8Rg=o1xxMJ8=5z8B-g@mail.gmail.com/
Fixes: 9873964d6eb2 ("[PATCH] HWMON: w83791d: New hardware monitoring driver for the Winbond W83791D")
Cc: stable@vger.kernel.org
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Link: https://lore.kernel.org/r/20251202180105.12842-1-hanguidong02@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/w83791d.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/hwmon/w83791d.c
+++ b/drivers/hwmon/w83791d.c
@@ -218,9 +218,14 @@ static u8 fan_to_reg(long rpm, int div)
 	return clamp_val((1350000 + rpm * div / 2) / (rpm * div), 1, 254);
 }
 
-#define FAN_FROM_REG(val, div)	((val) == 0 ? -1 : \
-				((val) == 255 ? 0 : \
-					1350000 / ((val) * (div))))
+static int fan_from_reg(int val, int div)
+{
+	if (val == 0)
+		return -1;
+	if (val == 255)
+		return 0;
+	return 1350000 / (val * div);
+}
 
 /* for temp1 which is 8-bit resolution, LSB = 1 degree Celsius */
 #define TEMP1_FROM_REG(val)	((val) * 1000)
@@ -521,7 +526,7 @@ static ssize_t show_##reg(struct device
 	struct w83791d_data *data = w83791d_update_device(dev); \
 	int nr = sensor_attr->index; \
 	return sprintf(buf, "%d\n", \
-		FAN_FROM_REG(data->reg[nr], DIV_FROM_REG(data->fan_div[nr]))); \
+		fan_from_reg(data->reg[nr], DIV_FROM_REG(data->fan_div[nr]))); \
 }
 
 show_fan_reg(fan);
@@ -585,10 +590,10 @@ static ssize_t store_fan_div(struct devi
 	if (err)
 		return err;
 
+	mutex_lock(&data->update_lock);
 	/* Save fan_min */
-	min = FAN_FROM_REG(data->fan_min[nr], DIV_FROM_REG(data->fan_div[nr]));
+	min = fan_from_reg(data->fan_min[nr], DIV_FROM_REG(data->fan_div[nr]));
 
-	mutex_lock(&data->update_lock);
 	data->fan_div[nr] = div_to_reg(nr, val);
 
 	switch (nr) {


