Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1E83F9D2;
	Tue, 12 Aug 2025 18:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022810; cv=none; b=ZT2CD89dNMQbi7OeIvlT0RN+2TX5vruNf5VnbwI2nwE8S6aaIaznlj/GJD8Hq+00UgVV7D3x5DTwm9M9Haha69SXaLe8/Flediaa8+KKWTeF0M+qrHvf0O5C5oLw3h8wJf+yETu7+Wpd4Qhd85LXoBRXXnJP7PKqb2yqIdLDl38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022810; c=relaxed/simple;
	bh=OCSzRreOSN06uIRdevCo230TXE85lu9QiBIjauNP/vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGwLlfiZBu2gQMoH30Y2GpkPzZqoSHD3hKlS4UoEh2KBzJTF3RM5RNvvdv7Z6hXJHVGFfEhvS64JlJ54wL9ZzQVadcCPJxVwC3rT+cZMZ1N34O9s1rA/c8SMNX7ecG9DXUxRt/LlPYSYUJNzJa/j3LR2HKjJ/azQGlyLBaBwzVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0V0c4O5u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0V0c4O5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEED9C4CEF6;
	Tue, 12 Aug 2025 18:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022810;
	bh=OCSzRreOSN06uIRdevCo230TXE85lu9QiBIjauNP/vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0V0c4O5uFwAuGlse2+vkkF4Wp6450QKc05f4NW3i56sTaUp9RmR1DRES8oAr7ikk3
	 ztHMHHkAFQagQH7yDhxfbycFn9MEMUBX0UyX0E/HW7uMfbMRd64MO9zzueyGZu4W7f
	 rOrBTa6YCgdntXR628P+bOxd0+1IWtu8zXGkwreU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 248/369] rtc: rv3028: fix incorrect maximum clock rate handling
Date: Tue, 12 Aug 2025 19:29:05 +0200
Message-ID: <20250812173024.095195690@linuxfoundation.org>
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

[ Upstream commit b574acb3cf7591d2513a9f29f8c2021ad55fb881 ]

When rv3028_clkout_round_rate() is called with a requested rate higher
than the highest supported rate, it currently returns 0, which disables
the clock. According to the clk API, round_rate() should instead return
the highest supported rate. Update the function to return the maximum
supported rate in this case.

Fixes: f583c341a515f ("rtc: rv3028: add clkout support")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Link: https://lore.kernel.org/r/20250710-rtc-clk-round-rate-v1-6-33140bb2278e@redhat.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-rv3028.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-rv3028.c b/drivers/rtc/rtc-rv3028.c
index 2f001c59c61d..86b7f821e937 100644
--- a/drivers/rtc/rtc-rv3028.c
+++ b/drivers/rtc/rtc-rv3028.c
@@ -738,7 +738,7 @@ static long rv3028_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
 		if (clkout_rates[i] <= rate)
 			return clkout_rates[i];
 
-	return 0;
+	return clkout_rates[0];
 }
 
 static int rv3028_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.39.5



