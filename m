Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062269;
	b=iZCzRKz7VZ+2i2rkd87C8hnLDQWBnRQtZFhEzjHTeMp6Rv/7TLg9kAgg4TTv98cnh1UC
	 NKNLUv6puJiBMFz9YAPYuHUD0/sAu5oK6J84Mq9iW//O/C16sz+KRpXb2uCM+KtVFeOAt
	 QK1bF1LDw3Ik5n2D3FMRVDvSklpaFHuN6klFtjlaQBqDVm+xDgyL+J+69Vcvf1JkbJQlV
	 dUVko8MkR59hqXcfqH1JINKNOtYsaWj5WR4XKV8Mht1sQmYKTgem9onM0Uy2Rloflo+VN
	 ZagTxWDGbLTMaibhdBcbckFEgmuUgPWclY0NSB0oZyyEnT5gksgfg6S/jNZTqaP/10A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UOPBXGP2VGluO7dsO6PNJTTUK0gI6/19W56R1LsPXhk=;
	b=vFdIdK3CLN8jtagunk5hjxi70FzP9CnTdykPbQ6IpOclMl412PT8QZPRgRy1UCWXby1q
	 fNM4Ze3DMUhAwrlxYGI7U2nrZQJ1/l+eFQdLuymXatTVf9jGxoKPBAKdkENMcgAZ3MQWH
	 G0nILKcbi4puFlODUrO110jkryPWOuUKXcJhCBsFQRdahF6cyHyYGdIs2601cPR2F7fnX
	 N57k6aGetGZqkr4OopiEN6HByuL1q4S3iWIXvJgIkVlBL+28f4sgv1fFL1DH3Jdnkj0CJ
	 wPaDPxuN2p71lA20WNwPajLNr+GvO4UvB+hWeqZ0Qnv2mLQhWRQMhX2qTkjiF7zXjbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yWE3aJMs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC3F60A380D;
	Sat,  7 Nov 2026 14:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yWE3aJMs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7D81F0089F;
	Sat,  7 Nov 2026 14:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062268;
	bh=UOPBXGP2VGluO7dsO6PNJTTUK0gI6/19W56R1LsPXhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yWE3aJMsUM8/+PdIB2mAset23vtGOTR/rOwoeBpyFH4r4lXwLOG1pBsUtl1W9Sdxd
	 sZPrdufTyZRfyobI9EkcSvKclRvSmRhzyHebnkKUPGxMnVbQhMro6t8Zc3hN+uSWTb
	 GJULf1UKVq9ZG9jLUbFD/pQLVioR70Tfct5q+ZHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sebastian Brzezinka <sebastian.brzezinka@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1211/1536] iommu/dma: Catch scatterlist length overflows
Date: Sat,  7 Nov 2026 08:53:47 -0500
Message-ID: <20261107135031.769448179@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 059463664b418..452b9517fb442 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1440,6 +1440,11 @@ int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
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
@@ -1456,7 +1461,20 @@ int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
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



