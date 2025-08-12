Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A10E3D994;
	Tue, 12 Aug 2025 19:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026449; cv=none; b=fj6BPjCvaYoZUuh+oL+6vrLZzqhMmHKEEJMS7asAubq8quRCFFfdk6/NDKtssbyPX9DLUdBXgjs2lhePczux0+XQYsx+PoQ4ecnYtFcRtf0MmUDhrFX4kgwzI9TzdEsZTy5JuYHi/rJ4tEM1qlNUjRIOlb79jaWXkDgvLhM3VB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026449; c=relaxed/simple;
	bh=e98XG5zjadBsp8xQtT0VTA+x6mOWKQy0wm1vPZuRa1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AaUZg+Kus63roCF4UZaV8n+2OGa+NF5/frV/QAEnPYI9JbnXYBSRNI6nbx7VKJlxfBgQXrwp6tlPRkdatf/oKhla85SG2Lj89m6WeBbrgXIgTju8fj523JSlUXkRt59f9jIdtxm2g8h/2TQFx+m6A6jKdI7BY5BJ16JwWpn71E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S5VwIQLp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S5VwIQLp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79D1C4CEF0;
	Tue, 12 Aug 2025 19:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026449;
	bh=e98XG5zjadBsp8xQtT0VTA+x6mOWKQy0wm1vPZuRa1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S5VwIQLpAL4+7TX0wrNzMPaD7aSDJMwuPnMGK0KVfd96BW6p9sYd2cGRhFH1/vWZP
	 XiY9IVHmxIx+iSYRn4fcP1+k1txoYpcrOjXbdvefgr9imrz0ukWMK32O2dvvzLfrdo
	 +23EEoo4/l4lWRKfc8vbv5oA2x1XnYoNP5sdS98c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 341/480] rtc: nct3018y: fix incorrect maximum clock rate handling
Date: Tue, 12 Aug 2025 19:49:09 +0200
Message-ID: <20250812174411.505848258@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



