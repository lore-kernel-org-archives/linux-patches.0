Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59669282F29;
	Mon, 17 Aug 2026 15:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979207; cv=none; b=E07Ug8trZyGoMl7eKOLupRgDDX3yNMuWmKnlO8rFU3HuM0GuZig56W+A3d23VspU3mgxsw4Rw/ytymVv/iLAWj8fvBIJHwAydYlIIk0eG4MraID4ycivvu+tE9Dh94C6XnyOrAI1AVPjAH13VEH5gIx8UdJPYLd8uymxyi5A+XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979207; c=relaxed/simple;
	bh=bvP5pkLBfNM0rcUGTDQHHDGs0XOdCjNbwU4ZkNWZ06w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPYZc9cr2NgRmlmXqd+uhkbzwzgi/bB/DArXXzaGj0IsTvJUgoPrfZy2nK07ftzPMET7x/TT5s7lfIDcHfqXksOG6r0esbLJ3/uUCit/Qf8Z68KyxY5yHPXn41A+sQaLjsDGciGFP/svBMOQ1pJIwQCgFhEVgJWo4DuBtbH22BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d+rPyMOU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d+rPyMOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68F01F00A3A;
	Mon, 17 Aug 2026 15:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979206;
	bh=t+oIU3/tX+TDhP0LgkisB+qBf1zYCRLUerezgcYfVdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d+rPyMOUEVmeQ2+uf/xbLtmw+7PoLlGaBYmg1aYf0uKica/jI3czPub4U3adpfi8B
	 MccMF4eXk8+LJP0MF3iz3vPyAC9Mb0ZQhdlt9BQQq/opSTLRhpGLzzCaJxPgzBaM91
	 GyqLa+c389H7mjR2s71DrcDUkDZGvidOq4hZ8JNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 144/609] wifi: mt76: connac: fix possible NULL-pointer deref in mt76_connac_mcu_uni_bss_he_tlv()
Date: Mon, 17 Aug 2026 15:27:20 +0200
Message-ID: <20260817132548.829404361@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6b5bfdbec8b11d..6f4b1a784a0786 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1298,6 +1298,8 @@ mt76_connac_mcu_uni_bss_he_tlv(struct mt76_phy *phy, struct ieee80211_vif *vif,
 	struct bss_info_uni_he *he;
 
 	cap = mt76_connac_get_he_phy_cap(phy, vif);
+	if (!cap)
+		return;
 
 	he = (struct bss_info_uni_he *)tlv;
 	he->he_pe_duration = vif->bss_conf.htc_trig_based_pkt_ext;
-- 
2.53.0



