Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DF4429008;
	Sat, 12 Sep 2026 10:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209061; cv=none; b=j3m8z7yYxGNBVm35ISG6YMv/CNYyGB/DZpawQ+iIjKNvXHntthSieqGwhSEWZ0yImM1x0jUwCBuBl3lRWeIkdjNtzTLVnsDLy8SM0wstaCxtTNnTWAbeQTp5fu6Lohn3hrbvBxBDXdJGWNBy3UpBbZDtHbDqiRMIjQu22zgbiIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209061; c=relaxed/simple;
	bh=0PPVl9ySYmUnQ1R7yuiMagatuOZMLsaXTGRBfGA3lUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRakIKR6OgGVjsJoiWTqSCFc2fQXSKznqcT+SQo2eBuAoxzxoUB7lruUbyEs886XbXZ2/uUfDrK+STiL/T5VZknddFSSqdy+eC8F15PYn+MCA7W1M5vxkEDmfn6nVu3xUQla4La96t4+ZfBcL1Rne2g99dCXJzBGMzjcJFjNkw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/9+CNU6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/9+CNU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5CA1F000FF;
	Sat, 12 Sep 2026 10:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209059;
	bh=eajOybriBqVEea/4J5pbpznAlByG5du1yjItugEXuQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x/9+CNU66ZFMhxU6c3MjJlX9BIiVCxctNRr0LXRSsmLIsjP6Mw1WqJv3hFfpPXP3K
	 3ttL6/BDo7W2J+ZpMf+UB8QoeTz1stk9vHm/8+TzvJpR3AAaW70uVdiXgD/XFssaWW
	 Z3uGW+wSBFpZ9ERZS6dk5u1dx8rvlO3SMXt7gSvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0745/1518] wifi: mt76: mt7996: validate RX band_idx before dereferencing phys[]
Date: Sat, 12 Sep 2026 08:48:34 +0200
Message-ID: <20260912065640.285069536@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 21b3e0b20888f..648c27c1bf66f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -480,7 +480,13 @@ mt7996_mac_fill_rx(struct mt7996_dev *dev, enum mt76_rxq_id q,
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



