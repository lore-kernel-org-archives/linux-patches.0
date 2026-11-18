Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041322;
	b=h+hIkeXcQoy9dWI9YxXk/YVisIFVoR8qEn9YRxpVEmfCywmgKyDOZnou4ocjQwryLfrE
	 1kSoJR8z3g8vFzmhuBxM+AOsB4Fr4eqb78bck1z1NnW7UQMk4cQIR1KW1bLYdn2XpSQte
	 O7LCt0VXcmqK3dfrlifEY/B1zJTBpefziJhmU7PUpMK4Zu94g0GU9LGY3/MdsU16oOSsh
	 /o1gtq3PU8M1sumo9XSBHYkyJdwNulNs1C5rriukR3z7NMgT7c2jCq4WJj49R2IaTM2Qt
	 VLu356kihB2VwJ+r/EUqxEPswTxaV3CsEaNUb1yg2+eqv0gNPqJ+7c7cwUtpjdhmNUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041322;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5Z/lryu8xrPPP2pKdUROFMWY1A3WVu7NqDZgzR0u5Z4=;
	b=Idr5k+OiAyej6sRzUoF5oBOEsldlA16FXv7XruvG1Hl05pjteCoZG2axe7a2rSR38tWl
	 Fm5uv/1hAtiHL6Si2DPu2MVJqg2PTTrIWU/mNceOeJUqJYAvJyrEYli3yTu+Qv9uO3++O
	 ByKG7h5DIAgQoSdhenYydKggA/b2yXVMkcERQwje245FqzmN5VeSAm4kcgaM4Gqr4Wwum
	 qXVFoKW2Km5BlfPQJxT0iAQC/KMpCxZXx86fVFkprMiyYDDv88ZZHii75CrofqgCsRLzC
	 qudj2ry8LjZyUxKVg/KXpdyX1rjeBt0V5G/yiSvzk4WJdfIvr1vvRmbB6AABuJrCDYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="FB4hlH/G";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A127606A325;
	Wed, 18 Nov 2026 22:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FB4hlH/G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B54D1F000C4;
	Wed, 18 Nov 2026 22:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041322;
	bh=5Z/lryu8xrPPP2pKdUROFMWY1A3WVu7NqDZgzR0u5Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FB4hlH/GnU8HPqdoT3MPH2ttEwVYxKkPScl4cRGHd/Ue79CUb3wlJlNhUjhP3MDCa
	 75ARStk6E2+f+8ZEThiFl4PhztLz8srqh6OEdeZxWqOhIG6GHQTsBCOlUdiKbPEt8q
	 tRO6i0Jknrse5qus1Lmn8bNpIJzkpJ66u4EAprFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Leonardo Scorcia <l.scorcia@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2773/3318] clocksource/drivers/timer-mediatek: Fix random crash at boot
Date: Wed, 18 Nov 2026 15:56:35 +0100
Message-ID: <20261118150443.900103996@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7bcb4a3f26fb0..e20075b09fab0 100644
--- a/drivers/clocksource/timer-mediatek.c
+++ b/drivers/clocksource/timer-mediatek.c
@@ -277,7 +277,7 @@ static struct timer_of to = {
 	},
 
 	.of_irq = {
-		.flags = IRQF_TIMER | IRQF_IRQPOLL,
+		.flags = IRQF_TIMER | IRQF_IRQPOLL | IRQF_NO_AUTOEN,
 	},
 };
 
@@ -298,6 +298,7 @@ static int __init mtk_syst_init(struct device_node *node)
 
 	clockevents_config_and_register(&to.clkevt, timer_of_rate(&to),
 					TIMER_SYNC_TICKS, 0xffffffff);
+	enable_irq(timer_of_irq(&to));
 
 	return 0;
 }
@@ -334,6 +335,7 @@ static int __init mtk_gpt_init(struct device_node *node)
 					TIMER_SYNC_TICKS, 0xffffffff);
 
 	mtk_gpt_enable_irq(&to, TIMER_CLK_EVT);
+	enable_irq(timer_of_irq(&to));
 
 	return 0;
 }
-- 
2.53.0



