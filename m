Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC775AD59B;
	Mon, 31 Aug 2026 13:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184388; cv=none; b=ge3xpAH1CPQwQRqF2jiV+mvdYAQxGbmicXYkCbwQjo1dGh9VRpsqy79Tfy065qlkuZBBN+9FeE09polWxjGVAaNVq1UnD75Wn/8y5qfCauwsAsYglaa4e1anOSFKuCe6eI0qRhxSC7dq5VFeSaDwXQyUsK/QQOzzG8r4V8tOhwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184388; c=relaxed/simple;
	bh=ydmXWRpaS8I4yXAyUR5KClfkeXgZ+X6DqSfDpgatCqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H00MVCRXV0nB6wcg9+E6p4e8oeu3uIbUGGoPr07m1JWlellYKYVAn5oq9hV4IhmzrhwNNmCAd6cteDn4m4oHpi5CH2DxzilNSHpLMBAKjubWEg+4IfPdqDwvZsfXjpQtT0AvXzyPGm3geNCUvy4NU4RMbFUu7cC1dK1Pocmem1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E9ZvdtF+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E9ZvdtF+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2251F00ADB;
	Mon, 31 Aug 2026 13:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184385;
	bh=KgZ66DdStcQrMNk5jXgyQRq3gha5MTdPWvbTahPHEB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E9ZvdtF+iZY6+QWQKhHMpGiGGZ/aa7p1Izt3/JoGKr+hdgiYNDIn+UBey7Mb5OWDq
	 AFY8gJyD+QL2ZmfW9rwy035GM8nqRYDSyIH2BUipg4oH8e1nbcKBPJVh//LsbYB83y
	 xs/Q/cbWp4LYn8w5y9Kga9NxjR0csn5p9+uqsSJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Frank Li <Frank.Li@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 88/99] crypto: mxs-dcp - fix source scatterlist length access
Date: Mon, 31 Aug 2026 15:34:57 +0200
Message-ID: <20260831133404.164850965@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


