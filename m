Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215364;
	b=tHeQqRGEJ6JTaP7wGI0zTD8tgiUpWKeSL2062Ilb27HkIlpeQHvWkgulXPWL83B1W74v
	 TS0rVkZUXgjJWRbOu/j2lGm57szYwoSZFK0BZ6Mobi7C1Mjx8CvM0BOF/llgramcl1KLY
	 7593B1wtlJUQbM/sfMUbsGVNtw70EuQ0hlVKmj5szLc4lPUja5Dr6RLhkUoRrIbZ7ogMy
	 yyVP4PETtUpKzhN227FhFbzaXVL0A8Gdy/LK5bfpPJaN3QW4+5c5ag/1yGK8LKXVEdbZg
	 IRP7AS6gpe+V+zjBlqQXjEA3JHK54YFZUhi1TmC8c2yxjx5ENH2qE/UcxWCLxP6q1pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215364;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NczshF9R5t3BTDAv0690yZ6irZn5sirfpnUy/R7+Efo=;
	b=v0Ht93jaY/nHlnfQerV/pwU+pi8Mi8tP0PgWz4uB9gUQTcWSM2vRIbcF5LRvoQpfDaSh
	 pcTDRfqIwiyhGjWmh/DtFxH3SSy+FaKQsgliUsX6ZFlJBcqk6t3vPTT5GZDScoPfk/cjw
	 xMsVU+ewGC1s8kLuUgN+hI9vLXoKv5Z0D5aRJ7/l9iJst9o3u9b6KL6xi4lfTvsBo9k8I
	 IrqAG4uTIqBSkzZs0fNbTjl9C+oX3lNI800fQ4X6gPHAAPxqnqkdGOqEQOU9sz3OU4Wju
	 pE/jL1/cyV/bm88VPUnUEWbR5QQ9zy/h2Vft1jmJa5WSRINmCcuP7DPKkqE5XM4SVCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0yqyeLE8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE53B606A31C;
	Wed, 28 Oct 2026 19:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0yqyeLE8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300F41F031E1;
	Wed, 28 Oct 2026 19:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215363;
	bh=NczshF9R5t3BTDAv0690yZ6irZn5sirfpnUy/R7+Efo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0yqyeLE8flt3C/C5sykjBXSTTGEPIMeyB9q0SOEFpMs2mYDpQ4Xks9j2mrvlr2msD
	 zIvT4ZKLfe3ddfaEjjgPtyoVRqguFpe5UitUg1EQ5pJbWtbOn9mMpBIVtf2ZdviEUA
	 CuQoaNElqtBFg9EcpcpHFf9tLCjj70qPO8qZHNBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1142/1887] hwmon: (lm90) Add lock protection to lm90_alert
Date: Wed, 28 Oct 2026 17:53:58 +0100
Message-ID: <20261028170525.394500308@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8970927bef8ab..7a8a47b9ba41b 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -2958,6 +2958,7 @@ static void lm90_alert(struct i2c_client *client, enum i2c_alert_protocol type,
 		 */
 		struct lm90_data *data = i2c_get_clientdata(client);
 
+		mutex_lock(&data->update_lock);
 		if (!data->shutdown && (data->flags & LM90_HAVE_BROKEN_ALERT) &&
 		    (data->current_alarms & data->alert_alarms)) {
 			if (!(data->config & 0x80)) {
@@ -2967,6 +2968,7 @@ static void lm90_alert(struct i2c_client *client, enum i2c_alert_protocol type,
 			schedule_delayed_work(&data->alert_work,
 				max_t(int, HZ, msecs_to_jiffies(data->update_interval)));
 		}
+		mutex_unlock(&data->update_lock);
 	} else {
 		dev_dbg(&client->dev, "Everything OK\n");
 	}
-- 
2.53.0



