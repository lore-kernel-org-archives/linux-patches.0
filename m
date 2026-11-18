Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045505;
	b=OI2BhZcuiErMfj/YncGSDbiZniF9NzS18NT580yWN8Q56OhHKvlseJq1k4EHcsL2pDY7
	 5jVRASxmNmTPTmQWjHf7FCDFlGyH5n5obtEgnrVVd1H0dPZcOe4wYo2F6Kqosy4nbySb5
	 FbpyBJknB4TyoAEAkh2bO4lX3btIcnMAiiPU4MDIwR/aIgQkCfkUWPwWyRgNcDLJJnmjP
	 sB9h3UFLjG4wqxdNLuVO9YrN8jONuzAgfRFGvRQACnEMxi79B6DivGHTmuFT4bzFzcKmO
	 SAnO1mvbZNQ/DWPs7y4z17Cg4sRFJKoIIm5A8EQJTh4SK95BS9QkRJ9LG7c6JprVBVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045505;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hESpy6B97kY9RwZ3mO67pVMl2NFN/oLwlbfeZGdKPYY=;
	b=p9cuvQYnsHtmb6YxoeLe1WB2BAwWGn8ETrFuQXODPZMKt2tO6eshK1wPFBmJpC/Q3ueb
	 PRa/ExD7dYzjrVc7HZg1URozn1zf/yi934IBj7MtqortIY8unPgr3dZCUydCszlf38PX9
	 lFlUQD+c981B6MNLGlwPPhKRl80Ju6SoKhnD6ibziC7hFop/4VdbC1dhLIsV4gP47B9rF
	 ldi0+ApOsI6+6itAhR1lLew8ya48qIJf/lTXFE/Igj6TAan1E17k423kruR6FswMkXg9B
	 Fbqfgeh447xeroizemX3f2aYceJTVFHcXtO0b+iaNuf0l6DYU5kaK6gtE+dGwlzHvww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hQAIrpvU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1C4606A325;
	Wed, 18 Nov 2026 23:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hQAIrpvU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182981F000C7;
	Wed, 18 Nov 2026 23:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045505;
	bh=hESpy6B97kY9RwZ3mO67pVMl2NFN/oLwlbfeZGdKPYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hQAIrpvUZ/ky9Dkbu081nezmCcjp2b2sHms98LO+pcg5t6bgeFrtFYC7zJwTp3dvt
	 uPJ1SMkXsvJcqgA3af8RhEJ0Fqsd5bqVot/pLjROU8Z45eKO18EFzzf9RRid2gLfJU
	 2WTKQbhtPe1Zt0km5UeJr3GxXmBmXwpjv8aI04OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Baruch Siach <baruch@tkos.co.il>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0898/2857] clocksource/drivers/digicolor: Fix clk reference leak on request_irq failure
Date: Wed, 18 Nov 2026 15:32:12 +0100
Message-ID: <20261118150233.895031545@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 9cc2e18b32f12d26ae6729c62a03640423956b17 ]

digicolor_timer_init() obtains the timer clock with of_clk_get() and
enables it, but the request_irq() failure path returns without releasing
the clock reference, leaking both the enable/prepare state and the
reference itself.

Disable and put the clock before returning on the request_irq() failure
path. The success path keeps the clock enabled for the lifetime of the
timer and is left untouched.

Fixes: 9b8bb7736b78 ("clocksource: Driver for Conexant Digicolor SoC timer")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Acked-by: Baruch Siach <baruch@tkos.co.il>
Link: https://patch.msgid.link/20260915045242.1726702-1-vulab@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-digicolor.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clocksource/timer-digicolor.c b/drivers/clocksource/timer-digicolor.c
index 559aa96089c34..46e0c329957a2 100644
--- a/drivers/clocksource/timer-digicolor.c
+++ b/drivers/clocksource/timer-digicolor.c
@@ -190,6 +190,8 @@ static int __init digicolor_timer_init(struct device_node *node)
 			  &dc_timer_dev.ce);
 	if (ret) {
 		pr_warn("request of timer irq %d failed (%d)\n", irq, ret);
+		clk_disable_unprepare(clk);
+		clk_put(clk);
 		return ret;
 	}
 
-- 
2.53.0



