Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138914314B7;
	Thu, 16 Jul 2026 14:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212207; cv=none; b=ln2gYjet/afhgAqCKYxVtM8CiMk0W536JzbSlzIMPbUWkSOiBES0QwckHu+NcNDZz0txXoTcR29uD8tpc+zHrhupYukwaPIxeHw/UxD51SdHZT7b+8DXMmrQZToOJUrHgiROwaYPEj3xn8gxM5oWoXgUfCW+LeTMT7jcVcN4G/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212207; c=relaxed/simple;
	bh=Q8Wwu0zKIDje3RYUCTvuIgwrJQk3N+ZObF1x1gRjMxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NCyQquWlop4CSx7a539GLj+3RFo/E0+S6mxF+/S0+je48mONp+QlZEgNX6HHfKlU1fy7qSjqGen+CUm3WahOg6nPhLF937yuXkmH+7Rl+jrSoDD8tKA7FRzOTBQpcZ/xFk+hcN8wQRhao4DulqPdm4QnyPTTswpsVg/csvAlMJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6pHLyB0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6pHLyB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388FD1F000E9;
	Thu, 16 Jul 2026 14:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212205;
	bh=ev4W5UitjEpZ74kBe7T4Dd2Qj0r1asmRLBMtb+iF084=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j6pHLyB0Rwd940z1baOimrgAq3QGZ5YCAO1GOzZVzbHf5CUMWJf+bkCL07fdPkkvO
	 hHL3TSVy4lTduVa5c0J99XXRLUUjktV9ljB35RR3ixrpGed1Ahkj0o6AxObYxHpOWP
	 CWVqmdkqTCSBwltJ3v5zZvltD+dW0SnPOoexxppc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kartik Rajput <kkartik@nvidia.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 6.12 196/349] clocksource/drivers/timer-tegra186: Fix support for multiple watchdog instances
Date: Thu, 16 Jul 2026 15:32:10 +0200
Message-ID: <20260716133037.760832652@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -144,7 +144,8 @@ static void tegra186_wdt_enable(struct t
 	u32 value;
 
 	/* unmask hardware IRQ, this may have been lost across powergate */
-	value = TKEIE_WDT_MASK(wdt->index, 1);
+	value = readl(tegra->regs + TKEIE(wdt->tmr->hwirq));
+	value |= TKEIE_WDT_MASK(wdt->index, 1);
 	writel(value, tegra->regs + TKEIE(wdt->tmr->hwirq));
 
 	/* clear interrupt */


