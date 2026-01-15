Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886111A5B9E;
	Thu, 15 Jan 2026 17:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498161; cv=none; b=fo0BBuM26mLmEx+dQ2uSP6btJG8R7OflQ+uFMDIldZEiCUUzuUlHO8YbdTrfsfMnuAfRvkx7/PGguxKK895x7Jyg8O3gBo/CKXm1g0UKhbFx4O0zq/2HCxA7VHwG92qbdMeDBKgqw6aOUI10WFQDSIu0ZNQIjDOVYtrw80AC4vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498161; c=relaxed/simple;
	bh=S4vV9HIpCGqd3338yif3mzLJxDUoXKMby8bKXRm3EB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqCPgFvhW5olzvbhFYW4rKsVQK3ls2dFGpuecCqGKuL2WCal64DzbA9srnSGGlKBicIHYOj8mCNCjGe9FSs4GafGV0hyzRSeV6NYdnWe/Zac4IXttW5UeSPr+kX9/kRnEDSyKA98Vl/WBot+tDXtRCHWFlzcKBa/penN9MaGU2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yfk6V5h6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yfk6V5h6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D437AC116D0;
	Thu, 15 Jan 2026 17:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498161;
	bh=S4vV9HIpCGqd3338yif3mzLJxDUoXKMby8bKXRm3EB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yfk6V5h6Jo0WbqCwlyFh4iXSvAaxBblDVOJ9cb9O/54yVaJjth2EhEfQC1UKZbcBM
	 CKO19NS34Vk60Y2+qy3wBdvp+KbwM5R5Dqo46imDN4yE3C3xMJijBv4Hhvf8fPUGHe
	 CZ2A7acYaWn0dnW8m25Qvo8hnQW/p3CqSd+LHjK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 334/554] hwmon: (w83l786ng) Convert macros to functions to avoid TOCTOU
Date: Thu, 15 Jan 2026 17:46:40 +0100
Message-ID: <20260115164258.321040969@linuxfoundation.org>
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
@@ -77,15 +77,25 @@ FAN_TO_REG(long rpm, int div)
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
@@ -281,7 +291,7 @@ static ssize_t show_##reg(struct device
 	int nr = to_sensor_dev_attr(attr)->index; \
 	struct w83l786ng_data *data = w83l786ng_update_device(dev); \
 	return sprintf(buf, "%d\n", \
-		FAN_FROM_REG(data->reg[nr], DIV_FROM_REG(data->fan_div[nr]))); \
+		fan_from_reg(data->reg[nr], DIV_FROM_REG(data->fan_div[nr]))); \
 }
 
 show_fan_reg(fan);
@@ -348,7 +358,7 @@ store_fan_div(struct device *dev, struct
 
 	/* Save fan_min */
 	mutex_lock(&data->update_lock);
-	min = FAN_FROM_REG(data->fan_min[nr], DIV_FROM_REG(data->fan_div[nr]));
+	min = fan_from_reg(data->fan_min[nr], DIV_FROM_REG(data->fan_div[nr]));
 
 	data->fan_div[nr] = DIV_TO_REG(val);
 
@@ -410,7 +420,7 @@ show_temp(struct device *dev, struct dev
 	int nr = sensor_attr->nr;
 	int index = sensor_attr->index;
 	struct w83l786ng_data *data = w83l786ng_update_device(dev);
-	return sprintf(buf, "%d\n", TEMP_FROM_REG(data->temp[nr][index]));
+	return sprintf(buf, "%d\n", temp_from_reg(data->temp[nr][index]));
 }
 
 static ssize_t


