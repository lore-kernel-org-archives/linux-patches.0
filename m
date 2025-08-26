Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588AA352FC3;
	Tue, 26 Aug 2025 14:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217466; cv=none; b=mSFTWDzBBuwE9mMRNQ5U7vs7bTzhauxFCiAVGss85JGcvr6R0j6/fwgfXk6l8f8wyje6GCppHwHqthn+B+xGZbCXi1bt/HHPfA2UyVTl5e20tnSKbiZR6GI02foxuYldAR3N/yuz5n0ehDaGMKhyoKPqCpl9kDJksiFklIslWro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217466; c=relaxed/simple;
	bh=gkfjgev2SA2Mb5Jwrac0BGkpIGyHH9sVdSAMx+zLVGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7zosA6WLRhh1Bi4Hx5y6E+6ZFv4xlrcgwcFSFoljAs4/zHv8ltyqYy1t+71dA9SQCoP50HKG6bt/0trbFlEFGnL06HLG/ajeo7kxX2eTWo8tanDMijjqu9aELKaUZ5V/7EH00AQfQgjAwDCppPY6U9JxWZa9SoINon0/OkA+fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M1SE//C+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M1SE//C+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F22C4CEF1;
	Tue, 26 Aug 2025 14:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217466;
	bh=gkfjgev2SA2Mb5Jwrac0BGkpIGyHH9sVdSAMx+zLVGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M1SE//C+R+zPLaRl6aRPMOfP8Ct8jiV7/13PAg9U+NHx0D+bluyv33gdPZIpahg74
	 eBA3/S//tzrjkA8bcM8dIAxY9tsSQ773FsOGqwiEBMzXTSFEHymNzvnsMaGqNFrsfG
	 wy+H7sOdYH/uEZNbW+GoheqKz4YKlPXTHD3g84+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 153/523] rtc: pcf8563: fix incorrect maximum clock rate handling
Date: Tue, 26 Aug 2025 13:06:03 +0200
Message-ID: <20250826110928.255227890@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2dc30eafa639..129bd2f51779 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -399,7 +399,7 @@ static long pcf8563_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
 		if (clkout_rates[i] <= rate)
 			return clkout_rates[i];
 
-	return 0;
+	return clkout_rates[0];
 }
 
 static int pcf8563_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.39.5



