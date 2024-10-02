Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3FF1D0420;
	Wed,  2 Oct 2024 13:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877503; cv=none; b=GG5eqibjdH7KgGsDkM2J8ll0cLVLMtiMvupFRFnQTHmbya2reZJA55+OckSD09mA4lWYf0yf+VlMhzKDt0tWWWSIAijyGKPBlNnFBmokz1zM7HTlQGXsOZNLeVnBHN8Sig3cR2tWUBNQ4lg2TzSEY5SmeKroojUO9LqA1OM5JbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877503; c=relaxed/simple;
	bh=XFnNRpXeSLszDlMgkCcs17GyJ34vGqQRRboYHMnTfzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ha3og6JOV9nkI4GyYgO60FNtCxpFqHvzw5koB8nusRdV7JyizxtAJ/FuzSwjPXd0ik4kQXzZag/V1u8qo4C/q5Fkutfqgierk4gtHtdOZFFDBASoYdZ3InOUg/YxAY2UjOQGdCWlq0+w9UV4XI6dqrweHGmA7xLQ7JCINykqwkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=caZC/NIX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="caZC/NIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4A4C4CEC2;
	Wed,  2 Oct 2024 13:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877503;
	bh=XFnNRpXeSLszDlMgkCcs17GyJ34vGqQRRboYHMnTfzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=caZC/NIXzt/BrY7DeuL/DGb35COwJnm2FA7yrpfVbiEurJpOoyENeasHlXsA3SYCl
	 Gz5Lnchhe0TGB25g9/4f4s6aIYJKaEDPDHuQcKCe4DjB4WYD1DzNibK3KA3HRoTKjJ
	 wXEcBn1cqmQwZnXFAJmkAtLm7AsqpEw/TYgxllw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 069/634] wifi: mt76: mt7996: fix EHT beamforming capability check
Date: Wed,  2 Oct 2024 14:52:49 +0200
Message-ID: <20241002125813.830446869@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Howard Hsu <howard-yh.hsu@mediatek.com>

[ Upstream commit 9ca65757f0a5b393a7737d37f377d5daf91716af ]

If a VIF acts as a beamformer, it should check peer's beamformee
capability, and vice versa.

Fixes: ba01944adee9 ("wifi: mt76: mt7996: add EHT beamforming support")
Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20240816094635.2391-7-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 7220bcee6fae9..656199161e591 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -1429,10 +1429,10 @@ mt7996_is_ebf_supported(struct mt7996_phy *phy, struct ieee80211_vif *vif,
 
 		if (bfee)
 			return vif->bss_conf.eht_su_beamformee &&
-			       EHT_PHY(CAP0_SU_BEAMFORMEE, pe->phy_cap_info[0]);
+			       EHT_PHY(CAP0_SU_BEAMFORMER, pe->phy_cap_info[0]);
 		else
 			return vif->bss_conf.eht_su_beamformer &&
-			       EHT_PHY(CAP0_SU_BEAMFORMER, pe->phy_cap_info[0]);
+			       EHT_PHY(CAP0_SU_BEAMFORMEE, pe->phy_cap_info[0]);
 	}
 
 	if (sta->deflink.he_cap.has_he) {
-- 
2.43.0



