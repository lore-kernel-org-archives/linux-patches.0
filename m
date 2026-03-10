Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2EC37B413;
	Tue, 10 Mar 2026 11:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141996; cv=none; b=eUg4X9RXE1ZGHp+fEq23QUNPtnspOMluUlUv70EneGEcR3Vwe8D61FagFQRJR+BBd7dJPKT7Uu2jbikkXixSEdN7REsJFRFbw0Ig1dX+1dVLhdPgSjBS3DuI5TGDn2McGPPL2VkZqGrD0W17SHw5/Rcdq7JUlJskJ9uH1e67mbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141996; c=relaxed/simple;
	bh=qoKGMMA8c2XybmlNisuifTOpQXuhT19rXE7/Qukienc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMEXlcSljEO2E+naAFeu6eUyz/xR+AtK7b+vJ25j78I0Rxy+hBeFmlBRBpMbxuzVl2jIhK8ImDAOkTmCz4fwQxdrtCyGPs2okW0fWiK6xDrv7wYUfc8QCa/2o5FiWIU1BqT8NJ3ckdOU7yzU9RYaU3lHUoL2PL7YykzABpJWNpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i9TSi9RI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i9TSi9RI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E19FC19423;
	Tue, 10 Mar 2026 11:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141996;
	bh=qoKGMMA8c2XybmlNisuifTOpQXuhT19rXE7/Qukienc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i9TSi9RIdiBHG0xc8d3hIBg8utpOgdvskWSytHAtlcbOQfQGHSaB8I+bGSppgm7ZR
	 pkAjbGTgLLdZ+z3NfT4TiNxOlQoie58r5JviXiyiudTg/GuoLUToOf0Co7NQZj+o+n
	 uw1i8MBhGkZ7uF2XYpFcJGvCrktofOcqmJUvb/kzNNFLKNenaUmMa3LFkrjlnPJsUb
	 KQLID3kN5unsBi6QALzBAqgjw3Xz4ZiSX/2jfGlv9ooreMWLZ5xpp+61j2GbPTSV2M
	 Rm5qyOJamIvvXu5Bjoq/VPlYloQXHePnuPAaYLU9VpH9qsnSW/4dedpTjn+1hRkW6U
	 Mq23dEtUDWMUg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gui-Dong Han <hanguidong02@gmail.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 121/314] hwmon: (max16065) Use READ/WRITE_ONCE to avoid compiler optimization induced race
Date: Tue, 10 Mar 2026 07:16:20 -0400
Message-ID: <11f26b331ca8107a51d3862d2cb71a4d5c182e7d.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Gui-Dong Han <hanguidong02@gmail.com>

[ Upstream commit 007be4327e443d79c9dd9e56dc16c36f6395d208 ]

Simply copying shared data to a local variable cannot prevent data
races. The compiler is allowed to optimize away the local copy and
re-read the shared memory, causing a Time-of-Check Time-of-Use (TOCTOU)
issue if the data changes between the check and the usage.

To enforce the use of the local variable, use READ_ONCE() when reading
the shared data and WRITE_ONCE() when updating it. Apply these macros to
the three identified locations (curr_sense, adc, and fault) where local
variables are used for error validation, ensuring the value remains
consistent.

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Closes: https://lore.kernel.org/all/6fe17868327207e8b850cf9f88b7dc58b2021f73.camel@decadent.org.uk/
Fixes: f5bae2642e3d ("hwmon: Driver for MAX16065 System Manager and compatibles")
Fixes: b8d5acdcf525 ("hwmon: (max16065) Use local variable to avoid TOCTOU")
Cc: stable@vger.kernel.org
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Link: https://lore.kernel.org/r/20260203121443.5482-1-hanguidong02@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/max16065.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/hwmon/max16065.c b/drivers/hwmon/max16065.c
index 4c9e7892a73c1..43fbb9b26b102 100644
--- a/drivers/hwmon/max16065.c
+++ b/drivers/hwmon/max16065.c
@@ -151,27 +151,27 @@ static struct max16065_data *max16065_update_device(struct device *dev)
 		int i;
 
 		for (i = 0; i < data->num_adc; i++)
-			data->adc[i]
-			  = max16065_read_adc(client, MAX16065_ADC(i));
+			WRITE_ONCE(data->adc[i],
+				   max16065_read_adc(client, MAX16065_ADC(i)));
 
 		if (data->have_current) {
-			data->adc[MAX16065_NUM_ADC]
-			  = max16065_read_adc(client, MAX16065_CSP_ADC);
-			data->curr_sense
-			  = i2c_smbus_read_byte_data(client,
-						     MAX16065_CURR_SENSE);
+			WRITE_ONCE(data->adc[MAX16065_NUM_ADC],
+				   max16065_read_adc(client, MAX16065_CSP_ADC));
+			WRITE_ONCE(data->curr_sense,
+				   i2c_smbus_read_byte_data(client, MAX16065_CURR_SENSE));
 		}
 
 		for (i = 0; i < 2; i++)
-			data->fault[i]
-			  = i2c_smbus_read_byte_data(client, MAX16065_FAULT(i));
+			WRITE_ONCE(data->fault[i],
+				   i2c_smbus_read_byte_data(client, MAX16065_FAULT(i)));
 
 		/*
 		 * MAX16067 and MAX16068 have separate undervoltage and
 		 * overvoltage alarm bits. Squash them together.
 		 */
 		if (data->chip == max16067 || data->chip == max16068)
-			data->fault[0] |= data->fault[1];
+			WRITE_ONCE(data->fault[0],
+				   data->fault[0] | data->fault[1]);
 
 		data->last_updated = jiffies;
 		data->valid = true;
@@ -185,7 +185,7 @@ static ssize_t max16065_alarm_show(struct device *dev,
 {
 	struct sensor_device_attribute_2 *attr2 = to_sensor_dev_attr_2(da);
 	struct max16065_data *data = max16065_update_device(dev);
-	int val = data->fault[attr2->nr];
+	int val = READ_ONCE(data->fault[attr2->nr]);
 
 	if (val < 0)
 		return val;
@@ -203,7 +203,7 @@ static ssize_t max16065_input_show(struct device *dev,
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(da);
 	struct max16065_data *data = max16065_update_device(dev);
-	int adc = data->adc[attr->index];
+	int adc = READ_ONCE(data->adc[attr->index]);
 
 	if (unlikely(adc < 0))
 		return adc;
@@ -216,7 +216,7 @@ static ssize_t max16065_current_show(struct device *dev,
 				     struct device_attribute *da, char *buf)
 {
 	struct max16065_data *data = max16065_update_device(dev);
-	int curr_sense = data->curr_sense;
+	int curr_sense = READ_ONCE(data->curr_sense);
 
 	if (unlikely(curr_sense < 0))
 		return curr_sense;
-- 
2.51.0

