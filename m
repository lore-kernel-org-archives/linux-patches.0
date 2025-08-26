Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8827352FC3;
	Tue, 26 Aug 2025 14:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217463; cv=none; b=jXJikcFIObHLi2y9iotLnsUi35/QWTSdXxkwunZELE0UgmE2+U1sIpioCPqlyygCsN/D2502MJ4f+18xG93eJkVqDbohUPp09Q4rkA93eSXTVTgc9pw7ZDjkCLoL7fd3qrHEKwDhdzY9Eckf+ySDcPK+i3B2ppgvrldugp0Xwdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217463; c=relaxed/simple;
	bh=8ze7HVIu/Q9VtOd8oQU7VzCgPBZPOCVwA81ftBD+ZN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pV4zYB9Jn8fUZ8/l10NDo5FmyEae70UX1elsFmsOtVBw1OJM5Wx9dWRqIwxAAsKVEkRnEgLVWp3TcSgpkmdOlSpsytldNokEnzZm3fUM6+Zm0EpiRQrUmmbOfgQocmrz2eQ9fg2Rnq05phXIBbs58exfMm6tglk5H95vjlpPLBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Omq9O0J5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Omq9O0J5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC69C4CEF1;
	Tue, 26 Aug 2025 14:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217463;
	bh=8ze7HVIu/Q9VtOd8oQU7VzCgPBZPOCVwA81ftBD+ZN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Omq9O0J5zaDZQ12W/L+Z+RKt7+8d6pPk/w9dHXXpsqQ9DhEGtZdXpgJaumFYYNOr2
	 cDhkueF0okr0Pm/hsL3bamj3dym4OLj+YHafpZrB2OKG/6uCI8OwvH7gRWOJIExfHu
	 9VXgkeRj60au5Pqqm7dKnV+xkUS3tNhKMFlZZ9RM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 152/523] rtc: pcf85063: fix incorrect maximum clock rate handling
Date: Tue, 26 Aug 2025 13:06:02 +0200
Message-ID: <20250826110928.232925875@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index dd3336cbb792..0c957144e8ec 100644
--- a/drivers/rtc/rtc-pcf85063.c
+++ b/drivers/rtc/rtc-pcf85063.c
@@ -415,7 +415,7 @@ static long pcf85063_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
 		if (clkout_rates[i] <= rate)
 			return clkout_rates[i];
 
-	return 0;
+	return clkout_rates[0];
 }
 
 static int pcf85063_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.39.5



