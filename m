Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5BF61FFE;
	Tue, 12 Aug 2025 18:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022625; cv=none; b=ANGX8SpogA32fna3e68KkiG7H2ZWwCM3CmRNsYktuNFFLBIrrqRF71ZSj9609XHRvBrNmJT7hwSm83xgVKr3JivgZKpu5de6vuVo5++39xodgRNMeQqqSYSmgahkIKQlQhNPvMN0Pis+El7JMXkeAbsff1WD83zCbVqlf3IBGDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022625; c=relaxed/simple;
	bh=7Ea624KM/+OgohTHZK7kVSM+M0R3gcY2hGwQPoqty9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HjC1+XM95EUa7EsyQVTWxkypUPHcmxHHuYOQEzf1qPakeXJh1MGA9e9Hf9k+60goawR/vDZPruK0b6ErLX6U4XEnl9QaGTYjqoS9dBel+0h4+KC61vx26bFvuS0xZ9zmnfnDNYLSz3r+MTd9Ab6cZGu9kzRMPkoNJzs/h0BJuFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tS8F9LOb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tS8F9LOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3168C4CEF0;
	Tue, 12 Aug 2025 18:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022625;
	bh=7Ea624KM/+OgohTHZK7kVSM+M0R3gcY2hGwQPoqty9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tS8F9LObQuLLlFWVxCCYweMnWdn1+cj9OsS+zjhfACpH/HV9+SVtb6T5VajrQ7Lzr
	 2Ps4LLObbqNq8yss8cWd5F7DTJ7BLmeno3d1uoo6TDOcvLu0J2AFCreMBRzzA5KChd
	 rLZhbl8oWeCNtD4pJuBcEi3WtmyKNTJ7k51UvYbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 209/369] crypto: img-hash - Fix dma_unmap_sg() nents value
Date: Tue, 12 Aug 2025 19:28:26 +0200
Message-ID: <20250812173022.622997953@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 34b283636181ce02c52633551f594fec9876bec7 ]

The dma_unmap_sg() functions should be called with the same nents as the
dma_map_sg(), not the value the map function returned.

Fixes: d358f1abbf71 ("crypto: img-hash - Add Imagination Technologies hw hash accelerator")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/img-hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index 7e93159c3b6b..d5df3d2da50c 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -436,7 +436,7 @@ static int img_hash_write_via_dma_stop(struct img_hash_dev *hdev)
 	struct img_hash_request_ctx *ctx = ahash_request_ctx(hdev->req);
 
 	if (ctx->flags & DRIVER_FLAGS_SG)
-		dma_unmap_sg(hdev->dev, ctx->sg, ctx->dma_ct, DMA_TO_DEVICE);
+		dma_unmap_sg(hdev->dev, ctx->sg, 1, DMA_TO_DEVICE);
 
 	return 0;
 }
-- 
2.39.5



