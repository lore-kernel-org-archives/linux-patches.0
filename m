Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E973F1D95AB;
	Tue, 15 Oct 2024 11:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992665; cv=none; b=cYd++MDiwZV2B3rSm3w/eYlqBFlWKr78SFQ7/2KPU2d0dqaulyRv7iNbDxgPPi3i4u/cBsg809khuyOUkn0z/lhJpxCXvpvZo91k5E72mHmcAReSB4NjYUln7+gm4QULQnvrvaJtGv/G8Sr/BN4I5nIlYFZYkfMZZp+9GQyAdJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992665; c=relaxed/simple;
	bh=5BEMuI/S/vMER1L5HkiAfQ2HbMlxur+JV4VRLfrQNW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4xD0S5TwkYsA0NY3KIoTgowaXxE5XAd58v/xLA4V9Pxcj2aaOvtqCbg+9WmEGI4U884r/N49h52Kf3jCdg0B3l0UB+2l06lOvBfkfpfgmovF1ofSggqe3UL5J/8FPjYS6ZcdbkoInWuHraDp+asr+sG3nAn+u9xAZCu9KTAb0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uhV65Rsd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uhV65Rsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054F0C4CEC6;
	Tue, 15 Oct 2024 11:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992664;
	bh=5BEMuI/S/vMER1L5HkiAfQ2HbMlxur+JV4VRLfrQNW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhV65RsdU/p6OesjpEEr9nVFl25LRkai9EkkBjcPp1qG6piHHWJ4K8lL/Do62SJb0
	 YidW3Gx/rizcuAvRuTrMzhjU2Nk+znE1f136Nsvde+NY3060/1MadIEgflBM1lntUR
	 ceOpIntXUVXyhoUWp7D6QXr5VeZ3iccPHRGKOlNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 151/691] hwmon: (max16065) Remove use of i2c_match_id()
Date: Tue, 15 Oct 2024 13:21:39 +0200
Message-ID: <20241015112446.349213827@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 47d039c46cb09..174a2b9ea2b80 100644
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



