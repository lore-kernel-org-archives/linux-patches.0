Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE05A3B47D3;
	Tue, 21 Jul 2026 20:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666022; cv=none; b=TZW4esj84vaVNH3EfrrWwX0hWLGjwwhMed3WAg+32hUR8VHfFTWgcXOSrwI0fazPq9HRIfCxW99RUzGEsfQHGxBNAd7OtaEuWQbxXtpQlcjxk2ruqbcFI7lCfT38k38jRrIPmdBJUfF6y3nqs6S6ZssztHbE+imQwxW1nFse8Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666022; c=relaxed/simple;
	bh=qHHM+/iMJrRecBranSxmavYOjOkfNCkm/x7i07NGqHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CpoFAxkPshqaTtAVoOsBiAGZ/ZqGUHzBALNIbxLoS0MZuzOQaH5naq6+AdnKxkFxQ5t1Y/dETLreqWOScOXBqtlAHfjeYXJIsJLR0C+vwsjxiwdkvuzxHUdRI9C3KCzavPAHRFnHinKKMYLOuZA7FYyI1HDaQ3f4SVH3b6LgzcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CSip/lbN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CSip/lbN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6A41F000E9;
	Tue, 21 Jul 2026 20:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666021;
	bh=/ybz0HwvZl973zau/uVu04wpD+Sq2vDUYH/jDUbK8g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CSip/lbNDItIcs3h4uK8TWczsthxkQS6FHfL/9U/H7RUCqf24AAXyP4wD1l+knklP
	 sqOgjw1l8iYqkbIYurn+D+KxeU8426XLMoYrv9CmtrAid0nMpsjI9swmjsW/MyX5iS
	 dvyjTtge32/8jaQ13fUNRiedb3boRsYTJi9UFx2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0525/1266] wifi: mt76: mt7915: fix potential tx_retries underflow
Date: Tue, 21 Jul 2026 17:16:02 +0200
Message-ID: <20260721152453.600879242@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index e2983dbf05a90e..ae91a9815fd22a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -916,16 +916,16 @@ mt7915_mac_tx_free(struct mt7915_dev *dev, void *data, int len)
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



