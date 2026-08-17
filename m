Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE11339EF05;
	Mon, 17 Aug 2026 14:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976815; cv=none; b=qceR1l5fiYwsNuKGN29Yl0qo1C4CBcwHNu+PoStP/VtGJ8n7lx6Q8H1eFSklHOi/IPLxfe0+X0J4aoCgWMXpknVGsxbENiM7+mY4prj/z+9krC2mBIHWZbHi8oZF+lDj570+tfnp/0hkOM7l4/Qt3BaqMMSU0Fu0TUP8l8PGCEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976815; c=relaxed/simple;
	bh=ZovKxNbYMs19/9nA73XMfCsz2AGzGsaWX50StUPlyyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbzJaZzMn1pP95pWMaY7OSfhupak4WFz/YjEhDtcAf8WG0YqjZKfY3wU0qsttQcknjL6irqZH2fAVZtUonrYg7qvEEoioLNlNAkN1q1BqCGT8VP3uE563+tGO1WAe7W2FsUvT0ZcZTvyWf4Zi0odcz/nLij1ZPRB9nRiCWwthXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqJiNyM2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqJiNyM2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6831F000E9;
	Mon, 17 Aug 2026 14:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976813;
	bh=XHjUVIDHRRmVGkyS07hE8axkqPwIX8VHwtylz4pkmL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fqJiNyM2W9iDZMIeSQ4tPTdcSOXa58vGDQxqYZ9FZ2mCJKM0RrMhduqHwX8HSDrLj
	 XuNGm79UFqmp5cWhUMdvtObLr8T1Xv+wN45Lo8lwI9jNqeQ5oVJ/KBVrz48H2WkiHg
	 FVOWJ+299FhLNpJpdTDC/vYN7JkeZluHvzzXxTkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/456] wifi: mt76: connac: fix possible NULL-pointer deref in mt76_connac_mcu_uni_bss_he_tlv()
Date: Mon, 17 Aug 2026 15:28:24 +0200
Message-ID: <20260817132544.543404256@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 2c1fb2335f5e3afb34f91bc07ecb63517c328090 ]

mt76_connac_get_he_phy_cap routine can theoretically return NULL so
check cap pointer before dereferencing it.

Fixes: d0e274af2f2e4 ("mt76: mt76_connac: create mcu library")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260621-mt76_connac_get_he_phy_cap-fix-v1-1-ed4ccf7a0363@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index a5dda20f39f3a3..3143b3f2ba6ad9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1191,6 +1191,8 @@ mt76_connac_mcu_uni_bss_he_tlv(struct mt76_phy *phy, struct ieee80211_vif *vif,
 	struct bss_info_uni_he *he;
 
 	cap = mt76_connac_get_he_phy_cap(phy, vif);
+	if (!cap)
+		return;
 
 	he = (struct bss_info_uni_he *)tlv;
 	he->he_pe_duration = vif->bss_conf.htc_trig_based_pkt_ext;
-- 
2.53.0



