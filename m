Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49280432E81;
	Thu, 16 Jul 2026 14:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212304; cv=none; b=gH1VfepuXySbbomJRkxyuC4O3CHe4LVFLatClp1SMZsWH5EhiDkkLmvYwaPO6S3hbU3RykUzSw4xAfwUsKhKdX70VtUa+/cLc40iQ0/IM8HvSBVSqeI5/9iT3xeNsOwdaNZmePJsFncRfXViBlF5g8OAYMZlRjYRYnlF8o3aZUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212304; c=relaxed/simple;
	bh=I/VGoGO/qGPJAKcNdAbFN+p/YVupged8fCxpMNDdCiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4kl6Rs9/hpDobKGi9mP/B6BJQf+SIl2Se/DjJ5X8jvc0wEQtTQQk/wlBv15ff60k4ROUtnsgdG3gAbqJPfAYAgCKjaGfUesBhcPFw01eKnSicQ/ayFfEPAsQuc6pTqW6FcM7Jcn8OyghSdj8gm+B0iPl+R73/NYC7o+/m2gTEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=onny57fC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="onny57fC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A901F00A3A;
	Thu, 16 Jul 2026 14:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212303;
	bh=gaQxa9Cxbuhk9r2DlD5ACpWxWAYHSqMV5hVRy6cNce0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=onny57fCN4zIXxZnMQGrLbiIkAc4NM5cM0LvBZ3kEVjwIPJkW3288gAyDD1UJC+N/
	 AEChO0EyVHDw4gheWt2WBBzIh3/2ITmfRJaRoOsrkYATlOK9MQXZIATwGoLQ/FbWaJ
	 cARY8gsB4hTVElKjArvZsq4QfjEsfdq6myEQPE1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ruijie Li <ruijieli51@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 274/349] crypto: pcrypt - restore callback for non-parallel fallback
Date: Thu, 16 Jul 2026 15:33:28 +0200
Message-ID: <20260716133039.471366068@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Ruijie Li <ruijieli51@gmail.com>

commit ed459fe319376e876de433d12b6c6772e612ca36 upstream.

pcrypt installs pcrypt_aead_done() on the child AEAD request before
trying to submit it through padata.  If padata_do_parallel() returns
-EBUSY, pcrypt falls back to calling the child AEAD directly.

That fallback must not keep the padata completion callback.  Otherwise
an asynchronous completion runs pcrypt_aead_done() even though the
request was never enrolled in padata.

Restore the original request callback and callback data before calling
the child AEAD directly.  This keeps the fallback path aligned with a
direct AEAD request while leaving the parallel path unchanged.

Fixes: 662f2f13e66d ("crypto: pcrypt - Call crypto layer directly when padata_do_parallel() return -EBUSY")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Ruijie Li <ruijieli51@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/pcrypt.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -122,6 +122,8 @@ static int pcrypt_aead_encrypt(struct ae
 		return -EINPROGRESS;
 	if (err == -EBUSY) {
 		/* try non-parallel mode */
+		aead_request_set_callback(creq, flags, req->base.complete,
+					  req->base.data);
 		return crypto_aead_encrypt(creq);
 	}
 
@@ -173,6 +175,8 @@ static int pcrypt_aead_decrypt(struct ae
 		return -EINPROGRESS;
 	if (err == -EBUSY) {
 		/* try non-parallel mode */
+		aead_request_set_callback(creq, flags, req->base.complete,
+					  req->base.data);
 		return crypto_aead_decrypt(creq);
 	}
 


