Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB7F3ED3B2;
	Tue, 21 Jul 2026 15:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649499; cv=none; b=MbNm3EkRaf35VQJ/tqEQ1zohLquvpFIMnDQvuZlIAzZJBnJ5R1dnLmlZhVo5e4qKjOTzRfVwOrt8RJ8IhA0y5IZ5vzv2sbvM+R3G3Awz8eT6VTHCPowKUIOHXbrT8rkGnR1UnCigJj4tdrt+qG7icFE15Rw12NiGV9lMylEJkws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649499; c=relaxed/simple;
	bh=2FPVZyMIxZtNoDgBS3LH0VxTFMsXQHf9PVg/adRCZKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXNQc9a3zEsjJUNIEGAYsggEVbR+cnIPucbxdFzzoHrbce2nhsnnGSz2Vu7MvXNyUanj6YWNf9/unOVbpmm6exp3+ITXeHngzzAjX/pDmCqHNvFU9GEcUOHKg4ub7XbYxirPqWanjNndYQ4hY1ue11yvm65W8dip+9mlrmsJpDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yOEwFwT2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yOEwFwT2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907321F000E9;
	Tue, 21 Jul 2026 15:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649498;
	bh=JcOrSaEJ7kwew4U3gHILyGIAsZRW++6ae0bGan+HGdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yOEwFwT2p9KLfmY1GufUYxCSH70ovYvVSu67qxMv/loI4qB3Hd0Z13dg1Pin9DloL
	 CBU747qkVqi0FSFY67QFLWb4zjqWAcbvzlIM7Em3MfzIPtwMiGvbIUA5Rescteuy0z
	 ws/c3yht/AYlvteKNVGNeB4udEizA+ywHKE2GK2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0594/2077] wifi: mt76: mt7921: fix potential tx_retries underflow
Date: Tue, 21 Jul 2026 17:04:27 +0200
Message-ID: <20260721152606.819287025@linuxfoundation.org>
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

[ Upstream commit 3c5671ed81b1fff97fa868dae771690599db94f7 ]

When FIELD_GET returns 0 for the retry count, subtracting 1 causes
an unsigned integer underflow, resulting in tx_retries becoming a
very large value (0xFFFFFFFF for u32).

Fix by checking if count is non-zero before subtracting 1.

Fixes: 9aecfa754c7f ("wifi: mt76: mt7921e: report tx retries/failed counts in tx free event")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Link: https://patch.msgid.link/20260605113306.3485554-2-ryder.lee@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index 03b4960db73f0b..668bfa19538078 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -530,8 +530,9 @@ static void mt7921_mac_tx_free(struct mt792x_dev *dev, void *data, int len)
 		stat = FIELD_GET(MT_TX_FREE_STATUS, info);
 
 		if (wcid) {
-			wcid->stats.tx_retries +=
-				FIELD_GET(MT_TX_FREE_COUNT, info) - 1;
+			u32 count = FIELD_GET(MT_TX_FREE_COUNT, info);
+
+			wcid->stats.tx_retries += count ? count - 1 : 0;
 			wcid->stats.tx_failed += !!stat;
 		}
 
-- 
2.53.0



