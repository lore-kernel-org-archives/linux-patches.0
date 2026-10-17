Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5DD3BB133;
	Sat, 17 Oct 2026 17:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258968; cv=none; b=mTTPFKCyT2ox2d09Jba1AAoFMHL5sd/Kt8xLVtP5ynUBKM0W8jKeYQi69nGdD/S6x9ShVuH4MAaklZ5cfWLcV/9Z2htIJa3ozlhiMjie078ez5gnOfMq2l8dEyTwvh9jybXTliFUPB31l6hfmmuK4YXHdP6rwnHy5LAdOodyKbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258968; c=relaxed/simple;
	bh=W+6Din+PRlB2I07TqjLveba9vbOQo+7HTBA0a60akF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+oacDGIlTiIX/kvX1V7pDKyJI5SF09oJqDpO9zrwUmsybh50ArVAqUBsEOdr+0JPxoKsbMdjnTRSU5W91ruTvhTFhOjcCpVhpjWzLgP2i4LiNvu3GGeL6puLuVrUDQW0dw7PElpIb1ZvlttnlHv0fvkd8vOozxqmwbvvNta3Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SoKS9uYH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SoKS9uYH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42FEE1F000C4;
	Sat, 17 Oct 2026 17:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258966;
	bh=C4zAcLuAQVWrjk+yetOyDQ6ECr33fTpEsJwr9VwqoO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SoKS9uYHWhTV7P4QFC94x7IX3GI9ziOLOYn+jgmkX154z14KbLROZy9/IngATcMh0
	 zSPwtP5eU9aVSwW896zBzJleSiAmV85bc5wGqeCiyIp3KdOx2us2bweOL1nu3MPKvs
	 SL9APMOixKnVUmD4IP5lt7ruauLLB7rY4Eznky14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1056/1674] hwmon: (lm90) Add lock protection to lm90_alert
Date: Sat, 17 Oct 2026 17:55:28 +0200
Message-ID: <20261017160458.231149483@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 873e919e3101063a7a75989510ccfc125a4391cf ]

Sashiko reports:

lm90_alert() executes in the smbus alert context and calls
lm90_update_confreg() to disable the hardware alert line, without
acquiring hwmon_lock.

Concurrently, sysfs write operations (such as lm90_write_convrate) hold
the hwmon_lock, temporarily modify data->config, and then restore it.

If an alert interrupt occurs concurrently with a sysfs write, the sysfs
path will overwrite the alert handler's modifications to data->config
and the hardware register.

This unintentionally re-enables the hardware alert line while the alarm is
still active, causing an interrupt storm.

Add the missing lock to lm90_alert() to solve the problem.

Fixes: 7a1d220ccb0cc ("hwmon: (lm90) Introduce function to update configuration register")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm90.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index 96a10b9875f0e..d3996950bd5d0 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -2943,6 +2943,7 @@ static void lm90_alert(struct i2c_client *client, enum i2c_alert_protocol type,
 		 */
 		struct lm90_data *data = i2c_get_clientdata(client);
 
+		mutex_lock(&data->update_lock);
 		if (!data->shutdown && (data->flags & LM90_HAVE_BROKEN_ALERT) &&
 		    (data->current_alarms & data->alert_alarms)) {
 			if (!(data->config & 0x80)) {
@@ -2952,6 +2953,7 @@ static void lm90_alert(struct i2c_client *client, enum i2c_alert_protocol type,
 			schedule_delayed_work(&data->alert_work,
 				max_t(int, HZ, msecs_to_jiffies(data->update_interval)));
 		}
+		mutex_unlock(&data->update_lock);
 	} else {
 		dev_dbg(&client->dev, "Everything OK\n");
 	}
-- 
2.53.0



