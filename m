Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E49D2FA0FD;
	Tue, 12 Aug 2025 17:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021593; cv=none; b=L/FzelOAfXc36sVambszFqoGiFbzTRH4W0jp5mzVCEwnLIp8DZ6mDjbhnWQznEm841JXHSBExtIbK5TPKRY0zr/zYgpfFk3YxfL4jsZyopznIKY3plBD4BU141bI4TFmUhzI/LIZyo9jTeeWf1mFi3/uC5bS7eyKYk1YLYzYGPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021593; c=relaxed/simple;
	bh=JO7lU9N3I/9z2KmRD8uFQVol2x8QRYgUtrqALSFpKyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNidfrg02VJLarxTWHr0aCYx2zcMJOSl0xSgSKwAKmWX2fzr4n+Ha0mj5bRcX7YRcmP6IhghCO4b7g1qJ/TeTOSeVxU9fJ0ARN61Y2ptxj5utlGOl1tBU6/ntmPpRFssfxyGBiq8GZGATodHSGciFyByj0rR8Vsu0sfdGN8s5DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vFsYadjH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vFsYadjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4CAC4CEF0;
	Tue, 12 Aug 2025 17:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021593;
	bh=JO7lU9N3I/9z2KmRD8uFQVol2x8QRYgUtrqALSFpKyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vFsYadjHJrbyxcm76PaYJQxvYFAZMsKrOIUNDT4bUrTN0k+6BVHJz3oX6kmNyystF
	 WurkbfpnoinNp/EPE1wHTRImJgWX9p6NRUFNErSBTtcJvjguDe1djeBqYv2nApizzw
	 v/zp8CBhst4KieWXidJ2M+ac03r6QRcdyI7Lrkfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 168/262] rtc: nct3018y: fix incorrect maximum clock rate handling
Date: Tue, 12 Aug 2025 19:29:16 +0200
Message-ID: <20250812173000.253998480@linuxfoundation.org>
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
index c4533c0f5389..5e7a8c7ad58c 100644
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



