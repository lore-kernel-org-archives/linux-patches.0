Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50BC3385A5;
	Sat, 12 Sep 2026 12:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216848; cv=none; b=RLxS3xZB51VRL09uY++yWlpndwPqknoXYjWkFW9KOk1EbYLM9ISCHhZvZ1ALVucFbh+mZZoCMzXtJ4y7ZawO0Q/ntSc1iaWqrdWYO3DK6wp0gXQ2TaZbhbMoTbD+2LU7FPL0MZTV9Mb0kDigMk4m3s8Oro66QdBS55J3rTFucBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216848; c=relaxed/simple;
	bh=3r7b0geXvXcVWv5S418LGusF3hakDSylSxxIMtdK1r4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D1Ga+ioZEtfT6TEZid+2nSvjTK8wsVcSv5NYqAYUq7XCm8+XG3lVmJjkMsacXnLmfgW1G/dn5uV729uTc6/YVNF63S/b30muOrog7RorXlgWcRsye5vciM9i/ETg6IgvA14kKVBznLf4PH4wNTRrQatoP/etTcOrSpp2uZ6jL0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJNZ5tYs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJNZ5tYs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8B21F000FF;
	Sat, 12 Sep 2026 12:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216847;
	bh=uEsCTqsK4P14O50yIqZB0kq6eRHvVDgf8o58eRvwCEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wJNZ5tYsj6wnDN5M+Yg6OAbtttL9WIH3IkahJ8HLaEkFM5dXFA7wRhfIjGcanPndO
	 ++jOAs3NmDIbfRe7Z1zdrvYHUGJH3PyHBX29Uc6Oq8sPuqwLbKc9fipoGHrEYbOa/f
	 yJoL4n5rz+590cIUjVKc6L26ruL6g2TJB2/YkIFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0819/1376] wifi: mt76: mt7996: reserve space for the CSA-abort countdown TLV
Date: Sat, 12 Sep 2026 08:54:05 +0200
Message-ID: <20260912065625.798160558@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index ded2fe7210680..ce01f540972bf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -804,7 +804,7 @@ enum {
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



