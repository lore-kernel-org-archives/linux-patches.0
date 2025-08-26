Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB2829D291;
	Tue, 26 Aug 2025 13:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215899; cv=none; b=Tpm3ODA8LC5j+VZloEqC+B2XgMqzXUxhc0lXG+E2RpksTMAfHG75lPr1BWrNpzCata+cCHnAAactlUuACqs+mZoD0gA9ZFoH0xhJeNBMX+PuvsICm+upFEmWJTr52xYS30T5/b0mml4STmHU/AhRNhtgE8El3g7NC4O6TzB5m6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215899; c=relaxed/simple;
	bh=0MmL7y6mPBm8zDQw2BKB3vXZ/z1hwCGHJ6Wid15i8kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNeGpIXWEtBOj8aX+44HJzoWx890nLhXhgKgP5OyBnrKKWOIxpFhuuelJBrPeQ4674EvwC42vI+Cb3l6XxBIw5tzoeqPvO4WEXIUCf5xP7lyWOwgORUjF2aSWlVQ/+Yh7h/FgUW1Ywi7cV2RVlD8f2PpgmdQZmGU8wP2BVtsfHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hJkFKTK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hJkFKTK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD49C113D0;
	Tue, 26 Aug 2025 13:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215899;
	bh=0MmL7y6mPBm8zDQw2BKB3vXZ/z1hwCGHJ6Wid15i8kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0hJkFKTKV13Ds1E0QqMrNnTUNvsDTY3LQvt8Jt/BpngPDm2nKf7cDncBapo9N17vb
	 zzjakItgrAYrWs3i9f2R9K9o1wTtSu1uNCvwhKf3o/kz+fQHtVMxHyiyJZ/xZlrfId
	 Ng1/hpSn5+mcfxQhUcBPU2rbN5M1asjf56OEjOFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 209/644] rtc: pcf85063: fix incorrect maximum clock rate handling
Date: Tue, 26 Aug 2025 13:05:00 +0200
Message-ID: <20250826110951.619665508@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 186ae1869880e58bb3f142d222abdb35ecb4df0f ]

When pcf85063_clkout_round_rate() is called with a requested rate higher
than the highest supported rate, it currently returns 0, which disables
the clock. According to the clk API, round_rate() should instead return
the highest supported rate. Update the function to return the maximum
supported rate in this case.

Fixes: 8c229ab6048b7 ("rtc: pcf85063: Add pcf85063 clkout control to common clock framework")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Link: https://lore.kernel.org/r/20250710-rtc-clk-round-rate-v1-4-33140bb2278e@redhat.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pcf85063.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-pcf85063.c b/drivers/rtc/rtc-pcf85063.c
index 89e080798e03..b286e3078025 100644
--- a/drivers/rtc/rtc-pcf85063.c
+++ b/drivers/rtc/rtc-pcf85063.c
@@ -407,7 +407,7 @@ static long pcf85063_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
 		if (clkout_rates[i] <= rate)
 			return clkout_rates[i];
 
-	return 0;
+	return clkout_rates[0];
 }
 
 static int pcf85063_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.39.5



