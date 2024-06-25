Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E3114A0B8;
	Tue, 25 Jun 2024 09:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308553; cv=none; b=Ip8tpnqt1P2I7GsSrSoG4qog3Z5q8B5gRuJMgkrcnHkHiANKF913StthTA5Tptxo6uwLikUx1AjSA8WGg9obOojYKWOYNgaTuDKOEZ43EqncxJbcCM3hyfq9IXLdpfq41TJfPJJv4Y6Xmzx4PwbbIzizslTCIfyMtg98r1BHow8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308553; c=relaxed/simple;
	bh=vEnKquRZaY9zrQ98NeVD/vphGmmYoFa+3N+XF8A3sOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kX+fN08ExCuIFJEX6cuEcO2z8ZZwbEIIRANCUJk/vwOEcy/zEgetQlgD28sxBV+a/h/B2yVjLK8dBnjxWNNBtNjmxVoZLpPmvehxRNGCIbSTpUKAIImfRJ0vn5/Gs1+WNC2HsMKHrdrScwyn/VG8XnT90mrFPrStAAU8ys0IYWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V0+61uka; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V0+61uka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E61AC32781;
	Tue, 25 Jun 2024 09:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308553;
	bh=vEnKquRZaY9zrQ98NeVD/vphGmmYoFa+3N+XF8A3sOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V0+61uka6ilrj8ahpo/ocqcB/iSridUPYMVSUFBh9QHaPWKtRRrU3Msfy50olxd9/
	 hVTx6nPk8Gf9ZAKKt3WLUUYPUlrzCagLULWpfguJ7Y4VbSlRhQxrQXDuUfb4/oS5o8
	 7fXZtSHOEGox6b0Asv80G6MUSe0a3hUcqAAXmHr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julien Panis <jpanis@baylibre.com>,
	Nicolas Pitre <npitre@baylibre.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 159/250] thermal/drivers/mediatek/lvts_thermal: Return error in case of invalid efuse data
Date: Tue, 25 Jun 2024 11:31:57 +0200
Message-ID: <20240625085554.163961437@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julien Panis <jpanis@baylibre.com>

[ Upstream commit 72cacd06e47d86d89b0e7179fbc9eb3a0f39cd93 ]

This patch prevents from registering thermal entries and letting the
driver misbehave if efuse data is invalid. A device is not properly
calibrated if the golden temperature is zero.

Fixes: f5f633b18234 ("thermal/drivers/mediatek: Add the Low Voltage Thermal Sensor driver")
Signed-off-by: Julien Panis <jpanis@baylibre.com>
Reviewed-by: Nicolas Pitre <npitre@baylibre.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240604-mtk-thermal-calib-check-v2-1-8f258254051d@baylibre.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/mediatek/lvts_thermal.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/mediatek/lvts_thermal.c b/drivers/thermal/mediatek/lvts_thermal.c
index 4e5c213a89225..6b9422bd8795d 100644
--- a/drivers/thermal/mediatek/lvts_thermal.c
+++ b/drivers/thermal/mediatek/lvts_thermal.c
@@ -740,7 +740,11 @@ static int lvts_golden_temp_init(struct device *dev, u32 *value, int temp_offset
 
 	gt = (*value) >> 24;
 
-	if (gt && gt < LVTS_GOLDEN_TEMP_MAX)
+	/* A zero value for gt means that device has invalid efuse data */
+	if (!gt)
+		return -ENODATA;
+
+	if (gt < LVTS_GOLDEN_TEMP_MAX)
 		golden_temp = gt;
 
 	golden_temp_offset = golden_temp * 500 + temp_offset;
-- 
2.43.0



