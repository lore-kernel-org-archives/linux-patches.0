Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A6E352071;
	Tue, 26 Aug 2025 14:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217458; cv=none; b=hdnii6kLPtDEnIFg8JkwiopENktx6rz4YXhdTU8ddplXrR2jN83Ch1771bKt0p2IvU+vPnMEtMuU3qvG7vjvDX/Tj+8F0HmR78VdJuZriqYIBSxVT3wmsYcSD5FJWsmXnRqNmmO4kLG9J864Ye3bpGlQ1/OMU0t1A6UCHk2F5mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217458; c=relaxed/simple;
	bh=0cWPbGFxune0xI0353paFKAmBpl5c42HNnXqlr/dPHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERoc/vpDvAy6aWzF1mhH/J7d7Ufj4HtzefOYoSfZI/2BZlG5HPuZrVYIOSweeL4EN8g//dvTi2oAiaL85g66YhTvPpe+R4hUiv5D8J8g8IgFq3XjSgd3dZlud96gU7bp0ziAp/BS+4CTmI9IaTS5j/ha4jdk6LTyAuOXJd57oc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xNWFUz7V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xNWFUz7V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3058C113CF;
	Tue, 26 Aug 2025 14:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217458;
	bh=0cWPbGFxune0xI0353paFKAmBpl5c42HNnXqlr/dPHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xNWFUz7VY1BLpnQqd6kp0Km8dqaGmuTLl0GVW7/eVmqNLrzpn9Rx212bI2Q4Nnb6W
	 tOedi1Nm/LzvvwWrkvlkR2YEzfTfuMcj2/aASI9K1yTmYhhv/msljaFl0ALXPYOm77
	 8J8IfLrlIm9l9rAJaigrE4J8Redr4A6+PFk4C25w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 151/523] rtc: hym8563: fix incorrect maximum clock rate handling
Date: Tue, 26 Aug 2025 13:06:01 +0200
Message-ID: <20250826110928.209455502@linuxfoundation.org>
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

[ Upstream commit d0a518eb0a692a2ab8357e844970660c5ea37720 ]

When hym8563_clkout_round_rate() is called with a requested rate higher
than the highest supported rate, it currently returns 0, which disables
the clock. According to the clk API, round_rate() should instead return
the highest supported rate. Update the function to return the maximum
supported rate in this case.

Fixes: dcaf038493525 ("rtc: add hym8563 rtc-driver")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Link: https://lore.kernel.org/r/20250710-rtc-clk-round-rate-v1-2-33140bb2278e@redhat.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-hym8563.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-hym8563.c b/drivers/rtc/rtc-hym8563.c
index 0fb79c4afb46..b5e76d6ee64b 100644
--- a/drivers/rtc/rtc-hym8563.c
+++ b/drivers/rtc/rtc-hym8563.c
@@ -312,7 +312,7 @@ static long hym8563_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
 		if (clkout_rates[i] <= rate)
 			return clkout_rates[i];
 
-	return 0;
+	return clkout_rates[0];
 }
 
 static int hym8563_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.39.5



