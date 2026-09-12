Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A1A32D7F8;
	Sat, 12 Sep 2026 18:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789236937; cv=none; b=OX3AgIMAsUHtjKRU2agEXl9hQHYqbmSS7YwJVtOPBwcHvZidZ3f5Nj4AiXs4xjG40Zh8cNvU/3mTz2xz7OKeSO3palmhiE2wYVr/LQcoICFXButoa2c4PO8dHhYh6AnphBkMxroHyWZuYg7/wQ4/5i8GUEaEMdLROwu+u3uor6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789236937; c=relaxed/simple;
	bh=/hbkLuJStWQfouDjpozndphvOPaKsdsucfR93ybwuhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1rwJsIpJA/x4YNWt1hHKmvdfUzXJiU/mYhwN+tCPr3vIsG2RmUmECONCGFu3eWfEYzpuFbiV+FHjzmIRSAMXvSlAd3Jo85sqcpJ6v75Cs5oFKUVXzzrlSmFxWo5QE/XfUiie8fC+s3ZvyJUV1RxGYLAGCQlbwPSuX5q0QEbOmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PM6nKUxg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PM6nKUxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2EB1F000FF;
	Sat, 12 Sep 2026 18:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789236936;
	bh=gMLn2+llRF5+GhuXct5aPPM5l8l+pR0u2tGP4XdPDUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PM6nKUxgCDCl422sMyO6lDt+kKkWOFi/ervEygHgTDUxjyarDpROt+R87uPCJD1d4
	 4U/o/S363WMzRee9tOHzWik1VtXz49coz+K7ASLXSX4pS/Kr92t9wkYcxvjbQLIo20
	 +sD/CEOsYgzuj2V7KeNh9n9bXv9XK010eKEXyYRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.15 156/935] power: supply: ucs1002: fix use-after-free on remove
Date: Sat, 12 Sep 2026 08:53:06 +0200
Message-ID: <20260912065530.399753477@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 609af0ceeaefdfa42cd01dd060b20f2e41f9a232 upstream.

ucs1002 has no remove callback, so unbind runs entirely through devm.
The alert IRQ handler queues the health_poll delayed work, and the work
reschedules itself while the chip reports a bad-health condition.  devm
frees the alert IRQ, which only synchronizes the handler; it does not
cancel the delayed work, which can then run after devm frees the driver
data and dereference it.

Register health_poll with devm_delayed_work_autocancel() before the
alert IRQ is requested.  devm then frees the IRQ before cancelling the
work, so the handler can no longer queue it and the work is cancelled
before the driver data is freed.

This issue was found by an in-house static analysis tool.

Fixes: 81196e2e57fc ("power: supply: ucs1002: fix some health status issues")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Link: https://patch.msgid.link/20260802051249.424015-1-fanwu01@zju.edu.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/ucs1002_power.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/power/supply/ucs1002_power.c
+++ b/drivers/power/supply/ucs1002_power.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/kthread.h>
 #include <linux/device.h>
+#include <linux/devm-helpers.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
@@ -644,7 +645,10 @@ static int ucs1002_probe(struct i2c_clie
 	}
 
 	info->health = POWER_SUPPLY_HEALTH_GOOD;
-	INIT_DELAYED_WORK(&info->health_poll, ucs1002_health_poll);
+	ret = devm_delayed_work_autocancel(dev, &info->health_poll,
+					   ucs1002_health_poll);
+	if (ret)
+		return ret;
 
 	if (irq_a_det > 0) {
 		ret = devm_request_threaded_irq(dev, irq_a_det, NULL,


