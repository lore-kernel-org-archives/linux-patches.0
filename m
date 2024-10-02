Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5F31CFEB0;
	Wed,  2 Oct 2024 13:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875373; cv=none; b=MquTq7U5CPpvV4bp74AHOEOjFHxyabD9WQpD0GhIi6RHg910PY3oVQvgca89D7dWHdzYbpD3Ado36QdZO5cFMDt06dsPZTxsAQi+NmY/DGtO9ykV1RJMDOOzXknIMRebQ2fRboskSbA2XgP3ihfRsBPT96lA7jFS3bm6glvAp2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875373; c=relaxed/simple;
	bh=3Ibo5tNjMCE7bUMYavkYeEF3u+HGfiXhUQK+1blyja4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WvJu+cYJXjf3E8CaWtP0A8L8QZfNB20xxTHNlFHDRjpEy6xzdgogH1rU5BBYff4qZkLlr7WFVhQAnBbddPx7WW9TM9Db/m2huR/2ij4pXLk+szeKc+/d/NaEq76FDWi/5iPcelfiqJdZ3eJRgDutBoNh+/xYfOdS+TUcEc+xiAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vQ9qMRa5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQ9qMRa5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23192C4CEC5;
	Wed,  2 Oct 2024 13:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875373;
	bh=3Ibo5tNjMCE7bUMYavkYeEF3u+HGfiXhUQK+1blyja4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQ9qMRa50+xyfQP3t6u1Mt08k+y7DFR/IoYC6AzYr/8YuIHHhOZ/wWeNsCf3Lf3Er
	 d4NJbVdGWScS2Nj2atvXVnqogdqY2qvU/TpWdw5rR6WDVesUivyrhInbdg0WQXfPzY
	 2ttuKny1whHvGL+8Jf0n89smFFZcpS0yGzAj6zSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 079/695] wifi: mt76: mt7996: fix EHT beamforming capability check
Date: Wed,  2 Oct 2024 14:51:17 +0200
Message-ID: <20241002125825.634769672@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index e68724e54013c..daef014954d02 100644
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



