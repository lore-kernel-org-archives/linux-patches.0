Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07466381E95;
	Thu, 17 Sep 2026 18:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668575; cv=none; b=WPi222AWNR3adZzeK5IB+AvfVKuOkQL5pMSqSrKc0Bf3yL79X31x4KF/IZDV5Cd/FZgFOUE1OrEf9LC/2B8uDlC7NMZUBfF59wMTU7EDbiL8lvNcl/UpeloKKyuBlQX1WYkll2f5c4YnrNwKBCJnWDuPzOos4hA8f7fi8AfPuO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668575; c=relaxed/simple;
	bh=hvORrwp8ACIufhx5kRLOof6DL7N3yPaiVCGeTIGlUjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0rbuObX2dMLoMJXVzi9SXMZAhx1hMKE6pxiWAvcmarGMT6zhGNkS+9xvU8i+Xiz8juj/1iMU2/parAC5ZWKka73BSws1yvyjF6Vp/JRi8Kj8sDSoe4yzVESdwq2ApdtBk3xbf1AsYqgcbHUKx2wks6q9S/bronFUbWPmrnDpn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CDn92GOp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CDn92GOp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FD61F000FF;
	Thu, 17 Sep 2026 18:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668573;
	bh=FmuMamY0fKGaCilFEdIzka9IG8PpyPQ/nd6w6ahAsSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CDn92GOpRXbosiF3btlCZsxEi4aVi/pJWbBdtec9Y0sF2LsO3jQej5cVke1FRpFhd
	 OlxRPZJVnSO7clkRxSTrydio6/7Fap4RjEZiJav2bJZsUwMXl1GM3zzysWem3oCj7Y
	 PMe8o6E3ZEBLvmjU9Ynzjbn0mv1x0aBacb0+aX+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Junjie Cao <junjie.cao@intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0471/1102] wifi: mt76: mt7921: skip unknown CLC firmware records
Date: Thu, 17 Sep 2026 16:06:54 +0100
Message-ID: <20260917151551.516406885@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 141167cf79b5d..6caf8fbd6a7f2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -472,18 +472,23 @@ static int mt7921_load_clc(struct mt792x_dev *dev, const char *fw_name)
 
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



