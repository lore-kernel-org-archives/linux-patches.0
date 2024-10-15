Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF741C07C2;
	Tue, 15 Oct 2024 12:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997043; cv=none; b=ELz3ptnvtjyMs5RDBSlYsl/jqEe3Y8m7IJEDIpOXrjRZqHzG/L5qK7f970MsitoGzXHDMNOtuf2XNKYpa7dEOOws5JgwSeiYWo2ZjU5nWsLrIlMuG2DNLnUY3C8l0SzuNBnc3bDJiMqySTb5pUIbpWyGwxWKVcQmEmIHxCyyQ3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997043; c=relaxed/simple;
	bh=tayU9T894VW7328J8vlC3wNNykyJCcjNgRtkkCk2K60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oc/oSQ6M79HD7ei9SO2xsr1c9RnA5iT6sGXiFxsJaMgBcOK2SQSo1pF4ZVDutlLMj92Ja2SmXfXtJRn75g0BV5Y4r1y7zd6AAiumI6CfoWKrVKSAq1FjQMDwb6BjQB4nkGpwzW1wKhCpdBudMxMIpYMyEQQZNBtQQPZSFEeX0S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UFsqrenG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFsqrenG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34095C4CEC6;
	Tue, 15 Oct 2024 12:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997043;
	bh=tayU9T894VW7328J8vlC3wNNykyJCcjNgRtkkCk2K60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UFsqrenGN+Wwcu+tCwhZrJaL7NyrzSErIpZW2bfwg4nLj2vzxZWKEj69wn5jTCyy5
	 kUA7BBlSK4wqVow6LQ262ybT4u6fiCP8t478EylYdsFH3bfDc6eM81Jbl5ypuqHUYS
	 +ONsrSn/01PhkWMrUVVheNmQz6Ft9lHDMxgxLMew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/518] wifi: mt76: mt7915: fix rx filter setting for bfee functionality
Date: Tue, 15 Oct 2024 14:39:36 +0200
Message-ID: <20241015123919.783005056@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Howard Hsu <howard-yh.hsu@mediatek.com>

[ Upstream commit 6ac80fce713e875a316a58975b830720a3e27721 ]

Fix rx filter setting to prevent dropping NDPA frames. Without this
change, bfee functionality may behave abnormally.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Link: https://patch.msgid.link/20240827093011.18621-21-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index e78d3efa3fdf4..6495d2edf7dc4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -401,8 +401,7 @@ static void mt7915_configure_filter(struct ieee80211_hw *hw,
 
 	MT76_FILTER(CONTROL, MT_WF_RFCR_DROP_CTS |
 			     MT_WF_RFCR_DROP_RTS |
-			     MT_WF_RFCR_DROP_CTL_RSV |
-			     MT_WF_RFCR_DROP_NDPA);
+			     MT_WF_RFCR_DROP_CTL_RSV);
 
 	*total_flags = flags;
 	mt76_wr(dev, MT_WF_RFCR(band), phy->rxfilter);
-- 
2.43.0



