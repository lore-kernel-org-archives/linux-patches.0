Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BBA2594BD;
	Sat, 12 Sep 2026 13:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218266; cv=none; b=tbDAfW3xu0pUUGV7rETPQsGeiKPr7JaffxSikY+Xw+ZQkC9glYvfSqcZbE7kF6fXwT0IXUqHWsT3pi8h5XexQVd089v+fRpem9aFYp0f0pwNP8jz2LTyxk4QZCJ761HDkaOyQ8YdslrMt0lkB8HlOj+7TdClKz84iuEIswy6aEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218266; c=relaxed/simple;
	bh=7Z7Lm3Y5A/ctzgYyXiZi8e6gVOUIKKss5TSctT5ABN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iD9CIM2mZ1qzcj4pmJrZkf8M2X4qX6es/Q7Pv/NErmH/TUFpNBAGwplQ+0Wtw+lNaVXNDi8ioGYCbSGMfyYCqdAzkWzLs7bzrq0RvjyweAfOnjFVxZHU0yS2iV0Ec0ug2ejArSVqxpAA552WsP3qPMexhhWTR28bh+4HZu80hJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7iDPsno; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7iDPsno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47411F000FF;
	Sat, 12 Sep 2026 13:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218264;
	bh=NPFt+hYodVC/NqqOzbcVW4Y+1wND6tHSP9t01pkThEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C7iDPsno6MkJ/wJ6cksNp++WdRq4dGKXjwWpl5IzrtEEh3TiJ6vPGDs90/LEqeBPI
	 5+IgZ8iO7Vekf4UeFrDbRApp+7ol7h6/txoDH0p5rZhuItHo7kyVtmruEvxw1GGIxB
	 8R4I3ou+ye6CnsjJttYol2Pdn+JIh/YIh+PGd3Eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1107/1376] clocksource/drivers/clps711x: Do not unmap clocksource MMIO
Date: Sat, 12 Sep 2026 08:58:53 +0200
Message-ID: <20260912065632.233605602@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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



