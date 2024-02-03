Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70D911720;
	Sat,  3 Feb 2024 04:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933553; cv=none; b=hV4HswFFNzY8q9ReAeWo9Ix6vPwI4ltBJx2tRRxC+Bbo0YHeDKyuUKpNPpRswMUjZGNaBXEpbo2w98boR/TXTtEXsjBiVxbMcdR7V5QfNtWyManP8BfaiFBPR8n5OdSiqytGjY9Ggzb3qbPTdmQBCKLebP/xYikInVvmLCtx8Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933553; c=relaxed/simple;
	bh=1L6TpORxv6XHjOyBHCj9iQJfCAENhhJKTvuEZ6gREdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uk5pRPKGogzCQA/w0gzNOpNE8vfpHjsasJZYrnH41BaYvwZ4HkCW8YsrA0+fgSbDo0oAwdRr9tAplQkOVxdYO95sed6SVMiyYf27fo6YrODBWUb6s9fi12oMYrU6yy9tv2guIYzSkmYA0i5UnCy2348PiSk7HgklIGRfhsS3koA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mg+wcrs/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mg+wcrs/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03A8C433C7;
	Sat,  3 Feb 2024 04:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933553;
	bh=1L6TpORxv6XHjOyBHCj9iQJfCAENhhJKTvuEZ6gREdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mg+wcrs/IyURmIY31a3JHb/27foenhAfPAOgH71fBEfVjxgEeDkU1mb9oUNd13ctY
	 p57MT5JdLCUTthBlwHTh9OMvKER9hITzUU7PkreahvqPKdTX2JBGkIqepkbWQF/qI6
	 g3vqUqp74/Uh/RmPDuYuqKTOdLfcKJxisGmWc+8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MeiChia Chiu <meichia.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/322] wifi: mt76: connac: fix EHT phy mode check
Date: Fri,  2 Feb 2024 20:03:22 -0800
Message-ID: <20240203035402.544282691@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: MeiChia Chiu <meichia.chiu@mediatek.com>

[ Upstream commit 2c2f50bf6407e1fd43a1a257916aeaa5ffdacd6c ]

Add a BSS eht_support check before returning EHT phy mode. Without this
patch, there might be an inconsistency where the softmac layer thinks
the BSS is in HE mode, while the FW thinks it is in EHT mode.

Signed-off-by: MeiChia Chiu <meichia.chiu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 8274a57e1f0f..dc4fbab1e1b7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1347,7 +1347,7 @@ u8 mt76_connac_get_phy_mode_ext(struct mt76_phy *phy, struct ieee80211_vif *vif,
 	sband = phy->hw->wiphy->bands[band];
 	eht_cap = ieee80211_get_eht_iftype_cap(sband, vif->type);
 
-	if (!eht_cap || !eht_cap->has_eht)
+	if (!eht_cap || !eht_cap->has_eht || !vif->bss_conf.eht_support)
 		return mode;
 
 	switch (band) {
-- 
2.43.0



