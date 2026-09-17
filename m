Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361DD58F08A;
	Thu, 17 Sep 2026 15:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658808; cv=none; b=GPqfJXH8BHEyL1FlJpEdpUcDnLI1m0yHFyZYXZT+AqXaEgMN43xbROytr3Wm2xI8xg8Bw6dH8Pa63t4/9QnR3Wb7SDsYBWTInLqYkIORBno6VITeUgTDtbM0lpX+FwOITK+PEvitkj+iWbO6+487l5Hq6o+pJJGPusRStiNsD8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658808; c=relaxed/simple;
	bh=2Lfg9PsqkAZQrNQ3JZRTUDdL5Uy2mSBR6ls3xCLQLbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfA1FDm6d3/2vP2Eu8ZE9NAcC+VpDErEvEpDOCNd5sky9Dd9dGZ1Z3tikGT3j6ab7xHdy5DWGPltvQRrN4j8Dme+8UtbQdRwdhvz1d5/cJ4E7PkvHW5nlnN83Ij9ZYQR+rpZoWCu7RoUN+hl6eahhbl9+p+kSZIxNuuVrSgH180=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o6vQsjHz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o6vQsjHz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4153A1F00899;
	Thu, 17 Sep 2026 15:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658799;
	bh=s3osRpR+5i5hVOT/FWruRw3/EpNBz5U5WpdpIkwjpg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o6vQsjHz7H/TXKf92D0cizwsEKc+NLK+Lu9YiOG1VD5YhqNhwZc0gCUpfeN5IPgAl
	 N5IXzJmLKVU//90btUNYhrzr0UvpKHDtBSXvbkEnY8q6X3bv7rvbqREW0912ASboqi
	 r1qCuA5vHf7hZKHvM25AKi/L/lnstdGDTUOguP6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Junjie Cao <junjie.cao@intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 003/733] wifi: mt76: mt7921: skip unknown CLC firmware records
Date: Thu, 17 Sep 2026 16:05:11 +0100
Message-ID: <20260917151350.702024415@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
index 564dd836e0b38..45439652c847b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -475,18 +475,23 @@ static int mt7921_load_clc(struct mt792x_dev *dev, const char *fw_name)
 
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



