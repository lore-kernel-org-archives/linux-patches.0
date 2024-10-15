Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23391C07C4;
	Tue, 15 Oct 2024 13:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997280; cv=none; b=kvQKrfNVJaV64h085vB+qcmN0l6BG8WLMtcbVZZiSOvlNnngnkIvg5KNWtxDM5CObeaZM6RL/dzaKu6o/sqV0i8zlptrDMoAQ87LBspfn8FwJIbhrmF93i8N1NV9kR72DgzCOfU/aqN+TE8rDnJjGJ7C02z2fks4BP5JiNElQrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997280; c=relaxed/simple;
	bh=ZbZNSgBNx9gOc6ZQC3B5dXBJ3kVi0NTjlG7sD7VCBKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfzd86E83E7FlUT8YeL6AEwejgdxPKvwiDNGUfVuUJjeOLz5+CaDX2ry4xTRlz2VgHGJDySkBLL0twZVE3/dGBI95PVzq/90klYrjdyV4hZ9WxGKYl5yE6RNSY4ysLOtP570bUM7MMMrDGWAKF24G8Q1vjapXr/6L0WiBXoYCr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iBfQ4vxF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iBfQ4vxF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5F1C4CEC6;
	Tue, 15 Oct 2024 13:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997280;
	bh=ZbZNSgBNx9gOc6ZQC3B5dXBJ3kVi0NTjlG7sD7VCBKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iBfQ4vxFNfURi3O8t6Ov6U1TTzPdwqKg+mIEBBIpcWVniEdT3/7ES9m/dtTWrbl3u
	 zypRCp5QmHVwc3JIxZh4yv5OxZYpZSiDfMm8VX2blY5y9iTNL9GRrupQviZEZxZPnK
	 zajvIXPZnydP9bzywHIABNYLRuASKVzHHTi8JuB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/518] hwmon: (max16065) Remove use of i2c_match_id()
Date: Tue, 15 Oct 2024 14:40:09 +0200
Message-ID: <20241015123921.054055609@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Andrew Davis <afd@ti.com>

[ Upstream commit 5a71654b398e3471f0169c266a3587cf09e1200c ]

The function i2c_match_id() is used to fetch the matching ID from
the i2c_device_id table. This is often used to then retrieve the
matching driver_data. This can be done in one step with the helper
i2c_get_match_data().

This helper has a couple other benefits:
 * It doesn't need the i2c_device_id passed in so we do not need
   to have that forward declared, allowing us to remove those or
   move the i2c_device_id table down to its more natural spot
   with the other module info.
 * It also checks for device match data, which allows for OF and
   ACPI based probing. That means we do not have to manually check
   those first and can remove those checks.

Signed-off-by: Andrew Davis <afd@ti.com>
Link: https://lore.kernel.org/r/20240403203633.914389-20-afd@ti.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 119abf7d1815 ("hwmon: (max16065) Fix alarm attributes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/max16065.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/max16065.c b/drivers/hwmon/max16065.c
index 6a09ab606fcbf..072f22f85dc0c 100644
--- a/drivers/hwmon/max16065.c
+++ b/drivers/hwmon/max16065.c
@@ -494,8 +494,6 @@ static const struct attribute_group max16065_max_group = {
 	.is_visible = max16065_secondary_is_visible,
 };
 
-static const struct i2c_device_id max16065_id[];
-
 static int max16065_probe(struct i2c_client *client)
 {
 	struct i2c_adapter *adapter = client->adapter;
@@ -506,7 +504,7 @@ static int max16065_probe(struct i2c_client *client)
 	bool have_secondary;		/* true if chip has secondary limits */
 	bool secondary_is_max = false;	/* secondary limits reflect max */
 	int groups = 0;
-	const struct i2c_device_id *id = i2c_match_id(max16065_id, client);
+	enum chips chip = (uintptr_t)i2c_get_match_data(client);
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA
 				     | I2C_FUNC_SMBUS_READ_WORD_DATA))
@@ -519,9 +517,9 @@ static int max16065_probe(struct i2c_client *client)
 	data->client = client;
 	mutex_init(&data->update_lock);
 
-	data->num_adc = max16065_num_adc[id->driver_data];
-	data->have_current = max16065_have_current[id->driver_data];
-	have_secondary = max16065_have_secondary[id->driver_data];
+	data->num_adc = max16065_num_adc[chip];
+	data->have_current = max16065_have_current[chip];
+	have_secondary = max16065_have_secondary[chip];
 
 	if (have_secondary) {
 		val = i2c_smbus_read_byte_data(client, MAX16065_SW_ENABLE);
-- 
2.43.0



