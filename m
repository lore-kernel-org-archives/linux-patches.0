Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3742E18D62A;
	Sat, 17 Oct 2026 18:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260310; cv=none; b=onP1cpr2fyUFXr2ycf5cSp9e9+3g3ogg5YmJGM81U5pjAK7eMHD8SaS/YUojwuviqhDXJLfwWRFAmanXh2R1oTjq4iDXGkTvRsLIUup5udL49icFhSg75cQYrNsg1R0Zxi/9hIlU7QwEGEKfjkzHETHqArp9omgn4C6ZhZVur2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260310; c=relaxed/simple;
	bh=9Yy2RfeIEudf6iE9wv4VCHPTrtO5wt+XFT0f4MnQHbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbLDRCIj+JB1W/WMqN6BL47vsc+O+6NHOkMUuOB3yzlq8dkcg5DGRV0v61DzsQeEGAb08A0kxaxVeNTj0GVYgoLrzT7e5u1YR7jqTDOfkSqM5fosFy+fTiPMjJykjXB/Khs2kvvraXaBXHw2rf0ggKaIhJ4GBwRQEBtcrrcNSPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FzIFOgMS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FzIFOgMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39FE21F000C4;
	Sat, 17 Oct 2026 18:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260308;
	bh=4cfE9Mdt6YvmR7GM2rkxuJP7NzVFBtbXiJ44k8rhU44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FzIFOgMSVq+bI1W6w17KdbmhXmDx50DIwL6WWc46IP7q9UTzevV6hqRmirxaYNcPD
	 DPny5yW+zeAC2l7mE2xgKDDw+I9GAvSqVkFG3QKysxrsPgHa3EnJEbvTAp2ffanDUU
	 KN/PDdcKT+h00Z3A8MatlGmQCH2EYHm3/lgg+UQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael-CY Lee <michael-cy.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1451/1674] wifi: mt76: fix non-AQL packet accounting for MLO stations
Date: Sat, 17 Oct 2026 18:02:03 +0200
Message-ID: <20261017160508.423443483@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Michael-CY Lee <michael-cy.lee@mediatek.com>

[ Upstream commit 8ae659743ba936b22ecb4620815887728e2820d6 ]

__mt76_tx_queue_skb() overrides the wcid passed by the driver with
sta->drv_priv, so the wcid might incorrectly be changed after TX,
causing wcid->non_aql_packets to be counted on the wrong wcid. For
example, on the AP side, if a station's setup link is the 5G link and
the station uses 2G to transmit a frame, the value of non_aql_packets
is increased on the 5G wcid but decreased on the 2G wcid. Once the
inflated counter exceeds MT_MAX_NON_AQL_PKT, the TX scheduler
permanently refuses to service the station.

Drop the reassignment and account on the wcid used for transmission.
This also records the actual wcid in the queue entry.

Fixes: e1378e5228aa ("mt76: rely on AQL for burst size limits on tx queueing")
Signed-off-by: Michael-CY Lee <michael-cy.lee@mediatek.com>
Link: https://patch.msgid.link/20260722082610.2699628-4-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 47cdccdbed6aa..c1353ee158a3b 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -313,7 +313,6 @@ __mt76_tx_queue_skb(struct mt76_phy *phy, int qid, struct sk_buff *skb,
 	if (idx < 0 || !sta)
 		return idx;
 
-	wcid = (struct mt76_wcid *)sta->drv_priv;
 	q->entry[idx].wcid = wcid->idx;
 
 	if (!non_aql)
-- 
2.53.0



