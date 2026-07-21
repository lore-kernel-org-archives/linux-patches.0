Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52479415F24;
	Tue, 21 Jul 2026 17:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656517; cv=none; b=QpTOfvutRD2sUpWt86+IpwL4hBW0fQ5yvFxfkcGXN9DcMgW0NJ+qswPAdC8qI7zr6/RaXsTvxzDpMqSZvCdDBVYxSnB8UjExYr9sLtmhZSIjqbk/X3aOQ9OesPT+QeZiBfaAX6aLuf6vJszzYnSem5KrkW2dS3npJ8Jdn/HfA70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656517; c=relaxed/simple;
	bh=//y5Ku6MJu8fpj/KO2zn05FLeXWjRWAPsTdHHxcU6F0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnygrbDSeBrHtZYa6yGEwDUwTUlS6OVnZ03pWjn8uYhb7rFIE34jxILu8brTXizFagedETEjUGabC66D2GacDp6aaXjSjdEpNJIftRhuzrvtcQaunanWu6T4QY98l4tsCX9+x9BLsXYQZQJtFJ30AaLMS/o8a5dE+1SUWqJG3jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mupp7oE4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mupp7oE4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98131F000E9;
	Tue, 21 Jul 2026 17:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656516;
	bh=qGq1lyQqIPikK7wxkvbi5vH7JUveZi/qxd46MG6zY5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mupp7oE4fQnukIppiv9w+b/6A82pjChDf1ww0auQtbFeX1ksxf7ZqTKiTyA/4r0Zy
	 U3K9cB4TweadKg8CLDdKJkACJJPDcaDqWUVaTrgf+MDR9k46/x7BWZQ2q6DWQ3oQPG
	 5JYjdUeeQbCFCg01DBG/kzCanJyggkkiLSEKJYzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0415/1611] wifi: mt76: mt7996: fix potential tx_retries underflow
Date: Tue, 21 Jul 2026 17:08:51 +0200
Message-ID: <20260721152524.590567173@linuxfoundation.org>
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
index 57f3f358393aa2..29f599a7ad0171 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1398,13 +1398,13 @@ mt7996_mac_tx_free(struct mt7996_dev *dev, void *data, int len)
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



