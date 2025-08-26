Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EB63451AA;
	Tue, 26 Aug 2025 13:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215902; cv=none; b=F6/eS/RX6+fCySHCAQupp4bqJWMqW5UQynUPWoUq9Q9BhWdCT3JFv27dhQzIjP5JE1CwUnNCDX1YNOnFTcdOSF2lJ+R8ezUcVkvyDfxvEecq2V2k3MmYB7yLgfFD4EKWTZOEJExJHgnnTmhJ1WchWoPTCKC1zYQMqHoTbMLFud4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215902; c=relaxed/simple;
	bh=cOWwH2KSJauK+zlP3M5lW7xbbvhgkF7YNsFD+BlO9FM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yl0s4ZgtwETIyhLdQeQgzOW9F7BuJ7BvdU8QHStj3A69dAVk8FxtdXXMY4q254xNAR0GcEAZ2mtfq8q0jCS+UCeh+FQm1qwsRhByfzf3M1FFdk7+FoRKF4lpkQ93dCgID+TNIZWGqpT3NeRyTdyVWn8VPgPvls8AeXc9kMVrdKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9bwJdnt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9bwJdnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B5CC116B1;
	Tue, 26 Aug 2025 13:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215902;
	bh=cOWwH2KSJauK+zlP3M5lW7xbbvhgkF7YNsFD+BlO9FM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P9bwJdntf9MOFamnPCctVoXhnjHj+WUV1D1dwRFLtNEtMR0kbiwg3RZuuREYiGA6R
	 YWAZsIZjwMO3/ph5mR2Oox0eZASprY8jO+h8LPgtNW85/fyoFnru8Y+6O3e8HJZUau
	 fV9VXRi6L0gVF4vMEMoGmCxHOU5hv6HMtJGothQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 210/644] rtc: pcf8563: fix incorrect maximum clock rate handling
Date: Tue, 26 Aug 2025 13:05:01 +0200
Message-ID: <20250826110951.644181405@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 906726a5efeefe0ef0103ccff5312a09080c04ae ]

When pcf8563_clkout_round_rate() is called with a requested rate higher
than the highest supported rate, it currently returns 0, which disables
the clock. According to the clk API, round_rate() should instead return
the highest supported rate. Update the function to return the maximum
supported rate in this case.

Fixes: a39a6405d5f94 ("rtc: pcf8563: add CLKOUT to common clock framework")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Link: https://lore.kernel.org/r/20250710-rtc-clk-round-rate-v1-5-33140bb2278e@redhat.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pcf8563.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index c8bddfb94129..7d47d1f4802a 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -399,7 +399,7 @@ static long pcf8563_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
 		if (clkout_rates[i] <= rate)
 			return clkout_rates[i];
 
-	return 0;
+	return clkout_rates[0];
 }
 
 static int pcf8563_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.39.5



