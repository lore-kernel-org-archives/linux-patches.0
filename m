Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB685279915;
	Tue, 12 Aug 2025 17:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020784; cv=none; b=bIKQj/qN1piS7j8xX1oV1LHfvyiJ2RXvDnC3myXryUpp7vOgaG4HmjOraRPcBkQSp/3Gp0Ew6pmdrcJ4SjEzfP5PzMIzakV5+ab61OJbEqYC/YAQtaeaX8URKZkWcvRNW6sdZuYZywcVD2UfUCfgGMBQ3Bi3RZyS8zxiXZVkbDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020784; c=relaxed/simple;
	bh=Rt4UhCGet+BcfEzOwrOwOOcLGfsEymHR2ygOSDUJNjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j01nY2jrKC/UgDtZ7l6PUoZhZFF2RRG2Zgqs0p7Zj3/3NilNpyvJ7nhK4jzr2huHGrC3GRPH9I2CsvUNDJXNxOGgRBMaNKSJ0P1wQ9z1tSfF6jdsMCzJ/67pHgRekhDUxrafWS+DXULWWWI1vtoWBURVX4Luw1TtCBEx3fynsYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SMW++a4K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SMW++a4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302DBC4CEF0;
	Tue, 12 Aug 2025 17:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020784;
	bh=Rt4UhCGet+BcfEzOwrOwOOcLGfsEymHR2ygOSDUJNjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SMW++a4KcjYcXyKJ8yFINPuRxfpYJmR+17CVGKdBzF3v1x4O9r+INw50TZWnwRcTd
	 /ov+R3x0MOeYOAG9LRt9Opwbu0HpIsS973F32iChZFyuY2RFPugvHA3gIq5p4m4esw
	 bIGe4zjAtLHd/KMdp3s77XI9mYyH8OjNG7+m2DmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 168/253] crypto: img-hash - Fix dma_unmap_sg() nents value
Date: Tue, 12 Aug 2025 19:29:16 +0200
Message-ID: <20250812172955.871000489@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9629e98bd68b..0de49efb9ef9 100644
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



