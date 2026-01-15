Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148673D5235;
	Thu, 15 Jan 2026 17:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499608; cv=none; b=VSW9LabQdbyOWJfcfw3irIf83G0gLoDMgyOt1MJUQ7bZWyUs5JMjrI8pntyi8BQnm7cqY8GFJeh/RWoOK4bC9P3YreptHyWqqk0Zh2Og60O/GyzFOSwxYKKBNelRNiQy4JpmHmikpx0xD6NMqG12gh6e+HWfA8K+aVUjylCH5y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499608; c=relaxed/simple;
	bh=CNgMSNAlwYWLzl+bD8+8mlp04W6Lg5t2vV+1ibjd5fE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mntc6USQwPcmAKErtyCrixcVpcEycdbe8PZyuop/6WfWyN9qrKq4I1+6cbcS8qgCHqmLU04plHqga/oTVHz9XikMqe2Ev+EJKXKb9v337/6xhxaulxkmB31/EHQEWeulVQRNWj/r3zctB6TB6AhxpB2oHZ0eZTF/Yf8ZgEQV3s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ZuuZkZj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ZuuZkZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9119CC116D0;
	Thu, 15 Jan 2026 17:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499608;
	bh=CNgMSNAlwYWLzl+bD8+8mlp04W6Lg5t2vV+1ibjd5fE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ZuuZkZjOyEOP0qpT26JQP8tu1zwtIZK0e7nmbe12J6DMT72vi5b8VtiWJ64R+dkc
	 j7Y/YCeUgpUW8BS3nqInBSvl8cXkxW54eKqho9uj1Hfg3JEsM4VRhssNlDXl55Mmm3
	 coOI1c8PecjuzUYHlRizsI1DOCV73gLrAvhdHH5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 269/451] hwmon: (w83791d) Convert macros to functions to avoid TOCTOU
Date: Thu, 15 Jan 2026 17:47:50 +0100
Message-ID: <20260115164240.617444943@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


