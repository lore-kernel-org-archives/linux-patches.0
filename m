Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3855217F35;
	Tue, 12 Aug 2025 19:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026444; cv=none; b=bZIMW+ERRRngvmPPNUoHUgdtrheJE+yRIXnn9UzIno/81NR6GrKnv0vSaSxq1tPBgNlSzc+Y4vRFgNut15wlCqdSNd66GGyNsZvezH0+5GN/IGUl3b/eqjwOO2TzBYBAmDt2x7cMwMIznTxhobtVPzzt9Rt3n1SYWgqoN6l8ZPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026444; c=relaxed/simple;
	bh=BtbrkSmZ7TYn0Vin9RK+bJ20eXeGDgsvL0Z13Zn/ItE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NetUN/itCtd5gaEHIx7U7mXsZ6KQMNVQA037qUPnZP2J2Z5qwLKLkV834NTH5YGyRRpA+CYTT1VY+wHjrwY9quPs3yCzTgkPtlCnulbreTZQBLCCnMJYi3LjgbWkTZhEc1kjnoAA69uUI6fKh/Z9rOODUEYfP8xNSD5+gIFT6uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZ5IucMs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZ5IucMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EC4C4CEF0;
	Tue, 12 Aug 2025 19:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026442;
	bh=BtbrkSmZ7TYn0Vin9RK+bJ20eXeGDgsvL0Z13Zn/ItE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bZ5IucMs+wyhR12b64vsxW+cYgW4kzrlOR2redaMGikWFVWew8mHsnzmYozzJ96l8
	 RjBuMPxXvRiQiKngRXXos88OIFiv1TNBRgKsVst54L8V9chrHYgodPjPPSgcRVJRj4
	 HP8oVN78NuavYdHimd9d7FZY3Rs264Eql5a3U8Rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 339/480] rtc: ds1307: fix incorrect maximum clock rate handling
Date: Tue, 12 Aug 2025 19:49:07 +0200
Message-ID: <20250812174411.422873513@linuxfoundation.org>
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
index 5efbe69bf5ca..c8a666de9cbe 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -1466,7 +1466,7 @@ static long ds3231_clk_sqw_round_rate(struct clk_hw *hw, unsigned long rate,
 			return ds3231_clk_sqw_rates[i];
 	}
 
-	return 0;
+	return ds3231_clk_sqw_rates[ARRAY_SIZE(ds3231_clk_sqw_rates) - 1];
 }
 
 static int ds3231_clk_sqw_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.39.5



