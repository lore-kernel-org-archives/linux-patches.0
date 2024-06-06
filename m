Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EED61A1886;
	Thu,  6 Jun 2024 14:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683720; cv=none; b=lhBS+YphB29bLnuKSPdMgG86KqycclbWvK12eluAuFLcfgE+OShrPnA7IHTJOiLzs9oPMjMcpBWx3MUD3RrhTkcwcTcvtRPeFxAfU5Mb7q3MH073NmU56CE6IvmJAU3SXN8CNk7ph260EYWUBxlliD+kHNn2rtwvWVCqWDzxY5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683720; c=relaxed/simple;
	bh=SsXyHRw16sdleyEB1Lh3XsI7RuPM90kvIKRFyssh7eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVoe2jmsunjNGokbo5HLH/wvIkyH6F58axt0m2MaYxkQzvle7I6Nbd7spFeo87C+xqbIhqNVD+mxbULLvYrJ2dZInUdCSdvBOIK4Gpof6AixMy01GiVwpwyPaMvHmBcsKyGdtrJ/EwdYLj39NnakkYiZ6M6BtNlIxHaXC8VNJ+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Obd+40FA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Obd+40FA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F91EC2BD10;
	Thu,  6 Jun 2024 14:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683720;
	bh=SsXyHRw16sdleyEB1Lh3XsI7RuPM90kvIKRFyssh7eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Obd+40FARKgrEdA9V3bB2G7bL0NltN+LcigvBuMipDSMJnU+kgk021nYE+qckWFJH
	 z+Uyfq/3sL1b50qSa9qWiXcaYLmdvdY3xM8ude8ggm33v4nnUfzcWquoCWQ9Gtslx8
	 aO9oPcuaN++GT/yWXpnMvkIERITWJ65o0khD6xYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 662/744] net: fec: avoid lock evasion when reading pps_enable
Date: Thu,  6 Jun 2024 16:05:34 +0200
Message-ID: <20240606131753.693092769@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 3b1c92f8e5371700fada307cc8fd2c51fa7bc8c1 ]

The assignment of pps_enable is protected by tmreg_lock, but the read
operation of pps_enable is not. So the Coverity tool reports a lock
evasion warning which may cause data race to occur when running in a
multithread environment. Although this issue is almost impossible to
occur, we'd better fix it, at least it seems more logically reasonable,
and it also prevents Coverity from continuing to issue warnings.

Fixes: 278d24047891 ("net: fec: ptp: Enable PPS output based on ptp clock")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Link: https://lore.kernel.org/r/20240521023800.17102-1-wei.fang@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_ptp.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 181d9bfbee220..e32f6724f5681 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -104,14 +104,13 @@ static int fec_ptp_enable_pps(struct fec_enet_private *fep, uint enable)
 	struct timespec64 ts;
 	u64 ns;
 
-	if (fep->pps_enable == enable)
-		return 0;
-
-	fep->pps_channel = DEFAULT_PPS_CHANNEL;
-	fep->reload_period = PPS_OUPUT_RELOAD_PERIOD;
-
 	spin_lock_irqsave(&fep->tmreg_lock, flags);
 
+	if (fep->pps_enable == enable) {
+		spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+		return 0;
+	}
+
 	if (enable) {
 		/* clear capture or output compare interrupt status if have.
 		 */
@@ -532,6 +531,9 @@ static int fec_ptp_enable(struct ptp_clock_info *ptp,
 	int ret = 0;
 
 	if (rq->type == PTP_CLK_REQ_PPS) {
+		fep->pps_channel = DEFAULT_PPS_CHANNEL;
+		fep->reload_period = PPS_OUPUT_RELOAD_PERIOD;
+
 		ret = fec_ptp_enable_pps(fep, on);
 
 		return ret;
-- 
2.43.0



