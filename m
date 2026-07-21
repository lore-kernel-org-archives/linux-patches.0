Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E435C46C4B8;
	Tue, 21 Jul 2026 15:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649558; cv=none; b=uUUZ6elV0Xd6g7u1aUcvuFp6p+gxABSrhCsyVq618AwXhQwSG7+1atyUt8q3rvm2lzfidzMZ1vXTC/0pVxxb8epymGYBXWmCWEdoaxB7+E0Yc1SvmCvDt0bXhAY6LSIFotOt1dFcQCGIbbUmJYlHRUjAK6jTDK7IRc+bsQ4aCTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649558; c=relaxed/simple;
	bh=V5iVdD+3CBPe9mU5RcsCzGWwgYAGxQG4S9Ct1oxIWNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U9PgXiY+j05mE6N2VzH0wOz4YI6ak5//81WcDDyaTiUP7PW5o+yyFeZR6zb2ZSNuZdHnEIYdwXWmO1H59UiMY5usR0KHj/wSkKIDnQzLK0f0YO4m/7qwtUN/jMNWH5g/z87/sDPTYOCm+eOymQqSYISR+WP32uc6LQGEnX9r7Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j3BoY9aj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3BoY9aj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2B11F00A3A;
	Tue, 21 Jul 2026 15:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649556;
	bh=x4r1jYnpSsjDgV0GFMjhi7+3G3u7fvlMlrZZDrvC0ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j3BoY9ajvXMZ7/4zlA2x1SqpBFVrTu3zHyAOICMk1XUo8C5RrQFoxTG5o5PWU8py5
	 8SR3DjAWI/puRz0eJYf2EOSJueteZJJOsZ8lVfAjoQTCEE+lcHWnkZCsn/6TC691Lo
	 WOjmYDh0rRBEsfTl016OuOiUomkJCwu2Knz6GXHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0596/2077] wifi: mt76: mt7996: fix potential tx_retries underflow
Date: Tue, 21 Jul 2026 17:04:29 +0200
Message-ID: <20260721152606.863190018@linuxfoundation.org>
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

[ Upstream commit 4d8bba99d645bcb46a442b18eb42402610cba03a ]

When FIELD_GET returns 0 for the retry count, subtracting 1 causes
an unsigned integer underflow, resulting in tx_retries becoming a
very large value (0xFFFFFFFF for u32).

Fix by checking if count is non-zero before subtracting 1.

Fixes: 2461599f835e ("wifi: mt76: mt7996: get tx_retries and tx_failed from txfree")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Link: https://patch.msgid.link/20260605113306.3485554-4-ryder.lee@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index ffa15f32c250c9..2a0511b2e4d29e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1359,13 +1359,13 @@ mt7996_mac_tx_free(struct mt7996_dev *dev, void *data, int len)
 				cur_info++;
 			continue;
 		} else if (info & MT_TXFREE_INFO_HEADER) {
-			u32 tx_retries = 0, tx_failed = 0;
+			u32 tx_retries = 0, tx_failed = 0, count;
 
 			if (!wcid)
 				continue;
 
-			tx_retries =
-				FIELD_GET(MT_TXFREE_INFO_COUNT, info) - 1;
+			count = FIELD_GET(MT_TXFREE_INFO_COUNT, info);
+			tx_retries = count ? count - 1 : 0;
 			tx_failed = tx_retries +
 				!!FIELD_GET(MT_TXFREE_INFO_STAT, info);
 
-- 
2.53.0



