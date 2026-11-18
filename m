Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049563;
	b=4K2unRBM4st7LiOx/foB2nMR4yS5vI5mKT1nxo/nNbiuoROgyDLmNNXSEhdn8FITkJUQ
	 Ra26TiknEh64pJHLh8KrgRqNqkeA8Oz4QUdbIS2E0Cph0PPujhHlKamnYLzxSDjDGT/kZ
	 b/kSuUKbusa/79kLjzNhPpTmPVHrc7MrR+7q7mGHx60mCdxUPgG7PvwAQ6XDY3HOe3IiM
	 sGlDhYUgYRzC2bIym6PAKd7oYIFIFXJtojT1ow30vCc+y+/pCdShLzwHRB7gH4afzROv6
	 ttAPjUTamrzdEwvbWkXMpCfXw9pd2RZoeJf079Kjn2VSvqcSslcAkM96usuUy91/e5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049563;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zM/uGEDAEExYXiHVWaQR/lqbvLef97XpJPidMdFYeLk=;
	b=vIxTlhhvv01ptdnlM4Dq8gCwDBZ02BWEFnVkF/wdcRNSjrB4PY0zN1NZRZTPy5CBIvE4
	 l//YKkBw5jzt7Ap8VyO0VPIMqnbUR3y1aEkVei0CnUrljtrkgfqGfxkdbwf5WfXkmrHiW
	 dwNMkP+cwWkV58atn89p+YmVtxwe98D0DAlzyGLSmLbvGgwW+7befkn8sqe+6K/YDxJgV
	 4ro7ti+4v4ohsywLLZcKB6daPo78+yb883Pe/ZeE8pRnIGHq9N3ea4LfBqey4/qaDwWlw
	 UcQU8ERvkXQTX8jzuLlgtabNYaEJcjNcQlbYaLqV10G7Pn4KM/UtYlOwehIJOnHqCng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R9AOE8xH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AD1606A320;
	Thu, 19 Nov 2026 00:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R9AOE8xH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EADBA1F000C4;
	Thu, 19 Nov 2026 00:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049563;
	bh=zM/uGEDAEExYXiHVWaQR/lqbvLef97XpJPidMdFYeLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R9AOE8xHVA7LS87cbZ/ktSNjynkipiOJClIqPAjYit7oklW48qp1Jjvi5E4wNp/O2
	 i+FgZrOnI/dfpspkZ2ovJEk9YDlhX3ayQUl0DffVpOi88bo2P7t+AT5uJ6wmoY+E2T
	 MhP2h6dlWVBjG08rX+BAFTj0fQwP2JwF0CEG3Noo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Leonardo Scorcia <l.scorcia@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2395/2857] clocksource/drivers/timer-mediatek: Fix random crash at boot
Date: Wed, 18 Nov 2026 15:57:09 +0100
Message-ID: <20261118150327.756446073@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Luca Leonardo Scorcia <l.scorcia@gmail.com>

[ Upstream commit 8496a1d234e8cf9cb15c4282cb3a11c6550bd242 ]

MediaTek bootloaders generally enable APXGPT timers at boot. This means
that a timer IRQ can sometimes happen between the IRQ line request and the
configuration of the clock event handler. This leads to a hard crash with
an instruction abort, branch to pc 0x0 in mtk_gpt_interrupt handler as
clkevt is null.

To avoid this issue request the IRQ with IRQF_NO_AUTOEN and enable it
explicitly after the clock event is configured.

Issue was reported and fix tested on the Lenovo Tab E7 (TB-7104F, mt8167).

Fixes: a0858f937960 ("clocksource/drivers/timer-mediatek: Convert the driver to timer-of")
Signed-off-by: Luca Leonardo Scorcia <l.scorcia@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/20261002072115.169250-2-l.scorcia@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-mediatek.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-mediatek.c b/drivers/clocksource/timer-mediatek.c
index d5b29fd03ca2a..43c63c131b061 100644
--- a/drivers/clocksource/timer-mediatek.c
+++ b/drivers/clocksource/timer-mediatek.c
@@ -336,7 +336,7 @@ static struct timer_of to = {
 	},
 
 	.of_irq = {
-		.flags = IRQF_TIMER | IRQF_IRQPOLL,
+		.flags = IRQF_TIMER | IRQF_IRQPOLL | IRQF_NO_AUTOEN,
 	},
 };
 
@@ -411,6 +411,7 @@ static int __init mtk_syst_init(struct device_node *node)
 
 	clockevents_config_and_register(&to.clkevt, timer_of_rate(&to),
 					TIMER_SYNC_TICKS, 0xffffffff);
+	enable_irq(timer_of_irq(&to));
 
 	return 0;
 }
@@ -447,6 +448,7 @@ static int __init mtk_gpt_init(struct device_node *node)
 					TIMER_SYNC_TICKS, 0xffffffff);
 
 	mtk_gpt_enable_irq(&to, TIMER_CLK_EVT);
+	enable_irq(timer_of_irq(&to));
 
 	return 0;
 }
-- 
2.53.0



