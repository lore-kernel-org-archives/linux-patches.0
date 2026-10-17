Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED93C38654F;
	Sat, 17 Oct 2026 16:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254196; cv=none; b=Yp3oGl+CGKB6HHN3mVEHH/vR3i4zFnKVDStgS80yS9AZ8nsdLUxgbTYRG1bHDc9i1J/Min3Zh/AF5AxYWnxU0qHYVP3EJlXqIX/8ggS1STIpD8aYw1fGHUWGc7FdjKVUPb3uMAo/K2m4MOGdSWgCgoDBuBmPf0NiiOG1Lgs5LcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254196; c=relaxed/simple;
	bh=1G5+BY6TVY6uQehPfJOS/3s98MUlr4LbTZqtw1XDIm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfV//aBdUUa4QraV8s7x01lylD9o2YUyg0yO5TbZUwxt8hQ6dqXN/zy8QTew2cbyLiKwdo2WDIoIo0XTuWc7zD9MsthriAM1u4gCEeBSY4ggb5LBVE9LWoKurOnDZ36xtINnZDtSnSQQJyOINzJEz/EdBffHCR8d359Ep5hC+Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VE5KHGam; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VE5KHGam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE6F1F000C4;
	Sat, 17 Oct 2026 16:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254195;
	bh=I3Ej5CSGLie+5Gkv1xjTxV4zDJxqilZ53cjntUuwpVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VE5KHGam35EPmFUWpxtf48RvaJoNNoaAmcPXcstXp7YIH8lzzCy5NX9fb5DHwVcmM
	 Sai3oOagJzfBexGBs6rOmf1tV8eJNqoedmhj8nZZZ7nnz7ktoBKlH8J+8fStUqFKLk
	 BBCiRB1qO8ZTck8zVaJfi2pBukIhGlOwoSSGDrgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 366/869] hwmon: (lm90) Add lock protection to lm90_alert
Date: Sat, 17 Oct 2026 17:53:27 +0200
Message-ID: <20261017160046.492189869@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index d79f6d091e3ef..581a1d10a1b58 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -2885,6 +2885,7 @@ static void lm90_alert(struct i2c_client *client, enum i2c_alert_protocol type,
 		 */
 		struct lm90_data *data = i2c_get_clientdata(client);
 
+		mutex_lock(&data->update_lock);
 		if (!data->shutdown && (data->flags & LM90_HAVE_BROKEN_ALERT) &&
 		    (data->current_alarms & data->alert_alarms)) {
 			if (!(data->config & 0x80)) {
@@ -2894,6 +2895,7 @@ static void lm90_alert(struct i2c_client *client, enum i2c_alert_protocol type,
 			schedule_delayed_work(&data->alert_work,
 				max_t(int, HZ, msecs_to_jiffies(data->update_interval)));
 		}
+		mutex_unlock(&data->update_lock);
 	} else {
 		dev_dbg(&client->dev, "Everything OK\n");
 	}
-- 
2.53.0



