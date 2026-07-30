Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F953440A06;
	Thu, 30 Jul 2026 15:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423894; cv=none; b=O/MVmLX+YZWWOh+DDJRR3gJSxIDqJ3t5SE6n34v2j0LzCj5fmMCcPRbd+PNOQY0lO1CbnXddfx633X2p7QDTDGNSEHdZWDoumnSvlCBhnoatfcJNAjdWrJRkBNLSFL9i/P+N8GVbuoDeBUeWGQ9U5GQg2us5lQRHkHU9Tzv42FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423894; c=relaxed/simple;
	bh=XbgN20EiKRbuyNIRXNrrHa1kAd9uQzXBkTu08FAJs8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDB8ZLVC43ELpOXbKPFp7DiLSu/X512AJ/ynkgggu3iJUys0f4u4D3+rPTIDivwCa1vhgzfmXxDJSaQZFO5ljwSkbEhH0EnCojj6YHWhcT0GrxTJbEaFGHVyBUaH8d0srsLQiNvtx4OiBQ08GmC/Jgj/DnnDmDh6BPW5hA/uEEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PcXjQa2I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PcXjQa2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4F71F00A3A;
	Thu, 30 Jul 2026 15:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423893;
	bh=ywMkIjVBabGfEKt05uJi51F5jI1uTVIDyOrJGGWlkuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PcXjQa2I4pARlHfReJSvYO105cAFU4uhhgIT6nuOnmq5Zlw2ysjoKhVRSfkABqNcV
	 D0KXDm+BlzDrOeB3YgTeKGCvKHKQAnJcx0tUIVd9q4T7uSYSUrKZKyOURMYEsfuFSK
	 nM5dC8MvRbotABg3lSrRpp5RRmoAv70t+u5PIJNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 202/675] hwmon: (asus-ec-sensors) fix EC read intervals
Date: Thu, 30 Jul 2026 16:08:52 +0200
Message-ID: <20260730141449.436522581@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
index aac4706cd437fe..52986b64881eab 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -870,7 +870,7 @@ struct ec_sensors_data {
 	/* sorted list of unique register banks */
 	u8 banks[ASUS_EC_MAX_BANK + 1];
 	/* in jiffies */
-	unsigned long last_updated;
+	u64 next_update;
 	struct lock_data lock_data;
 	/* number of board EC sensors */
 	u8 nr_sensors;
@@ -1139,13 +1139,12 @@ static int get_cached_value_or_update(const struct device *dev,
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
@@ -1263,6 +1262,7 @@ static int asus_ec_probe(struct platform_device *pdev)
 	if (!ec_data)
 		return -ENOMEM;
 
+	ec_data->next_update = INITIAL_JIFFIES;
 	dev_set_drvdata(dev, ec_data);
 	ec_data->board_info = pboard_info;
 
-- 
2.53.0



