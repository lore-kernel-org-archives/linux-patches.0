Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053822;
	b=ANHLlSyHQzUofgxi5znu4pyAru6Zb6Y3XfRPpSRswvoNZD77eRsOFA/GqdZFEn7pnzh4
	 zJPZUD1nXGD1tWQ17qUT4ZXq8eyvTNYmNhwijEceL0p1ANSTW5Oi7RH/Iiw/1mYW6MM4j
	 qSmt6H/RhVdGMpsRnK+J745wDGjbJavlF5ZIt0w9rLoQqE9HLgkWQcRmwHyyajxxf9d4C
	 rbIVh8cWXexVkrPtE+923/KreS5LDytGrW7ax6nsWfVpZ+7uIkJt+JjrcSBvWe1R+VZke
	 MTa/Od/rf8MS+0xbW5Fn3iiQgh8wMYUgrlaKROsMwWQEIk7ePri54XUHV6GNq/C4JaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cknkn2AjX02fBsIswKi5hQkmlFC6gkz+4DPHed3mBx4=;
	b=jvcVU1tWegS4urxGpa/0ceill8+BFIaZh7xkQtDPbnjZq9SOJURBrb+O42Wv31eoeRSw
	 dQWM61dJWJbN6gMGlQvhJNlJnrHZCfxmPb/bBTdzYHYKJOn/AQzzjK811hWHpZMu2zT1f
	 5h96jOLEhGHywUMvxQ5A6LR/2LALW78EGFnH8/etSrEArO667EH+c+RGCLlZM9txfFmF2
	 1RNQ0bwtopYhppBxLoFbJaioo1kzZoAmGI3m9dXfyakaL9ltaMHK9cszm6MW5vDXmvqlH
	 J+sus165HXCg+1H9ksXu+rI2q5UG0rcxvi1D4QAamnsc8qAUcmSaMFC87/4R1wABDHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q9PYQ0pq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC204606A32F;
	Thu, 19 Nov 2026 02:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q9PYQ0pq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6271F000C4;
	Thu, 19 Nov 2026 02:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053822;
	bh=cknkn2AjX02fBsIswKi5hQkmlFC6gkz+4DPHed3mBx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q9PYQ0pqsG3LoZP9DlvT6fY3yFTF5iaINVxLTGAAf4AbAQi/x7OD/tX9sbem7cmXU
	 eWc5XKlzYNDWHNrsPGxYErShDdzaCiNGCmgONZuzscu0UBelRG0EQeV5Pd8XoNn0fk
	 Dwr5Sdikztydq5LnWf0ESvZBpixZfA6W/xKPTpH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sebastian Brzezinka <sebastian.brzezinka@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1054/2214] iommu/dma: Catch scatterlist length overflows
Date: Wed, 18 Nov 2026 15:45:30 +0100
Message-ID: <20261118150054.484741054@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced unavailable overflows_type(s_length, s->length) with s_length > UINT_MAX. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/dma-iommu.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index dfef5d7f5885a..d781c290f26c8 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1023,6 +1023,11 @@ static int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg,
 		sg_dma_len(s) = s_length;
 		s->offset -= s_iova_off;
 		s_length = iova_align(iovad, s_length + s_iova_off);
+		if (s_length > UINT_MAX) {
+			ret = -EOVERFLOW;
+
+			goto out_restore_sg;
+		}
 		s->length = s_length;
 
 		/*
@@ -1039,7 +1044,20 @@ static int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg,
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



