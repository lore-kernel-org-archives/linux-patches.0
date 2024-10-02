Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701EC1D0429;
	Wed,  2 Oct 2024 13:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875489; cv=none; b=TmFAV3698Moy0HAZXSsezJwtioGBbpRe/LWvyXZfmMiLRfyYCOtjUB/6xof5FsOUtOp5RgEiX7rEdluE0X/Y/6SXNz7c45Vl/LCILvG5bOHMlBLURjZGxRtR2Nic6HNz2TZBeiseOqCBrZvKbHRcDn4HiZNWIe3mtvEZIsA06Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875489; c=relaxed/simple;
	bh=m6dK6KIBYaqcD8RSar094R7YVhWs3gmodrekg7psDAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1GiFyowaCkIXOdXyqd57BFRjx1cLwJ2MUQYHfuB4nBlA4pX/UQAPUOJx+0v04PdQUl135B8K9jV8JUkyQqctNcq3yiUbUU52hbtSg/28jzw9B6M+MIfjgh0p9blhWi48q4bhYxSEZ+VoMS+yGvNOTP7ZY/l5CfgCJyerMBBzik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IGkqTXnl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IGkqTXnl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9736EC4CEC5;
	Wed,  2 Oct 2024 13:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875489;
	bh=m6dK6KIBYaqcD8RSar094R7YVhWs3gmodrekg7psDAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IGkqTXnlw7K64Jo1Z7jvKEhPr5RyRtATpzX6vbVzm20T17As3dOniabUhd443w2tS
	 0BlfCpGkXPabJdvCT5Wy1mSIL6EAllL8X6fMlj66j0MzsbY/tpYzM/ICnNnEkBQPGc
	 v3Sq2a3MpO3Koji7bsKfzIz/oBf3xxFBznNXn4qE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rex Lu <rex.lu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 086/695] wifi: mt76: mt7996: fix handling mbss enable/disable
Date: Wed,  2 Oct 2024 14:51:24 +0200
Message-ID: <20241002125825.913061998@linuxfoundation.org>
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
index daef014954d02..c4c60c60155d3 100644
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



