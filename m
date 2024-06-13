Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1581849;
	Thu, 13 Jun 2024 12:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282501; cv=none; b=Z3j2w07WaYvZyM+ho7TS5gH5autmaezWqC/U0iosVIY9OIy3UJgLo3vLUEeSQDFUyLaeaiRArGflEK3z8z+0n0UnB+MgHCWIzyjwnbXxD2M7xKppMHtIx7lYXHcLNFGfDymfAodsQX0weytraOj6vGXfEYgCZvs/Igk2OJXiFTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282501; c=relaxed/simple;
	bh=NcYOZuuh0B41NKHI2MSBpCOYwA4VxUhdDG2Wqadpk94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3qwYN2uEsq4BZc7PV+oLQpUemCExSvFhGjJcSRsbuO7X9eBpxd4sR+S//2KPcLa3DqIy2gODV2bqLaXvhu+VovpEyiGNk0u5Auqn4jsXkJ9EVSdkjcRqhzfbBPGU/ASjwvSXzmfUuoUGe9eShAf59JQspGD6sz+BA821lcPl6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VjmCAFD7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VjmCAFD7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA79C2BBFC;
	Thu, 13 Jun 2024 12:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282501;
	bh=NcYOZuuh0B41NKHI2MSBpCOYwA4VxUhdDG2Wqadpk94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VjmCAFD7qHUp/qZvSGt1X54B8ncfOg9Wzb3GqHaUBT9laEEDn6Le1DvIZvqOnHd7f
	 j9oB/KYvJIuUZxXoFEAS8P2gfiJrKjL/ihif4mArxYP6yoIADpsemXYXrt0S/ve6Rd
	 563vn+p5Zm1GrY9AtD8lCcfb0hli1zpICmKRL9HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 299/402] net: fec: avoid lock evasion when reading pps_enable
Date: Thu, 13 Jun 2024 13:34:16 +0200
Message-ID: <20240613113313.808516858@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c5ae673005908..780fbb3e1ed06 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -103,14 +103,13 @@ static int fec_ptp_enable_pps(struct fec_enet_private *fep, uint enable)
 	u64 ns;
 	val = 0;
 
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
@@ -441,6 +440,9 @@ static int fec_ptp_enable(struct ptp_clock_info *ptp,
 	int ret = 0;
 
 	if (rq->type == PTP_CLK_REQ_PPS) {
+		fep->pps_channel = DEFAULT_PPS_CHANNEL;
+		fep->reload_period = PPS_OUPUT_RELOAD_PERIOD;
+
 		ret = fec_ptp_enable_pps(fep, on);
 
 		return ret;
-- 
2.43.0



