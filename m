Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293E1268C73;
	Tue, 12 Aug 2025 17:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021118; cv=none; b=fSbNjTmHbBGmNQZZQO5EcL1jiKmzW/apCIUUWGVQGv869l5qbPoi45DyUNCOvh4bMm2xXBVeESA/wM6d4LFMOqN9MVf/LCcZBarV8DMEZFNfqqS0hjAb0tRHH7QiETIJ49fpjY1PmmcHJ10kc5kuV3KIz9sX4Ryd3TUgZz4IweY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021118; c=relaxed/simple;
	bh=XT6kuFWE4yXWZx2yPPjNDiD71k2QS75QQ6IKmNeWaOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlGs90Yf0uqSDc25zcdY7Px33xL2LbC83D52nR2D2WqTRSjCAeGNx7LlQb44JNQDZCe0wQgEmb5WHmp7Cw14D3t0RZm+3ZXgXmDsruIRHk1UAthcZVdP9PTKuhFPx5A90Ava456oDNN3I6njET7MRfdFV097+uRmVz9QrcfL1T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvfS+mFn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvfS+mFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A115C4CEF0;
	Tue, 12 Aug 2025 17:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021118;
	bh=XT6kuFWE4yXWZx2yPPjNDiD71k2QS75QQ6IKmNeWaOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvfS+mFnw8ezWudlj/fJzkUb+1imoUXOlUXxZI0Pb2/itpDaAQUSqC7+WDoD2eQdl
	 dEbOl39xYRcFgM6gDh/xn2cKpy4uu9qUthk5jfFBN4ixpo+SrkmkQSHnXks+jbHHgI
	 HFV7R/9/pHjuNG2vEzRRRHDHkGC9QtvUDi0moh30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 190/253] rtc: pcf8563: fix incorrect maximum clock rate handling
Date: Tue, 12 Aug 2025 19:29:38 +0200
Message-ID: <20250812172956.881406831@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 11fa9788558b..dd27acae137c 100644
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



