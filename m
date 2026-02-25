Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9831E30F7F7;
	Wed, 25 Feb 2026 06:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002669; cv=none; b=rLcFBS53H3X5qRPoKU3Q7z5KQbMDtDyCoi0EUpO9+qQqNhtpvOI7rWIyjBRIlwBBWusM/LOq2uDK5HZ1z0B6pk59W/7YqJMgoz1PxpLNfMmBxohdINDdAz1xpTqThaqYEpKFojNHbCZ7+n8uBT6pHIu2e0vZIizkAmf19SI7LNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002669; c=relaxed/simple;
	bh=mn8vIRPaB/8m3RzMxqvByarmp9ZjvO3Bm62M4aEoW/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWY+0np42+D+9XnWzIjOUrxbgSgn6OboQwzJMxel4uri6gjTSXl/5TjTg6YyWmnTFAIrtNtdD18oOhTrck2Qmvwjtu3f/kkinDfrqsesTDpazCTMJ7i2+HRUis3pEtAJnWuhf3gReAlYAF4kBH7utSDD5RGerfMPkA+NtvkL6b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zmjegfCI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zmjegfCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7070FC116D0;
	Wed, 25 Feb 2026 06:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002669;
	bh=mn8vIRPaB/8m3RzMxqvByarmp9ZjvO3Bm62M4aEoW/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zmjegfCIUkwPugPFmcwSvAwe1FvatbhbgkWkCQojKGNlpBBmHrhsEfThhSqIKAphN
	 xkNUc6/AUHsHtvMgSxNxvvgyxtM4FwzcrYH90c8fdyyFz/yVmIbgiMyeLAI8BOcZKV
	 LNeeZ6SHgxl2kWlJjP5B8kiCW2SR4PLieCGjLx8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 451/641] interconnect: mediatek: Aggregate bandwidth with saturating add
Date: Tue, 24 Feb 2026 17:22:57 -0800
Message-ID: <20260225012359.445756495@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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



