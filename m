Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A2E5A79B;
	Thu, 16 Jul 2026 14:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210976; cv=none; b=d7/nijW5WneTHbKZjgaIM2VwkeQQem7iDzHk00OGb+Su9y6/HuKldrHLHvTr0VPJBXifATrWU2pEKqUPtbsClhg52gak8LPYk0GFboH6T/apHopjQXaLkjeYCUWfcUpSa2QCA/TyHj6Bdw8X1C0izIS7SP26N1iykQJRvuxjXL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210976; c=relaxed/simple;
	bh=8gbCArPnJIh9CdqhbIB8hEKy+zaPcHyvmSHFMqQQsY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQATeL8B44zAjE8A632tIgWstA9vrZnETjfkzytJoS3moJxUIBU1CQ6M8QfMImNwQYUDCdKj3RogvbyvJOWx1Y5TXP1VdOX1D2psGu9nZ8xhKUxwILpsOU7WBwt6JLRk4wC6N+UiTL0FnnHOMUytJ+seRitQMHuaq8lWJu7jwC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cwz7GT7g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cwz7GT7g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164241F000E9;
	Thu, 16 Jul 2026 14:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210975;
	bh=4P7m7FwoX9BMugbSbN27plj+lrXs6qwsNtr1Ctb53zQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cwz7GT7gOFWo33V10MbRwABzdaAtzw2UtJ2QX6OYfw+tNmgRiFM8jnOJgS0loXpZZ
	 DHcISSLy1Tb8Xyc1vDSJ0GkmW2ah18WtJkTjk6AG05DRUuTWUIr4OjldZ9iYAUXN7V
	 v4Ctn4V8evm8KYXbZNMlZDCAw3o1Ax1UZAJa0oVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kartik Rajput <kkartik@nvidia.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 6.18 252/480] clocksource/drivers/timer-tegra186: Fix support for multiple watchdog instances
Date: Thu, 16 Jul 2026 15:29:59 +0200
Message-ID: <20260716133050.267355787@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Kartik Rajput <kkartik@nvidia.com>

commit ca57bf46e7a94f8c53d05c376df9fcfdcb482100 upstream.

Tegra SoCs support multiple watchdogs; currently only one (WDT0) is
used. When multiple watchdogs are registered, tegra186_wdt_enable()
overwrites the TKEIE(x) register, discarding any existing watchdog
interrupt enable bits. As a result, enabling one watchdog inadvertently
disables interrupts for the others.

Fix this by preserving the existing TKEIE(x) value and updating it
using a read-modify-write sequence.

Fixes: 42cee19a9f83 ("clocksource: Add Tegra186 timers support")
Cc: stable@vger.kernel.org
Signed-off-by: Kartik Rajput <kkartik@nvidia.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://patch.msgid.link/20260507154557.2082697-2-kkartik@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clocksource/timer-tegra186.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/clocksource/timer-tegra186.c
+++ b/drivers/clocksource/timer-tegra186.c
@@ -149,7 +149,8 @@ static void tegra186_wdt_enable(struct t
 	u32 value;
 
 	/* unmask hardware IRQ, this may have been lost across powergate */
-	value = TKEIE_WDT_MASK(wdt->index, 1);
+	value = readl(tegra->regs + TKEIE(wdt->tmr->hwirq));
+	value |= TKEIE_WDT_MASK(wdt->index, 1);
 	writel(value, tegra->regs + TKEIE(wdt->tmr->hwirq));
 
 	/* clear interrupt */


