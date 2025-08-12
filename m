Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6001DE2D7;
	Tue, 12 Aug 2025 17:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021586; cv=none; b=Tr3tyWOBKU4BwRlpbpIEL8OksJbO44tyJiJkGx7T9N7l305keegNByf0SjC8YCThI4RuJSlDjbQRYLAqahLM5E7njxRMzLpUS9avTnYicxmLX9SU6tiuSG0JYEOgTLToIQTxyMMk6iKlsnUJem/DwxYsx+sZu84TW8SNHe+sF8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021586; c=relaxed/simple;
	bh=HkPnjXMU4IOShtOalB4BiDVnjUU15yGhrDkKRadiwAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdNJPaipfW/bCQ+DQDq7v47jzr9d399cRtOYTY5UqbA3X3b4RpJkVTCZ9BbZb/yK3t59uHAs468bMA7roHV6cGT+jdkmkv1vaV+pIH8JE2Phu2qGlzmUvcTGUfhb/Gx5NEGz9RFFBmbIO3pN/FvOQ+EQmFNGVJi3VTAy1NPcPHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n58K+ORS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n58K+ORS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A281BC4CEF0;
	Tue, 12 Aug 2025 17:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021586;
	bh=HkPnjXMU4IOShtOalB4BiDVnjUU15yGhrDkKRadiwAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n58K+ORSpyTC5/PCb2f4sJz+rZm2MQWLi3PMIAM/FJ1Lszo4McFJl34Tu9t5sLtMq
	 dpm+pmRAcZFkhYQEvtf9rdQZJl3UablQ9gH23yAOi8EYTDr7l9lGecrTIICCUGJml4
	 j7a3/0jQM0uSJsb+gPODD6ecqScyr1k4JSKjTJL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 166/262] rtc: ds1307: fix incorrect maximum clock rate handling
Date: Tue, 12 Aug 2025 19:29:14 +0200
Message-ID: <20250812173000.167974991@linuxfoundation.org>
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
index 0c7845196092..e14981383c01 100644
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



