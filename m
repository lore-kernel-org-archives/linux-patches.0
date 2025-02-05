Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30AB155333;
	Wed,  5 Feb 2025 14:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765191; cv=none; b=n/pPVURBEX8B7WMGErfMqcHdYMcBGbfMCTUobagJqiom+SeZYvbqqaKigO0aExyO0ootoRJ1s3cnt7LoLTi3d+INQCamSFMM8NssFNUCZcpdHx4N+YMefb90wUPBoJpHVvmvXxeBoorPjU2sypSa+ZcE/kAlwM7VtOAgthBCtKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765191; c=relaxed/simple;
	bh=JPOdZ4Dmb3AWIKQiqrQev7yo3eQM+UTTHA6wvMYRAoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jguR/Kn2AMzIA5RbicPMjyDI1nC6pHLxElfgcHsYm31Po3zpp1WHC+rwtOX1llIypTB8xva5T3mS/UbwgzvP8AUVA9moIJokfMsQcYSFlj8xmWyN3m4SFc13mpOHMxrpDS77MKiYhsjXmAA7r804DYrJBOrMmsUfLINkMSJ4w+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+4oPoef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+4oPoef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4F5C4CEDD;
	Wed,  5 Feb 2025 14:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765191;
	bh=JPOdZ4Dmb3AWIKQiqrQev7yo3eQM+UTTHA6wvMYRAoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y+4oPoefScT+hhs0znMbUFzIYKCp/aj1n0XmxeCBQLGfbtJfHtmJlHENaRGk9KSK3
	 Gv8wjrwX+KBSLcOisdnGXlOkWyobZ84n/XJJsZdKe27mAve6SCZtnefDL9VJqStwvS
	 xv2ozGb/5U8QM8Ivjk79y3zyBmbkh2cFvOqtXMtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 198/590] wifi: mt76: only enable tx worker after setting the channel
Date: Wed,  5 Feb 2025 14:39:13 +0100
Message-ID: <20250205134502.855179300@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 228bc0e79c85269d36cc81e0288e95f2f9ba7ae1 ]

Avoids sending packets too early

Fixes: 0b3be9d1d34e ("wifi: mt76: add separate tx scheduling queue for off-channel tx")
Link: https://patch.msgid.link/20241230194202.95065-8-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 9d5561f441347..0ca83f1a3e3ea 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -958,11 +958,11 @@ int mt76_set_channel(struct mt76_phy *phy, struct cfg80211_chan_def *chandef,
 
 	if (chandef->chan != phy->main_chan)
 		memset(phy->chan_state, 0, sizeof(*phy->chan_state));
-	mt76_worker_enable(&dev->tx_worker);
 
 	ret = dev->drv->set_channel(phy);
 
 	clear_bit(MT76_RESET, &phy->state);
+	mt76_worker_enable(&dev->tx_worker);
 	mt76_worker_schedule(&dev->tx_worker);
 
 	mutex_unlock(&dev->mutex);
-- 
2.39.5



