Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACF13469F4;
	Mon, 18 Aug 2025 13:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525459; cv=none; b=gE8OpKF1HoKF9xJbZuwtWCDZWsIxWpyUYEoy8Vw2UIsIeVrxsBdm7N90Cx7XVQdhlKJZ+c1iYLqPsENZMrCVc7REbgxm1mHuCmI9QmZ8bM+/OEftNwzW9frLSuHHa9GFkoEUEq05HwffnkgFfiq2MX28GGCGz63RK5Gxg4rkfnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525459; c=relaxed/simple;
	bh=bAQnjD3O7VkdbalIPmlnYgtYshvZmruIoRZfx+vyHog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptYeF7gH+sk38Dzwaa+sP26tCjiV2cDmR/220V00QK8NHXqR28Mj4pd/ti14Jw5D1aGgqIbVsjfPtejbC8P7v9IEzK12dDSSEMHi0h6WXEQtm70YZyc0gOUe11upwiOLXfj4Y8CvvUFPzCRsvAeFqrQiUS22Hm3xwOYyvAqvSc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q5To0e18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q5To0e18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A50C4CEEB;
	Mon, 18 Aug 2025 13:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525459;
	bh=bAQnjD3O7VkdbalIPmlnYgtYshvZmruIoRZfx+vyHog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q5To0e18ixsS2CQcmG7sH2nQef6rhwdqBrDhiBGkZ4Lh7ZRhoQ3eFTzz1h8lrwCSq
	 5ShBrWgWqt33YtMIB/9UPjRtjMFDtsVcM+hnREPoIWFvgSiot4XheYR9Xt2YmYudfp
	 exM8N1DAyReH2+MLyESAOLjSfNxCtGg3Cc1BD4Io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 268/570] wifi: mt76: mt7996: Fix mlink lookup in mt7996_tx_prepare_skb
Date: Mon, 18 Aug 2025 14:44:15 +0200
Message-ID: <20250818124516.173722644@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 59ea7af6f9ce218b86f9f46520819247c3a5f97b ]

Use proper link_id in mt7996_tx_prepare_skb routine for mlink lookup.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250704-mt7996-mlo-fixes-v1-5-356456c73f43@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 92148518f6a5..37b21ad828b9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1084,9 +1084,9 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 		if (wcid->offchannel)
 			mlink = rcu_dereference(mvif->mt76.offchannel_link);
 		if (!mlink)
-			mlink = &mvif->deflink.mt76;
+			mlink = rcu_dereference(mvif->mt76.link[wcid->link_id]);
 
-		txp->fw.bss_idx = mlink->idx;
+		txp->fw.bss_idx = mlink ? mlink->idx : mvif->deflink.mt76.idx;
 	}
 
 	txp->fw.token = cpu_to_le16(id);
-- 
2.39.5



