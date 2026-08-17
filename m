Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675B3242925;
	Mon, 17 Aug 2026 15:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979125; cv=none; b=pR1p88j2hmTJiWgsxgsrxioQk+a2x+CZpZTOMD1f65HldjR5nqGmzRAvVFGr6bF9RjRbv2udDQXWtMAu9koC8tE1mKvbmFNKzMAP3wTFaNe4wwrDArx2e5bzYSg4z8Ox5XtBl0q8zetJ2bBZAQt9HAYYI1jxl60bMJxqDv+TExg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979125; c=relaxed/simple;
	bh=JKTmIvi7NBhouhoZfCrYjXEBa7CbXrpVyZi9WmNNrkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGsIP3yH6oZZsNY0/qTV/ibEVE3NteBt+LWyqElwAM4jIfGJYZIWHTq2LlRzm3S2ZPA1FhN4ic9866NcYZmRmMZquXxmnTbKyhAKw7mdN1M8zIGg2XppuV+sb537J+a6y32Lx0jNiqEIHjZ2vKu9ROIaTv5/CSR5UCq5BgP6/j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+iFxXIF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+iFxXIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C142E1F000E9;
	Mon, 17 Aug 2026 15:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979124;
	bh=Z5o51KmndsuP7oSBx4VpLyOgG9Q/FN6Q/dOQApTdYEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A+iFxXIFD5Vi7UQECUaiHXQAt/NcJFmwmQMjr1mNKtJdOlo+M+CK+WGGz4TagRlgw
	 xJu/5aKHqeUzR5kat4oL86Ohj6A/i2qHQcMHJBaAACXQeyZM0uJbVS6Q9LlEr7EJLL
	 h6QZkAS9G2OqgXFa1mCOKEIPrx2KRxJOfvEAONXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 118/609] hwmon: (asus-ec-sensors) fix EC read intervals
Date: Mon, 17 Aug 2026 15:26:54 +0200
Message-ID: <20260817132547.745504046@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Eugene Shalygin <eugene.shalygin@gmail.com>

[ Upstream commit 60710b2af13b81da71b429d3f8b19dd70310729d ]

Take INITIAL_JIFFIES into account when setting up next update time.

Fixes: d0ddfd241e57 ("hwmon: (asus-ec-sensors) add driver for ASUS EC")
Signed-off-by: Eugene Shalygin <eugene.shalygin@gmail.com>
Link: https://lore.kernel.org/r/20260712110650.1240071-2-eugene.shalygin@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/asus-ec-sensors.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/asus-ec-sensors.c b/drivers/hwmon/asus-ec-sensors.c
index c81c6e3264bb05..d6f6c8113af7ec 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -525,7 +525,7 @@ struct ec_sensors_data {
 	/* sorted list of unique register banks */
 	u8 banks[ASUS_EC_MAX_BANK + 1];
 	/* in jiffies */
-	unsigned long last_updated;
+	u64 next_update;
 	struct lock_data lock_data;
 	/* number of board EC sensors */
 	u8 nr_sensors;
@@ -794,13 +794,12 @@ static int get_cached_value_or_update(const struct device *dev,
 				      int sensor_index,
 				      struct ec_sensors_data *state, s32 *value)
 {
-	if (time_after(jiffies, state->last_updated + HZ)) {
+	if (time_after64(get_jiffies_64(), state->next_update)) {
 		if (update_ec_sensors(dev, state)) {
 			dev_err(dev, "update_ec_sensors() failure\n");
 			return -EIO;
 		}
-
-		state->last_updated = jiffies;
+		state->next_update = get_jiffies_64() + HZ;
 	}
 
 	*value = state->sensors[sensor_index].cached_value;
@@ -918,6 +917,7 @@ static int asus_ec_probe(struct platform_device *pdev)
 	if (!ec_data)
 		return -ENOMEM;
 
+	ec_data->next_update = INITIAL_JIFFIES;
 	dev_set_drvdata(dev, ec_data);
 	ec_data->board_info = pboard_info;
 
-- 
2.53.0



