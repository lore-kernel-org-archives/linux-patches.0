Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8121471257;
	Tue, 21 Jul 2026 19:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662022; cv=none; b=NUpPThsZIOOhUd93CSG6MIxY09yBDzjDs+lbgD9tgNi4SxeAEcC8hrH8atlLriPWALM9n4RpZSVQp3b8EFnfTj6VOBC/BnuuBLx3n26KzYkGq/ZetU5EFmfQZ8blj0bZ/jqQ4boCRMbBUsaem1oo+m9HVab0CuLtUkysFe2XZFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662022; c=relaxed/simple;
	bh=xDCnaoD2QiHwxAPkDIbVsuMKXr6Ld7CM0KpEzt5cs3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ep2BTp/WVg4EKxBaCdTicvHkGr17xEjD7DRFx/fLhYC5V1tDxfDCXnhlfgneuJ3E85PxpUgpV0XmkqLNLtXi1b/2mqCtFTbQY4zHhHq79bpbBp8iK6cjSr2vZ6lWxRRgV/BhwBKxok8jbTqHQTJtQN6+nhoyZXsjtqneM1cgv4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VdWckRAN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VdWckRAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A59A1F000E9;
	Tue, 21 Jul 2026 19:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662021;
	bh=D0rDB/DWM/J+o2XtpinbWBSxADTFYQxVKeVSBHyXKfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VdWckRANmOrxXcxOTxd7a38GWqIpWbtJFyExLEsV11zylSQHGMr8Q2/C+FPmyo1Ia
	 jsHktvB8Mr3dfTJXs1cizXIJQjfRYroC49bozQbikQMykQAQcTrWnB/5RbmR+PZDOY
	 f7YNK+4R57SXvYt0Lds32sy2A0J5N49dPul0O6Pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0288/1276] wifi: mt76: mt7996: fix potential tx_retries underflow
Date: Tue, 21 Jul 2026 17:12:11 +0200
Message-ID: <20260721152452.527174572@linuxfoundation.org>
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
index 6f8167bb861367..54bbc871c0bdc4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1155,13 +1155,13 @@ mt7996_mac_tx_free(struct mt7996_dev *dev, void *data, int len)
 			spin_unlock_bh(&mdev->sta_poll_lock);
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



