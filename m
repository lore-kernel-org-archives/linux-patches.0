Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64A8299920;
	Sat, 12 Sep 2026 08:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200870; cv=none; b=Jnn7eu3Juf7l6NyUmQkFCXV4oWgdpn4qzGysopo+vvxGetjev+gN5wF7UmQ8pUjmpSxezTDjXMqWJvW5srvsodwVjT1YGO0Y3lY6F42Ts1A6C5iQ/qoapvATlK9fiusL7DV2ELxCQZV6xhD1u7+fIL9kg3P6gCq1916fPdckXLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200870; c=relaxed/simple;
	bh=RzMwTIdf71uVtrEcr42imrJ9nb+HKfIgyzLNTLGcFDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LleQ/el9ZSTwux8KGDIrFOW94SKWwj8vksoQbmu9A0yFEu0wP3daQDmGT+sP1MRMSaKkufaa7mn7KGQhebeoOKJ0F/VhvUoFg2g/2C0DolpVHGGG8y28ZeMUelBAnrZuG3KleiZga46BJfl9175K3Pyu6X58zyUni5nWUzXEkRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pyk4uMCg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pyk4uMCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6E61F000FF;
	Sat, 12 Sep 2026 08:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200869;
	bh=n9GdEl7iyDiUmNDI5YY3xaCegXx6UDsnU/x1Vh9c9P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pyk4uMCga99/sARJod8frOCXEqFTs/T0DtR4XasVJjz4cCVjw4CcJiphA0B8GTV9p
	 hor44Cnr7E1lRtI17uQGJ+rfo/BpaW1kf9RBPC0JgXfE5GUjtskrZQr1XAuxwEy7c1
	 oY88LkTxv2grpEaxkScRF5KCGaA7946iYi1ruNNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0880/1815] wifi: mt76: mt7996: validate RX band_idx before dereferencing phys[]
Date: Sat, 12 Sep 2026 08:43:50 +0200
Message-ID: <20260912065709.578918113@linuxfoundation.org>
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

[ Upstream commit 2243778a5fae8329ab5f18e7adcd7e03b911a1b7 ]

band_idx comes from a 2-bit descriptor field (0-3) and was used directly
to index dev->mt76.phys[] (size __MT_MAX_BAND == 3) and dereference the
result. A corrupt or reserved descriptor value could index out of bounds
or hit a NULL phy on parts with fewer bands. Reject invalid band indices,
mirroring mt7996_rx_get_wcid().

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Link: https://patch.msgid.link/20260722082610.2699628-6-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index b7e46ecefd995..7f915aa20367d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -441,7 +441,13 @@ mt7996_mac_fill_rx(struct mt7996_dev *dev, enum mt76_rxq_id q,
 	memset(status, 0, sizeof(*status));
 
 	band_idx = FIELD_GET(MT_RXD1_NORMAL_BAND_IDX, rxd1);
+	if (!mt7996_band_valid(dev, band_idx))
+		return -EINVAL;
+
 	mphy = dev->mt76.phys[band_idx];
+	if (!mphy)
+		return -EINVAL;
+
 	phy = mphy->priv;
 	status->phy_idx = mphy->band_idx;
 
-- 
2.53.0



