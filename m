Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D43B3431FA;
	Tue, 11 Nov 2025 01:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824662; cv=none; b=sLGHidw+bpGvSPemJtQ4guxZsVzDKkMh5Y6GwE6lpFWCyR2liMkSBMBznqxLBo/Ftr6oOAgC9ObKmuxXWgGIlqwkwPbKhFRSCLN7wuFqS5sA6Hhuxr9DqPQZW3L1UEoj/UKBLa9+DCYq84Y5CMMT4eMXEYnmC9gOx+n4bKtrdBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824662; c=relaxed/simple;
	bh=gqgBLKI74qjNKMhxh0kiFPWK2XeXx/0W4PBIzGGqxG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bPtuSeQ44Idy8BxAOJdMOmrNj+ap0rO8I3kj1YXugW1Fj1Vs5wGJo8bT78h9D2aXQKigNLqR7QRWyEAMpM255sryIFP8BXwi4tXNkeEWhmZDPfytiWC66wxEKp14CCFkxFWYffipN5S0wwYdFzQFqB1mLt6Hy5xEuG0ffccCdjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZ7OlwBz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZ7OlwBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CFA1C16AAE;
	Tue, 11 Nov 2025 01:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824659;
	bh=gqgBLKI74qjNKMhxh0kiFPWK2XeXx/0W4PBIzGGqxG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZ7OlwBzolk0Jfg0tGy7A8qizO2cdyhybrbxWKZpDhVttD4/ZmlL/n1BYnps11i+C
	 sHG8je6qBwOpV8Lf9/gxzfK8LXIsjNw+PSD4PQqDSgd4kSTNhXvEH911c/yZi417HX
	 ter55lXG8vyzquZPzNinCySXUwM3AHJPsVRH6U+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 545/849] wifi: mt76: mt7996: disable promiscuous mode by default
Date: Tue, 11 Nov 2025 09:41:55 +0900
Message-ID: <20251111004549.585259182@linuxfoundation.org>
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

From: Peter Chiu <chui-hao.chiu@mediatek.com>

[ Upstream commit a4a66cbaa20f51cb953d09a95c67cb237a088ec9 ]

Set MT_WF_RFCR_DROP_OTHER_UC by default and disable this flag in
mt7996_set_monitor only if monitor mode is enabled.

Without this patch, the MT_WF_RFCR_DROP_OTHER_UC would not be set so the
driver would receive lots of packets meant for other devices.

Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Link: https://patch.msgid.link/20250915075910.47558-10-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index a75b29bada141..5e81edde1e283 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -383,6 +383,7 @@ mt7996_init_wiphy_band(struct ieee80211_hw *hw, struct mt7996_phy *phy)
 
 	phy->slottime = 9;
 	phy->beacon_rate = -1;
+	phy->rxfilter = MT_WF_RFCR_DROP_OTHER_UC;
 
 	if (phy->mt76->cap.has_2ghz) {
 		phy->mt76->sband_2g.sband.ht_cap.cap |=
-- 
2.51.0



