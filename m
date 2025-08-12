Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8644280037;
	Tue, 12 Aug 2025 18:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022739; cv=none; b=jwRA3PYMWJOlUTJaV6dcCdHnb7OayuN1L4gmwQIzgTeCCF01v7qnj844RR4hbMWwFtXy/nbh2ADUaMcYkWW+sdBPGGum5ogyHoPZ/7kdYR9omLtrG8IqrWurcjggY9oO10nP1d6qJQ7MRTW8umyEHtqSrJqIgDZcMrr51whL6L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022739; c=relaxed/simple;
	bh=JCZzoOIXsAJKH9sCie+IRhxiNmXbA4ygYf2HLe9xb2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFGbrz0CeBYxP3fdTQLlzXOFCpAn4zv/z9aWd/kzFcK9WST/BNtOo3KzEOyCT3UREVRPRLdNlvn7rsB1lnoj04zDyLXN+gaew7Wgj8Nz4xKLmLVlwZ78PGcy4vFGhaosVCq3uJ3AQbApxvXexbmE4lBVERfIzI4TWc8WzDhCz8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SUWs5Rsl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SUWs5Rsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C928C4CEF1;
	Tue, 12 Aug 2025 18:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022739;
	bh=JCZzoOIXsAJKH9sCie+IRhxiNmXbA4ygYf2HLe9xb2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SUWs5Rslg47K9ItiR5YKP3bZJQAtOyENIZb0Isj7swp6jKrWztWtyrAhgbay2vQZY
	 0F2PCHTRzPbMO3MMmIW5M0F+z2XinWMCs30/5fe43Yqx92pWebuKs4iko/IZxGin9O
	 dTKaF2E6iKRcsM8gkXZt2+Myakdu8fJePpsdWczQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 243/369] rtc: ds1307: fix incorrect maximum clock rate handling
Date: Tue, 12 Aug 2025 19:29:00 +0200
Message-ID: <20250812173023.910019193@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



