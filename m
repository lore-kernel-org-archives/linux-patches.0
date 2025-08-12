Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A52F221FAC;
	Tue, 12 Aug 2025 17:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020931; cv=none; b=npTC0t4TZoF+bufHFAg198ffoIcfmeNXZ3Dn8SbEvfpWBv5IQFrN8xTHBWqFWi7caGAOf2tUWT0qGG1iBjH2FW5LgU8eLn6HEge5mJEXCCYZ3qD5IFfD+2wKfSoWnUsLohp/YVorC90W6oxmtP0k5SHCBE89e7WpRZbYhnNiFOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020931; c=relaxed/simple;
	bh=I3JCQeZePTWV11hy8GMK2Cn3q8Pf+3VgtmGP4KNSgco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5Ox3zzj/7DC5qIbgzNJPsoYNcvhREGsNMSpqo2z9EDgHfu5El8CIzQhzeFY6haoBGKtSbojPcGpLPzYZrOjKevxP4LCr/PpziDZhfCXzrYmZOAqQPxyDCo2wd39ReQ9yf8MH+C66JwLnL6a4HpZ/6NjCf0ns6mNKUMLsZcWiKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=znlcQ5ds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="znlcQ5ds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0F1C4CEF0;
	Tue, 12 Aug 2025 17:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020931;
	bh=I3JCQeZePTWV11hy8GMK2Cn3q8Pf+3VgtmGP4KNSgco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=znlcQ5ds3R8K5I9J6Y6GyWNyr1X2FbwWbP/mCGSJIwbeAbG3Ktt2SroSpPT8zOE+2
	 UlrevLWFDrzcER7RBvnNtMcFQiisWUTmPmPaK1tf66eDw16axCejpFNOWYbQMvZsI3
	 xzq0uS0JJjB3HryRmI3hRC/4jpVQ7UYkrQ83ntns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 188/253] rtc: nct3018y: fix incorrect maximum clock rate handling
Date: Tue, 12 Aug 2025 19:29:36 +0200
Message-ID: <20250812172956.786806305@linuxfoundation.org>
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
index 108eced8f003..43b01f3e640a 100644
--- a/drivers/rtc/rtc-nct3018y.c
+++ b/drivers/rtc/rtc-nct3018y.c
@@ -342,7 +342,7 @@ static long nct3018y_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
 		if (clkout_rates[i] <= rate)
 			return clkout_rates[i];
 
-	return 0;
+	return clkout_rates[0];
 }
 
 static int nct3018y_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.39.5



