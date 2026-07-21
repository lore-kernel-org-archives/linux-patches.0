Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAAD408039;
	Tue, 21 Jul 2026 19:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662020; cv=none; b=nLcA5wfXmwhNskcRqoxfKgiYxT40+UjvdAoS3hQ6ZmE7beVc/vb/VTYybEB8Y4d2bzzCy2uCLYTn8Lzemv83Amh/LFAH+7KsqjUqAcv/IjxxA2waxIc7RM+E2qGHVX5J77IyhF6h/nVg10SYBNuhBoLw65z+m4RJAS35v57Lm9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662020; c=relaxed/simple;
	bh=EdtO5/bLCCv6ekamcfTCIgjrV6pa3YVR+oT0iaOjMVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTDC2MYLiQJH4fTzqA95s1rqMFEhBirnMAHyVjY6vldSFnlbi3k54iIPYEwFRegz1eR2wSKV29YuASoSAkx2SKuB7s+FF/q89phVL/teAktCiqr9t47AvBbiuZRI5oIOnEse/vtUuXLxc6poEbY9BHuG9kOV6zoFoiVSZsEwioY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mT4VUSBA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mT4VUSBA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9321F000E9;
	Tue, 21 Jul 2026 19:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662016;
	bh=G1zvdr1+vnf+ql+leRe9aOGK7J/zuP3L5deeAuZcVss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mT4VUSBAIrWCEaJxUpLnXTd2+trXNAMaoVU2NsH0wmxlqo79Jyo4+DNfMGHvwZ3hO
	 7R7FbNY1W6k4xHpHtOJszr+uk0jZSKRtdlX88f9i8peU/X66Wn/eXmILCYE0ThFfxd
	 LSszkjiKtKWJ0AKXzoBz+7cu49mAixhE7SabboZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0286/1276] wifi: mt76: mt7921: fix potential tx_retries underflow
Date: Tue, 21 Jul 2026 17:12:09 +0200
Message-ID: <20260721152452.482288714@linuxfoundation.org>
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
index bd1455698ebe5f..0c6b6d6c246ee1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -541,8 +541,9 @@ static void mt7921_mac_tx_free(struct mt792x_dev *dev, void *data, int len)
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



