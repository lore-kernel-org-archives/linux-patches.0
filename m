Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FDC3955F4;
	Tue, 21 Jul 2026 15:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649528; cv=none; b=LM0UtZaTIADITXn60GY4m4TackGt0umn+7BeeJmFvdXiaGZ0weRnQOxHJi7aMtj/B/Wah/d9C8kcQ+zo2jBUMUx7BsOeDT8EihS26TO9tqmh38rIf0kYrS1W2HLjIJs0uFxLHUa93Od68xdV+BQigJ0ETevm5mndFHBVipsX8xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649528; c=relaxed/simple;
	bh=1kBOxGn3JuojZM8rYVquEta/lNPaaGa6XEth+yYoUfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d9SFcB0ioermjrzP19G11YgtE8DjPmkwpZqOyoqAAzsb0xOPjnyiT78gzn0x85jd+13GgOR7A/eFJQc2/JGyy3LIr1JNL7DoIMyxKr9fx+DmEQKOXNv4EZrBCK9hgS8IXUdxS6bBACEhxEIHClVAUt2PosJOn4Vz3gCCsAEBk9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gSm/9TqR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gSm/9TqR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98821F000E9;
	Tue, 21 Jul 2026 15:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649527;
	bh=SPWyK7hqM1bRIhGhnMOIvXKi9SvdbiYiORuB8pXCZVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gSm/9TqRBboxcgPHlcq3o0tEI1wOC69TyvvU5D9dvUidVBa2IyNRhA5RR6DSJMRSU
	 pQH7wQjOzBPZvfABPTZgGE+QI76att5C82d2vc0LoIG0kaG/Nw4WcHJJECduP6QJlf
	 F9P644G7/oE9kU0GsQzPPRJPMiJoZHH9TdPwqup4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0595/2077] wifi: mt76: mt7925: fix potential tx_retries underflow
Date: Tue, 21 Jul 2026 17:04:28 +0200
Message-ID: <20260721152606.841174365@linuxfoundation.org>
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
index f025c0efeda217..50034d7c04f0cf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -1140,8 +1140,9 @@ mt7925_mac_tx_free(struct mt792x_dev *dev, void *data, int len)
 
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



