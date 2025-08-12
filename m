Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E7F2FF15E;
	Tue, 12 Aug 2025 18:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024754; cv=none; b=Ue99o552JiQCYrd2SOb36vcOa377/+hKLsng7cKQ5GUTq3bbGQp+gaWN9scImaN2hOH3uE7UGe5EnM1fTK+PdMk2Hln4cyS/wl3peSLNz5gz5AWYq32ZGwUDXUZdTH7l4SSPIj6/NNwdMQnxdvcaCZTaBRUcwBq8fidZts+53kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024754; c=relaxed/simple;
	bh=oXLwJRSsj/QOMLzhpbn7WztpwhoJ2loq4qJmGI2SMGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jD7Pjo+1+Y86E05kHcbc2b64f0Z5AVnXXnYEOvFShw7yItV+BdBpV9zsxZMaxDhVbB6LUvMFB4rIKneuBkLAAsCuALIV6cRQsmaKnYYLCd8ZGzvx7H968SMHjKkzExvppG25ya2AhV02CqgYs19VV2rTPY8rH44RzWrWC83w1ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JsFZ0B14; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JsFZ0B14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE448C4CEFA;
	Tue, 12 Aug 2025 18:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024754;
	bh=oXLwJRSsj/QOMLzhpbn7WztpwhoJ2loq4qJmGI2SMGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JsFZ0B14TrTlbWTRBd9805ZqzJJ62XQIh/zxDNmeHhFuWg7pwxtRhlJKp4Nf2z7vm
	 qoLbl2llQmIUI3FhoiAF6MEGV/v3tDeNoGfHBJUtn7RFhrvqFQKMw+nKLpUt2FFhQF
	 d6bqZLrkb60XW+JLeYjHTGDuB4zLHxY/MHtWyHM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 468/627] rtc: pcf85063: fix incorrect maximum clock rate handling
Date: Tue, 12 Aug 2025 19:32:43 +0200
Message-ID: <20250812173440.558149092@linuxfoundation.org>
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
index 4fa5c4ecdd5a..b26c9bfad5d9 100644
--- a/drivers/rtc/rtc-pcf85063.c
+++ b/drivers/rtc/rtc-pcf85063.c
@@ -410,7 +410,7 @@ static long pcf85063_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
 		if (clkout_rates[i] <= rate)
 			return clkout_rates[i];
 
-	return 0;
+	return clkout_rates[0];
 }
 
 static int pcf85063_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.39.5



