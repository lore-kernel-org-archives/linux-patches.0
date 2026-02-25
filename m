Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19941EB5E1;
	Wed, 25 Feb 2026 01:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982911; cv=none; b=P9Z9jk6gpU9iwR1PgxrZVvLwrCLdxldcf8sp5qvbHwMhw5IJFXQWinFWaRCMSnY8+klp5GXYXP5JyzaBuad7c/T646axXbco9TmU1P3BRzck2eOeHOXEckQsT/lqkK72iKSLgOi/ygNO58Iq1vwPYOCCxrzKPJxq2QLQKGOBWiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982911; c=relaxed/simple;
	bh=/tnjhTptpjw8ugyqMvjUbfXivJlt2x3rwbfhgo7cNRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHaLjV8Ij6wcQAt1kCTiUA1n+dXWcv/ZNx7gxwcJ1CkhrYFjQtghXRSlzy+qIPxB5kxqeU/rRTm6c8A6fb41sBiRJ7vLWa3GzzmPPzWGM4hjWfQ4urdRiG2dg5GTGQUEyxblBCEvqXXUhDRFZf5ftyDBqcDt2Wu/M+gOptsukoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y5fHbGjq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y5fHbGjq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4C5C116D0;
	Wed, 25 Feb 2026 01:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982911;
	bh=/tnjhTptpjw8ugyqMvjUbfXivJlt2x3rwbfhgo7cNRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y5fHbGjqeL+drEDB3F8UL5IYVpcpak7ShQVltPZwi3VSgvpKOcjPkIyiNdnxiur5J
	 Et2wcjaf/WEu1DbS5wCPNVnTqHy7+PiqjSXFgEXqeB/psKblG5u3/g/Repp7jID1jm
	 0jud5Xi/ggjZsWAy/r0Am3YJjr32MILG+VHSEZYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Stephen Eta Zhou <stephen.eta.zhou@gmail.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 093/781] clocksource/drivers/timer-sp804: Fix an Oops when read_current_timer is called on ARM32 platforms where the SP804 is not registered as the sched_clock.
Date: Tue, 24 Feb 2026 17:13:22 -0800
Message-ID: <20260225012401.972609551@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Eta Zhou <stephen.eta.zhou@gmail.com>

[ Upstream commit 694921a93f3e3621e067afc545cedf6fe3b234a9 ]

On SP804, the delay timer shares the same clkevt instance with
sched_clock. On some platforms, when
sp804_clocksource_and_sched_clock_init is called with use_sched_clock
not set to 1, sched_clkevt is not properly initialized. However,
sp804_register_delay_timer is invoked unconditionally, and
read_current_timer() subsequently calls sp804_read on an uninitialized
sched_clkevt, leading to a kernel Oops when accessing
sched_clkevt->value.

Declare a dedicated clkevt instance exclusively for delay timer,
instead of sharing the same clkevt with sched_clock.  This ensures
that read_current_timer continues to work correctly regardless of
whether SP804 is selected as the sched_clock.

Fixes: 640594a04f11 ("clocksource/drivers/timer-sp804: Fix read_current_timer() issue when clock source is not registered")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512250520.APOMkYRQ-lkp@intel.com/
Signed-off-by: Stephen Eta Zhou <stephen.eta.zhou@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://patch.msgid.link/20251225-fix_timersp804-v2-1-a366d7157f58@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-sp804.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/clocksource/timer-sp804.c b/drivers/clocksource/timer-sp804.c
index e82a95ea47247..d698584273596 100644
--- a/drivers/clocksource/timer-sp804.c
+++ b/drivers/clocksource/timer-sp804.c
@@ -106,21 +106,25 @@ static u64 notrace sp804_read(void)
 	return ~readl_relaxed(sched_clkevt->value);
 }
 
+/* Register delay timer backed by the hardware counter */
 #ifdef CONFIG_ARM
 static struct delay_timer delay;
+static struct sp804_clkevt *delay_clkevt;
+
 static unsigned long sp804_read_delay_timer_read(void)
 {
-	return sp804_read();
+	return ~readl_relaxed(delay_clkevt->value);
 }
 
-static void sp804_register_delay_timer(int freq)
+static void sp804_register_delay_timer(struct sp804_clkevt *clk, int freq)
 {
+	delay_clkevt = clk;
 	delay.freq = freq;
 	delay.read_current_timer = sp804_read_delay_timer_read;
 	register_current_timer_delay(&delay);
 }
 #else
-static inline void sp804_register_delay_timer(int freq) {}
+static inline void sp804_register_delay_timer(struct sp804_clkevt *clk, int freq) {}
 #endif
 
 static int __init sp804_clocksource_and_sched_clock_init(void __iomem *base,
@@ -135,8 +139,6 @@ static int __init sp804_clocksource_and_sched_clock_init(void __iomem *base,
 	if (rate < 0)
 		return -EINVAL;
 
-	sp804_register_delay_timer(rate);
-
 	clkevt = sp804_clkevt_get(base);
 
 	writel(0, clkevt->ctrl);
@@ -152,6 +154,8 @@ static int __init sp804_clocksource_and_sched_clock_init(void __iomem *base,
 	clocksource_mmio_init(clkevt->value, name,
 		rate, 200, 32, clocksource_mmio_readl_down);
 
+	sp804_register_delay_timer(clkevt, rate);
+
 	if (use_sched_clock) {
 		sched_clkevt = clkevt;
 		sched_clock_register(sp804_read, 32, rate);
-- 
2.51.0



