Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7E418E030;
	Tue, 30 Jul 2024 17:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359332; cv=none; b=nQDI9xzU0RpxzifUB7z/Hii3QrEllELBLKU+FS+X25drRuSn/FwatjShxUKDDHgDLmZifQAiFxuNLMS9ZluIGnXgM2OWz/6YJQeQDTZI/mEFUQqD/NL8VPz3IsUeBXrGuK1hm84AVjZmCJZ7rRSc46PPu4PccX38bBqqWpqf2QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359332; c=relaxed/simple;
	bh=/Vzg5LQpu3Y9ucSe45krcwqiRT1Aayy7oc8KOdC5hNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKGKdpHd4ihvvKMS8u2NpcItWGvblkBUgZTUOz6l3716gQPc2a4h4brR6e4mqwFhT6nTfXXxODOw/lMDS8rQo9E6Nz6wpKYd0TjKoK5jnt+vKYYPmFilboTmS7/wmxIRUDVAx+X0CL8Pgw7o7BNLwbQ+qZ/ToNHgCkyLk7QhXWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jE6lYHG8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jE6lYHG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157ABC4AF11;
	Tue, 30 Jul 2024 17:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359332;
	bh=/Vzg5LQpu3Y9ucSe45krcwqiRT1Aayy7oc8KOdC5hNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jE6lYHG8ygKye9ZJ+00p9L4yQhi8wMuUZiotFYajWjdCU9lkAwLjQB1KzCb5u4i6z
	 nIbHBi8c+2y6v7hZiCztBnysYIYqkCWG9BfBX0EoKCHEhJAtYNxNfjPwPevjvFE8ux
	 STLZ3TTmFPP9INBsO7kTOT1I3XJ7nYJwXAV1WX3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gstir <david@sigma-star.at>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 469/809] crypto: mxs-dcp - Ensure payload is zero when using key slot
Date: Tue, 30 Jul 2024 17:45:45 +0200
Message-ID: <20240730151743.259428621@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Gstir <david@sigma-star.at>

[ Upstream commit dd52b5eeb0f70893f762da7254e923fd23fd1379 ]

We could leak stack memory through the payload field when running
AES with a key from one of the hardware's key slots. Fix this by
ensuring the payload field is set to 0 in such cases.

This does not affect the common use case when the key is supplied
from main memory via the descriptor payload.

Signed-off-by: David Gstir <david@sigma-star.at>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202405270146.Y9tPoil8-lkp@intel.com/
Fixes: 3d16af0b4cfa ("crypto: mxs-dcp: Add support for hardware-bound keys")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/mxs-dcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 057d73c370b73..c82775dbb557a 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -225,7 +225,8 @@ static int mxs_dcp_start_dma(struct dcp_async_ctx *actx)
 static int mxs_dcp_run_aes(struct dcp_async_ctx *actx,
 			   struct skcipher_request *req, int init)
 {
-	dma_addr_t key_phys, src_phys, dst_phys;
+	dma_addr_t key_phys = 0;
+	dma_addr_t src_phys, dst_phys;
 	struct dcp *sdcp = global_sdcp;
 	struct dcp_dma_desc *desc = &sdcp->coh->desc[actx->chan];
 	struct dcp_aes_req_ctx *rctx = skcipher_request_ctx(req);
-- 
2.43.0



