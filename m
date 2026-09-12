Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329EB455626;
	Sat, 12 Sep 2026 15:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227440; cv=none; b=ps4XfMUbqPwQ0kwailLd4OhxrTVej2IleUEE1dERjg/49gMyZIeEQKsx2hajrotLJLvsuer+n9N7hifV0Rm2uiDDcdBsWj24GgL/JtJsTgjYp84ddnG/6nBQG3V0y0T2HSTzdwXZ1/URPRxhHZbBxWcXoLKCK139Uwp1MTbpRTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227440; c=relaxed/simple;
	bh=r9pFpyHrQ7f96ScFy9CCaSZSQkaYfmSR0QwDoEUSf+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tXPouWWYSSVPPu0qqSYsAoriH0zi6Ll7THeg8egxRavQEN32g6IxEzJUqzVbE/zwNyK7BKblwGi9F1BP7ZMlouKQFgyd6XFe80dt60dC0VDf72cxlOb969sspeUsY1XkzFlFFz5FaFSmdf6vKdyS+Q6+F95RCnrPc2jSPxxy1wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ybtsb3Rp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ybtsb3Rp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DEE1F000FF;
	Sat, 12 Sep 2026 15:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227439;
	bh=IaIdUdzNa2ofnfKb4mDLAbbHNj4rWpnkvgO8FDZqN20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ybtsb3RpCJqHmqbBzgJt2V/mF14826pYhAIh9YHUoc1Xa0FdqzBw8d9KjPZB7fUAH
	 +i6+6Qv2XbAyi5xIv+umTEBnUUC+tqbRQrrfwzjPh4Yfpwhs+gUO2CqeEXilkLJOPv
	 dW8aQKnMX4yCOsS0pXBUkD+4/JXLCszVz8f/jk24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.1 0180/1191] power: supply: ucs1002: fix use-after-free on remove
Date: Sat, 12 Sep 2026 08:48:28 +0200
Message-ID: <20260912065552.259648632@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


