Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FB0C145;
	Mon, 23 Mar 2026 14:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274981; cv=none; b=JAiLRnk7EEG1x1n8itU+zwjaD5owrTMOsQX8lkzPGu2DM6/BXl7b6+nkkgdV+6id8g8VmudUCAJ/WLoH5syVIg93xkNMJ2o4LaK4Wv61vIKhHxb26iJ6ZUyeGK7NTFZ5fuuiP+CHTo7py35QbICRYiuLVy2N6pMv/cSJo5aOV1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274981; c=relaxed/simple;
	bh=XJW3iNtZ2BTYeWAsNdVJIFcm5Sdfvnrw+GNQ0BqNBcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPYoQi3HbLmd3UAaUGU/BQmUzUw1amgQ7pajYWoykatmHvhsdJfAV28oSPSQyxi4b1e1uJ2O0bzLlWgNn04nWXy5Bic9IwadZGgQFkaHaSkP0Gb/+SLnVibkF5oNMke0UvDP3hB2nQGQS0s/nePwJtKXvO6JOXj3Fej/vNwzo0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ue/+3hs1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ue/+3hs1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD43C4CEF7;
	Mon, 23 Mar 2026 14:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274981;
	bh=XJW3iNtZ2BTYeWAsNdVJIFcm5Sdfvnrw+GNQ0BqNBcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ue/+3hs1wuxT4JUWYwOlwrYsXeNHccV+Ag8o3G6xqo5SosR2XggNaOZswn1ittD+5
	 JhNvteuoMpDE3Zdo5431pXXXGg2xyqR+cWVpstK33y/w9riw3For57P/NgVN3VG9A3
	 qarjxFf9/7Oc5NOkN8ploz9jXrl+Umztsb58ODUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 182/212] hwmon: (pmbus/mp2869) Check pmbus_read_byte_data() before using its return value
Date: Mon, 23 Mar 2026 14:46:43 +0100
Message-ID: <20260323134509.500259736@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

From: Sanman Pradhan <psanman@juniper.net>

commit c6f45ed26b6eb4766db06f21ff28a97ed485bcbb upstream.

In mp2869_read_byte_data() and mp2869_read_word_data(), the return value
of pmbus_read_byte_data() for PMBUS_STATUS_MFR_SPECIFIC is used directly
inside FIELD_GET() macro arguments without error checking. If the I2C
transaction fails, a negative error code is passed to FIELD_GET() and
FIELD_PREP(), silently corrupting the status register bits being
constructed.

Extract the nested pmbus_read_byte_data() calls into a separate variable
and check for errors before use. This also eliminates a redundant duplicate
read of the same register in the PMBUS_STATUS_TEMPERATURE case.

Fixes: a3a2923aaf7f2 ("hwmon: add MP2869,MP29608,MP29612 and MP29816 series driver")
Cc: stable@vger.kernel.org
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://lore.kernel.org/r/20260317173308.382545-4-sanman.pradhan@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/mp2869.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/hwmon/pmbus/mp2869.c b/drivers/hwmon/pmbus/mp2869.c
index cc69a1e91dfe..4647892e5112 100644
--- a/drivers/hwmon/pmbus/mp2869.c
+++ b/drivers/hwmon/pmbus/mp2869.c
@@ -165,7 +165,7 @@ static int mp2869_read_byte_data(struct i2c_client *client, int page, int reg)
 {
 	const struct pmbus_driver_info *info = pmbus_get_driver_info(client);
 	struct mp2869_data *data = to_mp2869_data(info);
-	int ret;
+	int ret, mfr;
 
 	switch (reg) {
 	case PMBUS_VOUT_MODE:
@@ -188,11 +188,14 @@ static int mp2869_read_byte_data(struct i2c_client *client, int page, int reg)
 		if (ret < 0)
 			return ret;
 
+		mfr = pmbus_read_byte_data(client, page,
+					   PMBUS_STATUS_MFR_SPECIFIC);
+		if (mfr < 0)
+			return mfr;
+
 		ret = (ret & ~GENMASK(2, 2)) |
 			FIELD_PREP(GENMASK(2, 2),
-				   FIELD_GET(GENMASK(1, 1),
-					     pmbus_read_byte_data(client, page,
-								  PMBUS_STATUS_MFR_SPECIFIC)));
+				   FIELD_GET(GENMASK(1, 1), mfr));
 		break;
 	case PMBUS_STATUS_TEMPERATURE:
 		/*
@@ -207,15 +210,16 @@ static int mp2869_read_byte_data(struct i2c_client *client, int page, int reg)
 		if (ret < 0)
 			return ret;
 
+		mfr = pmbus_read_byte_data(client, page,
+					   PMBUS_STATUS_MFR_SPECIFIC);
+		if (mfr < 0)
+			return mfr;
+
 		ret = (ret & ~GENMASK(7, 6)) |
 			FIELD_PREP(GENMASK(6, 6),
-				   FIELD_GET(GENMASK(1, 1),
-					     pmbus_read_byte_data(client, page,
-								  PMBUS_STATUS_MFR_SPECIFIC))) |
+				   FIELD_GET(GENMASK(1, 1), mfr)) |
 			 FIELD_PREP(GENMASK(7, 7),
-				    FIELD_GET(GENMASK(1, 1),
-					      pmbus_read_byte_data(client, page,
-								   PMBUS_STATUS_MFR_SPECIFIC)));
+				    FIELD_GET(GENMASK(1, 1), mfr));
 		break;
 	default:
 		ret = -ENODATA;
@@ -230,7 +234,7 @@ static int mp2869_read_word_data(struct i2c_client *client, int page, int phase,
 {
 	const struct pmbus_driver_info *info = pmbus_get_driver_info(client);
 	struct mp2869_data *data = to_mp2869_data(info);
-	int ret;
+	int ret, mfr;
 
 	switch (reg) {
 	case PMBUS_STATUS_WORD:
@@ -246,11 +250,14 @@ static int mp2869_read_word_data(struct i2c_client *client, int page, int phase,
 		if (ret < 0)
 			return ret;
 
+		mfr = pmbus_read_byte_data(client, page,
+					   PMBUS_STATUS_MFR_SPECIFIC);
+		if (mfr < 0)
+			return mfr;
+
 		ret = (ret & ~GENMASK(2, 2)) |
 			 FIELD_PREP(GENMASK(2, 2),
-				    FIELD_GET(GENMASK(1, 1),
-					      pmbus_read_byte_data(client, page,
-								   PMBUS_STATUS_MFR_SPECIFIC)));
+				    FIELD_GET(GENMASK(1, 1), mfr));
 		break;
 	case PMBUS_READ_VIN:
 		/*
-- 
2.53.0



