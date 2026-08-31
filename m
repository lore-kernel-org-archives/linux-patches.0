Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D854A5C4E;
	Mon, 31 Aug 2026 13:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183858; cv=none; b=Ii9nXM/hT4moGzPB3M/eW/opsBH5VSu56a+z5lwZOykYLquiSEfoKdEcm+XMqwYAzOyuJUW03cb+RWgjnsgmHqVotR2fLbwRwbM2YtWdEUG2eL7kutD7niEVNDsyBfrF2md2DKXtUaGFcoKWyE3ZM/jfKx3zWOMHcPw4HmZ0lwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183858; c=relaxed/simple;
	bh=2dmK1eaczbwGeuGFV8tovZgxUDGJ08nN7t/5/RkLAdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLdtemRE+bgIJgu5KPjxK95yJkh1amexu04ckiLJ5FAqJAdUX9h+PaaizW6Jba5ayNo7Rl7nKLvG0WjCdHXPqJSHLr98Gh05mr0AX++Nw9ePuX990ZeVCKl0vXiZNzf+ivH9R5wqFWFTinDgXBkkO6GKXzDzUQRxZLu79wkK88E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xddj9V/e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xddj9V/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80521F00A3D;
	Mon, 31 Aug 2026 13:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183856;
	bh=TUGMVfz1SOcJSc6VfaQjlCeBgK+V+EDc+s9KbAVq2Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xddj9V/eiaCOpQuLJkxo0Kv0JxRH4E78aAbcppqH+ZkaxVDB7SXhJUCciwycpbSZP
	 H5vgVt86Aqey71zcOJ8EbFMrRs1mf1rgt+RHOmIz58QyYcAvtOqBAnYqVHjGzK3YOX
	 8ib0IrGZ6AmLpPdTb065ys8L6ulab4rCan+IqzjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Frank Li <Frank.Li@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 64/76] crypto: mxs-dcp - fix source scatterlist length access
Date: Mon, 31 Aug 2026 15:34:36 +0200
Message-ID: <20260831133402.739254064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 


