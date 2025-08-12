Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDD73D994;
	Tue, 12 Aug 2025 19:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026456; cv=none; b=YnFNayJ+MhDV9UT1VitpxSt2k+PDkbmH8kDT20UdanR+H+Ch5hs7MzE+bCV+JU036DGfWDgP3oMU+d7fS0QNB2+kAVPwxYIvcTycFfk98jpCWTSFktp4c3XHpZpSRjIe6ZoY4mPukZhvTLjFedRXbiDvAyj66FQEQVjlDvBa1GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026456; c=relaxed/simple;
	bh=lrnzvkcPWcKX5nvKpxfxAmZoC4tnps1YNDaqZKHbK5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJy/gfd1l+Et6++6hV3GtaFlwNeCF6n2+JJHk/KU6xoFsA1oYCPmFLZnTVeR9tQXNxAZ8zbXLxhnQgSHg/jmu/4lPHts8unvfRriRutYXdMsflBVYjNwf6BVsZqe0ObpwOyNkLLgAEHJNKpww/7FSkJi5l8bapplInPl/L5fm6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fE6JrrP0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fE6JrrP0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1560EC4CEF0;
	Tue, 12 Aug 2025 19:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026456;
	bh=lrnzvkcPWcKX5nvKpxfxAmZoC4tnps1YNDaqZKHbK5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fE6JrrP0DdAN0KUGBZeW8yMOV3b2+AvAw2oaSCEqlpK1pfBOpMwyGLKjC+5vkAiBn
	 U2/xLQzkqxlc8u/+6SFs30dahkt0Z7p5Gv+pRkHKJuU7f/4RIqEzj/Bm60YnxaREMQ
	 orVz6z3ZSjzO/FQAhm/tvz07b5nPEIyM7U+qy+SE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 343/480] rtc: pcf8563: fix incorrect maximum clock rate handling
Date: Tue, 12 Aug 2025 19:49:11 +0200
Message-ID: <20250812174411.584448639@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5a084d426e58..e79da8901544 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -339,7 +339,7 @@ static long pcf8563_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
 		if (clkout_rates[i] <= rate)
 			return clkout_rates[i];
 
-	return 0;
+	return clkout_rates[0];
 }
 
 static int pcf8563_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.39.5



