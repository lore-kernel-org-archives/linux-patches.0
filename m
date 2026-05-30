Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E550332919;
	Sat, 30 May 2026 16:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160152; cv=none; b=dUjaGCIioaRFcUErP0sM01HESXFSv5Jz9tltbuvsjH+hZlc8tpNraSlAAlwswOWBbVIMEhbY4imAIQWR4dZqoZwXEu3wkBea27mpAoDIt7WxV3q6nPe1419V98tgoCXnSpu7YYoi1y9XetLZliWWbC3SRXPPB1cCwOVyA3PV0Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160152; c=relaxed/simple;
	bh=ESd9cmxTs6Ajx6Ojx2/C+YyfZB/Xzx/RfNImwtQRk6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Am8YMKOgELsA0LJqH8fbBqopLSFG5QCR87l1zHMSzMVElETg6jFjxh4NJjOtwdCiAYSIik8zVbhLHIXDoi95fSq+qQjfsz5VX8lzljy8IADvLnvu5PpotKzB0dHimZ4YHim67Gih9x9Gle3SkrzqBIn8F5RsQzpvYMY7+qACny4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNUb8etJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNUb8etJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784611F00893;
	Sat, 30 May 2026 16:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160151;
	bh=Lutj7V27ybBh6Yl/+izrOghFq9pbEtEOXEi0LnlcM80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QNUb8etJez9xzygzMth61CkSFx6aFChc1K66avQ7/LvHWGqZT/G2laS9lmz1WqR3/
	 e5f6FCPUo4NyxA6+p1EHWnfEIO7vL6crtKHmqV4DuVwUqYbLOtuRxAx6Hm/OTWjR7y
	 9AEzIMDBEOQtWaIxGgPoPRCBiiRIaKyfKcnymN3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 258/969] crypto: hisilicon - Fix dma_unmap_single() direction
Date: Sat, 30 May 2026 17:56:22 +0200
Message-ID: <20260530160307.606553679@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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


