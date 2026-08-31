Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B490649DB82;
	Mon, 31 Aug 2026 13:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183623; cv=none; b=rINacFznTH/gFufvVZnuMo6b2j2NOk/nyqEtl/TLeJVDQvYiNLrwZzWyA6gxqfWBVlLn+ZpooEwzbePKQKgq00a42ulK0fhm9Jz7Fe7ghMSIJHyNwA46XQ90fqil62HRiPet1m83RakEKXyLn9AMlZ1EFUkLpM8wQydEZVSCnS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183623; c=relaxed/simple;
	bh=p/FWk9wqNJ7r8PxC7EDWd8V3Q1f1CPLcbYCsu/rwku4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HIJgY6I862jRAe1q7DcozMhYlDzKHed79HR3GsFbU3ZHQJ5zkdFzH7Srq8+B5gfkUdscbXDRb9rjo5d3fkltnVH/+jqEwQYmCAUXoWSgQigcpNnch4sSu9znqalhloqoZHgSEqTKYZcn2jiLyrbYweHAAFLV0Y0ByRm5Dm5jLQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YkgPHc0/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YkgPHc0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5411F00ACF;
	Mon, 31 Aug 2026 13:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183621;
	bh=0oncZW9TXoisJ+fIXFpAdzc7vi3XmeDLt2C5PjVXG1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YkgPHc0/dPiWPYBxvDX7pUcmJdflmT9X00Df0EWw/E79TZBplM9fXA52+hK1cH6Gv
	 O2X7Q2wWZ/l/lp1J9h0VIk8kO+UGwdJgaIxaxVjSOETY4JQRaHvQdzm0/3G6vPXKsD
	 xiaYXlV65UP8T86v61IQc/grI/N9rBwsKZKir/1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Frank Li <Frank.Li@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.2 59/71] crypto: mxs-dcp - fix source scatterlist length access
Date: Mon, 31 Aug 2026 15:34:24 +0200
Message-ID: <20260831133402.280657534@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -353,7 +353,7 @@ static int mxs_dcp_aes_block_crypt(struc
 
 	for_each_sg(req->src, src, sg_nents(req->src), i) {
 		src_buf = sg_virt(src);
-		len = sg_dma_len(src);
+		len = src->length;
 		tlen += len;
 		limit_hit = tlen > req->cryptlen;
 


