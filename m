Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E60739A7EF;
	Mon, 23 Mar 2026 16:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283202; cv=none; b=ichxcDiG1SaERlDcczdXMbJxB7hvWzY5W7g9oyCDp2dfguotbaXy5pIsTQPvAoLa1BWcN4di3xBMB6LZtYcLp/2KWB+4u21KZhzO8rx52MhMySjCyWXwJIkJPAZFxj6w+n3wPvCFLClHBHNIVwDVgjdrsisIYDY8r5wF9Uhi2LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283202; c=relaxed/simple;
	bh=6kbcdXOoJZ8puh2bmkPtN7azjcD3yGH5TSJq+/Qt/kY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=If4l00KasAkpJc/MHTRPAHZbiGFSZ5MrF5lONPykkDRFCqXUuYxIcqDDaZauKXHAq+2/7jz/DEHT3KrH99pkEkFTjjdFenTUCCWLhrn26QyMUnE/vM4u4h+XeU+BbWbxi8Sd7ynixPSMyvX+XMHNFQUKwqRlnc02z8U8CdR9NJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FwruZBYD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FwruZBYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DEF6C2BC9E;
	Mon, 23 Mar 2026 16:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283202;
	bh=6kbcdXOoJZ8puh2bmkPtN7azjcD3yGH5TSJq+/Qt/kY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FwruZBYD57Us8dfiQ/5EakjsLD0hLGGw+Z0Ak2HkVJr89BjYUrbLpw/lTqGo62nDg
	 mlXT0QZNQ3Vx70Ox8E9FH6B0hx5+zS3hgwA2QZZMKknGQh/p8J39+DSgPckmSu4CM7
	 KN7Q/tUSG7AYVjloORudsxEgCGztA2MBw/yezwzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 440/481] hwmon: (pmbus/isl68137) Fix unchecked return value and use sysfs_emit()
Date: Mon, 23 Mar 2026 14:47:02 +0100
Message-ID: <20260323134535.935079650@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanman Pradhan <psanman@juniper.net>

commit 86259558e422b250aa6aa57163a6d759074573f5 upstream.

isl68137_avs_enable_show_page() uses the return value of
pmbus_read_byte_data() without checking for errors. If the I2C transaction
fails, a negative error code is passed through bitwise operations,
producing incorrect output.

Add an error check to propagate the return value if it is negative.
Additionally, modernize the callback by replacing sprintf()
with sysfs_emit().

Fixes: 038a9c3d1e424 ("hwmon: (pmbus/isl68137) Add driver for Intersil ISL68137 PWM Controller")
Cc: stable@vger.kernel.org
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://lore.kernel.org/r/20260318193952.47908-2-sanman.pradhan@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/isl68137.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/pmbus/isl68137.c
+++ b/drivers/hwmon/pmbus/isl68137.c
@@ -80,8 +80,11 @@ static ssize_t isl68137_avs_enable_show_
 {
 	int val = pmbus_read_byte_data(client, page, PMBUS_OPERATION);
 
-	return sprintf(buf, "%d\n",
-		       (val & ISL68137_VOUT_AVS) == ISL68137_VOUT_AVS ? 1 : 0);
+	if (val < 0)
+		return val;
+
+	return sysfs_emit(buf, "%d\n",
+			   (val & ISL68137_VOUT_AVS) == ISL68137_VOUT_AVS);
 }
 
 static ssize_t isl68137_avs_enable_store_page(struct i2c_client *client,


