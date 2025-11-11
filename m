Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D62234402B;
	Tue, 11 Nov 2025 01:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824668; cv=none; b=InJ9puRyaPkAcU3EO3TTahc4lymOT3dYh1XkhTaZQD3k37Di+PJwBU9NIzfXNCY6F07CL2XKNhJiDWkpNTQEDQ820XZueNm2sgmuWtxteTZ28DIJLUngltBiaaz4zh0AtmMHNpkgKKjjQEqrohc+sebfASjMe4Qx+Cm+NuroeBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824668; c=relaxed/simple;
	bh=gkKwe39/QS2TxLOdU4aCmqThknfEKquFZhyvaB4WKlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZsE8XrIZvBcXCUQJCV1k/8UW/9rgo1rJwuDMiHZTmau4YppGDe9IbYV47rI66Co+3e75qLAVA2JBhTHrLuwPvbIiNpfKmVzRK+tToquVurSJZxCdxFjWmSMsh4nPBAp0YjSwjuKZsauFcyUkufYRB3SkrpbFFryojo25+aWPlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M1v3NJ+W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M1v3NJ+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0C2C4CEFB;
	Tue, 11 Nov 2025 01:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824666;
	bh=gkKwe39/QS2TxLOdU4aCmqThknfEKquFZhyvaB4WKlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M1v3NJ+Wfbtsfk5sXlKbsEISPjb+SiDCF5B6MJMhbDT8YFfUjtjY2/ZMDSYyi4DoD
	 Au22WYEvWY5lol3xpnHozhXqKMeW9o49FdPcDcK9+k7m3QwLCTZlRdyydpdfhJ1/M9
	 /5BZsh2RSSzyI/1+mGD8S0ZgSN2t1N1aVjGgSOpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 546/849] wifi: mt76: use altx queue for offchannel tx on connac+
Date: Tue, 11 Nov 2025 09:41:56 +0900
Message-ID: <20251111004549.607173568@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 12911593efa97abc27b75e98c530b8b1193c384b ]

This ensures that packets are sent out immediately and are not held by
firmware internal buffering.

Link: https://patch.msgid.link/20250915075910.47558-9-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 8ab5840fee57f..b78ae6a34b658 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -618,7 +618,8 @@ mt76_txq_schedule_pending_wcid(struct mt76_phy *phy, struct mt76_wcid *wcid,
 		    !(info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP) &&
 		    !ieee80211_is_data(hdr->frame_control) &&
 		    (!ieee80211_is_bufferable_mmpdu(skb) ||
-		     ieee80211_is_deauth(hdr->frame_control)))
+		     ieee80211_is_deauth(hdr->frame_control) ||
+		     head == &wcid->tx_offchannel))
 			qid = MT_TXQ_PSD;
 
 		q = phy->q_tx[qid];
-- 
2.51.0



