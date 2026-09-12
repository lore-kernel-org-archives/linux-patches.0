Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838923A2E12;
	Sat, 12 Sep 2026 20:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243408; cv=none; b=ob0QKlPTNSh/vsvMQiM3jF0gXWzy3xt0S3P0zZpDDud+PTYJQPcnp1KQQVnNXX861AdihX+Gg8G93PXhdlNYQ6cUOjZQOiYyZ+IuMX0Roy6Usn8On0kldEwQfJAFj+QnCyhGZ4/THTYbiEFT+/RZAd+TTeGSXS4f2xfCD52J8kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243408; c=relaxed/simple;
	bh=Qu4+inrZdIWmlASjmdN7Ci+k16ujF9/eF8Oa1XW9JE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKa7JK21oWsVBIPvRCj7twEfI76I/JRbL6fECaY7788IXBTA7g8oiRfLvcSs2+0MhvKP9oLC9rsMWF2ydokKtD/fE2BgjtQ+X+IvQHTg5xBp4X8DXWe4249rfQrEsKvm4g6fanUSKA3ZXYqsNYjn3r5KTK5ZpUJOOZXU6+klKYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ae1kNeQg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ae1kNeQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC421F000FF;
	Sat, 12 Sep 2026 20:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243407;
	bh=emLfpeUChfcv7Ka2HklpArgi2SpjIS7APEiPxqSlZHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ae1kNeQgbFB286YG6RDki/jv92pWqlktjR4Zu6IuqEtUe84JiDrlWsBjiPLMj/TdS
	 RAyO9mQ7ZvlxLuZqM7eeQ4gAxy1KVmCc7VTmFaKO+79qtX4tM5hPdci8Zj77apfQqZ
	 nUcXzXH85ApFAPseF8LRv8nYfohhe3+Fnl26XwiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 702/798] clocksource/drivers/clps711x: Do not unmap clocksource MMIO
Date: Sat, 12 Sep 2026 09:05:30 +0200
Message-ID: <20260912065533.182322056@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



