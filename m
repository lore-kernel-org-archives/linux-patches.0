Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBDE1474CC;
	Tue, 12 Aug 2025 18:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024747; cv=none; b=t9/SA/IhqinPTUksKOxalc/fZEGGMePPTkhEAPsKHbbPdfkkygJXc66AfjNBRMBRbqi30WguVxfXamv/k+mOTpg7Wcc4JZl7+bR5NKi400ATwdCWa4riZj0sgrpqLL76OmDCR0C1gq7eY4sRSpJqHk4jK9ijU0Y2EOW5uqSRBnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024747; c=relaxed/simple;
	bh=ZCsR3H2Bju8FInNyXHyPmkwYCL/Ku2SlRig7OLibgZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEih+K92az+ByEVNEYMwsZwllLtCdPoVmzfw/xrOXtuuFCnZ+ym7Ez7+siaEZtlymPWn7zY3pVJbv+vSL4HjFubRNOUNLMh0BB39l+o8CfTjitQPI2WmyBO37b+VL4RJ8D59mX+4NxPgW3kAI4BzXl47ExOo0QLYfNp+65xLFgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IzbSBOZ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IzbSBOZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A93BC4CEF0;
	Tue, 12 Aug 2025 18:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024747;
	bh=ZCsR3H2Bju8FInNyXHyPmkwYCL/Ku2SlRig7OLibgZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IzbSBOZ3a6xrxZ8Y7mRck2sOOmFGhfDGNgM5PQ5tr6p6Y1G3IphDcOgUuTRDteYfg
	 GaF+zgUMX6ubhJ1dEIM3BIA7hX/rwyLuHejkHqeeiSnV7vdSNUA96g5LiB+xYeIxth
	 2/nyyLhdnStN/mtKZ0aUPdToFPqeNvAIhT4RNWtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 466/627] rtc: hym8563: fix incorrect maximum clock rate handling
Date: Tue, 12 Aug 2025 19:32:41 +0200
Message-ID: <20250812173440.157510959@linuxfoundation.org>
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
index 63f11ea3589d..759dc2ad6e3b 100644
--- a/drivers/rtc/rtc-hym8563.c
+++ b/drivers/rtc/rtc-hym8563.c
@@ -294,7 +294,7 @@ static long hym8563_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
 		if (clkout_rates[i] <= rate)
 			return clkout_rates[i];
 
-	return 0;
+	return clkout_rates[0];
 }
 
 static int hym8563_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.39.5



