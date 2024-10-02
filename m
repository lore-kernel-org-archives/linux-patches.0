Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8AF1D0BB3;
	Wed,  2 Oct 2024 13:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877430; cv=none; b=rtR0YCuhu1sDBDSE+F0Pg2dxYHupY+pk/pd3jx5T7y+3Gl0SVLIJJLzeHKz+vNQyLw57zuHdfnXNUQRkvJxGAEK4PK9BfgEAR0CqSGtmajoc02oeSPvqHShkJq48FbYaGUAkgqaGsJBaC9p0fXo8n/9Ph9OoxRT2O4T7Zskydck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877430; c=relaxed/simple;
	bh=hirYk8uImJ47DZIrbVykZDL9H3cT2AkyBUkGVbjKCuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VeAAfkd9eFB9EMbVzcyMXeDkljWfeOr0oHWq8/CgrzKHsdvrfn2dvvYwge0TWTUBLLJ7LW3gxFhR8h3Xk8oMEylcAcs6fRvZnBPsMacWEPvfBAIUycobx+TPcT7YW155sZoIEVxIsBiHPTvX2EJdD2bR9GQz1ZWW0KaGaVvw3jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PFrOc2EN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PFrOc2EN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56E0C4CEF0;
	Wed,  2 Oct 2024 13:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877430;
	bh=hirYk8uImJ47DZIrbVykZDL9H3cT2AkyBUkGVbjKCuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PFrOc2ENx17tHUvOkXDUMv/devncMTjQ7/7EWVX3QvsMuJlQxoCDB5h1i+r1Eq86+
	 49QnS6EysAsrVWCfU3mUkWzb7w0/7+YG5PfsFE/zOtMLwJQJI9CHtK7a2uud9r/jYJ
	 S4zfBT866OzSWBPaXd9Fp/SCmZgkAVRa+BPR+nGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rex Lu <rex.lu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 076/634] wifi: mt76: mt7996: fix handling mbss enable/disable
Date: Wed,  2 Oct 2024 14:52:56 +0200
Message-ID: <20241002125814.107635453@linuxfoundation.org>
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

From: Rex Lu <rex.lu@mediatek.com>

[ Upstream commit ded1a6d9e13a32d4e8bef0c63accf49b9415ff5f ]

When mbss was previously enabled, the TLV needs to be included when
disabling it again, in order to clear the firmware state.

Fixes: a7908d5b61e5 ("wifi: mt76: mt7996: fix non-main BSS no beacon issue for MBSS scenario")
Signed-off-by: Rex Lu <rex.lu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20240816094635.2391-9-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 656199161e591..161ebf54a46e3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -822,7 +822,7 @@ mt7996_mcu_bss_mbssid_tlv(struct sk_buff *skb, struct ieee80211_vif *vif,
 	struct bss_info_uni_mbssid *mbssid;
 	struct tlv *tlv;
 
-	if (!vif->bss_conf.bssid_indicator)
+	if (!vif->bss_conf.bssid_indicator && enable)
 		return;
 
 	tlv = mt7996_mcu_add_uni_tlv(skb, UNI_BSS_INFO_11V_MBSSID, sizeof(*mbssid));
-- 
2.43.0



