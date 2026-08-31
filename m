Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAEC42E43A;
	Mon, 31 Aug 2026 13:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184647; cv=none; b=VGmGVplrFx53FnIfqj7e7Ey2fP3+8Ei2gk4D4sr4pGXACkQZ5+Qb9nq/rbsiRtlhBJUMiY6jUGMtgSK7LtwMt3Wj0Vwoy6s7oBnlbFRCaS5uhZqUdpf+fIpXjPaqMOXNDSdql7oZLuDk75vFw9eEeUHIFzB6pAEiOclz87pIPrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184647; c=relaxed/simple;
	bh=J9M8vri8xaTJVvRhEQQE6LRvr/7eb0cCThxV2mbSyMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/chmfqdLB0Hq1o52RqGpOgxYnwejD8/gRfN8zB3HuyWYFTnQWxUNk0KhC5gEChcF8wFVKKaGEZolDbslBwQzyceQl6NDoBiWqvzZKaiStmGs8OR0r93Ld2cLw8tft57Y45HjCFnURMRBEujWsFJc4bjgSKfj5r+JMlQR2L1FY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kb19jm0W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kb19jm0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E221F000E9;
	Mon, 31 Aug 2026 13:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184646;
	bh=s3fKHItI+5yd+qNBiZsWRsJpDlRBrxN3z61IQdUcY9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kb19jm0WUQOx8XQtkebutQpIzg29ijyIXLyQxCswFTEDxuZW3b+UlymgS6g3CExg7
	 QuSdeYgZH/1OLTOc7GWlVJMngHnBygk14el+sZDjcZe8ypUtCPGaf9AwcqxVFHW7kC
	 VqLNTndIZHJlF2nbWCAfFY6IaQfm88UwO17a+aVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Frank Li <Frank.Li@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 81/91] crypto: mxs-dcp - fix source scatterlist length access
Date: Mon, 31 Aug 2026 15:35:09 +0200
Message-ID: <20260831133403.777239652@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -333,7 +333,7 @@ static int mxs_dcp_aes_block_crypt(struc
 
 	for_each_sg(req->src, src, sg_nents(req->src), i) {
 		src_buf = sg_virt(src);
-		len = sg_dma_len(src);
+		len = src->length;
 		tlen += len;
 		limit_hit = tlen > req->cryptlen;
 


