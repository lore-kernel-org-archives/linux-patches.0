Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F3E2C032C;
	Sat, 12 Sep 2026 08:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200972; cv=none; b=ARl5Ouyz8YWL82uQhq5iKQ/25cHeRxnGIK+gDfRo8PsCo7y5QAofEUQqkxUaFPGO9VveJvolIOxnfjbIvpHkVssmdOsTMCMKfLw+jmzbQR9MNafucIqpITFkEoKchqV6Qr9h+dRl+OMD68uuhFf6chffpl6zwBHV23kq4VgyP80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200972; c=relaxed/simple;
	bh=1lmu7SRuIVWIYmr+vO4DoD+nEFkTDXwWg/sPEqVytZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwEnU6wyDh/qH/6N7pfWjEhhiNkMwsA0gHsbqKu4xN4587cLZESZLOSYc3uvJg5IsxAXz/IZfaLQtlG7Ro7dZ86ptaf0I2hwwN0tII7fww81pOReyVIEZCaXEjAnmfh2k/hp2YO11dA2vrTpCKHYpS5yNe9i5a/rYqN5cDKrbsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dfjXtexw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dfjXtexw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8A41F000FF;
	Sat, 12 Sep 2026 08:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200970;
	bh=T6h+D1tu4uCWxH9NHGB6xTLMTN7V/6XLnEkfKFLS7qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dfjXtexw4/IBcEWYw3PeVy9SCKYlutVouIfUnKEJPREhHVlcTDtKGfbE94kot+Lqj
	 SeMqwJfWptVJcHg6xaJM7NHLKsXtEcG7yDiZOJ6SyX4rgkEGR16x8Ku3axHZMLIJne
	 nzgZU76u1nlD+42b1RpbxeBG94Jrbz0o8yIJHp08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0899/1815] wifi: mt76: mt7996: reserve space for the CSA-abort countdown TLV
Date: Sat, 12 Sep 2026 08:44:09 +0200
Message-ID: <20260912065710.025610165@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 8902e16508b75..c673e986ecb52 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -917,7 +917,7 @@ enum {
 #define MT7996_BEACON_UPDATE_SIZE	(sizeof(struct bss_req_hdr) +		\
 					 sizeof(struct bss_bcn_content_tlv) +	\
 					 4 + MT_TXD_SIZE +			\
-					 sizeof(struct bss_bcn_cntdwn_tlv) +	\
+					 sizeof(struct bss_bcn_cntdwn_tlv) * 2 +	\
 					 sizeof(struct bss_bcn_mbss_tlv))
 #define MT7996_MAX_BSS_OFFLOAD_SIZE	2048
 #define MT7996_MAX_BEACON_SIZE		(MT7996_MAX_BSS_OFFLOAD_SIZE - \
-- 
2.53.0



