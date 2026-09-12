Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B783624BC;
	Sat, 12 Sep 2026 08:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203537; cv=none; b=WNbK6yCRNUxEIGPzblInz7h//xZKCyCd9Fvlk0BbfFFd/kJK4y+bHIYoBeB4qaS2Ehji0X+0NUkb0vd4+hy6yXVf2VBzkLkABEx4UiQfhQ5M8f+804siO0MFQx5Mwl19IppUcj3BN9Toh6UcfQqU8hXZ+2xY9R58gXsgUt07k5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203537; c=relaxed/simple;
	bh=YYBOb8DcSeojYBQYmL3DT0EhQ17fBHLrpdo81WxM9e8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/ZP/Jm8Z+tpN9IaknuWPzVcbsrjHfqEc1uzHpWnyWgDDVIgMc1aKoiK3IMmYKE1OQ/OX7qH/vDzb/2nYvMJBaMiTsySGeaNfzagXATx8X4dnx8aSDqcyzC5p84XBHbQAI2Zp7Bcj1cqdOX7QuMvBn+HVeDvUbLqHA/3fivB620=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eQOPj/WD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eQOPj/WD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8831F000FF;
	Sat, 12 Sep 2026 08:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203535;
	bh=eMAh+sb4s+xazmrUnAwVzBPdDxbvbeU9KB8qLkOBDgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eQOPj/WDTVZtDs0WfKcl9qD5ibkgSuEP2ERGEce2muynQidakdU7TMa94ZuDbchJx
	 +/OVw4KQZ49tFI+WZslA0EQulGwz/ar9/vaWQKmYd49splKMc9ithY79s26FDm2Kpx
	 vuiC+I305+XhsfI93nimdQSbo/W62zozkxtZO/+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1429/1815] clocksource/drivers/clps711x: Do not unmap clocksource MMIO
Date: Sat, 12 Sep 2026 08:52:59 +0200
Message-ID: <20260912065722.565614455@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit e998c6300ef4e062a704ee17b5a812c0b595cf42 ]

clps711x_clksrc_init() stores the timer base address in the static tcd
pointer and registers it as both the clocksource MMIO address and the
sched_clock read address.

The clocksource init path must therefore keep the mapping alive after
clps711x_timer_init() returns. However, the shared unmap_io exit path is
also reached after successful clocksource registration, so the MMIO
mapping is torn down while the clocksource and sched_clock readers may
still access it.

Return directly after successful clocksource registration and leave the
mapping alive for the registered readers. Keep the unmap_io path for the
error paths and for the clockevent init path.

Fixes: cd32e596f02f ("clocksource/drivers/clps711x: Fix resource leaks in error paths")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/20260704175451.256364-1-lgs201920130244@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/clps711x-timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/clps711x-timer.c b/drivers/clocksource/clps711x-timer.c
index bb0a44adaf28a..63ae3a691b148 100644
--- a/drivers/clocksource/clps711x-timer.c
+++ b/drivers/clocksource/clps711x-timer.c
@@ -94,7 +94,7 @@ static int __init clps711x_timer_init(struct device_node *np)
 	switch (of_alias_get_id(np, "timer")) {
 	case CLPS711X_CLKSRC_CLOCKSOURCE:
 		clps711x_clksrc_init(clock, base);
-		break;
+		return 0;
 	case CLPS711X_CLKSRC_CLOCKEVENT:
 		ret =  _clps711x_clkevt_init(clock, base, irq);
 		break;
-- 
2.53.0



