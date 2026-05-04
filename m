Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6637521C173;
	Mon,  4 May 2026 14:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904208; cv=none; b=SSw6ofTXm3IQCEVUMzpscWfIFYei+/Ks0Ll3KlWjjj0KquwUGr5GP70S/3koOkWTD8WwKn7X4bpFXH/Gy8SPqM4ZKM8mUwTF+vhXjKcY8LWOKTTKr/TT0G0ON9ZyF4ESi5JfTFjG3VyPxR1q2cf0L0vjrqzA2u4qCb8UUQZCeN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904208; c=relaxed/simple;
	bh=BQjBHSAc6OtCIYALQM7uiQ0G32O8nf8NPf5gIAVqTaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BiPaKwuTvFOrommGPjcmJZ3iC6LI2gqfNydHyHFsMPOdZUNsv+5I7y8xzYV49+gtwCO73AQNH/elTHSjpMnKJ/0v8INqeuRN6k/vHAIAMSYZUNTwHF7wJxoKQxixzmFYiBL2FzkSAKzDI03fmRotaujILdj5BYHqz0WdWbOpMrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ZUYUc9N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ZUYUc9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F9CC2BCB8;
	Mon,  4 May 2026 14:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904208;
	bh=BQjBHSAc6OtCIYALQM7uiQ0G32O8nf8NPf5gIAVqTaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ZUYUc9Nyi72YsvwIg8p5DPytWNvyxSEpK/bdhSZD60ihBOtSIxhRL9FS7RvfDzKO
	 do1RFtXgN9iUraBgL8rQFSXtGL0yQCRnwaIo0fGgoOZF4/h12pqohTW9TWq07cmKK6
	 GQRRNY98KfHDiCzs8ZdFL6G13Cw1AwDsFWs7XMeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 224/275] crypto: hisilicon - Fix dma_unmap_single() direction
Date: Mon,  4 May 2026 15:52:44 +0200
Message-ID: <20260504135151.388987677@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Thomas Fourier <fourier.thomas@gmail.com>

commit 1ee57ab93b75eb59f426aef37b5498a7ffc28278 upstream.

The direction used to map the buffer skreq->iv is DMA_TO_DEVICE but it is
unmapped with direction DMA_BIDIRECTIONAL in the error path.

Change the unmap to match the mapping.

Fixes: 915e4e8413da ("crypto: hisilicon - SEC security accelerator driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/hisilicon/sec/sec_algs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/hisilicon/sec/sec_algs.c
+++ b/drivers/crypto/hisilicon/sec/sec_algs.c
@@ -844,7 +844,7 @@ err_free_elements:
 	if (crypto_skcipher_ivsize(atfm))
 		dma_unmap_single(info->dev, sec_req->dma_iv,
 				 crypto_skcipher_ivsize(atfm),
-				 DMA_BIDIRECTIONAL);
+				 DMA_TO_DEVICE);
 err_unmap_out_sg:
 	if (split)
 		sec_unmap_sg_on_err(skreq->dst, steps, splits_out,


