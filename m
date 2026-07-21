Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156BA2DC76A;
	Tue, 21 Jul 2026 16:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649624; cv=none; b=YDDpa615dFeCcPhdUTY4R4Q+LfbhxT92n2MtE2Orv6t6mCdLEKce5huvjkD4cELmebQ59Iq+wJ5OykfBFQwa/9hQE+FkmqXQ/Wer/p6HR/FeELt02ZXdYZMdiGnRZLe/tEHWxaCWhbwiX3io8eIZC5vyj0MTe3vz2sSU9sr3ESg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649624; c=relaxed/simple;
	bh=kX5QpUc665BNAcp6hli/nGgTQbI7Yen9RdfyeWwzKQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9lEcwJ0rh4hdyTNMFWPtQzYDdH8XAOgV41LJRrlmx3049kimYCaOA/Oj4qgA9A+lHHvbnmA1Y+oYsDyveoZx+eqxBwkSQgAoyXLId7B1AiBdU7gVJXPV3A3m5P/eDMj7OtQ7tbqYiaLaY0plteNyA3FEnJ7lwscf60IEdSpZI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qizX9J1C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qizX9J1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5A61F000E9;
	Tue, 21 Jul 2026 16:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649623;
	bh=wJr9ugRhSfzihteW3sLd7SGFOlYf9n3zCv3nITdQ+Hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qizX9J1CkC/BlvWy2AlYzTJvVYkeEb8z2I72V9XC8VnZquV1NyJkr0I8edtSz8vpx
	 +h3mAzqmUJ8A7Xj+leXPdPQmQ9FHr5mj9rQcs/abVKyIVLEU64H1m5H5olAQGA11E9
	 v6cHPDIExEG7YgnBEcv/DDcalu6wn/da33aVjrf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0593/2077] wifi: mt76: mt7915: fix potential tx_retries underflow
Date: Tue, 21 Jul 2026 17:04:26 +0200
Message-ID: <20260721152606.796578503@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index cec2c4208255fd..334c19ab2b22ca 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -912,16 +912,16 @@ mt7915_mac_tx_free(struct mt7915_dev *dev, void *data, int len)
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



