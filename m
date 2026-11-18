Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036367;
	b=jCsCLpozKa1M5i3cK0MBNkJCYVXDTSVGSFb7OJrk8zeH6r9WeYYHRj8VtiFn0eGXOjj2
	 gY0R9HcNBFNZ8I9nNCJUCN3M430nNqvIx13aa6UbY6gk1zSuJJW7h58UTQOqyItwoMXZN
	 McyfG6Jcu6xbQD2qJg7JVOeCNNKpSqaUX8hTQfL2wewvbdF+96TC5zmVuk10+nVspKoPO
	 o/BhSx8A3K290Vh6JSKwMI/sJGAXVdaPnmuTN3CfrOJtF44yg622NjD2ZcGHzwFeXQvZ6
	 bpMhXc9T5NTNwncWnXdjjdM+FRTd/s8OFG+DW+mXNW9xu8t5oB/MnbjWp4QoYeSOyrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=btVXrHCPJsjMr3fRpdzZce0p0WEQGpd3HXe/bIm1dh0=;
	b=5GgyXqoZl57KD4gC/aejtYkHkUCTPVHKTE51Fz02ZUBL4zgdryldBp/wmK/IIHdP2fBJ
	 2gC5JI3ZoCEewQ9jbhdTntY9mbI6MDeuNIjnQ/rKx8U89P6mR47Vasx4z7EPFRF2qXw6l
	 EKwe6rf25MPoP95k6PfxC1UIavp/gay6DHb3azkGJ3+0cIeWqWWVAvmkhLcdmaqSzY6F7
	 sC3Dbp+agp+cf9LYmuEusQSlXBQjpdb8sXqadu4Z+z29t8N0uFgdY5z0dIx5r7Bg6MAXl
	 QaUcGyDJVtTFntYYf7d4zHCcaS3Oij2CIpZ1tWV05LgKnAfADVCSBlAxTfEowjwX/4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0WC8Y7Il;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C31C606A320;
	Wed, 18 Nov 2026 21:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0WC8Y7Il
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF971F000C4;
	Wed, 18 Nov 2026 21:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036367;
	bh=btVXrHCPJsjMr3fRpdzZce0p0WEQGpd3HXe/bIm1dh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0WC8Y7Il5mFnUOMwfS+11gzvU2pr3LoTKeBhYXdl9Wo2u2jNfA0QMMz3sUtq9q1tA
	 /QGzLQZyqQiroxXp/Fi12DGuKOJzePry8PVuuJDNJhMt/vw/bck3vGpeiMPiqjEWT2
	 jpOkkqwyEnaNCkm+rL7XR3EmnoAVhKnArjYFaOVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Baruch Siach <baruch@tkos.co.il>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1034/3318] clocksource/drivers/digicolor: Fix clk reference leak on request_irq failure
Date: Wed, 18 Nov 2026 15:27:36 +0100
Message-ID: <20261118150350.919935232@linuxfoundation.org>
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



