Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A589B2EA17C;
	Tue, 17 Jun 2025 15:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175986; cv=none; b=tPR5KSzwBB0xMyg/6iWbhwaJWMlEUWJLNOG3Amo72YdblyKzZ52mQOE3TFeoWyHsZpMLAKv+CAfSxXIO2VSP76UawL2CAk2UNk7OKUpXEoGQlcJrkDmsnVe/pgwg2IT/Gj6n4zEB4gbW0R+da71cq4XkAJpXUBYetM8aYKVtK1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175986; c=relaxed/simple;
	bh=JO27YwDsPJD9P3d33giKgOp0YWA1jIQIs1HLJi54WPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5Y0nh6Oikwxtlu18gECGdqEBuiHiKd9MEFYhZRBb7EGTQcsOSYTKjRP4Og6WIYl128We3HX/VuKV6oGiEYX5KyCIIpfXzptx1PSEpu97zFJH9cgovCYMMUTnxBdjZwzJtG89bCkZMlVAUhGe1cwOyHsSq9LjOrfMiLFQ3mKCWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CTJzo+8c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTJzo+8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11571C4CEE3;
	Tue, 17 Jun 2025 15:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175986;
	bh=JO27YwDsPJD9P3d33giKgOp0YWA1jIQIs1HLJi54WPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTJzo+8chcWObHJ8EfRXpdGYVg6PWx0k32UeZI3hET2ZOySX94Uv98xWWbCtAEux8
	 ++gUd507lA1IDw6WfaHj3kseBiRjHnai63XQfRZdAToKm3GYiUEJ2uvgc3ITiRdr1G
	 mErmDPNmnVDh+JOQpeU7A0MagbPOvK1zoGAa74wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 185/512] wifi: mt76: mt7925: prevent multiple scan commands
Date: Tue, 17 Jun 2025 17:22:31 +0200
Message-ID: <20250617152427.140048090@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit 122f270aca2c86d7de264ab67161c845e0691d73 ]

Add a check to ensure only one scan command is active at a time
by testing the MT76_HW_SCANNING state.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250414013954.1151774-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 2396e1795fe17..7ad9e1eaaa8f3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2771,6 +2771,9 @@ int mt7925_mcu_hw_scan(struct mt76_phy *phy, struct ieee80211_vif *vif,
 	struct tlv *tlv;
 	int max_len;
 
+	if (test_bit(MT76_HW_SCANNING, &phy->state))
+		return -EBUSY;
+
 	max_len = sizeof(*hdr) + sizeof(*req) + sizeof(*ssid) +
 				sizeof(*bssid) + sizeof(*chan_info) +
 				sizeof(*misc) + sizeof(*ie);
-- 
2.39.5



