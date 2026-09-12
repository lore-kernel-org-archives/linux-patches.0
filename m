Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA01229DB64;
	Sat, 12 Sep 2026 10:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209336; cv=none; b=d6hhnvVx8efctXuJInUGXdO0IjXTPFQaQCv/W3aoj6DI9u1C8XGEtvq3GAPMMcrbohLVIbKwEJYJHJabuL1+qnHIRhIQqPhnnYMLcwY1RIkOBvTmtTRpnGoli+i2GB7p3gdVfhz1lIquyKqm+EX7Ij8jf6ysQ4IEDj1TkNovsDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209336; c=relaxed/simple;
	bh=Ly1GiSIIjKJi2HwKABIL1I7zWipXKF2OvrT3Gr8zrWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6tsNTkPp5rh2PpzaRTxavSF31+yEdztF5J+tHChXuoxQddL/VQWicoulGl2Bfa7C70DiP078bFJWZqptX8lUcAkrtISyn0hNamnhjaDHCFiz44IR5h503m8acbINTdxlgK1Qcj79QYWZdOj90P/pZM8dooqmsJDpGFp/tV5dRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lr5vxtjg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lr5vxtjg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3F31F00893;
	Sat, 12 Sep 2026 10:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209335;
	bh=iuhzfDbx5NV3LvQbPstiRuk3iWHWfrGdBDTDhDdOG/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lr5vxtjgKN6tMQSg7V5om1qzkC05U7PcrQcWkt/gYP8DaJQDbjpSRmHJ/mwNvBYWT
	 qqFSmCAQc63vuJ+uGp4KYOtKJ+PXib68a4EKnFjHkwICfirBDQ7zz1RRI8cw7EIkyL
	 1gIE54RvnJLJhlhVy2gfoofQgCF6NQ4GRIvkZmyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0800/1518] wifi: mt76: fix queue assignment for disassoc packets
Date: Sat, 12 Sep 2026 08:49:29 +0200
Message-ID: <20260912065641.530460311@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chiu <chui-hao.chiu@mediatek.com>

[ Upstream commit 3999d15cfcc72a946ec419c4059b0e0cd7860053 ]

Like deauth, a disassoc frame sent to a client in powersave mode can get
stuck in a tx queue along with other buffered frames, filling up hardware
queues with frames that are only released after the WTBL slot is reused
for another client.

Move disassoc packets to the ALTX queue, matching the existing deauth
handling.

Fixes: dedf2ec30fe4 ("wifi: mt76: fix queue assignment for deauth packets")
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Link: https://patch.msgid.link/20260727150434.1778520-11-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 26463d84b7898..28630d75bdb21 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -615,6 +615,7 @@ mt76_txq_schedule_pending_wcid(struct mt76_phy *phy, struct mt76_wcid *wcid,
 		    !ieee80211_is_data(hdr->frame_control) &&
 		    (!ieee80211_is_bufferable_mmpdu(skb) ||
 		     ieee80211_is_deauth(hdr->frame_control) ||
+		     ieee80211_is_disassoc(hdr->frame_control) ||
 		     head == &wcid->tx_offchannel))
 			qid = MT_TXQ_PSD;
 
-- 
2.53.0



