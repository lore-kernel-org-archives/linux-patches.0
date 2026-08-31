Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E960834389F;
	Mon, 31 Aug 2026 14:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184915; cv=none; b=aY0mEfL3KB2A43wBlu+kjz8S6KN6DD06kub9BIHu+4SFiawBvDSkkxTGRvDL3WVEaHMvdM0Lb3+lNlSPh9lJSSpDod4fAWyNGD210nOvsEiQSIMqe6ceKhROHsLzM+mNxkY0Q2xWEeoy7GtAqSkBeL1uZ0Fwb44oppgVPEM4b4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184915; c=relaxed/simple;
	bh=BA0hfJK8kWtWKiVsqaanv4iWEGHnG+TKIZSSk5yFJ3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gVo76PZ3fPar2h0E53SdnIQqd0O9hQY1Sh6dSM/IS7a+nu8SiAiOdYJoFY1mrvkYMTg8BzXLezEfmdQDtkJQXrJzBuZbYP+1sofww/CG149HRjJmZUKu3o7+pAqoMoBbTVJBpWOCgwHF0G0AO6qfDi9tHdTn0kkVoBZkY/qZ8yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pgimg79t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pgimg79t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378DE1F000E9;
	Mon, 31 Aug 2026 14:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184913;
	bh=QKfjaaafM85YIXYBSEGolZ2VNBVrALnsVwjKpF4+frQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pgimg79tsKjEsp4xiLwb7zCaDTPXCEwsu5EkOk6eEXCg34R1javLM/fgmbfXo/x7Q
	 NNno5OryVb+kvdD1PNQhucIV9lvmIAl4+yYQuYlHfyS0/q0HX/yGdccHj9OjpbdJrr
	 1Q68cgj4f6StxJCzp9q+PzXAY6ivPfQe6RnGdtDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Frank Li <Frank.Li@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 81/92] crypto: mxs-dcp - fix source scatterlist length access
Date: Mon, 31 Aug 2026 15:35:19 +0200
Message-ID: <20260831133403.747891924@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


