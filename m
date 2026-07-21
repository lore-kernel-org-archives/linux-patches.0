Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6125F46F4A4;
	Tue, 21 Jul 2026 19:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662017; cv=none; b=iUcT3DKRJ9UdoO2YP4KF3fbLqxT6pKmuo5NaEIRVYSZ06YIkdAew2hpqpUEoHc6hePAGzIZ2uYwtDH4Uh+YAC7tyd03MFuic1zCz/WCQpLEP2STiI4wwqewq6sdMdn4rN7g56+2IPDNjXrsFhutMzk82RAymWcZLTqqA9QWRD+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662017; c=relaxed/simple;
	bh=lwDR4KCJJmFXE0nbU0T2dYhqKLZYkb7nImZ0/E9iJKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fP+sZl+CulVof1zxNGdiCTdhoEwuAnH/4jnql26rjtxVXCBLRRjOhOQeeTnnVlTqarSrMrE5gZ/6Qt5DlDq9hJbyYcohLOpLPYvLobSwd3Jm6CP/zU2lQKHNbIgGmCAyP2pjvEagXgdmGoxk83bji7NdF98lOCBSQh8aRDPFg6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D1Y+wepS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D1Y+wepS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6423C1F00A3A;
	Tue, 21 Jul 2026 19:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662013;
	bh=HP0s6hAr2j75oTNPCn0kw7IKzzMZE47Uq1wauzuPHrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D1Y+wepS+gsjn6y9u04Yo9fcDzUz/TWl4uQDs0XjgG0+ofM2MnaUOwwJ3ZrIsqFzt
	 ja93GQdj2amOBE5JnjYPiwqrqVuDBjzXnIkOkK2Am4UTfty/OhP2uDA6XSnIo67Pnn
	 +HZVgy/owRGWzWQeCgoZoYp9NDaQyxHT9xd2+hhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0285/1276] wifi: mt76: mt7915: fix potential tx_retries underflow
Date: Tue, 21 Jul 2026 17:12:08 +0200
Message-ID: <20260721152452.458807864@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit 05e72b6167970043348bfbe8f72a3b67a38a9f1c ]

When FIELD_GET returns 0 for the retry count, subtracting 1 causes
an unsigned integer underflow, resulting in tx_retries becoming a
very large value (0xFFFFFFFF for u32).

Fix by checking if count is non-zero before subtracting 1.

Fixes: 943e4fb96e6f ("wifi: mt76: mt7915: report tx retries/failed counts for non-WED path")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Link: https://patch.msgid.link/20260605113306.3485554-1-ryder.lee@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index ab31a350ca7354..b058a38a88cf2f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -923,16 +923,16 @@ mt7915_mac_tx_free(struct mt7915_dev *dev, void *data, int len)
 		}
 
 		if (!mtk_wed_device_active(&mdev->mmio.wed) && wcid) {
-			u32 tx_retries = 0, tx_failed = 0;
+			u32 tx_retries = 0, tx_failed = 0, count;
 
 			if (v3 && (info & MT_TX_FREE_MPDU_HEADER_V3)) {
-				tx_retries =
-					FIELD_GET(MT_TX_FREE_COUNT_V3, info) - 1;
+				count = FIELD_GET(MT_TX_FREE_COUNT_V3, info);
+				tx_retries = count ? count - 1 : 0;
 				tx_failed = tx_retries +
 					!!FIELD_GET(MT_TX_FREE_STAT_V3, info);
 			} else if (!v3 && (info & MT_TX_FREE_MPDU_HEADER)) {
-				tx_retries =
-					FIELD_GET(MT_TX_FREE_COUNT, info) - 1;
+				count = FIELD_GET(MT_TX_FREE_COUNT, info);
+				tx_retries = count ? count - 1 : 0;
 				tx_failed = tx_retries +
 					!!FIELD_GET(MT_TX_FREE_STAT, info);
 			}
-- 
2.53.0



