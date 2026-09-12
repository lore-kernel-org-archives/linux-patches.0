Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7DC274B39;
	Sat, 12 Sep 2026 16:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232310; cv=none; b=eScZ1vaKsf0439DnJJJTrV0MwcRWwSjlwKg/Dt9xFLCxueyb0RZDoOQL2w7Cs9huaVw7wwNMqxVuXbMNzUgHtNy/WhzKBTJM9ltVbTYwIFg5N+uEOK7jkUCd7ZbPJhNHqzwlijCdctgN+tjGU93yOWXJJ/ZJB1fFIVDEak3bO/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232310; c=relaxed/simple;
	bh=nVO/wT8gaOGjZ0LW3OoW1DIqqQZF6beXi80BdUG56Kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MuGtpY21+MQMZ2OYEvrOPVdJ0UNfx+l11pavg2G0f7tkr+7uw6rPHYYFHH3fB6wF9072BNCr8eA7w3ZL1151L0nklc3CJ1MYTHLADMTd9f+Vadv4TokcHEIJZkwOEC5BPu9KTXgfNe7OpzDpLWk6dQGBjOKVbJi1kYY1DTgRueY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pBMowaLT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pBMowaLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03D31F000FF;
	Sat, 12 Sep 2026 16:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232308;
	bh=wM0MHLL3xHuHK9q3ERHdTGh+ioEtW2dBW1amqZtKmfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pBMowaLTN55mN6TZPvrwJo78aKYrjHrOrxfMWV87mESEH4hMziOd0kqQmHKc9Am2u
	 HhE/z/jKFOEWVK4PeWR0W722GnMl0l6hadT6LvcY3DMZHZfNzyAXLtjzyXY+2Vej/V
	 XCmZeGxXi43oh5hZzFsUpqxe2uD0zd9t6aT5g85g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1176/1191] wifi: mt76: mt7915: fallback to non-wed mode if platform_get_resource fails in mt7915_mmio_wed_init()
Date: Sat, 12 Sep 2026 09:05:04 +0200
Message-ID: <20260912065614.553209223@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 5f9d5d4fc561e7bd3a18742f1fdb96cab98f1870 ]

mt76 assumes mt7915_mmio_wed_init can fail just after wed driver has
been attached running mtk_wed_device_attach().
Fall back to non-wed mode if platform_get_resource fails in
mt7915_mmio_wed_init routines.

Fixes: eebb70976be5 ("wifi: mt76: mt7915: enable wed for mt7986-wmac chipset")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
index ada669c4868d6..3c329eb7a8295 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
@@ -618,7 +618,7 @@ int mt7915_mmio_wed_init(struct mt7915_dev *dev, void *pdev_ptr,
 
 		res = platform_get_resource(plat_dev, IORESOURCE_MEM, 0);
 		if (!res)
-			return -ENOMEM;
+			return 0;
 
 		wed->wlan.platform_dev = plat_dev;
 		wed->wlan.bus_type = MTK_WED_BUS_AXI;
-- 
2.53.0



