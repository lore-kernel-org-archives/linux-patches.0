Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BBD434E3B;
	Tue, 21 Jul 2026 20:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665189; cv=none; b=oB5HbeSzQ2M6clo2BD0G0CrXtsIJtNj4jh7X8/lCSZkx/b+k9ozcheynaCaJKqHSodXD0ZejcAJoNzhhIRBDoE2oOyWymbHpZCmGErMtmHik9rX9Amg8/FGuN+u61gjMNr3yN1Pz8nHlCwYtnBgTV9YToQMf4OPOFB8JeHST1hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665189; c=relaxed/simple;
	bh=o+qLXjGmK/6LzjJglOEsxagyq5CjNlFffsLQ8PMRDPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVwiVMKTXlTuOd53BiO3eohWL6oLreUIyIPYLRQgzkVyemHFrhl4hIbxzomJwfl2Iennv48cofT9jHgzkbcMKWdZYL2Uskm1QnKt4oxnUTReOUN1si1NrsoJffWW3Z2UwyaKnCWXetv8brDaQ0vI0+PW39z8nI/CPbZcXX9Lw+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZBwpfLNF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZBwpfLNF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59351F000E9;
	Tue, 21 Jul 2026 20:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665188;
	bh=HwMRgA5gJHe2WaF0WvBlnlRLW69xS+hkH0zwyMFMDY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZBwpfLNFpRkwn8cZjSN6A9fqL/GQ6JOCd1sVVQeRnQV3NGCNnRAg+q+2/pY84FkHN
	 F1OgRFQLDkkBO3UdTCga8ifjKKXcwo1cUTbD/X09/9kcJ8vRadW8tvGQvowSlL/qEM
	 /uFhP4GnMZK1V/mgIdmyE0D3ZTPR/cYrUI8L35Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kartik Rajput <kkartik@nvidia.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 6.6 0209/1266] clocksource/drivers/timer-tegra186: Fix support for multiple watchdog instances
Date: Tue, 21 Jul 2026 17:10:46 +0200
Message-ID: <20260721152446.490359484@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


