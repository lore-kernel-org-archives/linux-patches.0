Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762B43750CF;
	Thu, 30 Jul 2026 15:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424068; cv=none; b=Cu9YoRGioVKFL3g0B1/TBaHIK5MjESSHz9quVWzdSAMkOa8QjnK+q8iDFcNAe/B+1vYxR8VP28nCfXAIYNOQFCy/J6NvjtHIo//nYqE7m1IcuFpal/4fqBjbmv1b+0Urm4yooNCXT63NXI6zTpbVp/a/ZYO0plj05Fg4/GHYd1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424068; c=relaxed/simple;
	bh=ulSrpNeJNS5KTFq1obAvVO0j89smAdDFoWeezC98XTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7IA2BAPQHi1FHCvzS+WH2grVe4xDYbbEdzMhcGAlaiLGr0H35zFRqVAQNm42Pt+PIdUmgHL7oY0yxODuW2Qzyv4C732SRTL50zdenjRQGqgBfzOCA/cCD/nk9Frqat9gDlXkKQqD5J9sZZXG80xqMkafN7X93rs9N+9kTiCEcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rrclLQkC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rrclLQkC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21141F000E9;
	Thu, 30 Jul 2026 15:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424067;
	bh=gmb0JPV98Ci40GYfZkG08kLAImmhIoU7c/1NzcbMJr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rrclLQkC7X/fWW18tW+d7b6EYOPoTErvMo7XzWmSomv0zoyYC854hw+T/6QjQXaGU
	 9MhdTaRpOKt8BOhDAZ2IqweYOMGXnI/j7NPcqpgfkJmJYDrrQT/7TsI7clTls/qGuM
	 DmWEpavn/tDeAsOrTTL3mOPkik0c/GlyDbeC88UI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 262/675] wifi: mt76: mt7925: fix possible NULL-pointer deref in mt7925_mcu_bss_he_tlv()
Date: Thu, 30 Jul 2026 16:09:52 +0200
Message-ID: <20260730141450.704030030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 8d1b6738c1ab48c086b17e7994034aca94258931 ]

mt76_connac_get_he_phy_cap routine can theoretically return NULL so
check cap pointer before dereferencing it.

Fixes: c948b5da6bbec ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260621-mt76_connac_get_he_phy_cap-fix-v1-2-ed4ccf7a0363@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index d887aa9a3dff72..647efa963db48d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2706,6 +2706,8 @@ mt7925_mcu_bss_he_tlv(struct sk_buff *skb, struct ieee80211_bss_conf *link_conf,
 	struct tlv *tlv;
 
 	cap = mt76_connac_get_he_phy_cap(phy->mt76, link_conf->vif);
+	if (!cap)
+		return;
 
 	tlv = mt76_connac_mcu_add_tlv(skb, UNI_BSS_INFO_HE_BASIC, sizeof(*he));
 
-- 
2.53.0



