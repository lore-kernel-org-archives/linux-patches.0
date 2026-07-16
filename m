Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BD12D0606;
	Thu, 16 Jul 2026 13:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209512; cv=none; b=HT1ssU1FrZEqYpRL3LcBIWqA8p5vfH5BZrPioAKXUQfl91aussduSSXxxEq8EbqFOStRCDXt+OjsflgLJl32sO8A10vYnHj2HjDs+Ep0W0ryDYncXPh/f/LDCFPaxMJHkC9HuQwn/GUlfsAAhEqFixLhFcQPmr1E84JgS/oYRcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209512; c=relaxed/simple;
	bh=zt6VTYJkIUXKe1wnHTF3aZXRfAUT11BwHIXvXIG/cDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tv4j3hb4g4aXMOwIRsedgWgXDD7qrKX8VVOPAXkmSZbEgT4W7mRMrER/Mp6Yv9wSB5erIe26yl4DdPACVcXTBfqFsa+UjGycoj033R3DNqZj0dYmdtis2TczSKqQe1mTxASn9hT+xBOzPjvku8cqJHT6OqZ6kbSUm3tMhRx16pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rtdv9y4e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rtdv9y4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292D11F00A3F;
	Thu, 16 Jul 2026 13:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209510;
	bh=+UnWIkmaZt81iCXNEbq0vUVCFC/EsRoyhfzwGFDdliQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rtdv9y4eZeGixCNdUjcZTKGq8JCk4m7WhKnzTDKzFp6qWnSE0j/VpRUaFdIzLS9aU
	 chI4ge/HLmvbM14jbwA2PzBn5l22ahqkMt0OlOW2wy531/rGxhqzzp2uJiXFSENFZr
	 YOrjdVAmUwyrrKEbdPSfvNBjcirnGzIXzEv1h7nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Michael Bommarito <michael.bommarito@gmail.com>
Subject: [PATCH 7.1 169/518] crypto: krb5 - filter out async aead implementations at alloc
Date: Thu, 16 Jul 2026 15:27:17 +0200
Message-ID: <20260716133051.538549305@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 6c9dddeb582fde005360f4fe02c760d45ca05fb5 upstream.

krb5_aead_encrypt(), krb5_aead_decrypt() in rfc3961_simplified.c and
rfc8009_encrypt(), rfc8009_decrypt() in rfc8009_aes2.c set a NULL
completion callback and treat any negative return from
crypto_aead_{encrypt,decrypt}() as terminal, falling through to
kfree_sensitive(buffer).  When the encrypt_name resolves to an
async AEAD instance the request returns -EINPROGRESS, the buffer
is freed while the backend's worker still holds a pointer, and the
worker dereferences the freed slab on completion.

KASAN report under UML+SLUB with a synthetic async aead backend
bound to krb5->encrypt_name:

  BUG: KASAN: slab-use-after-free in t5_stub_complete+0x7d/0xc7

The helpers were written synchronously, so filter the async
instances out at allocation time instead of plumbing
crypto_wait_req() through every call site.

Reachable via net/rxrpc/rxgk.c, fs/afs/cm_security.c and
net/ceph/crypto.c on systems with an async AEAD provider bound to
the krb5 enctype name.

Fixes: 00244da40f78 ("crypto/krb5: Implement the Kerberos5 rfc3961 encrypt and decrypt functions")
Fixes: 6c3c0e86c2ac ("crypto/krb5: Implement the AES enctypes from rfc8009")
Cc: stable@vger.kernel.org
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/krb5/krb5_api.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/krb5/krb5_api.c
+++ b/crypto/krb5/krb5_api.c
@@ -207,7 +207,7 @@ struct crypto_aead *krb5_prepare_encrypt
 	struct crypto_aead *ci = NULL;
 	int ret = -ENOMEM;
 
-	ci = crypto_alloc_aead(krb5->encrypt_name, 0, 0);
+	ci = crypto_alloc_aead(krb5->encrypt_name, 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(ci)) {
 		ret = PTR_ERR(ci);
 		if (ret == -ENOENT)


