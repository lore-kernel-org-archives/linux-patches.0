Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071C61FB3;
	Tue, 27 May 2025 17:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367928; cv=none; b=AgvshryKA3x0FA4q/bAdJLI8XMzyt/LfIFvidyatLJljJ6r7eKo4GfBlSqHplo68yG80hNig4oQQQjQilQAL2G99ETQOIC75JUMJQA1eQLmVfN9QSWJ3cXr7hiuMENeqIS2EyGN2YfW6W6thayGzPW/HbePcgtk27BHyTrVW5tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367928; c=relaxed/simple;
	bh=9hD8ao917AwSfQbfxskg4JjCTyClP67iyZbXfryu3Ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mIOebTQfcC1UIN8R2s1wuYvFTXBmZd+p9it6KBoGz2x+ZiGny9AkJrWMG94DwHR4J2IOx4+hHtstjHBmI7tnU1gqJyZJKcAI3eeC/42kFvJSnxUAnxTMI1HBoQVs20XVICEHHvr56qmYlkdhH4MRPVMpE4Fk/VXlpMIZTd57VM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8xxiIEZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8xxiIEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E15C4CEEA;
	Tue, 27 May 2025 17:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367927;
	bh=9hD8ao917AwSfQbfxskg4JjCTyClP67iyZbXfryu3Ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8xxiIEZ1fD/nPSsr4wUMFN9At5oZApLa/KsZ5KmWPWEfVuugIXJr+xgOL8CxTBB9
	 8lIG69XFAIm9xX5lm6fekTkkGfpM7+1OyW/9L/Mmoce3HLCgMyhWWlq5z3fAYQsAlK
	 xR4giu7/2kTlFH3uvTQaxu66DlKFcWrHVKIYnREk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>,
	Nicolas Escande <nico.escande@gmail.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 514/783] wifi: ath12k: use arvif instead of link_conf in ath12k_mac_set_key()
Date: Tue, 27 May 2025 18:25:11 +0200
Message-ID: <20250527162534.073682460@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>

[ Upstream commit 00e4dc11695d48322780812b503314682659e98b ]

Currently, in ath12k_mac_set_key(), if sta is not present, the address is
retrieved from link_conf's bssid or addr member, depending on the interface
type.

When operating as an ML station and during shutdown, link_conf will not be
available. This can result in the following error:

ath12k_pci 0004:01:00.0: unable to access bss link conf in set key for vif AA:BB:CC:DD:EE:FF link 1

The primary purpose of accessing link_conf is to obtain the address for
finding the peer. However, since arvif is always valid in this call, it can
be used instead.

Add change to use arvif instead of link_conf.

A subsequent change will expose this issue but since tear down will give
error, this is included first.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1
Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00130-QCAHKSWPL_SILICONZ-1.97421.5 # Nicolas Escande

Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Signed-off-by: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
Tested-by: Nicolas Escande <nico.escande@gmail.com>
Link: https://patch.msgid.link/20250204-unlink_link_arvif_from_chanctx-v2-5-764fb5973c1a@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 9123ffab55b52..95ad9fefbdfcd 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -4534,9 +4534,6 @@ static int ath12k_mac_set_key(struct ath12k *ar, enum set_key_cmd cmd,
 			      struct ath12k_link_sta *arsta,
 			      struct ieee80211_key_conf *key)
 {
-	struct ath12k_vif *ahvif = arvif->ahvif;
-	struct ieee80211_vif *vif = ath12k_ahvif_to_vif(ahvif);
-	struct ieee80211_bss_conf *link_conf;
 	struct ieee80211_sta *sta = NULL;
 	struct ath12k_base *ab = ar->ab;
 	struct ath12k_peer *peer;
@@ -4553,19 +4550,10 @@ static int ath12k_mac_set_key(struct ath12k *ar, enum set_key_cmd cmd,
 	if (test_bit(ATH12K_FLAG_HW_CRYPTO_DISABLED, &ab->dev_flags))
 		return 1;
 
-	link_conf = ath12k_mac_get_link_bss_conf(arvif);
-	if (!link_conf) {
-		ath12k_warn(ab, "unable to access bss link conf in set key for vif %pM link %u\n",
-			    vif->addr, arvif->link_id);
-		return -ENOLINK;
-	}
-
 	if (sta)
 		peer_addr = arsta->addr;
-	else if (ahvif->vdev_type == WMI_VDEV_TYPE_STA)
-		peer_addr = link_conf->bssid;
 	else
-		peer_addr = link_conf->addr;
+		peer_addr = arvif->bssid;
 
 	key->hw_key_idx = key->keyidx;
 
-- 
2.39.5



