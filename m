Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66213B19DE;
	Fri, 15 May 2026 16:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861829; cv=none; b=qVpZsCUNdYiTbZIWZnZSPcKVy/MGi2IsplDFi159edTOcGmJNlqfwZ407j7WS8wec6yTTSDBgGjIU44WeLtpXtlCdK40bP6dgTe/DRT9DF7no0rCfGCPOaf46YX7sJ3usz0QVBDyTuIwKDpItu0bPqWNndC8dUbv6e8000OtH78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861829; c=relaxed/simple;
	bh=D3wWN18aDf/IBhyyVjclfibuEfLVl43xGl+v3shyCAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XuBQSHdAOOwiquFm8sltcQ9+GcF0ELfNKPHm+wE4I4n3mYLpsYWj+3ndkqrWw2EnGfyDXyfL6tgIRD0P3gCIaYxPjV24M9z+HDHj4pucSpDC28ommd+FxHT7mz3QIL4kCZKlrecprBiJ6MiUEdRTG8hLhFtvkg1S2PqK6rdsD0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qFMf09sh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qFMf09sh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED13C2BCB0;
	Fri, 15 May 2026 16:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861829;
	bh=D3wWN18aDf/IBhyyVjclfibuEfLVl43xGl+v3shyCAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qFMf09shD9qDLBC39qYQuzafvsDN9AYcpXqlT7yPYqxdWWuYlkXOYAqOdq8gYIIRy
	 GdruwaJPNps7FO54/dpSBakf4NCjTxjeeYDuH0O0gAz55Wc0/uggW1u6tRPJ3cqoD+
	 2Mi6LGE1d3HI9x6DYqsKKG0IHczJ/QGylt24AkYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 472/474] crypto: nx - fix context leak in nx842_crypto_free_ctx
Date: Fri, 15 May 2026 17:49:41 +0200
Message-ID: <20260515154725.318436695@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

commit 344e6a4f7ff4756b9b3f75e0eb7eaec297e35540 upstream.

Since the scomp conversion, nx842_crypto_alloc_ctx() allocates the
context separately, but nx842_crypto_free_ctx() never releases it. Add
the missing kfree(ctx) to nx842_crypto_free_ctx(), and reuse
nx842_crypto_free_ctx() in the allocation error path.

Fixes: 980b5705f4e7 ("crypto: nx - Migrate to scomp API")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/nx/nx-842.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -115,10 +115,7 @@ void *nx842_crypto_alloc_ctx(struct nx84
 	ctx->sbounce = (u8 *)__get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
 	ctx->dbounce = (u8 *)__get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
 	if (!ctx->wmem || !ctx->sbounce || !ctx->dbounce) {
-		kfree(ctx->wmem);
-		free_pages((unsigned long)ctx->sbounce, BOUNCE_BUFFER_ORDER);
-		free_pages((unsigned long)ctx->dbounce, BOUNCE_BUFFER_ORDER);
-		kfree(ctx);
+		nx842_crypto_free_ctx(ctx);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -133,6 +130,7 @@ void nx842_crypto_free_ctx(void *p)
 	kfree(ctx->wmem);
 	free_pages((unsigned long)ctx->sbounce, BOUNCE_BUFFER_ORDER);
 	free_pages((unsigned long)ctx->dbounce, BOUNCE_BUFFER_ORDER);
+	kfree(ctx);
 }
 EXPORT_SYMBOL_GPL(nx842_crypto_free_ctx);
 


