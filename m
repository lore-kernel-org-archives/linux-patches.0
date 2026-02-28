Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67C4331212
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301890; cv=none; b=KR2SopjnWT6jITDfACMo6w+CPvqbR65p/aN1YHbt/oNr8Vx4ye5dYo84BHR0ZYIzCRQ/eNBo5mKg8A2Iue/i7np4gJ0oW5XhIGCOpIyz/IumRlpHJFouh96XXu2xx/9DH6xwNYz1aiY1hztXO3Qq/RhBt06yyHY1tQgHuSsPbxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301890; c=relaxed/simple;
	bh=QvPPbpJXgH6vBw6rMj9cxu/M8j7zDuTHb0prvdKfgQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JzU9E7mWirsTCGRHFLbsjPg9eg/1xu06bTASd6kVTT0lDE9fG2psh9l48kmAYPG/zrK0pjBiR0OYfAx3h+CU6FmpucI9UMDFCAU8/TesjGQiPlDSCQrHCa7cENtaDhcoHs8IBYuKFWrSPhndtQ6UEZPaXqfQzVKcKrHpEU8Cdc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DIToNbQD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DIToNbQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014D3C19425;
	Sat, 28 Feb 2026 18:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301890;
	bh=QvPPbpJXgH6vBw6rMj9cxu/M8j7zDuTHb0prvdKfgQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DIToNbQDwwIpp9Av2gUCXtuC7HqzBOIsX87mdVHhIrTjfRFevVQTFnym0PGjbGYGe
	 20OpHz29cI/D4rt+Q8bIQTCRs+T/YWcpmB2q0Bu8VshzvSNN2gkXBrEXQFMx0wysnH
	 zgPT9QjK5tSvWmH0fQ7qJMVwB5qniWX//4E+a6tlBpXb93y18xZiDmI6f3i0Gpnmuf
	 7F03xJrcsJ1x4ySj06NdZ9L7yAq5TIyhQRYZrkFRpnG/WJeeh7CNoh8kn/fxQtlpUE
	 u5CnPdl5Npqkt4trYIMs5d6G/MBTxnhIN7UGJfVxsxZsrz/a9ZB5rjxpZTfAIYdGGo
	 MGPMZT2n1HO4w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 317/385] interconnect: mediatek: Aggregate bandwidth with saturating add
Date: Sat, 28 Feb 2026 12:58:59 -0500
Message-ID: <20260228180011.1568201-317-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

[ Upstream commit 6ffd02b82243d9907b5f5d2c7a2fc6a62669eece ]

By using a regular non-overflow-checking add, the MediaTek icc-emi
driver will happy wrap at U32_MAX + 1 to 0. As it's common for the
interconnect core to fill in INT_MAX values, this is not a hypothetical
situation, but something that actually happens in regular use. This
would be pretty disasterous if anything used this driver.

Replace the addition with an overflow-checked addition from overflow.h,
and saturate to U32_MAX if an overflow is detected.

Fixes: b45293799f75 ("interconnect: mediatek: Add MediaTek MT8183/8195 EMI Interconnect driver")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Link: https://lore.kernel.org/r/20251124-mt8196-dvfsrc-v2-13-d9c1334db9f3@collabora.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/mediatek/icc-emi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/interconnect/mediatek/icc-emi.c b/drivers/interconnect/mediatek/icc-emi.c
index 182aa2b0623af..dfa3a9cd93998 100644
--- a/drivers/interconnect/mediatek/icc-emi.c
+++ b/drivers/interconnect/mediatek/icc-emi.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/overflow.h>
 #include <linux/platform_device.h>
 #include <linux/soc/mediatek/dvfsrc.h>
 
@@ -22,7 +23,9 @@ static int mtk_emi_icc_aggregate(struct icc_node *node, u32 tag, u32 avg_bw,
 {
 	struct mtk_icc_node *in = node->data;
 
-	*agg_avg += avg_bw;
+	if (check_add_overflow(*agg_avg, avg_bw, agg_avg))
+		*agg_avg = U32_MAX;
+
 	*agg_peak = max_t(u32, *agg_peak, peak_bw);
 
 	in->sum_avg = *agg_avg;
-- 
2.51.0

