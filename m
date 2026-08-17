Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B27A43E9FB;
	Mon, 17 Aug 2026 14:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978461; cv=none; b=Gvpag+CB+ETrmIKoIAL+h0kHMPa79wXCsaLvaiQOXnCWcg+hkkuUH+MAtDO5EHHw9stbeDYCo3g0By/xUxy2eD424kX38cpQpT3RgtQgEglzMKfOnGYIVY7qX0xUXbnzV8mQ02lNRuhEzXsmuYTeJZxVD6sbO4VwOf34e5dPM7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978461; c=relaxed/simple;
	bh=8NjgoADk+geBDv5bXuuU2XdRoeA6vb9XrDRM/H6nffU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+jrku7mMuHy8ylLrq1ZWhSb5B/e3lwvixSqFXk5qpXuAYMqwv1/g1IE8A0ULz/3OV9+rLvLUsG4VGlT8wSDKqfJZY+GwQ6AK6kUJvipQ0HOH7H5szJmurS+tafvezd0zmEMju6QIXZbDZFw0KtTnkCiaaAnC+ESsp4Pj2GqQXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pBnvTS2U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pBnvTS2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46181F00A3A;
	Mon, 17 Aug 2026 14:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978459;
	bh=bnKlWM/OWQfbOWarsLRWD6sETtQ0DGQfScm5GtL7cvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pBnvTS2U4Bt0+CQvuDn6U1fPuZbIFwCAdOcvTRsPtGrWMFxODHh/wtqfZzvFEniow
	 o+2pnFZgYKJ4E9py5I/Q+5c35YofH7FNGfiBucv7m+FBRwRYw++4gad3Yy/6v33zJM
	 iL8d7uRWb7VxTUUBmNc56TcHKjbM4i6kM75o02bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Keegan Freyhof <keegan.freyhof@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/156] bnxt_en: Fix PTP PPS setting bug
Date: Mon, 17 Aug 2026 15:32:59 +0200
Message-ID: <20260817132536.363541229@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 404b433f1bc08..d8f39776481b6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -475,12 +475,15 @@ static int bnxt_ptp_enable(struct ptp_clock_info *ptp_info,
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



