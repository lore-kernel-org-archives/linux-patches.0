Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3530920409A;
	Tue, 12 Aug 2025 18:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024761; cv=none; b=GiM4pBDDY/LToLlfAt+48oKnWrueR/Y70GmOOVC2c2UYV4cF23BlNQelAY6P75KeZHc4sZ927Ye4qygzghJRvIRz3C7B497C3CWaC98Qmnyhzv9qB0dqvOSvIyd5truT2ea/UH4CVrLaUOdzA29d7iZlU3QLZKiZcT29uUIdOZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024761; c=relaxed/simple;
	bh=woMJGPnrmnyNgx55y4I/Yyu3oIQ0U9RGjh4Sy5xBVR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qaY63abAcFQqyAavjBnOIIm6tgWJLIow+94Cxj/Majc+fGqyCstKaZclB6kr9a+rB77D/YGmMuSUy8JZEycARN8NZo39tH3dMc7bRCsMuIrKIN5R42CQCKmMZ/iwejP8vUVrUb5Yg6CkcvoKPXZzc5/GcTLxSA8Xjd0KJM1qv34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hhhEpwQc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hhhEpwQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A641C4CEF0;
	Tue, 12 Aug 2025 18:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024761;
	bh=woMJGPnrmnyNgx55y4I/Yyu3oIQ0U9RGjh4Sy5xBVR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hhhEpwQcvQw2tfxryT11pGgDppDDkpt6uRDMIf4t0H0pV2OX4mkRTe8QBgcr36BN1
	 ThPR1FBSVIX4M8W3e0cD+609ZXLfjA9adPN8LNDSG/i4szfWyE6T44KFZ7w/vN7jaZ
	 HyAM+W908QBHvxkSJbDd2epAsn/CXH/E6xCZ9Tqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 470/627] rtc: rv3028: fix incorrect maximum clock rate handling
Date: Tue, 12 Aug 2025 19:32:45 +0200
Message-ID: <20250812173440.960085256@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit b574acb3cf7591d2513a9f29f8c2021ad55fb881 ]

When rv3028_clkout_round_rate() is called with a requested rate higher
than the highest supported rate, it currently returns 0, which disables
the clock. According to the clk API, round_rate() should instead return
the highest supported rate. Update the function to return the maximum
supported rate in this case.

Fixes: f583c341a515f ("rtc: rv3028: add clkout support")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Link: https://lore.kernel.org/r/20250710-rtc-clk-round-rate-v1-6-33140bb2278e@redhat.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-rv3028.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-rv3028.c b/drivers/rtc/rtc-rv3028.c
index 868d1b1eb0f4..278841c2e47e 100644
--- a/drivers/rtc/rtc-rv3028.c
+++ b/drivers/rtc/rtc-rv3028.c
@@ -740,7 +740,7 @@ static long rv3028_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
 		if (clkout_rates[i] <= rate)
 			return clkout_rates[i];
 
-	return 0;
+	return clkout_rates[0];
 }
 
 static int rv3028_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.39.5



