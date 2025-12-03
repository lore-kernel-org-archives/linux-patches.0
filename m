Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA396376BD0;
	Wed,  3 Dec 2025 16:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780678; cv=none; b=D5QbEr7SdY3T3gC2GRTFMBeWJDQcmibZlz4hAMtCRrwPSQCRoMb/5TgJmgjji/L9kVCJAxRoM2Y1INCvVpNqQf11RS0y8Nxljs++/bb8AAUulpL/fFgiqH7GukcXb5bO1nyhSDiZTWxCMvHlpt/Yd/4bDn3aqKPSPOFinilSMb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780678; c=relaxed/simple;
	bh=7kglwBD3O/SBuE8jUiKLRNxQdsXmXpi/sQmAcc6/i5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3KOmgEyQHdWOvI5omskQJMtH/rYOzovXNkBXxDNgoYHVEUtuZme+4x5gMIfYZoHNeaCOVWt1hX6cFTIy1U2iwMsFHNAw2p3T4czq+Uz3U/WOZH2oZGA7yAO32W8QVv39I2KpWDprACHGX/bkwGjKgFq4PrSb2EYvaNF6yzBjGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rsfO+/IY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rsfO+/IY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A0DC4CEF5;
	Wed,  3 Dec 2025 16:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780678;
	bh=7kglwBD3O/SBuE8jUiKLRNxQdsXmXpi/sQmAcc6/i5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rsfO+/IYuH7Y8Fg72kvoTMm5P6imkdZ6uF/Vl3MrbUgV42s1FDMMx4XK8sD3uy13g
	 QzauhW/7NPv7XAQ1ah8nFaN5AUcV3CwumRP1qix72HJjcbpz11Sf7gvR+w1840WzeI
	 n1Tmp3lnnL8wCAschbv0gd4uY8uE4EGf1NnH7+uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/132] net: fec: do not allow enabling PPS and PEROUT simultaneously
Date: Wed,  3 Dec 2025 16:28:29 +0100
Message-ID: <20251203152344.416717433@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit c0a1f3d7e128e8d1b6c0fe09c68eac5ebcf677c8 ]

In the current driver, PPS and PEROUT use the same channel to generate
the events, so they cannot be enabled at the same time. Otherwise, the
later configuration will overwrite the earlier configuration. Therefore,
when configuring PPS, the driver will check whether PEROUT is enabled.
Similarly, when configuring PEROUT, the driver will check whether PPS
is enabled.

Fixes: 350749b909bf ("net: fec: Add support for periodic output signal of PPS")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20251125085210.1094306-4-wei.fang@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_ptp.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index a3853fccdc7b6..beb1d98fa741a 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -129,6 +129,12 @@ static int fec_ptp_enable_pps(struct fec_enet_private *fep, uint enable)
 
 	spin_lock_irqsave(&fep->tmreg_lock, flags);
 
+	if (fep->perout_enable) {
+		spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+		dev_err(&fep->pdev->dev, "PEROUT is running");
+		return -EBUSY;
+	}
+
 	if (fep->pps_enable == enable) {
 		spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 		return 0;
@@ -572,6 +578,12 @@ static int fec_ptp_enable(struct ptp_clock_info *ptp,
 			}
 			spin_lock_irqsave(&fep->tmreg_lock, flags);
 
+			if (fep->pps_enable) {
+				dev_err(&fep->pdev->dev, "PPS is running");
+				ret = -EBUSY;
+				goto unlock;
+			}
+
 			if (fep->perout_enable) {
 				dev_err(&fep->pdev->dev,
 					"PEROUT has been enabled\n");
-- 
2.51.0



