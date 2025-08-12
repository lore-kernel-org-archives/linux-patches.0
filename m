Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632C92F7477;
	Tue, 12 Aug 2025 17:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020914; cv=none; b=Y0jMlErwga2JomdFj/H4M3IkGqbYOc6dAay+MteR83K9NSpImpCoPS+/RWERW3EwNilB0le0Q6SNoi0Yca13z9lAi0FWAWowycHsLagHBm1kNTdJ885RD0P8cvUp5nE/AmklnRP0KrMN8iuedhDxt+37TdQfwYcv+uC2Zhlu8Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020914; c=relaxed/simple;
	bh=96FaAoAFeIPuNq1I9V4RKNMApEZWRyq9T2SV+LH34GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdsPnrRuFxBVXzcRslKirdTWam4qVxo4W/DAIvVzmSLCJ8c+1UaH81w4jIH5znINZdSKXIPuZhGpdY29JrNzqcPqAu/GzrTroe+Lw4fzWtYLc3MXYZGobWcPvcCNdVSg1kHYoxdjTKOmEWpbfdCLGpiWlla6SwR+iizFIoOnHnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LRaDACei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LRaDACei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C603EC4CEF0;
	Tue, 12 Aug 2025 17:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020914;
	bh=96FaAoAFeIPuNq1I9V4RKNMApEZWRyq9T2SV+LH34GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LRaDACei5/IMVSsQhefhhZvtu5vMM6IubNPq4ruFeEYwk2eBp2BdsZ7Pw4LCSWfF6
	 KsOFAytdNHRmlARzRAEaE/NNQQl6yJ/FMaGet8IiLeBiW3IU5bfk0y5Xl7eJuozRT4
	 DSJFLz2ssDUHpIMzyF5BFbgDPGmfdHv70QeXAIAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 186/253] rtc: ds1307: fix incorrect maximum clock rate handling
Date: Tue, 12 Aug 2025 19:29:34 +0200
Message-ID: <20250812172956.700475681@linuxfoundation.org>
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
index b7f8b3f9b059..73f2dd3af4d4 100644
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



