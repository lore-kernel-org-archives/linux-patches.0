Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD121A6827;
	Mon,  4 May 2026 14:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904239; cv=none; b=Eg941WpQ8qTebr6bn5KLw87WkrGP65XMMC6nlWbp26kgL432im6p5I4SuWE+Grms/xwb3FtpTPeCe+Z2IdVyKfFP3gDUWkeSPJxtbAMAxXCsPtooieP5Gm4wpd7iuodC6J3YUJqQnsGjp5c57BsPLyXVqwfut2ZTL2YcNqGMPaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904239; c=relaxed/simple;
	bh=6yTaWxHo+peOzY5uXbqAYWfAh8sNFXChDTRC/F5evQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iaXBYgTwFTh13yfaomNQtqM6T7p6q/uCUR/QavN05mhiZX1mq60v6PXwBaoJTZf6LfIuwji5rd7weVyuXTY1K9Lwgmh5uroQ/40Z1W9RVAlORP2xN1Jtbnrv9EPeBwgLoLbMBEx6DWI+p2G4Td4bwlAmzwbA/GPkeMRkYAw8jpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rDJ+yoVv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rDJ+yoVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA397C2BCB8;
	Mon,  4 May 2026 14:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904239;
	bh=6yTaWxHo+peOzY5uXbqAYWfAh8sNFXChDTRC/F5evQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rDJ+yoVv3jfHHdjJNcnrT+COJJ4MHptqTrZh5UHulln3J8yFv6Oo2oqAq3C6yHORj
	 8cWpAaYql5A+Di/Aq/ATFuXrWiFBL4llXvXD95x3/Tql0uEYCVlnq+AxFrie+2VfVs
	 CdHj9XiabpzlIgSW18RnxvgXKTgY4yiuLfLOfPuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 230/275] crypto: nx - fix bounce buffer leaks in nx842_crypto_{alloc,free}_ctx
Date: Mon,  4 May 2026 15:52:50 +0200
Message-ID: <20260504135151.602058850@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

commit adb3faf2db1a66d0f015b44ac909a32dfc7f2f9c upstream.

The bounce buffers are allocated with __get_free_pages() using
BOUNCE_BUFFER_ORDER (order 2 = 4 pages), but both the allocation error
path and nx842_crypto_free_ctx() release the buffers with free_page().
Use free_pages() with the matching order instead.

Fixes: ed70b479c2c0 ("crypto: nx - add hardware 842 crypto comp alg")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/nx/nx-842.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -116,8 +116,8 @@ void *nx842_crypto_alloc_ctx(struct nx84
 	ctx->dbounce = (u8 *)__get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
 	if (!ctx->wmem || !ctx->sbounce || !ctx->dbounce) {
 		kfree(ctx->wmem);
-		free_page((unsigned long)ctx->sbounce);
-		free_page((unsigned long)ctx->dbounce);
+		free_pages((unsigned long)ctx->sbounce, BOUNCE_BUFFER_ORDER);
+		free_pages((unsigned long)ctx->dbounce, BOUNCE_BUFFER_ORDER);
 		kfree(ctx);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -131,8 +131,8 @@ void nx842_crypto_free_ctx(void *p)
 	struct nx842_crypto_ctx *ctx = p;
 
 	kfree(ctx->wmem);
-	free_page((unsigned long)ctx->sbounce);
-	free_page((unsigned long)ctx->dbounce);
+	free_pages((unsigned long)ctx->sbounce, BOUNCE_BUFFER_ORDER);
+	free_pages((unsigned long)ctx->dbounce, BOUNCE_BUFFER_ORDER);
 }
 EXPORT_SYMBOL_GPL(nx842_crypto_free_ctx);
 


