Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063286;
	b=dHkMzkcKSz5HeNLsllYMN61STJeeCRR+VwtiBZfeY6Vuas6Aal59BX41t0SvCbTRJgOJ
	 +r6wBRivL4ig3a9+bgIl3ZeI3E8SArXzsHvlAvuwUN5D7AkoZlw4LSbANBAbL/tmyVh8I
	 Dg7bjUITNZdcMZxE5OqLCaw/eZNdhwn9Jp4ARfsmWQ7ZaEaPu8DRI1aNw1apyu1IAWAp7
	 iYMT+KWy0VR7koiWba5Fe6x3JFQatQQbkTYvceeeSa2p8u1RwR0jgQ+ZUpOHbb66QPY9J
	 oIrKedPthGMDbc/8cgwouC16zCeqGdNlmO5i8n1y+kadoITJm6g9xS9GD6LQ863R91Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XQ7MrLdMEqy7RY/ygZa0+Ik6tcv4XAneWat4tBcnK0Y=;
	b=n9OHcWM1nEmc8JzU3sJslkc/0ZLIeeh+wTZ0CT+XGZ/TgWbrZRkzmicdz3iQYAj2AZk9
	 ftXooTuZ3L1nW6iG/MbD8pZ0h1wIe25RmBEelsaUgV8jx/punM0XJ4B9QpEBogMDdTN49
	 35pCkhWgkqbnon6iDbuPL3xtllSuXJxJo/6AHGfS7JSISKQSRw8AKGXBURJqIwqDo4N7k
	 Dpffiz7WJW8OUstg0S7D3OuywGdEpDoDoIn3O3PeOBT+HSXctLSnN9sxuOP09G6C5peWm
	 QwE3qv9OsvcUUbsbm53BMivFcuAkMDhqV7Zk21d7LxH2mk++6VFXe+hBlAM+jO3cT6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lKHZsx7h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE19606D809;
	Sat,  7 Nov 2026 14:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lKHZsx7h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6057F1F008A6;
	Sat,  7 Nov 2026 14:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063285;
	bh=XQ7MrLdMEqy7RY/ygZa0+Ik6tcv4XAneWat4tBcnK0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lKHZsx7hrgOBV9QkDwBUcuw0u3T0fIUAv/8ybuly48QjWJ3uFiG2BOL7jgnR76FEC
	 oXs1Ucbn0QRbWWyxwxsrct7RuIXRuywYnnaiMbhrwXxou8/xTlULP0I+Q6CjOVsXfK
	 85LhtcW/nrqguS53qfogz8Hsf8Dpc3VsD+/yVEpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sebastian Brzezinka <sebastian.brzezinka@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 441/869] iommu/dma: Catch scatterlist length overflows
Date: Sat,  7 Nov 2026 08:52:03 -0500
Message-ID: <20261107134908.719562028@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9da773ba550ba..aa9ebf2bc96ed 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1453,6 +1453,11 @@ int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
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
@@ -1469,7 +1474,20 @@ int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
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



