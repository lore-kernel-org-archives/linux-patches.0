Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDC52E041E;
	Tue, 15 Jul 2025 13:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586873; cv=none; b=N9d2wEP5rhcyuehg8cWm9GCHahTp190LP+TO46teZvo8P5YQJKMpzpPQKRyyoMoILUxyWXQhhNfBoZnre0AtrHMnxiEunpkZ/RfAjtAimc6OVjBob0uQ8d0Cwy52zJL3Mc1zwRXkqDxGobvanu0EuLStaeOVFZyukHW8o1ZXJrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586873; c=relaxed/simple;
	bh=c0WaRU+vKTU2M09OE65CgzjphAIlr6Ab9r40/ldJQqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPBRwL45gTis035yWxRN5eyjR50Hb4weMYyVW8u6sLiJkSVWub6fe6oKNMlwybYjext4/KFGX1TxcOG4WIhcRfDsI5fI3Eo9FyigKqOqz3AVPmoSZ0il7J1TO1DpXCnrXjvCpavB2Yun/iDh0s6HKDC7Wh5wD8gfP2enAaH29Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AbIsDbmw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AbIsDbmw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2F0C4CEE3;
	Tue, 15 Jul 2025 13:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586872;
	bh=c0WaRU+vKTU2M09OE65CgzjphAIlr6Ab9r40/ldJQqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AbIsDbmwnL5if2N+CgfuFRYhhCEkQG4FRj93USTbzaWi2cNZpPLNdseX8bfLG2nS5
	 dji/cKzaoTavzZuydH0TVzS3Gh5DKYaNq3WOU3KtVgF2kVFBkYRUdcvL2C7Xzq2ndy
	 qaJXDk7KZ8S1JGUiU3OefR+aT4NY4jFYTgVlKIyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Lo <michael.lo@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.15 080/192] wifi: mt76: mt7925: fix invalid array index in ssid assignment during hw scan
Date: Tue, 15 Jul 2025 15:12:55 +0200
Message-ID: <20250715130818.133897881@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Lo <michael.lo@mediatek.com>

commit c701574c54121af2720648572efbfe77564652d1 upstream.

Update the destination index to use 'n_ssids', which is incremented only
when a valid SSID is present. Previously, both mt76_connac_mcu_hw_scan()
and mt7925_mcu_hw_scan() used the loop index 'i' for the destination
array, potentially leaving gaps if any source SSIDs had zero length.

Cc: stable@vger.kernel.org
Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Michael Lo <michael.lo@mediatek.com>
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250612062046.160598-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c |    4 ++--
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c      |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1703,8 +1703,8 @@ int mt76_connac_mcu_hw_scan(struct mt76_
 		if (!sreq->ssids[i].ssid_len)
 			continue;
 
-		req->ssids[i].ssid_len = cpu_to_le32(sreq->ssids[i].ssid_len);
-		memcpy(req->ssids[i].ssid, sreq->ssids[i].ssid,
+		req->ssids[n_ssids].ssid_len = cpu_to_le32(sreq->ssids[i].ssid_len);
+		memcpy(req->ssids[n_ssids].ssid, sreq->ssids[i].ssid,
 		       sreq->ssids[i].ssid_len);
 		n_ssids++;
 	}
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2834,8 +2834,8 @@ int mt7925_mcu_hw_scan(struct mt76_phy *
 		if (!sreq->ssids[i].ssid_len)
 			continue;
 
-		ssid->ssids[i].ssid_len = cpu_to_le32(sreq->ssids[i].ssid_len);
-		memcpy(ssid->ssids[i].ssid, sreq->ssids[i].ssid,
+		ssid->ssids[n_ssids].ssid_len = cpu_to_le32(sreq->ssids[i].ssid_len);
+		memcpy(ssid->ssids[n_ssids].ssid, sreq->ssids[i].ssid,
 		       sreq->ssids[i].ssid_len);
 		n_ssids++;
 	}


