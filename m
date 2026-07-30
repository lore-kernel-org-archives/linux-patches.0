Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CFD3806BD;
	Thu, 30 Jul 2026 15:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425716; cv=none; b=Ompq2D2/9laFPn0IAC6xkNuw8p2uh5oYxHakfD8i68fMRgeeVndeK1aEnhgXYKGnO6S6Q3hZ2CQ9qh0NV8d0PNjxcL5g/WVLB9KVGsnY100EVHSJ8XPeRZCu3srFFljtVYoQ13qD3dauoFY+/KCnlcWe6BAcjxhGYCGTZb+Lfus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425716; c=relaxed/simple;
	bh=5XHPbzqFBmIWWNPi/sM8pxklxJwrh9AvnUkB/5g9o5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F76F92miH0xRfD2J0KqDOigLBKe+bdYX48dvWCdVeIHZs/3X5CTqVKD91V/chdnR+hpKXUnYqJRAGJuDcFGoXwSKl3h1NSFLESPRt6eXe/D2pIkodM28yIbUzym+jlB54bnU/lsULmH7GvENc5zIjWnqR4phD+4P0G4LB1vRON0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kw2L3/Zp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kw2L3/Zp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4F31F000E9;
	Thu, 30 Jul 2026 15:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425715;
	bh=ojprc2pWhX9EOQKdhjrn1NgcHNL//J6wmynrMHS/kUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kw2L3/ZplHk1xNHRi/TM7vBW9vXMujppvqh0JHMi0SSHuP6y1yP6UXw+0H9Hd2Hkv
	 f23UTIT8CSXQUADQIHaD+BkMpziDacwZMYvJ9eVq3Ia4wc90wOxM4HWRXO85cERi3t
	 7G21Ac9SOQqWJHPdUjcrUIXTBZcmIKwWvg+MdUEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 166/602] hwmon: (asus-ec-sensors) fix EC read intervals
Date: Thu, 30 Jul 2026 16:09:18 +0200
Message-ID: <20260730141439.459865310@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 909720fbf2685f..d08abd1adc0812 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -596,7 +596,7 @@ struct ec_sensors_data {
 	/* sorted list of unique register banks */
 	u8 banks[ASUS_EC_MAX_BANK + 1];
 	/* in jiffies */
-	unsigned long last_updated;
+	u64 next_update;
 	struct lock_data lock_data;
 	/* number of board EC sensors */
 	u8 nr_sensors;
@@ -865,13 +865,12 @@ static int get_cached_value_or_update(const struct device *dev,
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
@@ -989,6 +988,7 @@ static int asus_ec_probe(struct platform_device *pdev)
 	if (!ec_data)
 		return -ENOMEM;
 
+	ec_data->next_update = INITIAL_JIFFIES;
 	dev_set_drvdata(dev, ec_data);
 	ec_data->board_info = pboard_info;
 
-- 
2.53.0



