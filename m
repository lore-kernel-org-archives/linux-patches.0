Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AED8425877;
	Thu, 16 Jul 2026 13:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209650; cv=none; b=aZ6Sw8lmMC4W0oLHM3LLTwJkcCSqS/EctiRU2DaXuw/Mc6ICy6fjAfkA7RoLNyfW5teJoQcBXhj9efvczwMUUkiWsBTO1vcDs90aMTpc8XatCei3m2ZlrQVlXbegVMx5Brh1lgPk1GeyTm2cyqQWcNzOpuqsivajl1ysKmFJ2TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209650; c=relaxed/simple;
	bh=ov3kLOyx53QPb1DUXQ4Rqfe04DQWlPuyjgauSk90Kgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Un/2vWWW/OHvl2Z54+UMM8liQNNGqszlMIVwspxzMOdBJc1he6m3YsFcHOKkOWVa+q+YKUjtyWUGm2y+zgzSmnBWv1o9vjdMGgQbFZG2OztuK5NaVa3JDA1LnPvyPJKVxUCboSlFg3RvTF5TqowRsu+L45Uf0TcZuixkuKyhPhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9SfvokB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9SfvokB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C81C1F000E9;
	Thu, 16 Jul 2026 13:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209647;
	bh=5vXLZ2iWyYt88SWfmxm+9rv50Vq+6y+dDBwwf3WDSCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e9SfvokB9uX9X1BZPiWbQHWQBC0nvrQltn+wk/Gu3LXp18EMGtIwxrUZAGxhMiUcA
	 /73UChQkx349ZtAkFtAowFI+CwJ9Bh4Lp7WNW1qQmqRaVvXB8/Z7uMInzCLzgmUywo
	 kMZx/VHIRixTCAj87woNuWRBnRd97zUaUw8IlmHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kartik Rajput <kkartik@nvidia.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 7.1 258/518] clocksource/drivers/timer-tegra186: Fix support for multiple watchdog instances
Date: Thu, 16 Jul 2026 15:28:46 +0200
Message-ID: <20260716133053.464280583@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


