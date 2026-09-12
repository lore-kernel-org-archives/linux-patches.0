Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23E33ACA6F;
	Sat, 12 Sep 2026 10:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209138; cv=none; b=A73KWOLtYxP5XbtupJ4KjxlX7+TymqP5dZL3xhu1y9O5mFPphwIoslTPXe/BrLtejBp4c3nBux43dfSOGHVjoqjI5XSJXNBUtGRaw7LFfTyAJTgB6/Z9aWlbUQfzNmtWRrEH2gSeEJ00k83D1lWHVrdxVXgXYyIp5ViSFVDW29M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209138; c=relaxed/simple;
	bh=lWhx8C82UNWyeBEPJvGy1qFe48DHKY9DPtdwXTw4DLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ScLJ91OHYfSPXg7IYv8gFJbuIJIOyBYEkdN8tnv9NydY4XwjWFd1rtGrcaP5h+6d9tFRiXBPDNuCXiuNZ04HfJSyeQxLbt8H1YpgdD8QI53t8kduADD7kBlFmmY0q4evkSJI2PeEmaZf989Kz8SAjxsmTRqKmQPew7X6hiAWHm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X8c3I8bQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X8c3I8bQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B681F000FF;
	Sat, 12 Sep 2026 10:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209137;
	bh=IvFli7rYyKcqsOsQTUXyLQza7y77ZpuxQa1TRUsQq+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X8c3I8bQK+VMDVt8JGU0J37yddS7KD0BX7/Eg1ybhUTYuB6f2/7lYGphsNMrA1AOc
	 ZRhj383zNeevmGCvgVwte8UlytDSocAbUrVB9KPKOZ30tZkus3zHRjcGLzs1Gpg99H
	 DHTt1MSrYD0YRMAQPrSV/h7e+D7zoFHqKCcTB630=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0760/1518] wifi: mt76: mt7996: dont leak MLD group index on remap alloc failure
Date: Sat, 12 Sep 2026 08:48:49 +0200
Message-ID: <20260912065640.623785765@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 151a6cf0d12f5d333b93b634dbe5834ea0b77ce7 ]

mt7996_change_vif_links() sets the mld_idx_mask group bit before
allocating the remap index. If the remap allocation fails it jumped to
the exit without clearing that bit, permanently consuming one of the 16
MLD group slots. Release the group bit on the error path.

Fixes: 4fb3b4e7d1ca ("wifi: mt76: mt7996: fix MLD group index assignment")
Link: https://patch.msgid.link/20260724124813.3961474-9-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 840a0b7dd20c5..45cdbe727c8b7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -2297,6 +2297,7 @@ mt7996_change_vif_links(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 		idx = get_free_idx(dev->mld_remap_idx_mask, 0, 15) - 1;
 		if (idx < 0) {
+			dev->mld_idx_mask &= ~BIT_ULL(mvif->mld_group_idx);
 			ret = -ENOSPC;
 			goto out;
 		}
-- 
2.53.0



