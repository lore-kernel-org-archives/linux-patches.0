Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B2E492E5C;
	Wed, 23 Sep 2026 14:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175207; cv=none; b=JBDJEccFjKm0wBcRp4+u/4BlaqeiAKNxzXNpi2IAkIj32BD19n2KPewqMqEs45EROvceHBZoqs+expSTq2XxWrjvWxV7G5RX3v/YIsg+E2Wrb6pjmbYQtmXU+eswYoBfLtzx3uKyxkqMqdje0uwVwGKk0oKDCbs1G+79enBhnNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175207; c=relaxed/simple;
	bh=ImP73V65SZhKOJbhCaLcOJ50la53WdDwPXvrhZuZm3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJvsM+qVptJeWe3vrfw4JdstSQdNGjOWhOWfExNe7Fx3Qk8u5WaopS6EM6TFYFJI2PPnklicZKCMF1q0C+2mJh+jxXZ8oK3Lj3PwcA9ovj7HaohFcwtTsnMMv+gKi4PxNYYyA9PZNgGCqGPdBQgod28DzC4pm/gUy8Ab2YrMTsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rsJj1Rb+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rsJj1Rb+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B001F000FF;
	Wed, 23 Sep 2026 14:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175206;
	bh=4G6hb9bzFoSQyVgOp87Q+wV8Qfl6MbY/sDJ1buZlyrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rsJj1Rb+icNLR6RP0FwcHFzAelp8fYzAZqRTwZqzxrWnU1bEvzjEgj3qwr2lna2hT
	 rDTSFilyN5n3rq9yS62h2bdjtH2YJ95FJsdKdJTMpHKa/5Px0DcVa3eaHHToBlX8A3
	 787F2qAfJp7jWEJ49FRnuLn85Ib0KsIrlJNhEmWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 319/398] watchdog: rtd119x: Avoid division by zero
Date: Wed, 23 Sep 2026 16:06:33 +0200
Message-ID: <20260923140651.689569969@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Tzung-Bi Shih <tzungbi@kernel.org>

commit 5af7d2cbd20f893def03c8310a460ade66a5d822 upstream.

clk_get_rate() could return 0.  Avoid a division by zero panic.

Fixes: 2bdf6acbfead ("watchdog: Add Realtek RTD1295")
Cc: stable@vger.kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://patch.msgid.link/20260913064851.8239-3-tzungbi@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/rtd119x_wdt.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/watchdog/rtd119x_wdt.c
+++ b/drivers/watchdog/rtd119x_wdt.c
@@ -98,6 +98,7 @@ static int rtd119x_wdt_probe(struct plat
 {
 	struct device *dev = &pdev->dev;
 	struct rtd119x_watchdog_device *data;
+	unsigned long rate;
 
 	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
@@ -111,10 +112,14 @@ static int rtd119x_wdt_probe(struct plat
 	if (IS_ERR(data->clk))
 		return PTR_ERR(data->clk);
 
+	rate = clk_get_rate(data->clk);
+	if (!rate)
+		return -EINVAL;
+
 	data->wdt_dev.info = &rtd119x_wdt_info;
 	data->wdt_dev.ops = &rtd119x_wdt_ops;
 	data->wdt_dev.timeout = 120;
-	data->wdt_dev.max_timeout = 0xffffffff / clk_get_rate(data->clk);
+	data->wdt_dev.max_timeout = 0xffffffff / rate;
 	data->wdt_dev.min_timeout = 1;
 	data->wdt_dev.parent = dev;
 


