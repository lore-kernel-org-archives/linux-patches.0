Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607D234F48B;
	Wed,  3 Dec 2025 16:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778036; cv=none; b=OmU4rQsMrDPGCdSy4xvGgrdhcYjXVV7N0NaA4i8IV2fbfTVej2my5s2F/sysrslnOnvdAJ/TCGERc/yGfB5jKff+QkM5nUpGdF73rhSSUki+m5waznLVkj02IkFY7QrR8IIxWYwho7cabRu6I1WpKD7IDJq8DjoVDJb84F/PA5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778036; c=relaxed/simple;
	bh=9+QPHg1SMiDjPmvNhT4dLZzmZKTMkvKhWejdMxuZQzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmvg0vi+vWXu9rS6bdpRLOpPAnqc70K4sukQtoee4BEHn9md1SQeFHv0HwkPGdUCLUANLQH/Y2m++mHptUZWshqeidQ2SplIAFt9sf2FanXqippMAveeaJN54fLbKjBTfM+CJdKUyClFLXQG2nBPKYvieSiHqtzP4zM3t01ag2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mQropQfu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mQropQfu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60834C4CEF5;
	Wed,  3 Dec 2025 16:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778035;
	bh=9+QPHg1SMiDjPmvNhT4dLZzmZKTMkvKhWejdMxuZQzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mQropQfuwsJ9JaGISSHMbn1dmvM4UBOn1ymgxs61RixY/cMH9jSCDXC4kfqEXnMZj
	 /BL8yJg6sQKNau+rfGT6Q+9T7p1bgkP3k1o/dotWTibQIX08UuUD+Dwvt9dnbHtmeH
	 8g38ElS7o7Wk+C7r7jLWVM2o+IY31loMhJbVinX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cochran <richardcochran@gmail.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 223/392] bnxt_en: PTP: Refactor PTP initialization functions
Date: Wed,  3 Dec 2025 16:26:13 +0100
Message-ID: <20251203152422.391460978@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

[ Upstream commit 740c342e399981babdd62d0d5beb7c8ec9503a9a ]

Making the ptp free and timecounter initialization code into separate
functions so that later patches can use them.

Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: deb8eb391643 ("bnxt_en: Fix a possible memory leak in bnxt_ptp_init")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 45 +++++++++++++------
 1 file changed, 31 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index a78cc65a38f2f..67717274f6b9e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -732,6 +732,34 @@ static bool bnxt_pps_config_ok(struct bnxt *bp)
 	return !(bp->fw_cap & BNXT_FW_CAP_PTP_PPS) == !ptp->ptp_info.pin_config;
 }
 
+static void bnxt_ptp_timecounter_init(struct bnxt *bp, bool init_tc)
+{
+	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+
+	if (!ptp->ptp_clock) {
+		memset(&ptp->cc, 0, sizeof(ptp->cc));
+		ptp->cc.read = bnxt_cc_read;
+		ptp->cc.mask = CYCLECOUNTER_MASK(48);
+		ptp->cc.shift = 0;
+		ptp->cc.mult = 1;
+		ptp->next_overflow_check = jiffies + BNXT_PHC_OVERFLOW_PERIOD;
+	}
+	if (init_tc)
+		timecounter_init(&ptp->tc, &ptp->cc, ktime_to_ns(ktime_get_real()));
+}
+
+static void bnxt_ptp_free(struct bnxt *bp)
+{
+	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+
+	if (ptp->ptp_clock) {
+		ptp_clock_unregister(ptp->ptp_clock);
+		ptp->ptp_clock = NULL;
+		kfree(ptp->ptp_info.pin_config);
+		ptp->ptp_info.pin_config = NULL;
+	}
+}
+
 int bnxt_ptp_init(struct bnxt *bp)
 {
 	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
@@ -747,23 +775,12 @@ int bnxt_ptp_init(struct bnxt *bp)
 	if (ptp->ptp_clock && bnxt_pps_config_ok(bp))
 		return 0;
 
-	if (ptp->ptp_clock) {
-		ptp_clock_unregister(ptp->ptp_clock);
-		ptp->ptp_clock = NULL;
-		kfree(ptp->ptp_info.pin_config);
-		ptp->ptp_info.pin_config = NULL;
-	}
+	bnxt_ptp_free(bp);
+
 	atomic_set(&ptp->tx_avail, BNXT_MAX_TX_TS);
 	spin_lock_init(&ptp->ptp_lock);
 
-	memset(&ptp->cc, 0, sizeof(ptp->cc));
-	ptp->cc.read = bnxt_cc_read;
-	ptp->cc.mask = CYCLECOUNTER_MASK(48);
-	ptp->cc.shift = 0;
-	ptp->cc.mult = 1;
-
-	ptp->next_overflow_check = jiffies + BNXT_PHC_OVERFLOW_PERIOD;
-	timecounter_init(&ptp->tc, &ptp->cc, ktime_to_ns(ktime_get_real()));
+	bnxt_ptp_timecounter_init(bp, true);
 
 	ptp->ptp_info = bnxt_ptp_caps;
 	if ((bp->fw_cap & BNXT_FW_CAP_PTP_PPS)) {
-- 
2.51.0



