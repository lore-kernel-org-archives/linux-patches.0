Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD22B350D72;
	Tue, 26 Aug 2025 14:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218780; cv=none; b=ZGNNQVC15s8HD5J0WLY7bed8op/L89x+tBCBbgL5FM7oAZj4jB8GgWb5b+9HUy6CPB29hfLcwCsBRQE4ovTRRdrt9Yf6cel4TeEHGLex4kHMmO8CdtWXO+XeV287VFyTScHykJy3UhkRDBQVY+rrSZQ5IvxyeLMZV0FX9+t7p80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218780; c=relaxed/simple;
	bh=L/Q5tlezWZsgRXHMM4iZNLuY6TiAoMOWctaSW/WIpw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+Bqux4qhg5l4AxcE+5ipMMGzJF64s6InslmGykPqN33/iHYbavUXYsLAHd9VHoIY7BqWU/1+31a+vi/VYggsc0ctHocibArZsdp3Ly5IO2wAtHyfieM4UY8ERvaRmTpZqLAcilfMOjFo/CDuUdNHQfIFSmxTtsaaJFzHDfV0yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ye35yuQQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ye35yuQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2461FC4CEF1;
	Tue, 26 Aug 2025 14:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218780;
	bh=L/Q5tlezWZsgRXHMM4iZNLuY6TiAoMOWctaSW/WIpw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ye35yuQQI6grTBbmHG/0SDxdGzd//jf2RXxrpWrlDilCReXToecHat/cDsc2IKdkn
	 CyJWQeFZDBqGJAxAc85q2gzRK5CKg70Bq5Zt1yW17IkjvVEfFuozTpGAuJnOMhcnDS
	 OVWxnSwRxDW36Zec8jVjLIk3p+gbmGb+2bwxq7Ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 131/403] rtc: ds1307: fix incorrect maximum clock rate handling
Date: Tue, 26 Aug 2025 13:07:37 +0200
Message-ID: <20250826110910.360759270@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 40532a36ae67..b371d1e48942 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -1381,7 +1381,7 @@ static long ds3231_clk_sqw_round_rate(struct clk_hw *hw, unsigned long rate,
 			return ds3231_clk_sqw_rates[i];
 	}
 
-	return 0;
+	return ds3231_clk_sqw_rates[ARRAY_SIZE(ds3231_clk_sqw_rates) - 1];
 }
 
 static int ds3231_clk_sqw_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.39.5



