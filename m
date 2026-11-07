Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064565;
	b=uzTvCUHcCc8rOvK4j9OXufo3fCBAucW4ynQRw599dxaRC7Z2WuRV5DjxfcENq5H8HKi3
	 63D91OQv3tsmDM49bYcHtwLeozYxEkpfeu4+GAHDyxaz7Kq9Ki99LMY/bCualui7PnMK6
	 o+k7Pn9s38PusopoOZfR61ScG74d00HAta7RFFR9b+KMN2aUye3K8vHQKKmvSEcMXrnPu
	 uBIZvxIPwFtJG83JgzaI9u/rU+z+k16FzFkibS0X9Php2k77KPvvfWw3dZep7byZV1PPb
	 +bDPEf5E4N7s9pY0oHwQ/tk0b1QDH+JO1V1Il2y8WE2RVr4WbKFdMxeTPa1W8R7Jz0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064565;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W7ya+RiKx8H32H3spq4ISrrvVQIUhdB9fgTJLAhzMFo=;
	b=dPTs1JhTxEO56w21hM+TtVh82RsR/TQDbOWiTDzqWXoas6K2u5IATDkr8P+7vIcvZK2j
	 yidd0PjSdHBtryvkemfXxcuRi3HoX0yiQAL9oLEM3I+bizQZOSqt67fJgJQp2aAmOvGqI
	 o7LCXUetoKJIdUmOlogLldegsLe2p+VLIQlHIALq7yHscTQ7pd9DlBliRXmEvZYb3dyJf
	 TzflnqgY3hT8MSHuRy1hu+X1EcrquekuyLkYq7HPco2v68kxSHIHtvr8hV376ec4P7GSJ
	 dZBh59ccc/tgJORYyT0msGeHuhjQjElyhwINi0aYv+g9YTq2jegaY1pMUzOgglpvFfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R74mFLRr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42071606A335;
	Sat,  7 Nov 2026 15:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R74mFLRr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31881F0089F;
	Sat,  7 Nov 2026 15:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064565;
	bh=W7ya+RiKx8H32H3spq4ISrrvVQIUhdB9fgTJLAhzMFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R74mFLRrpKuMqAZKv/IN7l9p68ScbXFh3IRsn6p9IJ2p1iJp/36LJVEAULtg5QYql
	 iQtAs5VXjE9Hynsn1RKoNPZJtu4T1NgqF2GctrUx91x9ji7PRQLRWZLfEhdOpNct24
	 QxRA4BbeQ0gf1RyomAHnWfAD45ZHHZlCtNuzmQe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Baruch Siach <baruch@tkos.co.il>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0548/1257] clocksource/drivers/digicolor: Fix clk reference leak on request_irq failure
Date: Sat,  7 Nov 2026 08:47:24 -0500
Message-ID: <20261107134954.529750443@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



