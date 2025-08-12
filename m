Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5432FE571;
	Tue, 12 Aug 2025 17:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021600; cv=none; b=C82ieD5KDzLcOxHk3Vd4r9hOQT8bFJUi0bDys/9x79xEJ/Dm7qPcUM+K9DnNgAe85ZeP66rnG2pPcOUQD/ha8iby8sQxxdR/eA7YnJxoqSzPfdeRzF/tUxDTzzFcyoGTwilsO52phn1HJsLnQzOp+dgbVc9mDzM9P+czIT9QK38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021600; c=relaxed/simple;
	bh=GPWpdyQqvJfOAKWpm9l6XXf/KU/OEw88mf2Eaxll1yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rt6NWxufjWCkEASAvg14UlqSj3yKLJIvh4+uxie95KxsQjKXrLjguEPvmQ5srvyXzw0/oB5tt66eBL0TOqBmyhom3sIfisZIXchycHiMXYZT8rlYOTUWJIooZXPteRFCnFvSnP8Eyi/gDwviz1Rm6ifgITK7lDfvO40SyQ6hOMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Woq9hNlY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Woq9hNlY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4637AC4CEF0;
	Tue, 12 Aug 2025 17:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021599;
	bh=GPWpdyQqvJfOAKWpm9l6XXf/KU/OEw88mf2Eaxll1yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Woq9hNlYcH7V2rlGFu3NgCB2dlQE8pTOr1ldApKdxbl8CtGcFJzfTZaSxjFhcEXct
	 V6gIy87vZ96CGcw4RuB/msplYCeggZzuz7STwTqypPEicLu/qDAChKC084pfqhicyH
	 /b8/2YHZrEnPf7EB28Hp/ePaa+2fzh8sjabVTiOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 170/262] rtc: pcf8563: fix incorrect maximum clock rate handling
Date: Tue, 12 Aug 2025 19:29:18 +0200
Message-ID: <20250812173000.344681179@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 906726a5efeefe0ef0103ccff5312a09080c04ae ]

When pcf8563_clkout_round_rate() is called with a requested rate higher
than the highest supported rate, it currently returns 0, which disables
the clock. According to the clk API, round_rate() should instead return
the highest supported rate. Update the function to return the maximum
supported rate in this case.

Fixes: a39a6405d5f94 ("rtc: pcf8563: add CLKOUT to common clock framework")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Link: https://lore.kernel.org/r/20250710-rtc-clk-round-rate-v1-5-33140bb2278e@redhat.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pcf8563.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index ea82b89d8929..61be91c25cf1 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -386,7 +386,7 @@ static long pcf8563_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
 		if (clkout_rates[i] <= rate)
 			return clkout_rates[i];
 
-	return 0;
+	return clkout_rates[0];
 }
 
 static int pcf8563_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.39.5



