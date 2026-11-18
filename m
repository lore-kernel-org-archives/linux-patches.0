Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046904;
	b=q9drl6VGyZWd3iQOG2LmHiNjvloghQB3/VjHfq9mS3vSIOBZKpjFpot4yfpdBnU2MicO
	 nVpvxItm4X7F+MOMGBgddeipIQWB9oAjSYpp0klnOhKm18fSE27c8LI59Jk9cKVGiru6H
	 UnVZzLrZatlGoCzq7fT1i7vvPtpKwzDjKqZZcXm9gwRXKNHnqITk4PjE/HOIscWypefNa
	 kWNw2I8o056XaVP2C/JQ0v5z0VyJlCwOdQWGw+qGOZkd4HYis1/8ISHFjfmrjDOChZTPq
	 e4X9qXucHwFdtWt+7LDUsrbwuM0aW1uFynoCAkGXZfg5yYPytnDQf49IM3C3MXMfm3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046904;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q1e1x8y9BZA9m6mKGjxjmixQHWRN6v95iZc3+4zbbTw=;
	b=2lHGv73zgHkRSJBr/yG485U9fBQyFnz2l2Vubdy9wQeGD4xsY0A4f3V/4ai6WqYQY1Gn
	 g/AXby+/WauyPU+16yJ+kqrXlOMtxSMQhLQJjnuNl/krY0DpUED6XucKhIc/YumQuwcSX
	 Nmq+OWiHWj0qQ4uAgcGN7JtxJfF+QjAircGUxkMOrTEKT2CCsXz/h6PV7YOSFY14kdkgV
	 uh+T26iO2rlyyx50ykNOFcRDwUnw9E6PKZQi8ybTVgC5PAnhDOGNDsFaf6yBZUCbnP/Dw
	 rkWZXJGMpwcC04bIYGTdayWykncGr/uGX3+nDeS3OB9PIA0RpRSOcZyXV48VufZM28Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1NyUUgV5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A95E606A320;
	Thu, 19 Nov 2026 00:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1NyUUgV5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08021F000C5;
	Thu, 19 Nov 2026 00:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046904;
	bh=Q1e1x8y9BZA9m6mKGjxjmixQHWRN6v95iZc3+4zbbTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1NyUUgV5CeN5TsaV/JYK490kgf4hxndYZOAB/p7ae+61Osf4iy5zyYF0ahsLuvf6M
	 VdRaWR95R3XzQrWT3fz7OQihcp99etToYLfbUNgZfc5ciMiBCpgMyc1dAA1NLB0urF
	 8YqUR5L0fCmdfh/hNqlao2kHBRNJ6ehXInp2ORJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sebastian Brzezinka <sebastian.brzezinka@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1448/2857] iommu/dma: Catch scatterlist length overflows
Date: Wed, 18 Nov 2026 15:41:22 +0100
Message-ID: <20261118150253.451755720@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Karas <krzysztof.karas@intel.com>

[ Upstream commit 1c8f6308e557f32412e9d4678b3f029f47f6d9aa ]

It is possible, when a very large mapping uses only one
scatterlist, that padding overflows scatterlist's length field.
This results in:
 1) silently wrapping the value
 2) smaller than desired mappings produced by iommu_map_sg
 3) leaving mapped bytes in memory (no iommu_unmap)

Address this issue by adding overflow detection for scatterlist
length field.

Fixes: 809eac54cdd6 ("iommu/dma: Implement scatterlist segment merging")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Krzysztof Karas <krzysztof.karas@intel.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Sebastian Brzezinka <sebastian.brzezinka@intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/dma-iommu.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index c3e5f9a435ffb..3ac8faeef67ba 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1250,6 +1250,11 @@ static int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg,
 		sg_dma_len(s) = s_length;
 		s->offset -= s_iova_off;
 		s_length = iova_align(iovad, s_length + s_iova_off);
+		if (overflows_type(s_length, s->length)) {
+			ret = -EOVERFLOW;
+
+			goto out_restore_sg;
+		}
 		s->length = s_length;
 
 		/*
@@ -1266,7 +1271,20 @@ static int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg,
 		 *   time through here (i.e. before it has a meaningful value).
 		 */
 		if (pad_len && pad_len < s_length - 1) {
-			prev->length += pad_len;
+			unsigned int new_prev_len;
+
+			/*
+			 * For large mappings spanning multiple GBs we
+			 * may not be able to fit all needed padding into
+			 * sg->length.
+			 */
+			if (check_add_overflow(prev->length, pad_len, &new_prev_len)) {
+				ret = -EOVERFLOW;
+
+				goto out_restore_sg;
+			}
+
+			prev->length = new_prev_len;
 			iova_len += pad_len;
 		}
 
-- 
2.53.0



