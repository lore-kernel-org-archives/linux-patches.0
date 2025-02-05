Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E99522A;
	Wed,  5 Feb 2025 14:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765683; cv=none; b=jjgfAcpB+hiGFuMbO3LJAWnQcdmONRyuinzlO54QmhPAdfEKgd2vUcxeJAHGt8tg86jLjFYcgeEEdF9ZbFzVQ2qpx3DGLkcnlkLSAoq6XePa0j0VKT7SMFGyuBAFMWTSyfJTsXY24esH6xNukFxogJjoocCDvskDjGVuOpdLntg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765683; c=relaxed/simple;
	bh=3xy1NYJk11gr3d8WjhhtXoiX0Akdv89r9HCnrlWU+d4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlhUy1JG2GOvvjHl0whN1jP3xWzFWnPeb3oX5OHTuQ1h3x4AOmYMzVEGuNuNDoJri4xVVJw0oxjQaFRTJk+JJc+/DsZ4E+qs72iFlMnOrr2mtJ21PFZEQUBjrj1cXeJV/qk0ch0ta1LOdamFCZMS/fzu+Zo5FIyfhFbfJJ/Yo8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=heA1pj8+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="heA1pj8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4750BC4CED1;
	Wed,  5 Feb 2025 14:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765682;
	bh=3xy1NYJk11gr3d8WjhhtXoiX0Akdv89r9HCnrlWU+d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=heA1pj8+ZtfHu0rU4Ym5ClvZvj6CKgHVHRKBE8fc/e6bZbMzjrAV8PQlx+pt7w5TF
	 S2/d3pP+XyzKBHzpuJKrPUFv8Uu5Rgt//XJeMZWLEPHhSr90KVVIflg5+HfuIOhdbt
	 77pKmRI88x+8HpUyflK1Vm70djUWH/MEUOIZoXIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 204/623] wifi: mt76: only enable tx worker after setting the channel
Date: Wed,  5 Feb 2025 14:39:06 +0100
Message-ID: <20250205134504.033989000@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



