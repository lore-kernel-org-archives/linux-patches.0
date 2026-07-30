Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FC5443311;
	Thu, 30 Jul 2026 16:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427352; cv=none; b=U2+foPqzKTupYLHKQmPS5q0qOJ+0Ls1wpyNUVckFjVioCSU0f92L6PAL45sfxiCZ9f0ySqlm3JdULdwZ6Uqj/11YPY8QyiBSn6qX29P8vlSwLqjWKdU7iTh1E8MNE9Ob2k50BYIn3aU/Tglb4aSF9GD1eUh1iob1ANokT6SCbks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427352; c=relaxed/simple;
	bh=LTTCkW90NbC8oiv21xiqOArd1dEnBgmgZYaL8EAeCX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6C2eqQGjkUjAlPCWjyLRKvqk1tuiFrXOP87+kx4jJcbSQjK6o5fimu0zufA65vj1jenRs6QQRiqCMSELPMULtYFf1wZQ4khEA1IXo3g3Nzi0ULTsOx5hm4YfbEJgbj0rSJWLYKeNUwLVAggsTCoQ7ZGWwCcqvO4OPl8KFsbX1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nlBhkrXQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlBhkrXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6B41F000E9;
	Thu, 30 Jul 2026 16:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427351;
	bh=EILbSpIN/+X7RQtM/DY5MKxhxkyip8wGhH4N3Di7zrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nlBhkrXQBpp5sWh5mzIg4CgID4bPT47NRJVE2sOMQiEKUvmG63ucUW0VImqwnx4P3
	 vkkb5vPCW+eO/FqaURtbk4oEB83At/ftYQhLMduQwms/vJ9z37hMraUDWPoUNFP3Nt
	 7B4Uo9OTjRkjvi/sBrfajcu02U/NQk6ZWHuyDi7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 141/484] hwmon: (asus-ec-sensors) fix EC read intervals
Date: Thu, 30 Jul 2026 16:10:38 +0200
Message-ID: <20260730141426.525408615@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a6949358979e2f..3ada7db8008970 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -574,7 +574,7 @@ struct ec_sensors_data {
 	/* sorted list of unique register banks */
 	u8 banks[ASUS_EC_MAX_BANK + 1];
 	/* in jiffies */
-	unsigned long last_updated;
+	u64 next_update;
 	struct lock_data lock_data;
 	/* number of board EC sensors */
 	u8 nr_sensors;
@@ -843,13 +843,12 @@ static int get_cached_value_or_update(const struct device *dev,
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
@@ -967,6 +966,7 @@ static int asus_ec_probe(struct platform_device *pdev)
 	if (!ec_data)
 		return -ENOMEM;
 
+	ec_data->next_update = INITIAL_JIFFIES;
 	dev_set_drvdata(dev, ec_data);
 	ec_data->board_info = pboard_info;
 
-- 
2.53.0



