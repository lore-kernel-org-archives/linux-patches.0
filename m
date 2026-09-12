Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FCE23BD06;
	Sat, 12 Sep 2026 14:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224364; cv=none; b=ugIJBakxKM80LEfEaOyBRODu+tTEB1gHymVdnvwPSyP8HI9QCqia+ed6rGBikJmL5D5RWVP59xl+QKcO1F3N6CIF1/WiNVJo5+35r7BjbWAASFVz+wGmplTN/FoxqjkAVRCkgMafDJsJuyr1QAyGMwgMRCU8ypwXwcw38Mt95IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224364; c=relaxed/simple;
	bh=GJ5KZ9sOTM/Wu+DpwAUJ+nkPSYpPHkzbHmPQnsov38U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDSTMKT0nlMbw0Q7CX31el5Gl7MY9z21pC+f+8IrPGDP8DVooOpROjionWYflprBas+fGEoYgzgNYdDWT4YRlEyiTmqhgToHOUTO/b8ULhaFxsTV/l4WHDPySD2XlvVGvFX5X897wnfFhkfNAsvwp8opRyy1C8WIvq2V9aAKrA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/BfHngL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/BfHngL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E0D1F000FF;
	Sat, 12 Sep 2026 14:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224363;
	bh=g/11l17lrImbCp/hsKoDhOK8M2s0tAmLYha5Xr/qL8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q/BfHngLXzM9qy44eP1xn5wpdNGYzR9gTSHxDvLxoEY1JsGqzmY3TGncDtxSn2IKa
	 WqDq1ND3aOYXRg6DfJXrbhnypsYrwvFsKOS24R8q9xBRGABYSJCl+agLg2lelNvqeR
	 1bHlXpLw/UPaqK9foltIeVXou1S28EJDSAw2DrzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0978/1424] wifi: mt76: mt7996: reserve space for the CSA-abort countdown TLV
Date: Sat, 12 Sep 2026 08:56:50 +0200
Message-ID: <20260912065629.216689164@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 50c66bab321140c49aa2ed779a3ec9d2f085b458 ]

When a CSA countdown is active, mt7996_mcu_beacon_cntdwn() emits two
bss_bcn_cntdwn_tlv entries (the CSA countdown and the CCA-abort BCC), but
MT7996_BEACON_UPDATE_SIZE only reserved one. With MBSSID enabled and a
near-maximum beacon template the extra 8 bytes could push the offload
command past MT7996_MAX_BSS_OFFLOAD_SIZE and trigger skb_over_panic().
Reserve room for both countdown TLVs.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Link: https://patch.msgid.link/20260724124813.3961474-8-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
index fee79666fe162..70f65350111d2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -591,7 +591,7 @@ enum {
 #define MT7996_BEACON_UPDATE_SIZE	(sizeof(struct bss_req_hdr) +		\
 					 sizeof(struct bss_bcn_content_tlv) +	\
 					 4 + MT_TXD_SIZE +			\
-					 sizeof(struct bss_bcn_cntdwn_tlv) +	\
+					 sizeof(struct bss_bcn_cntdwn_tlv) * 2 +	\
 					 sizeof(struct bss_bcn_mbss_tlv))
 #define MT7996_MAX_BSS_OFFLOAD_SIZE	(MT7996_MAX_BEACON_SIZE +		\
 					 MT7996_BEACON_UPDATE_SIZE)
-- 
2.53.0



