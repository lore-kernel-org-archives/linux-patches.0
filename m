Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2532D2FDC25;
	Tue, 12 Aug 2025 17:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021509; cv=none; b=eZsWaXW4Ibi8rGSXFv7BOn4M/tb+stBO38EfzAdtEq3srwusjwR77Yuk1XFo7rapGYU3LGPme5fxhfg2gISHOsO7vcZhgI2axqH5P+ay7vODrUUFD/KQnTQDFkvQUJ1dMBx5J7T5P2VG++IZD/Di4//mBtwqHSjCy7m/MYLGa2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021509; c=relaxed/simple;
	bh=xWm8VpNNg2qQ9fvqIMJYNUEuAUZZC2niMfJmJAL8X3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ttqT/W+GLKOawJOXUqnA91BiLi0q2jfF3lE+iueKq06wBO/xuyZ8uKUkZcM0oH4WZ+cHN0XNjOkkMe0AMEFQvUUFl3ejUpLiJ4UqZpyNYcnFkJ45k4wdudlcoxpufMb11k7Ayphs/AvBbvftCy7Bv2FAKj+ibzisx2KaXl8ykkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vhe7YrM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vhe7YrM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88662C4CEF0;
	Tue, 12 Aug 2025 17:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021509;
	bh=xWm8VpNNg2qQ9fvqIMJYNUEuAUZZC2niMfJmJAL8X3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vhe7YrM5sEu6JqAtkebG7dH6s8BsapYZQSLyGke3L32FjBwgVDxBSoa2TRc/5S2E9
	 iYlcIzADK20ygq9fAhPUIqa0gYmBZm5vPNatvihXNdBVdVIzIGzpq9rCt0cslxRzxo
	 hU0N07MyBqOHZNYQoOHEK5uUz3JFgaJung1vm+TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 143/262] crypto: img-hash - Fix dma_unmap_sg() nents value
Date: Tue, 12 Aug 2025 19:28:51 +0200
Message-ID: <20250812172959.189525275@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 45063693859c..de80c95309e6 100644
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



