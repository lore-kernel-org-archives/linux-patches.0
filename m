Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973C9421EFB;
	Sat, 12 Sep 2026 13:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220628; cv=none; b=s+2b6r4AuEkeD4BC7yvbwGPmq5o3ltqVIG6F7wZLxMcfW5DQBAti5j7DiCaZOW2TXjxHue1ECqAps8h2qOQ3ujb9TeFpEpWFj29uywZc3r5ahJNTeql9v6UU2cVIbuDqDXUr2G2UXmXlZ/QxLKwqIurJkdHEbkCni86ZteeIXYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220628; c=relaxed/simple;
	bh=cx7jzL6Ce248tZJZJYziZlYbLV+leIn/Q50V13t4gZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/fsMere/vNF9LUxeVr18aHz94BktmeV3Qyu0tfFDIfW5mEenFwHXGTnK4VQ7nSpGWPgPYqZ0HP6+ijJM5VMW1/Acw+YhGLHbT/Y0WAOBJG2tqBYtTzOZK1UQKC1zp9ZjMH4hcqxf/WHpEF8pTxizMmMU4ZmCkWRnVCI5zdDhjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fwfCeRvv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fwfCeRvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517931F000FF;
	Sat, 12 Sep 2026 13:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220627;
	bh=SPABd1/wFLHm8L8X3AZD2DV7akuxoAYFaJhEkiaV7nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fwfCeRvvSligG9Z+owj8+tGqWYxgPdR4SMLHW3+2AXtASm9MyKlHwTZ+A+qYlJhX6
	 xB3ifqMXIA+LuXmW+V8l7VPQm+3bv8K/FNHLAjQst2GTeMHM8EEy7+fthT5q8Xwj9e
	 iSWyufap261tBg6iMG/P2JOz1ITNteRB2bWCzZuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianing Li <m13940358460@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.6 0217/1424] power: supply: max17040: synchronize work cancellation on suspend
Date: Sat, 12 Sep 2026 08:44:09 +0200
Message-ID: <20260912065612.146936041@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Jianing Li <m13940358460@163.com>

commit 86a3a8a926aa5969c329d1df2d3259f189961bbc upstream.

max17040_work() requeues itself after every poll. cancel_delayed_work()
only cancels a pending instance and does not wait for a callback that is
already running.

If system suspend races with the polling callback, the callback can
continue accessing the fuel gauge and requeue itself after the suspend
callback returns.

Use cancel_delayed_work_sync() to ensure polling is quiesced before
suspend completes.

Fixes: c6f4a42de60b ("Add MAX17040 Fuel Gauge driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jianing Li <m13940358460@163.com>
Link: https://patch.msgid.link/20260810004701.1683-1-m13940358460@163.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/max17040_battery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/power/supply/max17040_battery.c
+++ b/drivers/power/supply/max17040_battery.c
@@ -528,7 +528,7 @@ static int max17040_suspend(struct devic
 		// disable soc alert to prevent wakeup
 		max17040_set_soc_alert(chip, 0);
 	else
-		cancel_delayed_work(&chip->work);
+		cancel_delayed_work_sync(&chip->work);
 
 	if (client->irq && device_may_wakeup(dev))
 		enable_irq_wake(client->irq);


