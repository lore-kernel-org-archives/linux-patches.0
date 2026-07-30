Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF1D37C92C;
	Thu, 30 Jul 2026 15:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425833; cv=none; b=jU2MTa6YEF4O3dBXc6bgroHr+3wvO+Q515zKFBekNa2zIioytwAbEh6wtHcwK1Xec5bWWz14GXpJ6wfzlGmlw9IXLS2ixrR8XA90eylqBXKHTw2qQiQkvC2Y1RMpn5xN5jKlUYHdJE3a5+xBNy5+Gt1Gj2sF/25PDqms3rqBpoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425833; c=relaxed/simple;
	bh=MWCQO8tLVwtjv+nBU8nGwkzh+q+S0bRRYriiFRgQwwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWlql4sUy/GmKXlm7tT5HL9ysI/wefB8XXJK4ze7YC1q/75F9kAmeMfFd7uiOigeDc0Kx3PkewrbaBYxEu+Bjul/1CEiXnJ/02DljF6TOq0nXmoNmXDJTvnGDHDs7zvq/tfAQ7Xr2Yl5pRCANpMB6wb+aDduLI9MESwjpFGPRTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TbDMG2tZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TbDMG2tZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8655A1F000E9;
	Thu, 30 Jul 2026 15:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425832;
	bh=rczP1GWTf+vQzGV2yBrK1s8r2iB5hGVxcrrEa7MHOgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TbDMG2tZ499Up2HjMUHsaAR9F7RsXiHRUETnOdTHH31ukSeJpwzc83aGdrLprEI14
	 FUgM0DFhObQ4fLl9OXk7hSC87NRzuwN8muHMFKVzmeif/O3FEg2O4a+ir6UvJTqv4W
	 Ay8UCggSqntIDn42eVQudPAbEF3NkKMfJVG0gT6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 207/602] wifi: mt76: connac: fix possible NULL-pointer deref in mt76_connac_mcu_uni_bss_he_tlv()
Date: Thu, 30 Jul 2026 16:09:59 +0200
Message-ID: <20260730141440.305284246@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 462b4a68c4f0f1..b1a7fbedffac5c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1435,6 +1435,8 @@ mt76_connac_mcu_uni_bss_he_tlv(struct mt76_phy *phy, struct ieee80211_vif *vif,
 	struct bss_info_uni_he *he;
 
 	cap = mt76_connac_get_he_phy_cap(phy, vif);
+	if (!cap)
+		return;
 
 	he = (struct bss_info_uni_he *)tlv;
 	he->he_pe_duration = vif->bss_conf.htc_trig_based_pkt_ext;
-- 
2.53.0



