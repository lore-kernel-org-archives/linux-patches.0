Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A4336CDED;
	Tue, 16 Dec 2025 12:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887976; cv=none; b=GTda7IC0xT43b9AJquOx2ssmgn0Dc3ji7cxim8ROiwqO2Vo2EvOPT79M7MNonX/TSODpKpPxvtb5Dnr1lRos+jCHIeZXntX5878ETFstese/kYSL87ijeRNQLXu3O9fMOK6h6DKt8eO83OyXN26F09S/Hj3ZrJeUaTkGwI0ph5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887976; c=relaxed/simple;
	bh=9ORLiLaPERRfPMKyQV+KYLc2ZX+bd/qjH4EythWCsmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKd9KjZetzyInKwEr3F8gFtsswZFh7W5O4B344A9VZ/8Sz4TqBo/r9RkYu261+ZOhoKseY2XIL0FDRnBjwPpNwudIagYwJ3QM391kW4hGldF4IVb/Z33g3otpN7fTzoux6BWKfgyZUov4c9GhC6fQUCK01xCPnMLt+UC0nwwLsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QIlALCfK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QIlALCfK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6F4C4CEF1;
	Tue, 16 Dec 2025 12:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887975;
	bh=9ORLiLaPERRfPMKyQV+KYLc2ZX+bd/qjH4EythWCsmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QIlALCfKj+bGVOrg/+S56ayF4fL7HLyzMJl2tM/gCdTDGb6dEzjegnt/7S4flRgkh
	 M/cHyuYvES+ENXZ3ZOV0N1KwkXtygYt9sIslcNoZOvZwUMyBnsbytlKQLKmo7zvRCC
	 3Qyte35FTtRbtDNs2XSqt7AJmQZIKnvyiWQxLuFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shayne Chen <shayne.chen@mediatek.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 395/614] wifi: mt76: mt7996: fix using wrong phy to start in mt7996_mac_restart()
Date: Tue, 16 Dec 2025 12:12:42 +0100
Message-ID: <20251216111415.686168299@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit f1e9f369ae42ee433836b24467e645192d046a51 ]

Pass the correct mt7996_phy to mt7996_run().

Fixes: 0a5df0ec47f7 ("wifi: mt76: mt7996: remove redundant per-phy mac80211 calls during restart")
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20251106064203.1000505-11-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index fe31db5440a84..b06728a98a691 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2341,7 +2341,7 @@ mt7996_mac_restart(struct mt7996_dev *dev)
 		if (!test_bit(MT76_STATE_RUNNING, &phy->mt76->state))
 			continue;
 
-		ret = mt7996_run(&dev->phy);
+		ret = mt7996_run(phy);
 		if (ret)
 			goto out;
 	}
-- 
2.51.0



