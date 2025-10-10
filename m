Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CDC2F3C04;
	Fri, 10 Oct 2025 13:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102290; cv=none; b=DA0Qv8kmJYYxhMWn7nHoFDlndn2DS+r26e0pWqioaCgTensiVBjTdBJuerW5f1j1CE4VWOktF4xvkw444B74x4llxraerD77HBLjjwhJ95sWv/CiO5hSEPhYYqtUfZzZtb/aUHaD5YlVbKDCzS/nCO61VLIgnt9/jg3j963Xt2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102290; c=relaxed/simple;
	bh=gZ8vd/rHYCUunpnS5DY25WuZZF8WtebHdCqLSof0Noo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzxlW+NT/3WEv3ybZmB7PzsGtPxMurhjovoXnbbup8sAk3jXWYoCXafufyZbPOEG6op84Q95GjjmqbPW6RS/5O55OsSLkohG50HWE595NOqxv+XYxAEdYLMwjrlcfCDwr6xqUtuPhgsVOgYVNy5YKu0hAh0ReIB+p8u/1DeIGoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkbpHnz6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkbpHnz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386DFC4CEF9;
	Fri, 10 Oct 2025 13:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102290;
	bh=gZ8vd/rHYCUunpnS5DY25WuZZF8WtebHdCqLSof0Noo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkbpHnz6XnMM7+HedLyjPV23jRgSK7B1W7vbTen5YUtZtDzBZ4QMtS1hbToOz4ezq
	 OKFFuaxJTJvu7kCWkup4f164LozqvTQH+bfRqJm1p677jU7k5UgxnZD6eiet798z5d
	 6Q3MFAThLPp/VCDZIGnlm3uKavs0rXM0qXq8PiXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Xu <han.xu@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.17 21/26] crypto: zstd - Fix compression bug caused by truncation
Date: Fri, 10 Oct 2025 15:16:16 +0200
Message-ID: <20251010131331.977697160@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.204964167@linuxfoundation.org>
References: <20251010131331.204964167@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 81c1a15eb4a273eabedfcc28eb6afa4b50cb8a46 upstream.

Use size_t for the return value of zstd_compress_cctx as otherwise
negative errors will be truncated to a positive value.

Reported-by: Han Xu <han.xu@nxp.com>
Fixes: f5ad93ffb541 ("crypto: zstd - convert to acomp")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: David Sterba <dsterba@suse.com>
Tested-by: Han Xu <han.xu@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/zstd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/zstd.c b/crypto/zstd.c
index c2a19cb0879d..ac318d333b68 100644
--- a/crypto/zstd.c
+++ b/crypto/zstd.c
@@ -83,7 +83,7 @@ static void zstd_exit(struct crypto_acomp *acomp_tfm)
 static int zstd_compress_one(struct acomp_req *req, struct zstd_ctx *ctx,
 			     const void *src, void *dst, unsigned int *dlen)
 {
-	unsigned int out_len;
+	size_t out_len;
 
 	ctx->cctx = zstd_init_cctx(ctx->wksp, ctx->wksp_size);
 	if (!ctx->cctx)
-- 
2.51.0



