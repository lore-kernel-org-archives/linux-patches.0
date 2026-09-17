Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C3947C0F1;
	Thu, 17 Sep 2026 17:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665033; cv=none; b=rMBF6ypLcBm7G3cmcRd8hyLmRkPClzaBWqzMluC6oCf2w3iQVLP/cPyPVZeZH2sIzobkXbAgefm/pvvDi0MU2JgbHq6/1egFBbE2CHVano7ihKVlliDpVROtfb2M1T3XeqtsU8YJjt0Hc3LYmV/Ku1p64GMOUBdBsP2EQ/sirlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665033; c=relaxed/simple;
	bh=dzkc10ainqVDGlbxHfGgqPT5zjj5NCiMNpUA/YNAwlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ov82ySAMbEgB99tNhgf+7XASEYs090lm2mcvu6bdnD+TxsTHGXQ+/mlJ3xiSFhAywxIebkAWx0JTrgHVTcEFsDypDtfK+IVsc+6RCAcWviAV+y2xfe+Fpyw5+rwJ8/CCnFOgTdPLx/dWFJB16kIj/IrzWp2HuQeJ+8VTJqdiuto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zUVkbSvu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zUVkbSvu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E921F00893;
	Thu, 17 Sep 2026 17:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665032;
	bh=GqYFUXhnet6gGoktW7hsRThxroteeRpMV3cFxkba67o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zUVkbSvu5vM4ZxkOH7vK/Kz5Ujmx/nNC2mk9RtyaLbwGZAS4BJF0WH/BJMZljwUXF
	 T75dnHfLnF1Ve+pdhzVTknxDFOV4pUmvdK6nlw/kUoVxsKVyKO3EhHKkxUUlY6AMCQ
	 B4zgUhvoso4L4LvV+CBgZ/tulNHPyVM9PZoXRhe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Junjie Cao <junjie.cao@intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0571/1250] wifi: mt76: mt7921: skip unknown CLC firmware records
Date: Thu, 17 Sep 2026 16:06:06 +0100
Message-ID: <20260917151607.387632397@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>

[ Upstream commit 1a296bfd3e775e515233f746218824fc7dd5ff16 ]

Treat an out-of-range CLC index as newer firmware rather than a
malformed image. linux-firmware 20260810 ships MT7922 records with
idx 3, and rejecting them made mt7921e fail to probe.

Keep the record-length checks, and report those as errors so a
truncated table is visible instead of a silent retry loop.

Fixes: 9417c5818a01 ("wifi: mt76: mt7921: validate CLC firmware records")
Reported-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
Reviewed-by: Junjie Cao <junjie.cao@intel.com>
Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index ad0a7ebb2f3aa..8c8b35cba856c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -478,18 +478,23 @@ static int mt7921_load_clc(struct mt792x_dev *dev, const char *fw_name)
 
 	for (offset = 0; offset < len; offset += clc_len) {
 		if (len - offset < sizeof(*clc)) {
+			dev_err(mdev->dev, "Invalid CLC record\n");
 			ret = -EINVAL;
 			goto out;
 		}
 
 		clc = (const struct mt7921_clc *)(clc_base + offset);
 		clc_len = le32_to_cpu(clc->len);
-		if (clc_len < sizeof(*clc) || clc_len > len - offset ||
-		    clc->idx >= ARRAY_SIZE(phy->clc)) {
+		if (clc_len < sizeof(*clc) || clc_len > len - offset) {
+			dev_err(mdev->dev, "Invalid CLC record\n");
 			ret = -EINVAL;
 			goto out;
 		}
 
+		/* Newer firmware may add records this driver does not use yet */
+		if (clc->idx >= ARRAY_SIZE(phy->clc))
+			continue;
+
 		/* do not init buf again if chip reset triggered */
 		if (phy->clc[clc->idx])
 			continue;
-- 
2.53.0



