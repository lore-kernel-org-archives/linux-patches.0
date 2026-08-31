Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8659C4A2E3C;
	Mon, 31 Aug 2026 14:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185295; cv=none; b=QwWc8U4RmvHP09NoHVe7K2V9EL6PCGkNEN3OT/ZCZW7dcPlVaezZuLeX/UiwwqlLQzIUEp5bR+qgrK+Mpn+0WuT6FfDCd99ZNBzHkOIJ/4DRY7401y3wUyed3CuUw6LhbMN1FJNr0GdfGzZREKSRV1i1rpmRXWJt2Xco3lSEp7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185295; c=relaxed/simple;
	bh=Z2ueIaHV4HcuAmBiFlLyA0RL//ZxzHHK7Nhls/sOXjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHHtfqmkzkddq/Ag5pyhZ1E+KVAydwMR3whw4OkjYm4IoWFf6fkCYU7EVPbclUkJIFF42+Fja6AIQJYZ34FcavnA4DamXOd//04bYwMm1QhiMQ8sAk2aKO+HgvK9ackmBpLIDy0fdz6+DEQE5/wrtr8Xjff0uxvao+p/ejz7G0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQnW29Ku; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQnW29Ku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFCEB1F000E9;
	Mon, 31 Aug 2026 14:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185294;
	bh=OgjAJZkpcxDiYFqPU0pwbFzmL+bNjnp5LMZiAyCQeKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XQnW29Ku9ehg/w88c47QPlf9M/BoesVuDrALztBL/9+y7c4AN2BiqJpW36gM5Aevc
	 MnOPyMlYfnaSV5FoH2wzwoXF5D3rpqoeKIlV5rRVpLUanxl2U0Lo/wcahPKX2HUuk4
	 7EZ/vkdY7n0TL0hLRkW0FidA5mbG16mKvOWADNBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Frank Li <Frank.Li@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 35/43] crypto: mxs-dcp - fix source scatterlist length access
Date: Mon, 31 Aug 2026 15:35:43 +0200
Message-ID: <20260831133400.280286617@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.571886287@linuxfoundation.org>
References: <20260831133358.571886287@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit c5bcb084a9871e5b62afb5f48b60adfa13b5d9f8 upstream.

mxs_dcp_aes_block_crypt() uses sg_dma_len() without mapping the source
scatterlist with dma_map_sg() first. Therefore, sg_dma_len() is invalid
and could return zero or a stale DMA length, causing encryption and
decryption to process the wrong number of bytes when
CONFIG_NEED_SG_DMA_LENGTH=y.

Use the original scatterlist length instead.

Fixes: 15b59e7c3733 ("crypto: mxs - Add Freescale MXS DCP driver")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/mxs-dcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -332,7 +332,7 @@ static int mxs_dcp_aes_block_crypt(struc
 
 	for_each_sg(req->src, src, sg_nents(req->src), i) {
 		src_buf = sg_virt(src);
-		len = sg_dma_len(src);
+		len = src->length;
 		tlen += len;
 		limit_hit = tlen > req->cryptlen;
 


