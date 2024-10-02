Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD7E25771;
	Wed,  2 Oct 2024 13:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875362; cv=none; b=H4C+cfKCH+RV+ZArFcVf5ADyT0jND19Tbsvh8cmVxcTpi6WwvhsZ+/VYwSA395Xq/Otu12+KmE8fOrQUuv7QFmzNLhuEsewmOMTaVYPMQ6F72abyohEzFHa5gscDQEolUOLV3qomDy65B/eCQwd2g8zXOGLNEnWJQ2s78uIvFX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875362; c=relaxed/simple;
	bh=+Cvewbn87NT07y3TkDuT/mr6D/5v+8fc1ixxT6OrgyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADNqsxOVXhae02xSxZYxHL4tfU76LStbQJsC0y2zdDhOb633BRUwfsdjD2p9sQKqyEjlzwA5sPUxjvkQZ59owOcZxpgPN/4eZDTrRzpTwsiBh2zLHFmWRcMKVBBcXM4Wa3yHV3X44fxwksdpmNgSZFDPlIQin3m4HDQcDqUIorY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYQfWsQF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYQfWsQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7960DC4CEC5;
	Wed,  2 Oct 2024 13:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875361;
	bh=+Cvewbn87NT07y3TkDuT/mr6D/5v+8fc1ixxT6OrgyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hYQfWsQF9MFA8xkM7cPdNrrXUOp3j/DZ+eZA61pv2nmaMBjEUDaKq0OfrtQVJr4Px
	 dyJW4e4iF/kgWNyc3J1tJR/vyTs7A7QILbwS6JWwD2G+BdMgmQtIiRShFgVji336Nl
	 k0c8ps+GzZT/d+Emfw/XeGWfX78k3ClNqf3exGnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 076/695] wifi: mt76: mt7996: fix traffic delay when switching back to working channel
Date: Wed,  2 Oct 2024 14:51:14 +0200
Message-ID: <20241002125825.517118837@linuxfoundation.org>
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

From: Peter Chiu <chui-hao.chiu@mediatek.com>

[ Upstream commit 376200f095d0c3a7096199b336204698d7086279 ]

During scanning, UNI_CHANNEL_RX_PATH tag is necessary for the firmware to
properly stop and resume MAC TX queue. Without this tag, HW needs more time
to resume traffic when switching back to working channel.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20240816094635.2391-2-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index bce0820382194..f3f78e11a65f2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -307,6 +307,10 @@ int mt7996_set_channel(struct mt7996_phy *phy)
 	if (ret)
 		goto out;
 
+	ret = mt7996_mcu_set_chan_info(phy, UNI_CHANNEL_RX_PATH);
+	if (ret)
+		goto out;
+
 	ret = mt7996_dfs_init_radar_detector(phy);
 	mt7996_mac_cca_stats_reset(phy);
 
-- 
2.43.0



