Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CCE3431FD;
	Tue, 26 Aug 2025 13:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215894; cv=none; b=aiOgwEJOlYQp9xi8P7bRqD+cA1RRBqdQjRl4DYkQtIbUTn9FLhz2DzYZ8cgqS+lnM8d9A3YzP1lsQH8GIqgI//Be5pn5/vW/ZvcmQ+l2Xnag80FRmU6LCWub2YyaUGMGsVe0t9CUFde53qfLiI9vQxTTibNHEpEnh3RZNv2ne60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215894; c=relaxed/simple;
	bh=l1Wc6VNiyIySHy5bHYpdu9c1I0/ay362VNePW93ZO9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYq8BBBGyaUrcHB0pxDsAU9napDndhuM7OxFlfJG4GQqoYXGPfDBpVSUxQcPyvBA0Z81jyTM4u2cd6Z166UbNL4BCvQP/8jF0SjMT9h3IiZSMj6k83/qZL3Aqh97jXewJYzjlq1bcSkc60SpVpb3kPyVKGAuLF3LSvUr9wsNJQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cH+pv/Kf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cH+pv/Kf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E360AC113D0;
	Tue, 26 Aug 2025 13:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215894;
	bh=l1Wc6VNiyIySHy5bHYpdu9c1I0/ay362VNePW93ZO9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cH+pv/Kf7eLKzWqvds3deqCLZAdQjMT/W+ybl9CkjgPh/ncuxpb2tBkWIvO3sTfbw
	 8igZeLRiCjXt41tNj9hp5xaJ3lFuINYg+ZFwgkJ58AizKbQhTU2LK+96wVPyMLf9Oe
	 ypgX1BSxB4D3FeHEKMa8JTm6oUWUrMkBek8kMdiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 207/644] rtc: ds1307: fix incorrect maximum clock rate handling
Date: Tue, 26 Aug 2025 13:04:58 +0200
Message-ID: <20250826110951.574578367@linuxfoundation.org>
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

[ Upstream commit cf6eb547a24af7ad7bbd2abe9c5327f956bbeae8 ]

When ds3231_clk_sqw_round_rate() is called with a requested rate higher
than the highest supported rate, it currently returns 0, which disables
the clock. According to the clk API, round_rate() should instead return
the highest supported rate. Update the function to return the maximum
supported rate in this case.

Fixes: 6c6ff145b3346 ("rtc: ds1307: add clock provider support for DS3231")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Link: https://lore.kernel.org/r/20250710-rtc-clk-round-rate-v1-1-33140bb2278e@redhat.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ds1307.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index d5a7a377e4a6..1e621080f666 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -1461,7 +1461,7 @@ static long ds3231_clk_sqw_round_rate(struct clk_hw *hw, unsigned long rate,
 			return ds3231_clk_sqw_rates[i];
 	}
 
-	return 0;
+	return ds3231_clk_sqw_rates[ARRAY_SIZE(ds3231_clk_sqw_rates) - 1];
 }
 
 static int ds3231_clk_sqw_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.39.5



