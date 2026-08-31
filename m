Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AC356B862;
	Mon, 31 Aug 2026 13:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184103; cv=none; b=FJG2XnBttMe49OVxWZXrPQLIM+8Op4fk4hT0WOLREyEwJabe/CPpIT+IfPWIqCp6CX2aQeb41g/DzCWVDZ50IAt8DxRttnpv5CKbjLfEczChutK8rV+AaI1rzN4XLX21YEZ4Hnqjy2XYw7qyCUcsPsAFhJGuRm3YQEh/7SLJNZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184103; c=relaxed/simple;
	bh=swyFfM4i+V/zoY/IvC1Lknpr3FGCjZSMHHR7JG1gvc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtG2tD2vdsldjSGmalJA/5lDcp1Ou0mUZX8r7WTCREkOL81AR3yFmpN6z9RgHzjOFBoCqtsDWh0CV/9iiqo4SQX85d0Zin04Q6KGL8uix45iaF2fy2g8JJG7Ws6R0PeYuaovCfTdEhWZlVDlbwTZykMhZ3L9iBP+uYKCevIs8/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ll7QI/Y0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ll7QI/Y0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811F31F00ACA;
	Mon, 31 Aug 2026 13:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184102;
	bh=fESC9XtPDep2XOHmmra8UuUWWlKe21fJBoeFKzb/mo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ll7QI/Y0P7hursvYf4OhUolsHTvVjG+a5WavltfFMPautQ2laD4WtdP1NE7OLLtHL
	 chYh0gJQ21FfHCJzKTNtfAa4vzm4u8fHzqaNwGUMKSbWSsaca3xYljoWNpFn5xfo35
	 7yj79EsAPlryJw5+qQnz7L6uheFm9V3ZBLCdsvz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Frank Li <Frank.Li@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 72/83] crypto: mxs-dcp - fix source scatterlist length access
Date: Mon, 31 Aug 2026 15:34:48 +0200
Message-ID: <20260831133403.135330839@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


