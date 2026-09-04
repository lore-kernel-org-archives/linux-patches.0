Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01DF40B383;
	Fri,  4 Sep 2026 05:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501352; cv=none; b=iy9LE4KFcoLjrhaWVT5nfoYIXrktSJAQBWa2Nz8lY3QhqJimBiruvcrrtIhFbgpN2jaE7+WTL3j1ao/WJ5AjGT22mIgcl4/928RuiCN3QBhdr7GDvz0S9QqgEegEPFbhyczhJ2Q+XL7GnGIbGKcPmj8cBDvCDW/RPDIXWpTCPxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501352; c=relaxed/simple;
	bh=1YxbD3YaSN6gIp2ZkAssg4wQ2z10jEfKWjK2/KYRle8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kBF/pG+noLjB0Z3+J8NFop1tjz0HeS5bDot7kenZMQWCrZpp3yMe0mJ1jFYvtmp4m2Cq+bMweauEuAh4XSINzCGDm8FbLKt4NkqVET9wzbT67WgOcTKSO/mKmZ4K0i8+Jtuoyg/NUw1L6KQCgRulMAVFX6deodbgK7/kgeNJYLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zo0QJNKi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zo0QJNKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05ACC1F00A3D;
	Fri,  4 Sep 2026 05:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501350;
	bh=/ElVy+3rVTbRcd7S5BuRd0XW3ekEiJM9NMbbxAihDlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zo0QJNKi42T7VifMw+2ckaWI6okC0GzsJ3MtWb+imLQfp8FmHBcVER6755LBm382h
	 sifK2JyptPuVdrn41PyShZGBAENnXffDvrsD90z7QLiG4wyuQRrjj6Gd0oB499eWsq
	 bqCkW2FW2sJk6oo8Qv5dDWH5uZZgRgoocw667kjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.18 378/552] power: supply: ucs1002: fix use-after-free on remove
Date: Fri,  4 Sep 2026 06:58:55 +0200
Message-ID: <20260904045758.788653702@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
@@ -641,7 +642,10 @@ static int ucs1002_probe(struct i2c_clie
 	}
 
 	info->health = POWER_SUPPLY_HEALTH_GOOD;
-	INIT_DELAYED_WORK(&info->health_poll, ucs1002_health_poll);
+	ret = devm_delayed_work_autocancel(dev, &info->health_poll,
+					   ucs1002_health_poll);
+	if (ret)
+		return ret;
 
 	if (irq_a_det > 0) {
 		ret = devm_request_threaded_irq(dev, irq_a_det, NULL,


