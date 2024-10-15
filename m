Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5BC1EF0AB;
	Tue, 15 Oct 2024 11:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992552; cv=none; b=X9QdOYg29bpriOvR3vCnjSJ4BfRygkbK/jsqFeFbcs+y6BGn3y7TPUu5pdb0nSjd3AZBgBCp/REDJcNZLTAWPmSKMCgVXq4zR8T95CAcZ7/nZezr/5eVA0VEXq/1QHp2zgO4J9symVdsUn0Tpdw4mNSYO+5+2RGqvMljwrDvt54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992552; c=relaxed/simple;
	bh=lZHeOvdoohmm309fEGFhTbEFOxyFeOYLduCKZj7VkIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8wba+awr4GXknirdWeerpJ8iyl9a56DUSM5mxzS1HwP3ZG4lNSMLpVCkI0mgVDsIf6/qYxkfwsyk3LThBEdBhNVjDS1Mq0YIpd/EGrL2c1yWsBgsetixze39qmfp/9mR+yd3nAc7MMH82f6oZY7Xf/E2VmBrMSle1A5DK/vdD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZFM6BgaO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZFM6BgaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A767FC4CECE;
	Tue, 15 Oct 2024 11:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992552;
	bh=lZHeOvdoohmm309fEGFhTbEFOxyFeOYLduCKZj7VkIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZFM6BgaOhaynNJPVBzsX8kigZ5plWI8RRlEecAQFb/a9M64z+6K/aqquNgC36fD8c
	 3KCMB652eRNcPFsVoeGNvFPHK1f7N+ORYLalli4ujY3FlC+6+S/2sDuSpYBjffOhFC
	 7BIljPh/3GIZGWkqyD72nqkQBO+CdHcpCko6HwGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 118/691] wifi: mt76: mt7915: fix rx filter setting for bfee functionality
Date: Tue, 15 Oct 2024 13:21:06 +0200
Message-ID: <20241015112445.042374315@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 09ea97a81fb4f..6e8ad657c65d8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -526,8 +526,7 @@ static void mt7915_configure_filter(struct ieee80211_hw *hw,
 
 	MT76_FILTER(CONTROL, MT_WF_RFCR_DROP_CTS |
 			     MT_WF_RFCR_DROP_RTS |
-			     MT_WF_RFCR_DROP_CTL_RSV |
-			     MT_WF_RFCR_DROP_NDPA);
+			     MT_WF_RFCR_DROP_CTL_RSV);
 
 	*total_flags = flags;
 	mt76_wr(dev, MT_WF_RFCR(band), phy->rxfilter);
-- 
2.43.0



