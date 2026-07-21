Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AAE397E80;
	Tue, 21 Jul 2026 20:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666025; cv=none; b=QnV+/BK3ujY8To+3t83gke3gL0U2UJsNtr2EwOJEENp9VU+r6xUwF9XsSmDlSaM/7PmmLq9Sqrjl1Ld7q43XXqDabBE/YGGv58lvJAxF5ma93lkojJWUyK8DUdGC/EObcFoZfiibMAIQBgg1SrQFkCZTYXDJUtS/VwA67LbeseU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666025; c=relaxed/simple;
	bh=6l7HapHScYmtKFDnF4/wkYsiy97qF2hxKYLf9D/dRSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Otq3svQTmZlR6WIgszDMqxexFmMCOy2APuwO5yWAX//BPjusYO7jSsjepcsRTS1VYWDAjZeAxoCFKaL9hFXM3WLN0zCKn8v7B8ZSY+jy0ew+ksGM4VjyFx2kLWPWKBhXWmm8TIctL5hsrN3zJQ7gH4xeEJrOuy90v9tp7dnpNyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZNn93Mdf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZNn93Mdf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD181F000E9;
	Tue, 21 Jul 2026 20:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666024;
	bh=B43mGh0kWYBDOP+AGktrfIUDmcugxIWdegCmdeobHO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZNn93Mdf3tmU0csZssBlsw3GMkmoN2/B0v5i0ZIBpcB1SapoyEHZVfOkAQcy9kJPX
	 Pg3q/2sJFZ8opdfnbzBaDagicK720F/Yje9kGtBHr+g1bmiCsXKRi78zZt2dpegv9B
	 YEWKI2KdQ4yX5U1vN7c2j48cqb+7AZCv222vp5jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0526/1266] wifi: mt76: mt7921: fix potential tx_retries underflow
Date: Tue, 21 Jul 2026 17:16:03 +0200
Message-ID: <20260721152453.623401324@linuxfoundation.org>
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
index cd4eee3749226d..5099e6f79448fc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -536,8 +536,9 @@ static void mt7921_mac_tx_free(struct mt792x_dev *dev, void *data, int len)
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



