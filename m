Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C175A155A21;
	Wed,  5 Feb 2025 13:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763917; cv=none; b=K/IpXC0eT3qbkaWFcfsDT6ZenUqPwmrfVuv77InZH0y22UyT9rayQFh28HklM3zoWKO+gKU8dZG6EybXkuDuB2ckVsQstz+kkHppNB4bQcA36fVxMEsLQDTuTrxVP9x+iadOg9+mB0wsNrmMt2j1V6895eFqCCLFIKRBVvDoXq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763917; c=relaxed/simple;
	bh=VPg50kikS5cqYe4IPYZlXW49QcmtsG2B/h4Cp8j/SUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxUfn5Ah02M1J2zjbIrSSS//sms9Z+jmYpH7edsOqBoyJd9m9N01w3SSk+3HuVPUXY1xCYssI3B5jgNYq/GWQoMvbGKizDxcsL6tZlzdYGpiVX4EpxGq9R75cIrN7+q/VDHkMnIVYuoNg63FsitPdp2n+M/89FkhqTDMhhMbD88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PepvMHAv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PepvMHAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3108CC4CEE2;
	Wed,  5 Feb 2025 13:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763917;
	bh=VPg50kikS5cqYe4IPYZlXW49QcmtsG2B/h4Cp8j/SUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PepvMHAv1Z4tPfUU5L8WuWiyUoafGpEQuEFwG9HfTRz2AzkBQMzHnX+aoHvw5+AWw
	 PXxrwhBndljK/S5RkV0pRtUvmCfJDSnCtSN+uvml9DBD61GmtL8X5AKa4zXt4SoFBm
	 QlctMF8lHypRkitikoZhsYp/lvNpY8N1Xl5BPzxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/393] wifi: mt76: mt7996: fix rx filter setting for bfee functionality
Date: Wed,  5 Feb 2025 14:40:38 +0100
Message-ID: <20250205134424.846260669@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 858fd2a53877b2e8b1d991a5a861ac34a0f55ef8 ]

Fix rx filter setting to prevent dropping NDPA frames. Without this
change, bfee functionality may behave abnormally.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Link: https://patch.msgid.link/20241230194202.95065-5-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 0e69f0a508616..c559212ea86a7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -474,8 +474,7 @@ static void mt7996_configure_filter(struct ieee80211_hw *hw,
 
 	MT76_FILTER(CONTROL, MT_WF_RFCR_DROP_CTS |
 			     MT_WF_RFCR_DROP_RTS |
-			     MT_WF_RFCR_DROP_CTL_RSV |
-			     MT_WF_RFCR_DROP_NDPA);
+			     MT_WF_RFCR_DROP_CTL_RSV);
 
 	*total_flags = flags;
 	mt76_wr(dev, MT_WF_RFCR(phy->mt76->band_idx), phy->rxfilter);
-- 
2.39.5



