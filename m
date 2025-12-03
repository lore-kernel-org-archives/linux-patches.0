Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0213271F5;
	Wed,  3 Dec 2025 15:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776941; cv=none; b=op33tF6WPHLjscK/6cTCAjLb/ziwlB5MxWhn+TyrjIWc75MImikJB3/KMQRqILQ7RfDuKREXfubsYG5zUgttREaxVI6DOKMPjZyQaA5kEewGswPyQ6Z+XktbiSnI/DGVNlYOZwdzHNd0AMPWDKe/vUZlHT5V1lp7hSOAV7XOMjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776941; c=relaxed/simple;
	bh=rdrSJ6u0LCcCXiDyPtzSEwmgX1fug5KB2CYaSgTU5Sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMNZAXpMmMvf1ZzeVHJlIS7vm31ndvhDBPaZnkLFwWWJlfBmL3cOW35x0p0jCL1PIwc96a2Aj3Fcbxuz5wJet47n+ypnqcwmvMJxIyVdn7S2QqW1hdgbiLDwDhXg1ojFQ1NsWPtQHoiiBhMIa3sPvgWF8NUpm0Z71Z6fizpNyKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U9N+SAwr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U9N+SAwr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66796C116C6;
	Wed,  3 Dec 2025 15:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776940;
	bh=rdrSJ6u0LCcCXiDyPtzSEwmgX1fug5KB2CYaSgTU5Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U9N+SAwrcphgW/2izbwsXV+/QItYQ2T/oEEjnDOfvv8kww9hgXO+Mwox744X8KTcm
	 4F+1jX8NceJB6YAC3Pn7lt2f57fb2DD1BOBUATTmS8r3/tSKSJ/TC1CaC03nCGuBLe
	 MabB0fUIGfqrPJdefy9LOxqQTa4Xx/dax3ICoam0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 032/146] net: fec: do not allow enabling PPS and PEROUT simultaneously
Date: Wed,  3 Dec 2025 16:26:50 +0100
Message-ID: <20251203152347.649470418@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index f31b1626c12f7..ed5d59abeb537 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -128,6 +128,12 @@ static int fec_ptp_enable_pps(struct fec_enet_private *fep, uint enable)
 
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
@@ -571,6 +577,12 @@ static int fec_ptp_enable(struct ptp_clock_info *ptp,
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



