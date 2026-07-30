Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E859432E94;
	Thu, 30 Jul 2026 14:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421787; cv=none; b=EkxS0aHZJsfTh2wle1XUvR+Gv4YIpC25p3Kp+ofoIYIr5ZEQGw3xS4pchdhyTF0h7ej3yVEphB82v+noWwvqnbMHgNEuLtl8tFmijWyiJGo44JrfrpJiW/vFRjT82V4NwxrOf8/DIPK4FRwLsSr4DC4qs5JJcd7lreVXdUiPVSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421787; c=relaxed/simple;
	bh=aeNqBN1du/Qxoo9q9GO/Nn/5H7VD5g48SQ/m/dv1PtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4glcRMy9yumvjC9nDiiRSBugMMa5dBDL+042xd9Pj0qzRzG8/5aGhEQjudqpNUXY7Jr2UDJE4yFX2IvXJdTa0ZfYcjYZsBJpN9lcAbFanp7JCHyZ7pSnfZHKbKBE/n2qwLPh5Eo0sNc/6tG16U72RwL08MaAIFAj3SKQYpDMxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hgTjcn/1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hgTjcn/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705071F000E9;
	Thu, 30 Jul 2026 14:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421786;
	bh=5yaI0G74N9/ewRGzMy7DGQ6TVWBjBcfhzI9wD3fIoM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hgTjcn/1SiiBNB3qjRfXJx+46H+2VnUWsB5HpZDhKKxJWkGLVie0rCxvAZsG7i1Jw
	 UNIlM24qei5G5ZSyxw4pGxTRJYHf2HuOoJI6+6RYOPeZYqfkdmTYNWXiADbBBvkTeo
	 W+R/Ts/0cwjCGnO2F3Vvs0Df/DUM6wGYM312Fs1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 218/744] hwmon: (asus-ec-sensors) fix EC read intervals
Date: Thu, 30 Jul 2026 16:08:11 +0200
Message-ID: <20260730141448.918443355@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index d0a58207b00d3b..181fbb9511794c 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -974,7 +974,7 @@ struct ec_sensors_data {
 	/* sorted list of unique register banks */
 	u8 banks[ASUS_EC_MAX_BANK + 1];
 	/* in jiffies */
-	unsigned long last_updated;
+	u64 next_update;
 	struct lock_data lock_data;
 	/* number of board EC sensors */
 	u8 nr_sensors;
@@ -1243,13 +1243,12 @@ static int get_cached_value_or_update(const struct device *dev,
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
@@ -1367,6 +1366,7 @@ static int asus_ec_probe(struct platform_device *pdev)
 	if (!ec_data)
 		return -ENOMEM;
 
+	ec_data->next_update = INITIAL_JIFFIES;
 	dev_set_drvdata(dev, ec_data);
 	ec_data->board_info = pboard_info;
 
-- 
2.53.0



