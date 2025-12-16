Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D063451DB;
	Tue, 16 Dec 2025 11:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886275; cv=none; b=IDbeTYyMbcP7INSbamkA3w748neQOtgdoKBorejq5gRBsTsQ7xT8GUVCI3C/QnCsjDujxCFj3ar8kPc8sCV6K/YO7gne2r6tlzYHIq8wCPPsa+yq7UvaKe0w2wLQ18rdAxmhpcxEa/zXXCgeHrPuGlrV+MzHIUOTEzvQTi3c52g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886275; c=relaxed/simple;
	bh=pgQYHb19+GlOsnm6pkfnFiOrMzSn+GCKvIkTx6LdfN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=grhRfVhr6RLoLMCPYNcByJ7M5/EqXGSfPOhC1KmIzJI2zZokegn7Q7qqWaNWwpS8x5c31tBX+EVkr5q88q8M3D/ARy9z8DaJ3xfPrYWpJ3yNYaDu6EOosqB8ju13xqFOKDU6QT6kUXEQqGFVmgDi4MsmeRqhuMUBMoUr1Wzlvlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ChmDTulN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ChmDTulN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13EDAC4CEF1;
	Tue, 16 Dec 2025 11:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886275;
	bh=pgQYHb19+GlOsnm6pkfnFiOrMzSn+GCKvIkTx6LdfN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ChmDTulNLm+UEzZgjF0rnaJXQjw9c9k6txDyzT2xwE5x+OhUgzcYnjyG8+FtYwYuX
	 V7zwAgQXHmgvHLmLwsnjb2VuSFHjViPnneSL7qSHHGtvJFX0MepMnA/z3VbUBoz5CC
	 UhWK7RlmswX9q/r5cLUjBndWNayp21Czq9/i55r8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 356/507] clocksource/drivers/ralink: Fix resource leaks in init error path
Date: Tue, 16 Dec 2025 12:13:17 +0100
Message-ID: <20251216111358.354220705@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 2ba8e2aae1324704565a7d4d66f199d056c9e3c6 ]

The ralink_systick_init() function does not release all acquired resources
on its error paths. If irq_of_parse_and_map() or a subsequent call fails,
the previously created I/O memory mapping and IRQ mapping are leaked.

Add goto-based error handling labels to ensure that all allocated
resources are correctly freed.

Fixes: 1f2acc5a8a0a ("MIPS: ralink: Add support for systick timer found on newer ralink SoC")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://patch.msgid.link/20251030090710.1603-1-vulab@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-ralink.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/timer-ralink.c b/drivers/clocksource/timer-ralink.c
index 6ecdb4228f763..68434d9ed9107 100644
--- a/drivers/clocksource/timer-ralink.c
+++ b/drivers/clocksource/timer-ralink.c
@@ -130,14 +130,15 @@ static int __init ralink_systick_init(struct device_node *np)
 	systick.dev.irq = irq_of_parse_and_map(np, 0);
 	if (!systick.dev.irq) {
 		pr_err("%pOFn: request_irq failed", np);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_iounmap;
 	}
 
 	ret = clocksource_mmio_init(systick.membase + SYSTICK_COUNT, np->name,
 				    SYSTICK_FREQ, 301, 16,
 				    clocksource_mmio_readl_up);
 	if (ret)
-		return ret;
+		goto err_free_irq;
 
 	clockevents_register_device(&systick.dev);
 
@@ -145,6 +146,12 @@ static int __init ralink_systick_init(struct device_node *np)
 			np, systick.dev.mult, systick.dev.shift);
 
 	return 0;
+
+err_free_irq:
+	irq_dispose_mapping(systick.dev.irq);
+err_iounmap:
+	iounmap(systick.membase);
+	return ret;
 }
 
 TIMER_OF_DECLARE(systick, "ralink,cevt-systick", ralink_systick_init);
-- 
2.51.0



