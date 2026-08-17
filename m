Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9C8435EC8;
	Mon, 17 Aug 2026 15:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980286; cv=none; b=t65rG32dUzsWiSC9Ah/6lS288Ly/wR/p7G6bxcxx9L5WTL7IB20Qb6sz9abLWv47x1SJVZr5kDyreLui1SGx5e16k+qQIIM05QrNx6BZjV2abTNQ4jy47vVQE7W9rNw+jkmKCQ22U7BOC54Prmp3JyL54lGpYO6kax4eyU7a2g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980286; c=relaxed/simple;
	bh=RzGIH0hbj7jIjMdAzfowc3lzTzqKYM8IEuPZsyxiWho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2NWNAUM7JAuOLSdNgvcJ6Nt2cg/Sxptp0L4G4NjTTs2OJYU+42NLCmFCmysV+8rtUKO2ei+x/2f31UhyG8ut9GyoI4I0kTo2s08ixCsDwTT3xm7sTIaxGzL0tIQsDf2JYtJ6eWMXqpJbdfFUZ851MbTkvJrN+HLxCRBLNLga+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uNWl/AvB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uNWl/AvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96A11F000E9;
	Mon, 17 Aug 2026 15:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980285;
	bh=VSxXSSiQJDcGY82MYv53HLDeu2KMHh4o0l0v32b6R9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uNWl/AvBWf5srEm3NCZRiuFvUN9C2TP45URjMO6effA/V/ptaYGojeuNXMR5PHQvt
	 D8gd/Mmtnp9MZDKhWw1PFYQSgf6dcB1OMpLQu0nAmEM54URjXf8uHMGSuwEx9fMTjP
	 J7Yt/RImt/WBTZHuJzpmDilDhG/QJDYdL9spxKzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Keegan Freyhof <keegan.freyhof@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 519/609] bnxt_en: Fix PTP PPS setting bug
Date: Mon, 17 Aug 2026 15:33:35 +0200
Message-ID: <20260817132601.197723718@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keegan Freyhof <keegan.freyhof@broadcom.com>

[ Upstream commit 80eaf88efec33ac77ed7726d066c4f2f932cc329 ]

The existing driver logic is always turning on PTP_CLK_REQ_PPS
regardless of the "on" parameter passed to bnxt_ptp_enable().
During shutdown, PTP_CLK_REQ_PPS may be turned off and this
bug will do the opposite and may trigger a PCIe PTM request TLP.
On some systems this can trigger a PCIe AER.

Fix it by properly configuring PTP_CLK_REQ_PPS based on the "on"
parameter.

Fixes: 9e518f25802c ("bnxt_en: 1PPS functions to configure TSIO pins")
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Keegan Freyhof <keegan.freyhof@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20260731190937.807270-6-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index 1c888d6c3aee8..850e4c44044ac 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -460,12 +460,15 @@ static int bnxt_ptp_enable(struct ptp_clock_info *ptp_info,
 		return rc;
 	case PTP_CLK_REQ_PPS:
 		/* Configure PHC PPS IN */
-		rc = bnxt_ptp_cfg_pin(bp, 0, BNXT_PPS_PIN_PPS_IN);
+		pin_id = 0;
+		if (!on)
+			break;
+		rc = bnxt_ptp_cfg_pin(bp, pin_id, BNXT_PPS_PIN_PPS_IN);
 		if (rc)
 			return rc;
 		rc = bnxt_ptp_cfg_event(bp, BNXT_PPS_EVENT_INTERNAL);
 		if (!rc)
-			ptp->pps_info.pins[0].event = BNXT_PPS_EVENT_INTERNAL;
+			ptp->pps_info.pins[pin_id].event = BNXT_PPS_EVENT_INTERNAL;
 		return rc;
 	default:
 		netdev_err(ptp->bp->dev, "Unrecognized PIN function\n");
-- 
2.53.0



