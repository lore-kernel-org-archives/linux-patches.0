Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1C92264A5;
	Tue, 17 Jun 2025 16:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177363; cv=none; b=jwgJsv9F/7PTipHWjBWo6Dss2dCfG4+u79wkmk69xerWOsOXUnxIiqG2KbiLfc9aZIi8cF+2bfqor9DYGWF8QrnQO8tDJIj+yznPis2ZB+d/6b11C26BT5mXMKwy8158t0o1okeLeLeWmCPC1z4ftG5oCBNRuhrGDVDk19yBS58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177363; c=relaxed/simple;
	bh=7fJ0RCRpD/ktiVLFObRbGcNaZw8XW2Fv7KXDZ2lzrDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qdLb+G5fIP5c8inX9rA+fFboGG+EcmUe7pMRKoFzsc/ivmZRZlFglac8kNKUsv6WgE6VL2y5k/IkmO200XqaVCDO294pAiL46sXDf5zmph9ub7qEemNerVyqyd7EG8w/sY/0MrAofbnbNyZGsfYBUlKCUzq5ZeMty9jWhTuptoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aDwYXvjm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aDwYXvjm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC36CC4CEE3;
	Tue, 17 Jun 2025 16:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177363;
	bh=7fJ0RCRpD/ktiVLFObRbGcNaZw8XW2Fv7KXDZ2lzrDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aDwYXvjm6fitP9zXaMgPIqyWd6D5Lx0jhSI4acJWK7C6oAiHf1l6761FUClq2K55f
	 Gh8cOoO4dbuVVO2ZHmLXy9UxnmNVepBXiFZ+URKWReGt1a6h9B6/iN+RWs3ylK/Mz8
	 +CHzCg1MzLzyzptd08d8m3AqNpOLLJ1rDk1aX8XU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Feng Jiang <jiangfeng@kylinos.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 295/780] wifi: mt76: scan: Fix mlink dereferenced before IS_ERR_OR_NULL check
Date: Tue, 17 Jun 2025 17:20:03 +0200
Message-ID: <20250617152503.480424059@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Jiang <jiangfeng@kylinos.cn>

[ Upstream commit 7e1fcf687c2fb22ad25cf3fae322a37452f5f560 ]

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202504011739.HvUKtUUe-lkp@intel.com/
Fixes: 3ba20af886d1 ("wifi: mt76: scan: set vif offchannel link for scanning/roc")
Signed-off-by: Feng Jiang <jiangfeng@kylinos.cn>
Link: https://patch.msgid.link/20250402062415.25434-1-jiangfeng@kylinos.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/channel.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index e7b839e742903..cc2d888e3f17a 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -302,11 +302,13 @@ void mt76_put_vif_phy_link(struct mt76_phy *phy, struct ieee80211_vif *vif,
 			   struct mt76_vif_link *mlink)
 {
 	struct mt76_dev *dev = phy->dev;
-	struct mt76_vif_data *mvif = mlink->mvif;
+	struct mt76_vif_data *mvif;
 
 	if (IS_ERR_OR_NULL(mlink) || !mlink->offchannel)
 		return;
 
+	mvif = mlink->mvif;
+
 	rcu_assign_pointer(mvif->offchannel_link, NULL);
 	dev->drv->vif_link_remove(phy, vif, &vif->bss_conf, mlink);
 	kfree(mlink);
-- 
2.39.5



