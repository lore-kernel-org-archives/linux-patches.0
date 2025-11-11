Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB41A944;
	Tue, 11 Nov 2025 01:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824624; cv=none; b=CUGofZvsePBIndiqly3rmJVP/XtOdwIVG3o8TjrJ4jtkhb178fK6bfN6xz65bb3v96eOWFeFgudDYcgz+iiCM6HFm7XBG93Cs3fFUSr+5JoK8DaxTc66U0ZZb5gR74PVXgPaQtEHmijBneeSPZMTxIgg2oVmMuwvZfxc/veAS6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824624; c=relaxed/simple;
	bh=4riI1w7/zpXtsB4kooB1M0kaejTXeJvCX4o4LoQoYLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8SDi9fFqVr1MeJN0BvmSVmFY6cvgSphDlHSD6KJySblv9SkiKEtOxMvOaTErIrtMVdZajf27HVtiE5zHw+TFrzE9ht38Od9dl1NZ84/MgH5ZQVe3e8h+rUSZAnGr2en1oy9Cdebv89uD2Nmg7fePf9cwYuEGhqlKZnwVYVZpYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AXxcT8Mp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AXxcT8Mp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1A2C116B1;
	Tue, 11 Nov 2025 01:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824624;
	bh=4riI1w7/zpXtsB4kooB1M0kaejTXeJvCX4o4LoQoYLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AXxcT8MpAv6CP1gexcub8qNa9RQFgSi4m3E9WAuVG0D6wpUNBcTOCL078S0Yh0cTm
	 ef0uAt/NT0InUP2VE8fVFcNzArxyr3VSr9YisAO9JTB2y3a87zGy2sEex/PspF2QXh
	 wn7FoV/0bkJYYrgW3iURO9dkL2SpHtCQwzD98KpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Zhou <quan.zhou@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 536/849] wifi: mt76: mt7921: Add 160MHz beamformee capability for mt7922 device
Date: Tue, 11 Nov 2025 09:41:46 +0900
Message-ID: <20251111004549.375436388@linuxfoundation.org>
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

From: Quan Zhou <quan.zhou@mediatek.com>

[ Upstream commit 25ef5b5d02ac03fe8dd91cf25bd011a570fbeba2 ]

Enable 160MHz beamformee support on mt7922 by updating HE capability
element configuration. Previously, only 160MHz channel width was set,
but beamformee for 160MHz was not properly advertised. This patch
adds BEAMFORMEE_MAX_STS_ABOVE_80MHZ_4 capability to allow devices
to utilize 160MHz BW for beamforming.

Tested by connecting to 160MHz-bandwidth beamforming AP and verified
HE capability.

Signed-off-by: Quan Zhou <quan.zhou@mediatek.com>
Link: https://patch.msgid.link/ae637afaffed387018fdc43709470ef65898ff0b.1756383627.git.quan.zhou@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 5881040ac1952..67383c41a3199 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -135,6 +135,8 @@ mt7921_init_he_caps(struct mt792x_phy *phy, enum nl80211_band band,
 			if (is_mt7922(phy->mt76->dev)) {
 				he_cap_elem->phy_cap_info[0] |=
 					IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_160MHZ_IN_5G;
+				he_cap_elem->phy_cap_info[4] |=
+					IEEE80211_HE_PHY_CAP4_BEAMFORMEE_MAX_STS_ABOVE_80MHZ_4;
 				he_cap_elem->phy_cap_info[8] |=
 					IEEE80211_HE_PHY_CAP8_20MHZ_IN_160MHZ_HE_PPDU |
 					IEEE80211_HE_PHY_CAP8_80MHZ_IN_160MHZ_HE_PPDU;
-- 
2.51.0



