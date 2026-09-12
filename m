Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959DA33689D;
	Sat, 12 Sep 2026 08:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200976; cv=none; b=ZBtwyzfDzEUxeHv4MzLvhmiMY8lYKE8/TotYyDkIf3REzo4z/dozi60lzUYxlCNSFz5mrh9pXXyW7gJ/oJk/jDIiCWbSGSrZvFoa3EL89BKQ88TLPOsqaBCDbB1bVRP2X8i1iNdPOHXuDpgn5AAYO5o/5aDmDc2krrfM92CC9z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200976; c=relaxed/simple;
	bh=4VutmgvFY96B6Y6Gc1UDXjzGLCp6e5FuIh+kgMcEm2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVwMDD/dkEtiHpClMcDhQaud9a+PtfRBkFZ5TpmAseMxjnZ6Q72ZPQUQRAxtWtF4WQbSD8Z4eEoYFKUOEHA3eiUfJ7n94m7PLT+2zSeg1ETIaLkJ1c0y9jIwBlEsF5gHQha9PxVe98Z2/Yv5uHyumQ0B1lTU9pjILk4dfFmvbZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Svj3PWpw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Svj3PWpw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8B91F000FF;
	Sat, 12 Sep 2026 08:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200975;
	bh=Jzti7dyncRRGaXTn0kb2mbDS5QRSI2JewokXbtK4qSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Svj3PWpwgoKNj4c96jitZXBf5vMdHGXdLbehs7uoEE7KM0+2N/tz2ZjyREr1OF7v5
	 tS2pMJ7z+wvVkli6MmsvkMbgIi+6WZRvGVZC+J7w5WgpUDTPYvwsi9mMqbERj+nG+E
	 pCFn8hopW8anGVVc2j55QgVYSaNxJGm7VcRtqkJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0900/1815] wifi: mt76: mt7996: dont leak MLD group index on remap alloc failure
Date: Sat, 12 Sep 2026 08:44:10 +0200
Message-ID: <20260912065710.049516607@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 2487b00c37904..57afe4e81666c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -2458,6 +2458,7 @@ mt7996_change_vif_links(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 		idx = get_free_idx(dev->mld_remap_idx_mask, 0, 15) - 1;
 		if (idx < 0) {
+			dev->mld_idx_mask &= ~BIT_ULL(mvif->mld_group_idx);
 			ret = -ENOSPC;
 			goto out;
 		}
-- 
2.53.0



