Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D939C3A6F09;
	Sat, 12 Sep 2026 19:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240399; cv=none; b=DP4EZ7DBXNm1ORunphwGsxZx3KawT1+oBGANPeCDiXn3zxu6pUTLZj3boesaw7AQ6G2bcyM+AlEUTgvLCYchm5Cb7aCXVHCO15SaaAq0E6ezzmpCkQxh0jtfcaqMuorjXS3a38LlaGqJSGl1dHOrhs7oNZK65yDaW8fMcQ9sAgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240399; c=relaxed/simple;
	bh=tw+CPSO34gkVrpLzyEV65Od2n8fwWAnfb9M8KkByCVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DoNV+7Pe/NLkLNFQu+hGHvlps/wxYNUlxFaQKISi/l19O8Hv+/MuBhtbgFhfwtQvKRpGBZBO6xmEFibdk+991wMe1ehqsv9qyjqTGSGEWNCWtV7Xse4sAp2an4ePf+oR4Bo2772+7i88rLs7gqlrCe4E+c4X68wZd/a0+THiGGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RfoOi58D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RfoOi58D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECA91F000FF;
	Sat, 12 Sep 2026 19:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240397;
	bh=KrX7Uz/z/lKFOZx+SqSnw26Na3plWDlJa6T8MzxsxmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RfoOi58DT3h4NjGImVurMBcjqfEG5jT90bSfzL3AoUDLbT4yqa7waOOz8n/9WycQc
	 AMnVNdis8Nkt+JuZJq2WizRIax2zuGV03edT+r4j9bu+FaLKhC9wKK3KdV2oSTnW8R
	 MNgcogpiuO7UKFJIDa8q2kv+sDI80as4KcjlYDak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 817/935] clocksource/drivers/clps711x: Do not unmap clocksource MMIO
Date: Sat, 12 Sep 2026 09:04:07 +0200
Message-ID: <20260912065545.570088987@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index bbceb0289d457..95f8a50ba1ebb 100644
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



