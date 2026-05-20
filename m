Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826F733A6F2;
	Wed, 20 May 2026 16:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294638; cv=none; b=JRXqNcbTbzeJGr5TNj4iVGSH92UTYOezo5rJZqHj8wo3VdchZOocecVSeEo3HfAEewBr0kdhIwZy3BTrycpvAU6YgdDHwBcKL+WuoR2eS6G3BPfMCyd1qqbepSAbb5Anq1DDYDG42twPtt1CZDLDsRSpJvCkZ5Onqa+3OY32tes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294638; c=relaxed/simple;
	bh=Z596JxiUqvik05+B2QFzI6PDy/K6GX0vQrXEI0t3NSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDy6gYO8U6nIOJ1W/sNrnZPFi/LqBEj28wumdLR1/vfon0jhx5HxoLUO550eYcpYOcaLNt9TJSxxD0/s6Pufma7xywGcAPrM8aZG6+FgPqlExLYwAXCKy616g33ZTn1de2yIVu5PlP8fuQdEUFXDixJgPpc3FJ82+bNcu4NhHQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wTogluKg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wTogluKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D1D1F000E9;
	Wed, 20 May 2026 16:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294637;
	bh=J67YJM/XAQpuNtGA+Fo3uKt/kVD2r5Xgx3JX5kGNE9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wTogluKgTPH6UGrQ08jiAIKUQutgr0YlOjMNq5BfFPDtZhs4RmuJjzPbh6vNSJqmg
	 EWVQhVDnEEHAdUa2ZMXgLZyYyInN6N1fgGFKe+uNjWrFNLHfmkl2bwW372icRcAxbk
	 JUUVEltU/ihP+yw+MrZgRiZhE5Il4imzdfYlG4Ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Yen <leon.yen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0114/1146] wifi: mt76: mt7925: fix tx power setting failure after chip reset
Date: Wed, 20 May 2026 18:06:04 +0200
Message-ID: <20260520162150.916325484@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Yen <leon.yen@mediatek.com>

[ Upstream commit aae89dc4a1608da9060bada757f650ac94b7f184 ]

After the chip reset, the procedure to set the tx power will not be
successful because the previous region setting is still remains.
Clear the region setting during MAC initialization and allow it to be
reset to finalize the TX power setting.

Fixes: 3bc62aa4484d ("wifi: mt76: mt7925: add auto regdomain switch support")
Signed-off-by: Leon Yen <leon.yen@mediatek.com>
Link: https://patch.msgid.link/20260120163152.3694116-1-leon.yen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/init.c | 2 ++
 drivers/net/wireless/mediatek/mt76/mt7925/regd.c | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/init.c b/drivers/net/wireless/mediatek/mt76/mt7925/init.c
index 3ce5d6fcc69df..c0c5cb9aff75a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/init.c
@@ -91,6 +91,8 @@ int mt7925_mac_init(struct mt792x_dev *dev)
 
 	mt7925_mac_init_basic_rates(dev);
 
+	memzero_explicit(&dev->mt76.alpha2, sizeof(dev->mt76.alpha2));
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mt7925_mac_init);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/regd.c b/drivers/net/wireless/mediatek/mt76/mt7925/regd.c
index 292087e882d1f..16f56ee879d45 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/regd.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/regd.c
@@ -232,7 +232,8 @@ int mt7925_regd_change(struct mt792x_phy *phy, char *alpha2)
 	    dev->regd_user)
 		return -EINVAL;
 
-	if (mdev->alpha2[0] != '0' && mdev->alpha2[1] != '0')
+	if ((mdev->alpha2[0] && mdev->alpha2[0] != '0') &&
+	    (mdev->alpha2[1] && mdev->alpha2[1] != '0'))
 		return 0;
 
 	/* do not need to update the same country twice */
-- 
2.53.0



