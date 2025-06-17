Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E2D2E9730;
	Tue, 17 Jun 2025 15:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174633; cv=none; b=Da4Vf+ASEQK8LIS4zGVhOzlD5FYW1Ae/AmvudwQxRKzk77DRF85oQDpSJDYPVvJCm59PlVLFCmWeXMsyfWYsJHSfjbUGxpliHM2nhaK/4iHpMzXaXmBf8ue+3r7GaO0B3RnRKRRPrQaX6gAnInAf5/WLuQLqHF0dJIoyemSfM+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174633; c=relaxed/simple;
	bh=+dIv1mMQd6TgCHxMhJcGooXVcGvk3G6jHGLspp5hNOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUGlZIPKayRVGVOSP7x4asr529Isj630C+hJqUrbg2EtIHcYbNnRzlKUlV6gQzBBCRLxpkyQthq+ICLcol1e5/vqJ6V8jihyNnRmAY0A58iZtbmDmXPprtej3koqtXi7dNGMMC6Sk+yAvwZYTJU4FX1whGr9hNWX2qROKE08Eh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gxxAqPYM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gxxAqPYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165A1C4CEE3;
	Tue, 17 Jun 2025 15:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174633;
	bh=+dIv1mMQd6TgCHxMhJcGooXVcGvk3G6jHGLspp5hNOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gxxAqPYM63saM5Q1VOLKkgGMuzIukFamD37s0bsFikz28gPCKc/ktEmwsAXOvsfOg
	 JZY5Yqg0uY3FnBrHxGfEZnguRVuMmpgpLazBFzeGteMIWWoz+nBR7T2WERZUuvjZEY
	 sZemPckZoc538rJ6ak1SybepmR3aw7IL2grBDq5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 003/780] crypto: iaa - Do not clobber req->base.data
Date: Tue, 17 Jun 2025 17:15:11 +0200
Message-ID: <20250617152451.637240696@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit cc98d8ce934b99789d30421957fd6a20fffb1c22 ]

The req->base.data field is for the user and must not be touched by
the driver, unless you save it first.

The iaa driver doesn't seem to be using the req->base.data value
so just remove the assignment.

Fixes: 09646c98d0bf ("crypto: iaa - Add irq support for the crypto async interface")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 09d9589f2d681..33a285981dfd4 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1187,8 +1187,7 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 			" src_addr %llx, dst_addr %llx\n", __func__,
 			active_compression_mode->name,
 			src_addr, dst_addr);
-	} else if (ctx->async_mode)
-		req->base.data = idxd_desc;
+	}
 
 	dev_dbg(dev, "%s: compression mode %s,"
 		" desc->src1_addr %llx, desc->src1_size %d,"
@@ -1425,8 +1424,7 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 			" src_addr %llx, dst_addr %llx\n", __func__,
 			active_compression_mode->name,
 			src_addr, dst_addr);
-	} else if (ctx->async_mode && !disable_async)
-		req->base.data = idxd_desc;
+	}
 
 	dev_dbg(dev, "%s: decompression mode %s,"
 		" desc->src1_addr %llx, desc->src1_size %d,"
-- 
2.39.5



