Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF01C3DB634;
	Tue, 21 Jul 2026 17:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656514; cv=none; b=OXszhOguBrrHtY4zFzFtaxyWfq1GvUOreEatZv7qxp/E4h+XTrPyz3vyj2AVQTufj1uFjmfOe8QrW5rGvXkufY364ZDkfxN46GKOxICWgY4bxS22nhgu/6r08GMdMaRA5Q6Hr6/RvrIFbEEZ0rwpVsRtMhDc3ziw2CFT4vF3qiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656514; c=relaxed/simple;
	bh=sqHAbZvrKHe277AdsfichlovaeLQM2pWQUeLSzrYFEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RACp5QhI7iFooPoz2rRylBEakX915OeCThg4vhEtV6kTi0RSVG/gbZwrh/hlb8RdaC+PCpnCZ8o300MMjBelxkc68tuR4pFwOJx7qHCc725Ehn0ytqm7JyUcXoHowsu5OYQZJHod6sbt5g/35HkTQi9MA6IuVGtw3OEQTkNUhhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M05JvXmX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M05JvXmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222CD1F000E9;
	Tue, 21 Jul 2026 17:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656513;
	bh=ZQ2hZaJhGAUmsazZV2y6SVrssfwqa+tFIgkHDswwpZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M05JvXmXvELe3MZqsGHjvraJROyGdXMAnP3+aBtjGRXoyAPpI8MuqFLdtwkJOEqhH
	 ASXBLyMuLKGdE/CDzWXIxyWfTiungfwuZ1s2joaqqk+ECIc1tXqs3Xy7iKZfDwGBuP
	 q4L6ElMQepoAedDaVKLKA/5KmvVvuMFGotL7uXdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0414/1611] wifi: mt76: mt7925: fix potential tx_retries underflow
Date: Tue, 21 Jul 2026 17:08:50 +0200
Message-ID: <20260721152524.566986502@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit 1e1fd84571e62a2961cea44c053340ec5c99b2cb ]

When FIELD_GET returns 0 for the retry count, subtracting 1 causes
an unsigned integer underflow, resulting in tx_retries becoming a
very large value (0xFFFFFFFF for u32).

Fix by checking if count is non-zero before subtracting 1.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Link: https://patch.msgid.link/20260605113306.3485554-3-ryder.lee@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index 86de9ba6cde4f3..d951a46e9d48ce 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -1139,8 +1139,9 @@ mt7925_mac_tx_free(struct mt792x_dev *dev, void *data, int len)
 
 		if (info & MT_TXFREE_INFO_HEADER) {
 			if (wcid) {
-				wcid->stats.tx_retries +=
-					FIELD_GET(MT_TXFREE_INFO_COUNT, info) - 1;
+				u32 count = FIELD_GET(MT_TXFREE_INFO_COUNT, info);
+
+				wcid->stats.tx_retries += count ? count - 1 : 0;
 				wcid->stats.tx_failed +=
 					!!FIELD_GET(MT_TXFREE_INFO_STAT, info);
 			}
-- 
2.53.0



