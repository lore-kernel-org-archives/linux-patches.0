Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7873F9D2;
	Tue, 12 Aug 2025 18:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022746; cv=none; b=tWtkOAVg+9VO0ZiwXx0I4wMyBwbEqPONR5256qPL35+k/yyOYcKWaleXjjRooB0vCnlkiItge5wap2ER50iIMv1EPdBSTsXLlqzrURnPrgBA4eo0xM7+ZLviY75a+YTltyg3JzmGZgDh8FN8fCfTrEcgmRH9EHU0PtOZT4SgZew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022746; c=relaxed/simple;
	bh=LLBznlxEkRjF9iBImvAEYsIQQyXo7R55ijhGrcLu4Os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5FV2wMunxB4LDtfydUSrgc4eIMV9xyjZIfWFNclBYKtlMPVYDuaD0sNf8nj5SLZfl5ULJLeFrLypnIy+CuSidJRl7tsciaqu0BM9hVDxXJToEfGODfv42mEImGpnq7+kIASuiPa2ATkpKWgW4n6h2Uc/Ii1KNQ8ojDLEzHxk9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=grE0ZCMI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grE0ZCMI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF50EC4CEF1;
	Tue, 12 Aug 2025 18:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022746;
	bh=LLBznlxEkRjF9iBImvAEYsIQQyXo7R55ijhGrcLu4Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=grE0ZCMINScZrsgzuS4voIKOtBOHQeUDY1Pe7HUV1L86GIKAOAUD/X8KWOqq/9k4b
	 8IBySI/LjNuIcSrW4rZtgHHzKuWz4kIxIvl5qxIJ90Iwm+W2is2Gp8h429K7NW59rP
	 1Cj0wpw831KWK0fM4qek6EQFH3nRTq4I0e5nDUew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 245/369] rtc: nct3018y: fix incorrect maximum clock rate handling
Date: Tue, 12 Aug 2025 19:29:02 +0200
Message-ID: <20250812173023.984341742@linuxfoundation.org>
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

[ Upstream commit 437c59e4b222cd697b4cf95995d933e7d583c5f1 ]

When nct3018y_clkout_round_rate() is called with a requested rate higher
than the highest supported rate, it currently returns 0, which disables
the clock. According to the clk API, round_rate() should instead return
the highest supported rate. Update the function to return the maximum
supported rate in this case.

Fixes: 5adbaed16cc63 ("rtc: Add NCT3018Y real time clock driver")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Link: https://lore.kernel.org/r/20250710-rtc-clk-round-rate-v1-3-33140bb2278e@redhat.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-nct3018y.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-nct3018y.c b/drivers/rtc/rtc-nct3018y.c
index 76c5f464b2da..cea05fca0bcc 100644
--- a/drivers/rtc/rtc-nct3018y.c
+++ b/drivers/rtc/rtc-nct3018y.c
@@ -376,7 +376,7 @@ static long nct3018y_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
 		if (clkout_rates[i] <= rate)
 			return clkout_rates[i];
 
-	return 0;
+	return clkout_rates[0];
 }
 
 static int nct3018y_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.39.5



