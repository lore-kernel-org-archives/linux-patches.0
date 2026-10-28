Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208297;
	b=u/mSxJEspjDGovpA2DohQoFD5++6XYDFe1OJsTFxoy9vbuCcw7TlbPTaELOv8vqyEyir
	 USe+hxYWdnyCJFWULvVgKDIAlS9JnmfR6WBJ+yx4Y6DyWTSbYmmfxQY4fkolf+6QtIqob
	 8qu9XWCv2dXsEYdo8YdUBUrevA9aWBL8um31pwFk7NFb28Z83xHqzpCc0tHpYorDjBqzV
	 eA82xpOKmcLA8hnj4gPg8XNBVO8lmd0FCXmyzCzT32rH5+A/HlhfujW24QVVOmvRhqqUh
	 K+Fq/fy3UdLf/4U8R+JvATaVsEiXkQeUYvSfH2tQcWSRFyx22P9y/csbkG0ReRDP8Jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fEA2FgJ8Bu6yy/DNlumeXmk2kffZI1FBs6eW6WROZ5o=;
	b=NZTdQU/T+8DMAPpLFWMmCrfpQfIGQIJHOlj/dvZvxKplNQ1S1H6MyuGilL4yyJqhj9YF
	 NjQi7s6uuwCE6TUkD8RcNkafctUwTOtuhEXE+x+6tBs0hR7rMyg3Jbf4rJvD4uatfS1fy
	 FMuNZAiAEKnao/+Auc2sv+Z90TdtcGX0W2kNnM50IwIN7VTjAThX/CME3PNN4pal0aKGB
	 bcK/2pGTuq/CkQEPnNzkA7ObYq2IAi4RhF/1qxRAHyihYqBDrUzrXTzo7w6657UBXGB08
	 oWVjx5b1QmJzitKKOqfrGn2zyCC1DTijjsQtaJqsj/HC32gXllSnxz1lAKGhYJ/cslw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VkOC6kgr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC62606A32E;
	Wed, 28 Oct 2026 17:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VkOC6kgr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8771F031E1;
	Wed, 28 Oct 2026 17:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208297;
	bh=fEA2FgJ8Bu6yy/DNlumeXmk2kffZI1FBs6eW6WROZ5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VkOC6kgrubc1q9OMlqXVM2xrawCTRLFyFaI2WG9DCHi4AXHtUbsMMt2veKfugmMcU
	 4lQzrPB9rDY6XdGo9KGSmn6npRA8FVSEvkbYwO9alKbxgfZKUHMl0CcKY08XYlSiEm
	 quqhFA3uvQUdGxgVSLn0LLVNU9wCMiBX68KTvq9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/516] power: supply: ucs1002: fix use-after-free on remove
Date: Wed, 28 Oct 2026 17:53:42 +0100
Message-ID: <20261028170005.182611461@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit 609af0ceeaefdfa42cd01dd060b20f2e41f9a232 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ucs1002_power.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/ucs1002_power.c b/drivers/power/supply/ucs1002_power.c
index 332cb50d9fb4f..ee3c1e6888c24 100644
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
@@ -644,7 +645,10 @@ static int ucs1002_probe(struct i2c_client *client,
 	}
 
 	info->health = POWER_SUPPLY_HEALTH_GOOD;
-	INIT_DELAYED_WORK(&info->health_poll, ucs1002_health_poll);
+	ret = devm_delayed_work_autocancel(dev, &info->health_poll,
+					   ucs1002_health_poll);
+	if (ret)
+		return ret;
 
 	if (irq_a_det > 0) {
 		ret = devm_request_threaded_irq(dev, irq_a_det, NULL,
-- 
2.53.0



