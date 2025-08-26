Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F898352FDB;
	Tue, 26 Aug 2025 14:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218786; cv=none; b=LXQjFRCmBSCWuFQ9fZZp2b/riZOwDaRdKpipTdmFgFwZWjrxdUnB2+NXkb1s8RxjFZ/aP8qZS9rfVNdm8l0RH0N4aNlhJzVLOpTiV4MOZ+w9XetjJ1e2KlHNOgwmYpCINO1pSt6I6ssj+6teHiFzowgs53puSthK1lsbb1Hk1kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218786; c=relaxed/simple;
	bh=DJZRV0Yc/k1NOjqilRpNzGyNkuKZ7PRSkLpwV9OVRs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqcDeTrC51xhQMsfcKyFtFi/4CcIAcQjNZciyLwio8sRfg1ABZvojJrq0u3P2yrN6EFYrFQzn7rs44Rh9JdX7dodbkCQ9u77idf1msiFBNaNy4OwyoxpHY7Nk2TYvY7QYhPoJpCp37bKBuRPLBdj90D30m/siQ81t6ONpIp3C0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHPzkhw6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHPzkhw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF65C4CEF1;
	Tue, 26 Aug 2025 14:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218786;
	bh=DJZRV0Yc/k1NOjqilRpNzGyNkuKZ7PRSkLpwV9OVRs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHPzkhw6P1735GXY6MZmbUx51Qswds/oKCNPJMvu+4IORC4lKntFP/U8Z3MSru9ZM
	 o2yZfi9pjz/xdkFAjr/ng3wLayQzAt6g/U8GIEIs4RLzdCXx4/Knch002YxBL859pm
	 OoaaTJ+/GOijD+0EiFLiwy49LE8lQYhZHQ1G0Y2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 133/403] rtc: pcf8563: fix incorrect maximum clock rate handling
Date: Tue, 26 Aug 2025 13:07:39 +0200
Message-ID: <20250826110910.416716288@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 24baa4767b11..9e4fdfe9d86a 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -421,7 +421,7 @@ static long pcf8563_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
 		if (clkout_rates[i] <= rate)
 			return clkout_rates[i];
 
-	return 0;
+	return clkout_rates[0];
 }
 
 static int pcf8563_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.39.5



