Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F5A43A80C;
	Mon, 31 Aug 2026 14:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185120; cv=none; b=UUO5BThS12QUbEC1kKSgHIG5Nq+Lfmbiocr0N8FOa7dWiq2T5In1ckfWUpkz0KfESj+lSnoDInkvHbvaa2jIArXhCp/CVk2Sg9axPN3Xkq6uGFpBoWGjDHMSUIpYdFgR6pP0OAezjD1Yw7QVuCeiLm2ClUPICJO/m4tMrBEp9rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185120; c=relaxed/simple;
	bh=ZmrFgR5kXcVhFOztXdV8w+rmIYJ8NxKb6F0RlIxrc28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKkkEhgDRSRrptfZ+jKAzdhQFdwkWWuhkxszWUutDwIP4bJIBBhL+v/u5fSoxbwneqJrQXwyhUraUUbwuxRsKrYeilnXYUAHeELSDEqsxbp4epadr2DhFHrQ1ZcftVsyhCrmBqeL6XLnHWWHUpTueMXOJ/e7QOvdP2VgtOaFUZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/OolYQl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/OolYQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1DE1F000E9;
	Mon, 31 Aug 2026 14:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185118;
	bh=242lQfWEo2ZZN2OOrXo2mOwC1cMXttFfZYMdxM8n7zY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F/OolYQlxYf95O4b73Kjx/U2Eqf005sDlzQSo8RxNE1646K/KdFcAWD1vYtpgcG54
	 VFA0pHmrFERd3ArqiEbaIMi63ab3/HcfZyIVsQ7iyo7f/6XKYx7gbkXKKa47NXTx3U
	 MvJniWap7qVYJaQGBHy+wwAa7MuOqQZS23C8K/9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Frank Li <Frank.Li@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 59/69] crypto: mxs-dcp - fix source scatterlist length access
Date: Mon, 31 Aug 2026 15:35:32 +0200
Message-ID: <20260831133401.693859712@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


