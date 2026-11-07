Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062936;
	b=dyF3f3TdOpx7kvg5Cd/vldNxmfSpylc9X3ngCdup9ZknrX0jQbAFx66IezauIeX7YUgy
	 I9cOeQXNCE1sW5N/SCU4/+tmyNPoY8h/RtZAHIcUvWiJw3obxZrmHCa+NSXLtfAwvRcbC
	 EpWdJaTIrNit+AbZvQ53ZKxXoU/vwWKPdVn0glmkwyVl+3WEsJMTXZ0kZjaahVS2JZ3B/
	 V2bQPUbDPF78jLaJwVU9LF9QwheIa7J3C5egC68DRYFEnqd50ww2PNP37T30rHkNmdkLh
	 F+UxtShZWCt59dsdi65XJmPd9rwn8FSWw5b6Cs6xM20/LrelQwqtjHEJyQ5USU/YgVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062936;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R47N5s12ZrMnOg3lc06JsmVEvIRbkWnc3OZX9ZcTIbg=;
	b=Rn7CbWxKQwrWsqVfQlGt0gNExTzIxZ9Ua2wHyyUX+uaUYrTNt4DWkvbrn0sJAyzy+Tdq
	 XgvLNv8MZZKSkf2YuBZdyQC+4qS7HdYCQd9zPbYtF7ewUSBZS4TiNegIuvqZ/scqjEV67
	 B0NGNsCqhPYKx38vxtHFor7B4WRkO57xmWe1/VrGo+m6Szi5kPha9Zc3vpIDIW4xqf2k6
	 u0mDB3IF/0OwbyS7kele/Vb5BVPg9iYn1AaPMs7zEI2w/BkMTcpnuxV+L1PHB3t/P0esu
	 ed2nl6enQ4E1EYeJVoosdop3UUk7ZXitrYiFH+bdX9QpK/pzv6E2dc4a50kQxKkNHvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x4Oce3ca;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81468606A326;
	Sat,  7 Nov 2026 14:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x4Oce3ca
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AAC71F0089F;
	Sat,  7 Nov 2026 14:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062936;
	bh=R47N5s12ZrMnOg3lc06JsmVEvIRbkWnc3OZX9ZcTIbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x4Oce3caNkV7h3xsYX8AtciH+SSqgOLfHZed9x+vXfYrA+5GIlz4N+SM6ATe7/SWZ
	 Tl4QFZYrNwKpd6ZOjXZqnVAoDFL6q4FQoc/C8t4d4SI89uHN4dG5x8qa64ZXmqh63r
	 O82x1eBi0tsnNKbH3p4vY6rkt2IJKJBasY1+lHws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 205/869] crypto: hisilicon/hpre - fix ECDH destination DMA mapping
Date: Sat,  7 Nov 2026 08:48:07 -0500
Message-ID: <20261107134858.948593526@linuxfoundation.org>
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

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit 12d8edda8cdb41d18c4891851e25bf58be6be995 ]

hpre_ecdh_dst_data_init() rejects valid requests whose output length
does not equal ctx->key_sz << 1, and maps the user buffer using the
user-provided len instead of the hardware transfer size. Drop the
redundant length check and use ctx->key_sz << 1 for dma_map_single()
so the whole hardware output is mapped.

Fixes: 05e7b906aa7c ("crypto: hisilicon/hpre - add 'ECDH' algorithm")
Cc: stable@vger.kernel.org
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 870b296d45b45..41fa978079780 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1520,13 +1520,13 @@ static int hpre_ecdh_dst_data_init(struct hpre_asym_request *hpre_req,
 	struct device *dev = ctx->dev;
 	dma_addr_t dma;
 
-	if (unlikely(!data || !sg_is_last(data) || len != ctx->key_sz << 1)) {
-		dev_err(dev, "data or data length is illegal!\n");
+	if (unlikely(!data || !sg_is_last(data))) {
+		dev_err(dev, "data is illegal!\n");
 		return -EINVAL;
 	}
 
 	hpre_req->dst = NULL;
-	dma = dma_map_single(dev, sg_virt(data), len, DMA_FROM_DEVICE);
+	dma = dma_map_single(dev, sg_virt(data), ctx->key_sz << 1, DMA_FROM_DEVICE);
 	if (unlikely(dma_mapping_error(dev, dma))) {
 		dev_err(dev, "dma map data err!\n");
 		return -ENOMEM;
-- 
2.53.0



