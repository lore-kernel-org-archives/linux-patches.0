Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEC336D512;
	Tue, 16 Dec 2025 12:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888062; cv=none; b=mSrXB+Yv+A8Ukk1GF2rPGZ8LgSQY0pePL4Qwa/zjF2m+gsF/Yvd7r202s73IZvtqytyCKzzGw9BN1al3ymeDqv6e9gyoRSW+JK9eupyomWU8h1uoFMVdMNLu6msxPYneIG8QOCqy856jTa+7rrYO6Qcbl5IQM/muSQHTTS/rjck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888062; c=relaxed/simple;
	bh=5B8olh9fY67KBi+lIoTeoRrAsauC1AYrDcus89wy0MI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZRfAF2OlblEiH/sx2YRlmF9XkxVthZiGLsmYVTDpnBWVeDi0AooEb3AqOEY9LvzXHR0yQ46+080zdUTKtwM4/GqmyufkXNzn9umXH7aIxok0gViuh5lDIwCRl1pTVipjdkwn7t0GCl4MYuoZDftklFdBicGU4XeN9vjdnsLf/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ATvLkxci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ATvLkxci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84495C4CEF1;
	Tue, 16 Dec 2025 12:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888062;
	bh=5B8olh9fY67KBi+lIoTeoRrAsauC1AYrDcus89wy0MI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ATvLkxciyc8fqclLwG/4Wel8gmo3NdteHDySFw/Bg3INh6hluMZ1YZEstXbxnAYKw
	 scM3XF5gN8nuaMcGzwLSdR4TuRSRNZVdw2wXIPuSBK/vXRDNjuKV4DfjH8ZRXHsip+
	 Qsos2giX5sRfguoB4i4c4dpjKu7jRklIJ5ap7mDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 388/614] wifi: mt76: mt7996: fix max nss value when getting rx chainmask
Date: Tue, 16 Dec 2025 12:12:35 +0100
Message-ID: <20251216111415.428284905@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: StanleyYP Wang <StanleyYP.Wang@mediatek.com>

[ Upstream commit 361b59b6be7c33c43b619d5cada394efc0f3b398 ]

Since wiphy->available_antennas_tx now accumulates the chainmask of all
the radios of a wiphy, use phy->orig_antenna_mask to get the original
max nss for comparison.

Fixes: 69d54ce7491d ("wifi: mt76: mt7996: switch to single multi-radio wiphy")
Signed-off-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20251106064203.1000505-1-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index 718e4d4ad85f2..1727e73a99ce6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -786,7 +786,7 @@ void mt7996_memcpy_fromio(struct mt7996_dev *dev, void *buf, u32 offset,
 
 static inline u16 mt7996_rx_chainmask(struct mt7996_phy *phy)
 {
-	int max_nss = hweight8(phy->mt76->hw->wiphy->available_antennas_tx);
+	int max_nss = hweight16(phy->orig_antenna_mask);
 	int cur_nss = hweight8(phy->mt76->antenna_mask);
 	u16 tx_chainmask = phy->mt76->chainmask;
 
-- 
2.51.0



