Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEED51BE23E;
	Thu,  6 Jun 2024 14:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683531; cv=none; b=CCSgcz3Zx+yzYnG5ifW+TmT23E4ZlwagHYdZ9rjdso9aeb9PyfyjKojaiLdFNPRPKyrwqCEXwhWrf8W00ibje/++93t5eQP3gWlLO2Lslh9Z59oaTzG5REahkWS15s6+7GXXiPcRgdmMVNDwY68uq12yUXb7MaI85kZADMhtixw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683531; c=relaxed/simple;
	bh=wdC8BuKKrK6sbpCyP5tnbMbz7MsObdl6+6j+ZkCrFUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/oFJ6SYYx78drI75A0vzGmEz/BIC+a1i39FMbwDxDY9MH/SdqylMggMTJJeyA+3t04qMlJoEUKGDJZGJN9T4uTOx7giWzEvIOSDamTR8QwE3Fhhj7L4yz+Pm10t6BwMkRRrnzorXCz2VgoNY8uWWaCN5l2NftmChW3x9v9468Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HAfzoA+B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HAfzoA+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED02C2BD10;
	Thu,  6 Jun 2024 14:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683531;
	bh=wdC8BuKKrK6sbpCyP5tnbMbz7MsObdl6+6j+ZkCrFUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HAfzoA+BWaUFe0NAEDrJRBU8wzAPRRU4juETKSOL3syR4AdmH873l0oEp5+tZT1xr
	 2d3N4+RUgXiebl/V9VcunqWVcZmN8W2B6G4yXejW1jqo1rdp6Y51Bhh8D7YQcN4rFG
	 g6BUZWmnBslBB9ZFqaZ5AzI+JByxzrwzK8m0fqj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 422/473] net: fec: avoid lock evasion when reading pps_enable
Date: Thu,  6 Jun 2024 16:05:51 +0200
Message-ID: <20240606131713.721010928@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cffd9ad499dda..e0393dc159fc7 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -102,14 +102,13 @@ static int fec_ptp_enable_pps(struct fec_enet_private *fep, uint enable)
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
@@ -440,6 +439,9 @@ static int fec_ptp_enable(struct ptp_clock_info *ptp,
 	int ret = 0;
 
 	if (rq->type == PTP_CLK_REQ_PPS) {
+		fep->pps_channel = DEFAULT_PPS_CHANNEL;
+		fep->reload_period = PPS_OUPUT_RELOAD_PERIOD;
+
 		ret = fec_ptp_enable_pps(fep, on);
 
 		return ret;
-- 
2.43.0



